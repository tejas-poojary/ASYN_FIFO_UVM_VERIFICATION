class rd_driver extends uvm_driver#(rd_seq_item);
  `uvm_component_utils(rd_driver)
   virtual async_fifo_intrf vif_rd_drv;
   rd_seq_item rd_drv_item;
   event read_mon_trigger;
  
  function new(string name="rd_driver",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual async_fifo_intrf)::get(this,"","vif",vif_rd_drv))
      begin
        `uvm_fatal(get_full_name(),"Read Driver didn't get interface handle")
      end
    if(!uvm_config_db#(event)::get(this,"","event_rd",read_mon_trigger))
      begin
        `uvm_fatal(get_full_name(),"Read Driver didn't get event")
      end
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      seq_item_port.get_next_item(rd_drv_item);
      read_drive(rd_drv_item);
      seq_item_port.item_done();
    end
  endtask
  
  task read_drive(rd_seq_item rd_drv_item);
    @(vif_rd_drv.rd_drv_cb);
       vif_rd_drv.rd_drv_cb.rinc<=rd_drv_item.rinc;
       ->read_mon_trigger;
      `uvm_info("Read Driver Sending", $sformatf("Sent: %s at %0t",rd_drv_item.sprint(),$time), UVM_LOW)
  endtask
  
endclass
