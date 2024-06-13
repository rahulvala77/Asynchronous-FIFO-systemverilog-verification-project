//-------------------------------------------------------------------------------------------
//CLASS - DRIVER
//Description - To get data packets from generator and drives to DUT through Interface
//--------------------------------------------------------------------------------------------

class fifo_driver;
  //Declaration of instances for interface
  virtual fifo_interface.wr_drv_mp wr_drv_inf;
  virtual fifo_interface.rd_drv_mp rd_drv_inf;
  virtual fifo_interface reset_drv_inf;

  fifo_xtn data_wr;        // instances for transactions class write
  fifo_xtn1 data_rd;      // instances for transactions class read
  fifo_generator generator_h;
 
  //Mailboxes to send data packets to interface
  mailbox #(fifo_xtn) gen2drv_wr;
  mailbox #(fifo_xtn1) gen2drv_rd;
 
  //function new initializes class properties in the constructor when object is created
  function new(virtual fifo_interface.wr_drv_mp wr_drv_inf, virtual fifo_interface.rd_drv_mp rd_drv_inf,
               virtual fifo_interface reset_drv_inf,mailbox #(fifo_xtn) gen2drv_wr, mailbox #(fifo_xtn1) gen2drv_rd);
    this.wr_drv_inf=wr_drv_inf;
    this.rd_drv_inf=rd_drv_inf;
    this.reset_drv_inf=reset_drv_inf;
    this.gen2drv_wr=gen2drv_wr;
    this.gen2drv_rd=gen2drv_rd;
  endfunction : new

  //------------------------------------------------------------------------------------------------
  //TASK - START (call from environment class)
  //Description - To drive write and read stimulus to DUT through interface
  //------------------------------------------------------------------------------------------------
  task start;
    fork
      wr_drive();
      rd_drive();
    join_none
  endtask : start

  //-----------------------------------------------------------------------------------------------------
  //TASK - wr_drive() (call from start task)
  //Description - To drive write stimulus to DUT through interface
  //-----------------------------------------------------------------------------------------------------
  task wr_drive();
    forever begin
    gen2drv_wr.get(data_wr);
    @(wr_drv_inf.wr_drv_cb)
    wr_drv_inf.wr_drv_cb.din <= data_wr.din;
    wr_drv_inf.wr_drv_cb.wr_en <= data_wr.wr_en;
    end   
  endtask

  //--------------------------------------------------------------------------------------------
  //TASK - rd_drive() (call from start task)
  //Description - To drive read stimulus to DUT through interface
  //--------------------------------------------------------------------------------------------
  task rd_drive();  
    forever begin
    gen2drv_rd.get(data_rd);
    @(rd_drv_inf.rd_drv_cb)
    rd_drv_inf.rd_drv_cb.rd_en <= data_rd.rd_en;
    end 
  endtask
endclass : fifo_driver
