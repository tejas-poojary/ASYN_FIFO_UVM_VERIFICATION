class virtual_sequencer extends uvm_sequencer#(uvm_sequence_item);
  `uvm_component_utils(virtual_sequencer)
  
  wr_sequencer wr_seqr;
  rd_sequencer rd_seqr;
  
  function new(string name="virtual_sequencer",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
endclass
