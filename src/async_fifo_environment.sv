class fifo_environment extends uvm_env;
  `uvm_component_utils(fifo_environment)
   write_agent wr_agt;
   read_agent  rd_agt;
   fifo_subscriber fifo_sub;
   fifo_scoreboard fifo_scb;
   virtual_sequencer v_seqr;
  
  function new(string name="fifo_environment",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    wr_agt=write_agent::type_id::create("wr_agt",this);
    rd_agt=read_agent::type_id::create("rd_agt",this);
    fifo_scb=fifo_scoreboard::type_id::create("fifo_scb",this);
    fifo_sub=fifo_subscriber::type_id::create("fifo_sub",this);
    v_seqr=virtual_sequencer::type_id::create("v_seqr",this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    wr_agt.wr_mon.wr_mon_port.connect(fifo_scb.wr_agt_fifo.analysis_export);
    rd_agt.rd_mon.rd_mon_port.connect(fifo_scb.rd_agt_fifo.analysis_export);
    wr_agt.wr_mon.wr_mon_port.connect(fifo_sub.wr_sub_imp);
    rd_agt.rd_mon.rd_mon_port.connect(fifo_sub.rd_sub_imp);
    
    v_seqr.wr_seqr=wr_agt.wr_seqr;
    v_seqr.rd_seqr=rd_agt.rd_seqr; 
  endfunction
  
endclass
