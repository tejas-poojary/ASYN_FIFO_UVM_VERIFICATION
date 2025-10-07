class rd_monitor extends uvm_monitor;
  `uvm_component_utils(rd_monitor)
  virtual async_fifo_intrf vif_rd_mon;
  rd_seq_item rd_mon_item;
  uvm_analysis_port#(rd_seq_item)rd_mon_port;
  event read_mon_trigger;
  logic captured_rrst_n;
  
  function new(string name="rd_monitor",uvm_component parent=null);
    super.new(name,parent);
    rd_mon_port=new("rd_mon_port",this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual async_fifo_intrf)::get(this,"","vif",vif_rd_mon))
      begin
        `uvm_fatal(get_full_name(),"Read Monitor didn't get interface handle") 
      end
    if(!uvm_config_db#(event)::get(this,"","event_rd",read_mon_trigger))
      begin
        `uvm_fatal(get_full_name(),"Read Monitor didn't get event")
      end
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    //@(posedge vif_rd_mon.rrst_n); // Wait for reset de-assertion
    forever begin
      rd_mon_item=rd_seq_item::type_id::create("rd_mon_item");
      wait(read_mon_trigger.triggered);
      captured_rrst_n = vif_rd_mon.rrst_n;   //added
      @(posedge vif_rd_mon.rd_mon_cb);
      rd_mon_item.rdata=vif_rd_mon.rd_mon_cb.rdata;
      rd_mon_item.rinc=vif_rd_mon.rd_mon_cb.rinc;
      rd_mon_item.rempty=vif_rd_mon.rd_mon_cb.rempty;
      rd_mon_item.rrst_n=captured_rrst_n;   //added
      rd_mon_port.write(rd_mon_item);
      `uvm_info("Read Monitor Capturing",$sformatf("Got: %s at %0t",rd_mon_item.sprint(),$time), UVM_LOW)
    end
  endtask
  
endclass
       
