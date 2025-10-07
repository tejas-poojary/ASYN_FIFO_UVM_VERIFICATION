 import uvm_pkg::*;
`include "uvm_macros.svh"
`include "async_fifo_defines.sv"

class wr_seq_item extends uvm_sequence_item;
  rand logic winc;
  rand logic [`DSIZE-1:0]wdata;
  logic wfull;
  logic wrst_n;
  
  function new(string name="wr_seq_item");
    super.new(name);
  endfunction
  
  `uvm_object_utils_begin(wr_seq_item)
    `uvm_field_int(wdata,UVM_ALL_ON+UVM_DEC)
    `uvm_field_int(winc,UVM_ALL_ON+UVM_DEC)
    `uvm_field_int(wfull,UVM_ALL_ON+UVM_DEC)
    `uvm_field_int(wrst_n,UVM_ALL_ON+UVM_DEC)
  `uvm_object_utils_end
  
endclass
  
  
