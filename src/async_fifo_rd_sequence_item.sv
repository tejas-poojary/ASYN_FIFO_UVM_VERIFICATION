 import uvm_pkg::*;
`include "uvm_macros.svh"
`include "async_fifo_defines.sv"

class rd_seq_item extends uvm_sequence_item;
  rand logic rinc;
  logic [`DSIZE-1:0]rdata;
  logic rempty;
  logic rrst_n;
  
  function new(string name="rd_seq_item");
    super.new(name);
  endfunction
  
  `uvm_object_utils_begin(rd_seq_item)
    `uvm_field_int(rdata,UVM_ALL_ON+UVM_DEC)
    `uvm_field_int(rinc,UVM_ALL_ON+UVM_DEC)
    `uvm_field_int(rempty,UVM_ALL_ON+UVM_DEC)
    `uvm_field_int(rrst_n,UVM_ALL_ON+UVM_DEC)
  `uvm_object_utils_end
  
endclass
