//-----------------------------------------------------------------------------------------------------------------------
//BLOCK - INTERFACE
//Description - It is link between ENV and DUT. Data from ENV and DUT pass through interface only.
//-----------------------------------------------------------------------------------------------------------------------

interface fifo_interface(input bit wr_clk, rd_clk,clear_n);

  //Declaration of signals or pins between DUT and ENV.
  logic wr_en;
  logic rd_en;
  logic [7:0] din;
  logic [7:0] dout;
  logic full;
  logic almost_full;
  logic empty;
  logic almost_empty;
  logic rd_ack;
  logic wr_ack;
  logic rd_err;
  logic wr_err;
 

  //WRITE Driver clocking block
  clocking wr_drv_cb@(posedge wr_clk );
    default output #1;
    output wr_en;
    output din;
  endclocking

  //Read Driver clocking block
  clocking rd_drv_cb@(posedge rd_clk);
    default output #1;
    output rd_en;
  endclocking 

  //Write monitor clocking block
  clocking wr_mon_cb@(posedge wr_clk);
    default input #0;
    input wr_en;
    input din;
    input full,almost_full,wr_ack,wr_err;
  endclocking

  //Read Monitor clocking block
  clocking rd_mon_cb@(posedge rd_clk);
    default input #0;
    input rd_ack;
    input rd_en;
    input rd_err;
    input dout;
    input empty;
    input almost_empty;
  endclocking

  //MODPORTS declaration

  //Write driver modport
  modport wr_drv_mp (clocking wr_drv_cb);

  //Read driver modport
  modport rd_drv_mp (clocking rd_drv_cb);

  //write monitor
  modport wr_mon_mp (clocking wr_mon_cb);

  //Read monitor
  modport rd_mon_mp (clocking rd_mon_cb);

endinterface
