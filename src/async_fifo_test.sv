class fifo_test extends uvm_test;
  `uvm_component_utils(fifo_test)
  fifo_environment fifo_env;
  virtual_sequence v_seq;
  
  function new(string name="fifo_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    fifo_env=fifo_environment::type_id::create("fifo_env",this);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
      v_seq=virtual_sequence::type_id::create("v_seq",this);
      v_seq.start(fifo_env.v_seqr);
    phase.drop_objection(this);
  endtask
  
endclass
