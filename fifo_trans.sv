//-----------------------------------------------------------------------------------------------------------------------
//CLASS - Transaction - write
//Description - Declaration of signals used for write purpose
//-----------------------------------------------------------------------------------------------------------------------
class fifo_xtn;

  randc bit [7:0] din;
  rand bit wr_en;

  bit full;
  bit almost_full;

  bit wr_ack;
  bit wr_err;

endclass : fifo_xtn  
