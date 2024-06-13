//-----------------------------------------------------------------------------------------------------------------------
//CLASS - FIFO_reset - child class of GENERATOR
//Description - To generate stimulus for DUT 
//-----------------------------------------------------------------------------------------------------------------------

class fifo_reset extends fifo_generator;

  fifo_xtn data_wr;          // instances for transactions class write
  fifo_xtn1 data_rd;         // instances for transactions class read

  fifo_env env_h;
  fifo_driver driver_h;

  // function new initializes class properties in the constructor when object is created
  function new(mailbox #(fifo_xtn) gen2drv_wr,mailbox #(fifo_xtn1) gen2drv_rd);
    super.new(gen2drv_wr,gen2drv_rd);
  endfunction : new

//-----------------------------------------------------------------------------------------------------------------------
////TASK - START (call from environment class)
//Description - To generate write and read stimulus for DUT while apply reset from main TEST
//-----------------------------------------------------------------------------------------------------------------------
  task start();

    repeat(4) begin               // initial gap of 4 cycle before start operation
    data_wr=new();
    data_rd=new();
    assert(data_wr.randomize() with {wr_en== 1'b0;  din ==0; });
    assert(data_rd.randomize() with { rd_en==1'b0;  });
    fork
      gen2drv_wr.put(data_wr);
      gen2drv_rd.put(data_rd);
    join
    end
    
    repeat(16) begin               // 7 cycle of writing with wr_en high
    data_wr=new();
    data_rd=new();
    assert(data_wr.randomize() with { wr_en==1'b1;});
    assert(data_rd.randomize() with { rd_en==1'b0;});
    fork
      gen2drv_wr.put(data_wr);
      gen2drv_rd.put(data_rd);
    join
    $display(" TIME = %0t ,generator %0p\n",$time,data_wr);
    end
    
    repeat(3) begin               // 3 cycle gap between write operation
    data_wr=new();
    data_rd=new();
    assert(data_wr.randomize() with {wr_en== 1'b0;  });
    assert(data_rd.randomize() with { rd_en==1'b0;  });
    fork
      gen2drv_wr.put(data_wr);
      gen2drv_rd.put(data_rd);
    join
    end

     repeat(5) begin               // 5 cycle of writing with wr_en high
    data_wr=new();
    data_rd=new();
    assert(data_wr.randomize() with { wr_en==1'b1;});
    assert(data_rd.randomize() with { rd_en==1'b0;});
    fork
      gen2drv_wr.put(data_wr);
      gen2drv_rd.put(data_rd);
    join
    $display(" TIME = %0t ,generator %0p\n",$time,data_wr);
    end
    
    repeat(3) begin               // 3 cycle gap between write operation
    data_wr=new();
    data_rd=new();
    assert(data_wr.randomize() with {wr_en== 1'b0;  });
    assert(data_rd.randomize() with { rd_en==1'b0;  });
    fork
      gen2drv_wr.put(data_wr);
      gen2drv_rd.put(data_rd);
    join
    end
    

     repeat(3) begin               // 7 cycle of writing with rd_en high
    data_wr=new();
    data_rd=new();
    assert(data_wr.randomize() with { wr_en==1'b0;});
    assert(data_rd.randomize() with { rd_en==1'b1;});
    fork
      gen2drv_wr.put(data_wr);
      gen2drv_rd.put(data_rd);
    join
    $display(" TIME = %0t ,generator %0p\n",$time,data_wr);
    end
    
    repeat(3) begin               // 3 cycle gap between write operation
    data_wr=new();
    data_rd=new();
    assert(data_wr.randomize() with {wr_en== 1'b0;  });
    assert(data_rd.randomize() with { rd_en==1'b0;  });
    fork
      gen2drv_wr.put(data_wr);
      gen2drv_rd.put(data_rd);
    join
    end

     repeat(5) begin               // 5 cycle of writing with wr_en high
    data_wr=new();
    data_rd=new();
    assert(data_wr.randomize() with { wr_en==1'b1;});
    assert(data_rd.randomize() with { rd_en==1'b0;});
    fork
      gen2drv_wr.put(data_wr);
      gen2drv_rd.put(data_rd);
    join
    $display(" TIME = %0t ,generator %0p\n",$time,data_wr);
    end
    
    repeat(3) begin               // 3 cycle gap between write operation
    data_wr=new();
    data_rd=new();
    assert(data_wr.randomize() with {wr_en== 1'b0;  });
    assert(data_rd.randomize() with { rd_en==1'b0;  });
    fork
      gen2drv_wr.put(data_wr);
      gen2drv_rd.put(data_rd);
    join
    end
    

     repeat(3) begin               // 7 cycle of writing with rd_en high
    data_wr=new();
    data_rd=new();
    assert(data_wr.randomize() with { wr_en==1'b0;});
    assert(data_rd.randomize() with { rd_en==1'b1;});
    fork
      gen2drv_wr.put(data_wr);
      gen2drv_rd.put(data_rd);
    join
    $display(" TIME = %0t ,generator %0p\n",$time,data_wr);
    end
 
     repeat(3) begin               // 3 cycle gap between write operation
    data_wr=new();
    data_rd=new();
    assert(data_wr.randomize() with {wr_en== 1'b0;  });
    assert(data_rd.randomize() with { rd_en==1'b0;  });
    fork
      gen2drv_wr.put(data_wr);
      gen2drv_rd.put(data_rd);
    join
    end
    
    repeat(5) begin               // 5 cycle of writing with wr_en high
    data_wr=new();
    data_rd=new();
    assert(data_wr.randomize() with { wr_en==1'b1;});
    assert(data_rd.randomize() with { rd_en==1'b0;});
    fork
      gen2drv_wr.put(data_wr);
      gen2drv_rd.put(data_rd);
    join
    $display(" TIME = %0t ,generator %0p\n",$time,data_wr);
    end
    
    repeat(3) begin               // 3 cycle gap between write operation
    data_wr=new();
    data_rd=new();
    assert(data_wr.randomize() with {wr_en== 1'b0;  });
    assert(data_rd.randomize() with { rd_en==1'b0;  });
    fork
      gen2drv_wr.put(data_wr);
      gen2drv_rd.put(data_rd);
    join
    end
    

     repeat(3) begin               // 7 cycle of writing with rd_en high
    data_wr=new();
    data_rd=new();
    assert(data_wr.randomize() with { wr_en==1'b0;});
    assert(data_rd.randomize() with { rd_en==1'b1;});
    fork
      gen2drv_wr.put(data_wr);
      gen2drv_rd.put(data_rd);
    join
    $display(" TIME = %0t ,generator %0p\n",$time,data_wr);
    end

     repeat(3) begin               // 3 cycle of writing with wr_en high
    data_wr=new();
    data_rd=new();
    assert(data_wr.randomize() with { wr_en==1'b1;});
    assert(data_rd.randomize() with { rd_en==1'b0;});
    fork
      gen2drv_wr.put(data_wr);
      gen2drv_rd.put(data_rd);
    join
    $display(" TIME = %0t ,generator %0p\n",$time,data_wr);
    end
    
    repeat(2) begin               // 3 cycle gap between write operation
    data_wr=new();
    data_rd=new();
    assert(data_wr.randomize() with {wr_en== 1'b0;  });
    assert(data_rd.randomize() with { rd_en==1'b0;  });
    fork
      gen2drv_wr.put(data_wr);
      gen2drv_rd.put(data_rd);
    join
    end
    

     repeat(3) begin               // 7 cycle of writing with rd_en high
    data_wr=new();
    data_rd=new();
    assert(data_wr.randomize() with { wr_en==1'b0;});
    assert(data_rd.randomize() with { rd_en==1'b1;});
    fork
      gen2drv_wr.put(data_wr);
      gen2drv_rd.put(data_rd);
    join
    $display(" TIME = %0t ,generator %0p\n",$time,data_wr);
    end

     repeat(1) begin               // 1 cycle to make wr_en and rd_en low
    data_wr=new();
    data_rd=new();
    assert(data_wr.randomize() with {wr_en== 1'b0;  });
    assert(data_rd.randomize() with { rd_en==1'b0;  });
    fork
      gen2drv_wr.put(data_wr);
      gen2drv_rd.put(data_rd);
    join
    end

    
  endtask :start
endclass :fifo_reset
