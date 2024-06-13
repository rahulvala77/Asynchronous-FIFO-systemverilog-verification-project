//----------------------------------------------------------------------------------------
//CLASS - ENVIRONMENT
//Description - This class is under TOP and responsible for combining all component together in TB architecture
//------------------------------------------------------------------------------------------------------------

class fifo_env;
  //handle declare for all components used in fifo
  fifo_generator generator_h;
  fifo_driver driver_h;
  fifo_monitor monitor_h;
  fifo_reference_model reference_model_h;
  fifo_scoreboard scoreboard_h;
  fifo_mem mem_h;
  
  //mailboxs used inside environment by all components
  mailbox #(fifo_xtn) gen2drv_wr = new(1);
  mailbox #(fifo_xtn1) gen2drv_rd = new(1);
  mailbox #(fifo_xtn) mon2ref_wr = new();
  mailbox #(fifo_xtn1) mon2ref_rd = new();
  mailbox #(fifo_xtn) mon2sb_wr = new();
  mailbox #(fifo_xtn1) mon2sb_rd = new();
  mailbox #(fifo_xtn) ref2sb_wr = new();
  mailbox #(fifo_xtn1) ref2sb_rd = new();


  //interface used by environment
  virtual fifo_interface.wr_drv_mp wr_drv_inf;
  virtual fifo_interface.rd_drv_mp rd_drv_inf;
  virtual fifo_interface reset_drv_inf;
  virtual fifo_interface.wr_mon_mp wr_mon_inf;
  virtual fifo_interface.rd_mon_mp rd_mon_inf;

  // function new initializes class properties in the constructor when object is created
  function new(virtual fifo_interface.wr_drv_mp wr_drv_inf,virtual fifo_interface.rd_drv_mp rd_drv_inf,virtual fifo_interface reset_drv_inf,
               virtual fifo_interface.wr_mon_mp wr_mon_inf,virtual fifo_interface.rd_mon_mp rd_mon_inf);
    this.wr_drv_inf=wr_drv_inf;
    this.rd_drv_inf=rd_drv_inf;
    this.reset_drv_inf=reset_drv_inf;
    this.wr_mon_inf=wr_mon_inf;
    this.rd_mon_inf=rd_mon_inf;
    mem_h=new;
  endfunction

//-------------------------------------------------------------------------------------------------------------
//TASK - BUILD (call from test cases)
//Description - To start the process of building all components function new 
//-----------------------------------------------------------------------------------------------------------------------
  task build();
    generator_h= new(gen2drv_wr,gen2drv_rd);
    driver_h= new(wr_drv_inf,rd_drv_inf,reset_drv_inf,gen2drv_wr,gen2drv_rd);
    monitor_h=new(wr_mon_inf,rd_mon_inf,mon2sb_wr,mon2sb_rd,mon2ref_wr,mon2ref_rd);
    reference_model_h=new(mon2ref_wr,mon2ref_rd,ref2sb_wr,ref2sb_rd,reset_drv_inf,mem_h);
    scoreboard_h=new(mon2sb_wr,mon2sb_rd,ref2sb_wr,ref2sb_rd,reset_drv_inf,mem_h);
  endtask : build

//-----------------------------------------------------------------------------------------------------------------------
//TASK - RUN (call from test cases)
//Description - To start the process of running all components start process
//-----------------------------------------------------------------------------------------------------------------------
  task run();
    reset_dut();
    start_process();
  endtask :run 

//-----------------------------------------------------------------------------------------------------------------------
//TASK - RESET DUT
//Description - RESET the DUT before running every test cases
//-----------------------------------------------------------------------------------------------------------------------
  task reset_dut();
    begin
      reset_drv_inf.clear_n='0;
      #20 
      reset_drv_inf.clear_n='1;
    end
  endtask :reset_dut

//-----------------------------------------------------------------------------------------------------------------------
//TASK - start process
//Description - this task will start all start tasks in all respective components
//-----------------------------------------------------------------------------------------------------------------------
  task start_process();
    fork
      generator_h.start();
      driver_h.start();
      monitor_h.start();
      reference_model_h.start();
      scoreboard_h.start();
    join_none
  endtask : start_process
endclass : fifo_env 
