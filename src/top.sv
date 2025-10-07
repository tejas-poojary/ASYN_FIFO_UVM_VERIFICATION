 import uvm_pkg::*;
`include "uvm_macros.svh"
`include "async_fifo_defines.sv"
`include "async_fifo_interface.sv"
`include "async_fifo_pkg.sv"
`include "design.sv"

module async_fifo_top;
  
 import uvm_pkg::*;
 import async_fifo_pkg::*;
  
 bit wclk,rclk;
 bit wrst_n,rrst_n;
 event read_mon_trigger,write_mon_trigger;
  
 initial begin
   wclk=1'b0;
   rclk=1'b0;
   wrst_n=1'b0;
   rrst_n=1'b0;
 end
  
 always #5 wclk=!wclk;
 always #10 rclk=!rclk;
  
 initial begin
   #20 wrst_n=1;
       rrst_n=1;
   $dumpfile("dump.vcd");
   $dumpvars();
 end

  async_fifo_intrf af_intrf(.wclk(wclk),.rclk(rclk),.wrst_n(wrst_n),.rrst_n(rrst_n));
 
  FIFO dut(.rdata(af_intrf.rdata),
           .wfull(af_intrf.wfull),
           .rempty(af_intrf.rempty),
           .wdata(af_intrf.wdata),
           .winc(af_intrf.winc),
           .wclk(wclk),
           .wrst_n(wrst_n),
           .rinc(af_intrf.rinc),
           .rclk(rclk),
           .rrst_n(rrst_n)
          );
  
  initial begin
    uvm_config_db#(virtual async_fifo_intrf)::set(null,"*","vif",af_intrf);
    uvm_config_db#(event)::set(null,"*","event_wr",write_mon_trigger);
    uvm_config_db#(event)::set(null,"*","event_rd",read_mon_trigger);
    run_test("fifo_test");
    #10000 $finish;
  end
  
endmodule
  
  
