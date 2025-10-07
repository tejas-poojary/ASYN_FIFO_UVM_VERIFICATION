class write_agent extends uvm_agent;
  `uvm_component_utils(write_agent)
  wr_driver wr_drv;
  wr_monitor wr_mon;
  wr_sequencer wr_seqr;
  
  function new(string name="write_agent",uvm_component parent=null);
    super.new(name,parent);
  endfunction
    
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(uvm_active_passive_enum)::get(this,"","is_active",is_active);
    if(get_is_active()==UVM_ACTIVE)
      begin
        wr_drv=wr_driver::type_id::create("wr_drv",this);
        wr_seqr=wr_sequencer::type_id::create("wr_seqr",this);
      end
        wr_mon=wr_monitor::type_id::create("wr_mon",this);
  endfunction
    
    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      if(get_is_active()==UVM_ACTIVE)
        begin
          wr_drv.seq_item_port.connect(wr_seqr.seq_item_export);
        end
    endfunction
    
 endclass
    
