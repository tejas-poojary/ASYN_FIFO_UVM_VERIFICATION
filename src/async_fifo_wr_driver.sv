class wr_driver extends uvm_driver#(wr_seq_item);
  `uvm_component_utils(wr_driver)
  virtual async_fifo_intrf vif_wr_drv;
  wr_seq_item wr_drv_item;
  event write_mon_trigger;
  
  function new(string name="wr_driver",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual async_fifo_intrf)::get(this,"","vif",vif_wr_drv))
      begin
        `uvm_fatal(get_full_name(),"Write Driver didn't get interface handle")
      end
    if(!uvm_config_db#(event)::get(this,"","event_wr",write_mon_trigger))
      begin
        `uvm_fatal(get_full_name(),"Write Driver didn't get event")
      end
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      seq_item_port.get_next_item(wr_drv_item);
      write_drive(wr_drv_item);
      seq_item_port.item_done();
    end
  endtask
  
  task write_drive(wr_seq_item wr_drv_item);
    @(vif_wr_drv.wr_drv_cb);
       vif_wr_drv.wr_drv_cb.wdata<=wr_drv_item.wdata;
       vif_wr_drv.wr_drv_cb.winc<=wr_drv_item.winc;
       ->write_mon_trigger;
      `uvm_info("Write Driver Sending", $sformatf("Sent: %s at %0t",wr_drv_item.sprint(),$time), UVM_LOW)
  endtask
  
endclass
