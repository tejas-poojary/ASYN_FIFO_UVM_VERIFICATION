class fifo_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(fifo_scoreboard)
   uvm_tlm_analysis_fifo#(wr_seq_item)wr_agt_fifo;
   uvm_tlm_analysis_fifo#(rd_seq_item)rd_agt_fifo;
   logic [`DSIZE-1:0]mimic_fifo[$];      //queue to mimic fifo behaviour
   wr_seq_item wr_seqit;
   rd_seq_item rd_seqit;
   int depth=1<<`ASIZE;
   logic[`DSIZE-1:0]exp_read_data;
   bit exp_full,exp_empty;
   virtual async_fifo_intrf vif_scb;
  
  function new(string name="fifo_scoreboard",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    wr_agt_fifo=new("wr_agt_fifo",this);
    rd_agt_fifo=new("rd_agt_fifo",this);
    if(!uvm_config_db#(virtual async_fifo_intrf)::get(this,"","vif",vif_scb))
      begin
        `uvm_fatal(get_full_name(),"Write Driver didn't get interface handle")
      end
  endfunction  
  
 virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    fork
      forever begin
        wr_agt_fifo.get(wr_seqit);
        process_write(wr_seqit);
      end
      forever begin
        rd_agt_fifo.get(rd_seqit);
        process_read(rd_seqit);
      end
    join
endtask
  
  task process_write(wr_seq_item wr_seqit);
    exp_full=(mimic_fifo.size()==depth);
    exp_empty=(mimic_fifo.size()==0);
   if (wr_seqit.winc) 
    begin
      if (wr_seqit.wrst_n == 0)  //changed from interface reset to sequence item reset
        begin
         if (mimic_fifo.size() > 0) 
           begin
            mimic_fifo.pop_back();
            mimic_fifo.push_back(wr_seqit.wdata);
            `uvm_info(get_full_name(),$sformatf("During RESET: Replaced last element with %0d @%0t (queue size=%0d)",wr_seqit.wdata, $time, mimic_fifo.size()),
  UVM_MEDIUM)
           end 
         else
            mimic_fifo.push_back(wr_seqit.wdata);
        end 
      else  //normal operation without reset
        begin
         if (mimic_fifo.size() == depth)  //fifo is full
           begin
            if (exp_full == 0)
             `uvm_error(get_full_name(),"Full flag not asserted even though fifo is full")
            else
              begin
               `uvm_info(get_full_name(),"Full flag asserted correctly but cannot write further",UVM_LOW)
                if(exp_full!=wr_seqit.wfull)
                  `uvm_error(get_full_name(),$sformatf("Mismatch of full flag || exp_full=%0d || wfull=%0d",exp_full,wr_seqit.wfull))
                else
                  `uvm_info(get_full_name(),$sformatf("Match of full flag || exp_full=%0d || wfull=%0d",exp_full,wr_seqit.wfull),UVM_MEDIUM)
              end
           end 
        else       //fifo is not full
          begin
           if (exp_full == 1)
            `uvm_error(get_full_name(),"Full flag asserted even though fifo is not full")
           else 
            begin
              mimic_fifo.push_back(wr_seqit.wdata);
              `uvm_info(get_full_name(),$sformatf("Wrote %0d to FIFO @%0t size=%0d fifo elements=%p", wr_seqit.wdata, $time,mimic_fifo.size(),mimic_fifo),UVM_MEDIUM)
            end
         end
       end
      end
  endtask

  task process_read(rd_seq_item rd_seqit);
    exp_full=(mimic_fifo.size()==depth);
    exp_empty=(mimic_fifo.size()==0);
   if(rd_seqit.rinc) 
     begin
       if(rd_seqit.rrst_n == 0)
         begin
           if(mimic_fifo.size>0)
            begin
             exp_read_data=mimic_fifo.pop_back();
              if (exp_read_data !== rd_seqit.rdata)
                `uvm_error(get_full_name(),$sformatf("MISMATCH: Expected=%0d, Got=%0d",exp_read_data,rd_seqit.rdata))
             else
               `uvm_info(get_full_name(),$sformatf("MATCH: Expected=%0d,Got=%0d (queue size after popping out %0d=%0d)",exp_read_data, rd_seqit.rdata,exp_read_data, mimic_fifo.size()),UVM_MEDIUM)
           end
           else
             `uvm_error(get_full_name(),"RESET:Cant Read because fifo is empty")
        end
      else     //normal operation without reset
       begin     
         if(mimic_fifo.size() == 0)   //fifo is empty
           begin
             if(exp_empty == 0)
              `uvm_error(get_full_name(),"Empty flag not asserted even though fifo is empty")
             else
              `uvm_info(get_full_name(),"Empty flag asserted correctly but cannot read further",UVM_LOW)
            end 
         else       //fifo is not empty
           begin
             if(exp_empty == 1)
              `uvm_error(get_full_name(),"Empty flag asserted even though fifo is not empty")
             else 
              begin
               exp_read_data= mimic_fifo.pop_front();
                if (exp_read_data !== rd_seqit.rdata)
                 `uvm_error(get_full_name(),$sformatf("UNMATCH: Expected=%0d, Got=%0d",exp_read_data,rd_seqit.rdata))
                else
                 `uvm_info(get_full_name(),$sformatf("MATCH: Expected=%0d,Got=%0d (queue size after popping out %0d=%0d)",exp_read_data, rd_seqit.rdata,exp_read_data, mimic_fifo.size()),UVM_MEDIUM)
              end
           end
       end
     end
  endtask


endclass
    
