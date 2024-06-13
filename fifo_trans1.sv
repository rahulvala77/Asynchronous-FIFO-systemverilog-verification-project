//-----------------------------------------------------------------------------------------------------------------------
//CLASS - Transaction - read
//Description - Declaration of signals used for read purpose
//-----------------------------------------------------------------------------------------------------------------------
class fifo_xtn1;

  rand bit rd_en;

  bit [7:0] dout;

  bit empty;
  bit almost_empty;

  bit rd_ack;
  bit rd_err;

endclass : fifo_xtn1
