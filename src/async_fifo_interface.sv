interface async_fifo_intrf(input wclk,rclk,wrst_n,rrst_n);
  logic [`DSIZE-1:0]rdata,wdata;
  logic rinc,winc;
  logic wfull,rempty;
  
  clocking wr_drv_cb@(posedge wclk);
    output wdata;
    output winc;
    input wfull;
  endclocking
  
  clocking rd_drv_cb@(posedge rclk);
    input rdata;  //optional
    output rinc;
    input rempty;  //opt
  endclocking
  
  clocking wr_mon_cb@(posedge wclk);
    input wdata;
    input winc;
    input wfull;
  endclocking
  
  clocking rd_mon_cb@(posedge rclk);
    input rdata;
    input rinc;
    input rempty;
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
      
endinterface
