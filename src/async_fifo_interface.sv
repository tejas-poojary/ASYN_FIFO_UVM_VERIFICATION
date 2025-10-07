interface async_fifo_intrf(input wclk,rclk,wrst_n,rrst_n);
  logic [`DSIZE-1:0]rdata,wdata;
  logic rinc,winc;
  logic wfull,rempty;
  
  clocking wr_drv_cb@(posedge wclk);
    default input #0 output #0;
    output wdata;
    output winc;
    input wfull;
  endclocking
  
  clocking rd_drv_cb@(posedge rclk);
    default input #0 output #0;
    input rdata;  //optional
    output rinc;
    input rempty;  //opt
  endclocking
  
  clocking wr_mon_cb@(posedge wclk);
    default input #0 output #0;
    input wdata;
    input winc;
    input wfull;
    input wrst_n;
  endclocking
  
  clocking rd_mon_cb@(posedge rclk);
    default input #0 output #0;
    input rdata;
    input rinc;
    input rempty;
    input rrst_n;
  endclocking
  
  clocking scb_wr_cb@(posedge wclk);
    default input #0 output #0;
    input wrst_n;
  endclocking
  
  clocking scb_rd_cb@(posedge rclk);
    default input #0 output #0;
    input rrst_n;
  endclocking
    
  modport WRT_DRV(clocking wr_drv_cb);
  modport RD_DRV(clocking rd_drv_cb);
  modport WRT_MON(clocking wr_mon_cb);
  modport RD_MON(clocking rd_mon_cb);
  modport WR_SCB(clocking scb_wr_cb);
  modport RD_SCB(clocking scb_rd_cb);
    
  //ASSERTIONS
//1    
 property write_data_not_unknown;
  @(posedge wclk) disable iff (!wrst_n)
    winc |-> !($isunknown(wdata));
endproperty
      
assert property (write_data_not_unknown)
  $info("ASSERTION write_data_not_unknown PASSED");
else
  $error("ASSERTION write_data_not_unknown FAILED");

//2      
property read_data_not_unknown;
  @(posedge rclk) disable iff (!rrst_n)
      (rinc && !rempty) |-> !($isunknown(rdata));
endproperty
   
assert property (read_data_not_unknown)
  $info("ASSERTION read_data_not_unknown PASSED");
else
  $error("ASSERTION read_data_not_unknown FAILED");

//3      
property full_empty_simultaneous;
 @(posedge rclk) disable iff (!rrst_n || !wrst_n)
    !(rempty && wfull);
endproperty
 
assert property (full_empty_simultaneous)
 $info("ASSERTION full_empty_simultaneous PASSED");
else
 $error("ASSERTION full_empty_simultaneous FAILED");

//4  
property full_after_16;
 @(posedge wclk) disable iff (!rrst_n || !wrst_n)
    (winc && !rinc)[*16]|->wfull;
endproperty

assert property (full_after_16)
 $info("ASSERTION full_after_16 PASSED");
else
 $error("ASSERTION full_after_16 FAILED");
  
//5
property wrst_check;
       @(posedge wclk) (!wrst_n) |-> !wfull;
  endproperty
assert property (wrst_check)
      $info("ASSERTION wrst_check PASSED");
else
  $error("ASSERTION wrst_check FAILED");
  
//6
property rrst_check;
      @(posedge rclk) (!rrst_n) |-> (rempty);
   endproperty
assert property (rrst_check)
      $info("ASSERTION rrst_check PASSED");
else
  $error("ASSERTION rrst_check FAILED");
  
      
endinterface
