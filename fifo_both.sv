//-----------------------------------------------------------------------------------------------------------------------
//CLASS - FIFO_both - child class of GENERATOR
//Description - To generate stimulus for DUT
//-----------------------------------------------------------------------------------------------------------------------


class fifo_both extends fifo_generator;

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
    fork
      write;
      read;
    join
  endtask : start

//-----------------------------------------------------------------------------------------------------------------------
////TASK - write (call from start task)
//Description - To generate write stimulus for DUT
//-----------------------------------------------------------------------------------------------------------------------
  task write;

    repeat(5) begin           // 5 times write operation
    data_wr=new();
    assert(data_wr.randomize() with {wr_en== 1'b1; });
    gen2drv_wr.put(data_wr);
    // $display("generator %0p\n",data_wr);
    end
    
    repeat(3) begin           // 3 cycle of gap
    data_wr=new();
    assert(data_wr.randomize() with {wr_en==1'b0; });
    gen2drv_wr.put(data_wr);
    //$display(" TIME = %0t ,generator %0p\n",$time,data_wr) ;  
    end
    
    repeat(5) begin           //5 cycle of write operation again
    data_wr=new();
    assert(data_wr.randomize() with {wr_en==1'b1; });
    gen2drv_wr.put(data_wr);
    //$display(" TIME = %0t ,generator %0p\n",$time,data_wr) ;  
    end
    
    repeat(3) begin           // 3 cycle of gap again
    data_wr=new();
    assert(data_wr.randomize() with {wr_en==1'b0; });
    gen2drv_wr.put(data_wr);
    //$display(" TIME = %0t ,generator %0p\n",$time,data_wr) ;  
    end

     repeat(5) begin           // 5 times write operation
    data_wr=new();
    assert(data_wr.randomize() with {wr_en== 1'b1; });
    gen2drv_wr.put(data_wr);
    // $display("generator %0p\n",data_wr);
    end
    
    repeat(3) begin           // 3 cycle of gap
    data_wr=new();
    assert(data_wr.randomize() with {wr_en==1'b0; });
    gen2drv_wr.put(data_wr);
    //$display(" TIME = %0t ,generator %0p\n",$time,data_wr) ;  
    end
    
    repeat(5) begin           //5 cycle of write operation again
    data_wr=new();
    assert(data_wr.randomize() with {wr_en==1'b1; });
    gen2drv_wr.put(data_wr);
    //$display(" TIME = %0t ,generator %0p\n",$time,data_wr) ;  
    end
    
    repeat(3) begin           // 3 cycle of gap again
    data_wr=new();
    assert(data_wr.randomize() with {wr_en==1'b0; });
    gen2drv_wr.put(data_wr);
    //$display(" TIME = %0t ,generator %0p\n",$time,data_wr) ;  
    end
    
     repeat(5) begin           // 5 times write operation
    data_wr=new();
    assert(data_wr.randomize() with {wr_en== 1'b1; });
    gen2drv_wr.put(data_wr);
    // $display("generator %0p\n",data_wr);
    end
    
    repeat(3) begin           // 3 cycle of gap
    data_wr=new();
    assert(data_wr.randomize() with {wr_en==1'b0; });
    gen2drv_wr.put(data_wr);
    //$display(" TIME = %0t ,generator %0p\n",$time,data_wr) ;  
    end
    
    repeat(5) begin           //5 cycle of write operation again
    data_wr=new();
    assert(data_wr.randomize() with {wr_en==1'b1; });
    gen2drv_wr.put(data_wr);
    //$display(" TIME = %0t ,generator %0p\n",$time,data_wr) ;  
    end
    
    repeat(3) begin           // 3 cycle of gap again
    data_wr=new();
    assert(data_wr.randomize() with {wr_en==1'b0; });
    gen2drv_wr.put(data_wr);
    //$display(" TIME = %0t ,generator %0p\n",$time,data_wr) ;  
    end



  endtask : write

//-----------------------------------------------------------------------------------------------------------------------
////TASK - read (call from start task)
//Description - To generate read stimulus for DUT
//-----------------------------------------------------------------------------------------------------------------------
  task read;

    repeat(3) begin           // 3 cycle read operation
    data_rd=new();
    assert(data_rd.randomize() with {rd_en==1'b1; });
    gen2drv_rd.put(data_rd);
    //$display(" TIME = %0t ,generator %0p\n",$time,data_rd);
    end
    repeat(5) begin           // 5 cycle of gap
    data_rd=new();
    assert(data_rd.randomize() with {rd_en==1'b0; });
    gen2drv_rd.put(data_rd);
    //$display(" TIME = %0t ,generator %0p\n",$time,data_rd);
    end
    repeat(3) begin           // 3 cycle of read operation again
    data_rd=new();
    assert(data_rd.randomize() with {rd_en==1'b1; });
    gen2drv_rd.put(data_rd);
    //$display(" TIME = %0t ,generator %0p\n",$time,data_rd);
    end
    repeat(5) begin           // 5 cycle of gap again
    data_rd=new();
    assert(data_rd.randomize() with {rd_en==1'b0; });
    gen2drv_rd.put(data_rd);
    //$display(" TIME = %0t ,generator %0p\n",$time,data_rd);
    end

    repeat(3) begin           // 3 cycle read operation
    data_rd=new();
    assert(data_rd.randomize() with {rd_en==1'b1; });
    gen2drv_rd.put(data_rd);
    //$display(" TIME = %0t ,generator %0p\n",$time,data_rd);
    end
    repeat(5) begin           // 5 cycle of gap
    data_rd=new();
    assert(data_rd.randomize() with {rd_en==1'b0; });
    gen2drv_rd.put(data_rd);
    //$display(" TIME = %0t ,generator %0p\n",$time,data_rd);
    end
    repeat(3) begin           // 3 cycle of read operation again
    data_rd=new();
    assert(data_rd.randomize() with {rd_en==1'b1; });
    gen2drv_rd.put(data_rd);
    //$display(" TIME = %0t ,generator %0p\n",$time,data_rd);
    end
    repeat(5) begin           // 5 cycle of gap again
    data_rd=new();
    assert(data_rd.randomize() with {rd_en==1'b0; });
    gen2drv_rd.put(data_rd);
    //$display(" TIME = %0t ,generator %0p\n",$time,data_rd);
    end

    repeat(3) begin           // 3 cycle read operation
    data_rd=new();
    assert(data_rd.randomize() with {rd_en==1'b1; });
    gen2drv_rd.put(data_rd);
    //$display(" TIME = %0t ,generator %0p\n",$time,data_rd);
    end
    repeat(5) begin           // 5 cycle of gap
    data_rd=new();
    assert(data_rd.randomize() with {rd_en==1'b0; });
    gen2drv_rd.put(data_rd);
    //$display(" TIME = %0t ,generator %0p\n",$time,data_rd);
    end
    repeat(3) begin           // 3 cycle of read operation again
    data_rd=new();
    assert(data_rd.randomize() with {rd_en==1'b1; });
    gen2drv_rd.put(data_rd);
    //$display(" TIME = %0t ,generator %0p\n",$time,data_rd);
    end
    repeat(5) begin           // 5 cycle of gap again
    data_rd=new();
    assert(data_rd.randomize() with {rd_en==1'b0; });
    gen2drv_rd.put(data_rd);
    //$display(" TIME = %0t ,generator %0p\n",$time,data_rd);
    end
  endtask : read
endclass :fifo_both
