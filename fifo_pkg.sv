//-----------------------------------------------------------------------------------------------------------------------
//package - FIFO_pkg : 
//Description - to include all files in test file and in TOP module
//----------------------------------------------------------------------------------------------------------------------
package fifo_pkg;

  `include "fifo_trans.sv"
  `include "fifo_trans1.sv"
  `include "fifo_generator.sv"
  `include "fifo_driver.sv"
  `include "fifo_monitor.sv"
  `include "fifo_mem.sv"
  `include "fifo_reference_model.sv"
  `include "fifo_scoreboard.sv"
  `include "fifo_env.sv"
  `include "fifo_test.sv"
   
endpackage : fifo_pkg
