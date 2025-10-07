class read_agent extends uvm_agent;
  `uvm_component_utils(read_agent)
  rd_driver rd_drv;
  rd_monitor rd_mon;
  rd_sequencer rd_seqr;
  
  function new(string name="read_agent",uvm_component parent=null);
    super.new(name,parent);
  endfunction
    
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(uvm_active_passive_enum)::get(this,"","is_active",is_active);
    if(get_is_active()==UVM_ACTIVE)
      begin
        rd_drv=rd_driver::type_id::create("rd_drv",this);
        rd_seqr=rd_sequencer::type_id::create("rd_seqr",this);
      end
        rd_mon=rd_monitor::type_id::create("rd_mon",this);
  endfunction
    
    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      if(get_is_active()==UVM_ACTIVE)
        begin
          rd_drv.seq_item_port.connect(rd_seqr.seq_item_export);
        end
    endfunction
    
 endclass
    
