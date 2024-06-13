//--------------------------------------------------------------------------------------
//MODULE - TOP
//Description - This module is most outer module, it has ENV and DUT both inside it. 
//It is responsible for overall ENV and DUT working operations.
//--------------------------------------------------------------------------------------
module top();

  import fifo_pkg::*;     // importing all files through pkg

  reg wr_clk,rd_clk;

  fifo_interface FIFO_INF(wr_clk,rd_clk,clear_n);
  fifo_test test_h;      // declaration of instance of test

  //connecting dut with TB interface
  async_fifo DUT(.wr_clk(wr_clk),
        .rd_clk(rd_clk),
        .clear_n(FIFO_INF.clear_n),
        .wr_en(FIFO_INF.wr_en),
        .rd_en(FIFO_INF.rd_en),
        .din(FIFO_INF.din),
        .wr_ack(FIFO_INF.wr_ack),
        .rd_ack(FIFO_INF.rd_ack),
        .wr_err(FIFO_INF.wr_err),
        .rd_err(FIFO_INF.rd_err),
        .dout(FIFO_INF.dout),
        .full(FIFO_INF.full),
        .empty(FIFO_INF.empty),
        .almost_full(FIFO_INF.almost_full),
        .almost_empty(FIFO_INF.almost_empty));

  // generating wr_clk and rd_clk
  initial begin
    wr_clk=1'b0;
    forever  
    #12 wr_clk=~wr_clk;
    end

  initial begin 
    rd_clk=1'b0;
    forever
    #14 rd_clk=~rd_clk;
    end

  initial begin 
   test_h= new(FIFO_INF,FIFO_INF,FIFO_INF,FIFO_INF,FIFO_INF); // creating object for test and pass the interface instance as arguments
   
   test_h.build_and_run();    //call the build and run
   #3000 $finish;             //finish 1 test case at 3000ns time period
     
    end
  
endmodule : top   
