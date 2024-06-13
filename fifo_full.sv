//-----------------------------------------------------------------------------------------------------------------------
//CLASS - FIFO_full - child class of GENERATOR
//Description - To generate stimulus for DUT //FIFO WRITING CLASS AND MAKE FIFO FULL and CHECKING WHETHER FULL OR NOT
//-----------------------------------------------------------------------------------------------------------------------


class fifo_full extends fifo_generator;

  fifo_xtn data_wr;          // instances for transactions class write
  fifo_xtn1 data_rd;         // instances for transactions class read

// function new initializes class properties in the constructor when object is created
  function new(mailbox #(fifo_xtn) gen2drv_wr,mailbox #(fifo_xtn1) gen2drv_rd);
    super.new(gen2drv_wr,gen2drv_rd);
  endfunction : new

//-----------------------------------------------------------------------------------------------------------------------
////TASK - START (call from environment class)
//Description - To generate write and read stimulus for DUT
//-----------------------------------------------------------------------------------------------------------------------
  task start();
    repeat(4) begin          // Initial gap for 4 write cycle             
    data_wr=new();
    assert(data_wr.randomize() with {wr_en== 1'b0;  din ==0; });
    gen2drv_wr.put(data_wr);
    // $display("generator %0p\n",data_wr);
    end
    
    repeat(17) begin         // 17 times write to make FIFO FULL and produce WR_ERR
    data_wr=new();
    assert(data_wr.randomize() with {wr_en==1'b1; din <250; });
    gen2drv_wr.put(data_wr);
    $display(" TIME = %0t ,generator %0p\n",$time,data_wr);
    end
														
    repeat(4) begin          // After writing operation then make WR_EN zero for 4 cycle
    data_wr=new();
    assert(data_wr.randomize() with {wr_en==1'b0; din ==0; });
    gen2drv_wr.put(data_wr);
    //$display(" TIME = %0t ,generator %0p\n",$time,data_wr);
    end
  endtask : start
endclass : fifo_full
