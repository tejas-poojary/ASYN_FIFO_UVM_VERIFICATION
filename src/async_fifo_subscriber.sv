class fifo_subscriber extends uvm_component;
  `uvm_component_utils(fifo_subscriber)
  `uvm_analysis_imp_decl(_wr_mon)
  `uvm_analysis_imp_decl(_rd_mon)
   uvm_analysis_imp_wr_mon#(wr_seq_item,fifo_subscriber)wr_sub_imp;  //can use tlm fifo also
   uvm_analysis_imp_rd_mon#(rd_seq_item,fifo_subscriber)rd_sub_imp;
   wr_seq_item wr_item;
   rd_seq_item rd_item;
   real wr_cov,rd_cov;
  
  covergroup wr_act_mon;
    WRITE_DATA:coverpoint wr_item.wdata { 
                                          bins first_half = {[0:127]};
                                          bins second_half = {[128:255]};
                                        }
    WRITE_INC:coverpoint wr_item.winc{
                                       bins zero = {0};
                                       bins one = {1};
                                     } 
    WRITE_FULL:coverpoint wr_item.wfull{
                                         bins not_full = {0};
                                         bins full = {1};
                                       }
    WINC_X_WFULL :cross wr_item.winc,wr_item.wfull;
   endgroup
  
  covergroup rd_act_mon;
    READ_DATA:coverpoint rd_item.rdata { 
                                          bins first_half = {[0:127]};
                                          bins second_half = {[128:255]};
                                       }
    READ_INC:coverpoint rd_item.rinc{
                                       bins zero = {0};
                                       bins one = {1};
                                    } 
    READ_EMPTY:coverpoint rd_item.rempty{
                                         bins not_empty = {0};
                                         bins empty = {1};
                                        }
    RINC_X_REMPTY :cross rd_item.rinc,rd_item.rempty;
  endgroup
  
  
  function new(string name="fifo_subscriber",uvm_component parent=null);
    super.new(name,parent);
    wr_sub_imp=new("wr_sub_imp",this);
    rd_sub_imp=new("rd_sub_imp",this);
    wr_act_mon=new();
    rd_act_mon=new();
  endfunction
  
  function void write_wr_mon(wr_seq_item t);
    wr_item=t;
    wr_act_mon.sample();
  endfunction
  
  function void write_rd_mon(rd_seq_item t);
    rd_item=t;
    rd_act_mon.sample();
  endfunction
  
  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    wr_cov = wr_act_mon.get_coverage();
    rd_cov = rd_act_mon.get_coverage();
  endfunction
  
  function void report_phase(uvm_phase phase);
   super.report_phase(phase);
    `uvm_info(get_type_name, $sformatf("[WRITE] Coverage ------> %0.2f%%,",wr_cov), UVM_MEDIUM);
    `uvm_info(get_type_name, $sformatf("[READ] Coverage ------> %0.2f%%", rd_cov), UVM_MEDIUM);
  endfunction
 
endclass
  
