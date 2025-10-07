class wr_monitor extends uvm_monitor;
  `uvm_component_utils(wr_monitor)
  virtual async_fifo_intrf vif_wr_mon;
  wr_seq_item wr_mon_item;
  uvm_analysis_port#(wr_seq_item)wr_mon_port;
  event write_mon_trigger;
  logic captured_wrst_n; //added
  
  function new(string name="wr_monitor",uvm_component parent=null);
    super.new(name,parent);
    wr_mon_port=new("wr_mon_port",this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual async_fifo_intrf)::get(this,"","vif",vif_wr_mon))
      begin
        `uvm_fatal(get_full_name(),"Write Monitor didn't get interface handle") 
      end
    if(!uvm_config_db#(event)::get(this,"","event_wr",write_mon_trigger))
      begin
        `uvm_fatal(get_full_name(),"Write Monitor didn't get event")
      end
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    //@(posedge vif_wr_mon.wrst_n); // Wait for reset de-assertion
    forever begin
      wr_mon_item=wr_seq_item::type_id::create("wr_mon_item");
      wait(write_mon_trigger.triggered);
      captured_wrst_n = vif_wr_mon.wrst_n;  //added
      @(posedge vif_wr_mon.wr_mon_cb);
      wr_mon_item.wdata=vif_wr_mon.wr_mon_cb.wdata;
      wr_mon_item.winc=vif_wr_mon.wr_mon_cb.winc;
      wr_mon_item.wfull=vif_wr_mon.wr_mon_cb.wfull;
      wr_mon_item.wrst_n=captured_wrst_n;
      wr_mon_port.write(wr_mon_item);
      `uvm_info("Write Monitor Capturing",$sformatf("Got: %s at %0t",wr_mon_item.sprint(),$time), UVM_LOW)
    end
  endtask
  
endclass
       
