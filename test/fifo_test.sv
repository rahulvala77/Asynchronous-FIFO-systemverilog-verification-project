// import pkg files
import fifo_pkg::*;

`include "fifo_full.sv"
`include "fifo_reset.sv"
`include "fifo_empty.sv"
`include "fifo_multiple.sv"
`include "fifo_both.sv"

//-----------------------------------------------------------------------------------------------------------------------
//Class - Base test (call from Top module)
//Description - To have all test functions
//-----------------------------------------------------------------------------------------------------------------------
class fifo_test;
  virtual fifo_interface.wr_drv_mp wr_drv_inf;
  virtual fifo_interface.rd_drv_mp rd_drv_inf;
  virtual fifo_interface reset_drv_inf;
  virtual fifo_interface.wr_mon_mp wr_mon_inf;
  virtual fifo_interface.rd_mon_mp rd_mon_inf;

  fifo_env env_h; // Declare an handle for env class

  //declaring instances of all test case
  fifo_full fw;
  fifo_reset freset;
  fifo_empty fwr;
  fifo_multiple fmulti;
  fifo_both fboth;

  //function new initializes class properties in the constructor when object is created
  function new( virtual fifo_interface.wr_drv_mp wr_drv_inf,virtual fifo_interface.rd_drv_mp rd_drv_inf,
    virtual fifo_interface reset_drv_inf,virtual fifo_interface.wr_mon_mp wr_mon_inf,
    virtual fifo_interface.rd_mon_mp rd_mon_inf);

    this.wr_drv_inf=wr_drv_inf;
    this.rd_drv_inf=rd_drv_inf;
    this.reset_drv_inf=reset_drv_inf;
    this.wr_mon_inf=wr_mon_inf;
    this.rd_mon_inf=rd_mon_inf;
  endfunction : new

//-----------------------------------------------------------------------------------------------------------------------
////TASK - build and run (call from top module)
//Description - To have all test cases and it can trigger any test case as per command
//-----------------------------------------------------------------------------------------------------------------------
  task build_and_run();
 
    env_h=new(wr_drv_inf,rd_drv_inf,reset_drv_inf,wr_mon_inf,rd_mon_inf);


    begin

    if($test$plusargs("fifo_full"))begin
      $display("time %0t inside fifo_full test case",$time);
      fw = new(env_h.gen2drv_wr, env_h.gen2drv_rd);
      env_h.build(); 
      env_h.generator_h = fw;
      env_h.run();
    end
  
    if($test$plusargs("fifo_reset"))begin
      $display("time %0t inside fifo_reset test case",$time);
      freset = new(env_h.gen2drv_wr,env_h.gen2drv_rd);
      env_h.build();
      env_h.generator_h = freset;
      fork
        #204 reset_drv_inf.clear_n= '0;        // reset at the posedge of wr_clk
        #234 reset_drv_inf.clear_n= '1;
   
        #283 reset_drv_inf.clear_n= '0;        // reset at middle of posedge of wr_clk
        #308 reset_drv_inf.clear_n= '1;

        #343 reset_drv_inf.clear_n= '0;        // reset at middle of negedge of wr_clk
        #370 reset_drv_inf.clear_n= '1;

        #1358 reset_drv_inf.clear_n= '0;       // reset at the posedge of rd_clk
        #1379 reset_drv_inf.clear_n= '1;

        #1726 reset_drv_inf.clear_n= '0;       // reset at middle of posedge of rd_clk
        #1758 reset_drv_inf.clear_n= '1;

        #1940 reset_drv_inf.clear_n= '0;       // reset at middle of negedge of rd_clk
        #1984 reset_drv_inf.clear_n= '1;

        #2100 reset_drv_inf.clear_n= '0;       // apply reset when wr_en and rd_en are low
        #2200 reset_drv_inf.clear_n= '1;

        env_h.run();
      join
    end
   
    if($test$plusargs("fifo_empty"))begin
     $display("time %0t inside fifo_write_read test case",$time);
     fwr = new(env_h.gen2drv_wr,env_h.gen2drv_rd);
     env_h.build();
     env_h.generator_h = fwr;
     env_h.run();
    end

    if($test$plusargs("fifo_multiple"))begin
     $display("time %0t inside fifo_multiple test case",$time);
     fmulti = new(env_h.gen2drv_wr,env_h.gen2drv_rd);
     env_h.build();
     env_h.generator_h = fmulti;
     env_h.run();
    end

    if($test$plusargs("fifo_both"))begin
     $display("time %0t inside fifo_both test case",$time);
     fboth = new(env_h.gen2drv_wr,env_h.gen2drv_rd);
     env_h.build();
     env_h.generator_h = fboth;
     env_h.run();
    end
    end
  endtask : build_and_run
endclass : fifo_test
