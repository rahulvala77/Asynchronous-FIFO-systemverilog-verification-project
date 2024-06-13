//-----------------------------------------------------------------------------------------------------------------------
//CLASS - FIFO_multiple - child class of GENERATOR
//Description - To generate stimulus for DUT 
//multiple write-Read sequence test => Write-Read, WriteWrite-ReadRead, WriteWriteWrite-ReadReadRead, WriteWriteWriteWrite-ReadReadReadRead
//-----------------------------------------------------------------------------------------------------------------------
class fifo_multiple extends fifo_generator;

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

    repeat(2) begin          // Initial gap of 2 cycles before operation 
    data_wr=new();
    data_rd=new();
    assert(data_wr.randomize() with {wr_en== 1'b0;  din ==0; });
    assert(data_rd.randomize() with { rd_en==1'b0;  });
    fork
      gen2drv_wr.put(data_wr);
      gen2drv_rd.put(data_rd);
    join
    end
    
    repeat(1) begin          // 1 time write operaion
    data_wr=new();
    data_rd=new();
    assert(data_wr.randomize() with {wr_en== 1'b1;  din == 255; });
    assert(data_rd.randomize() with { rd_en==1'b0;  });
    fork
      gen2drv_wr.put(data_wr);
      gen2drv_rd.put(data_rd);
    join
    $display("generator %0p\n",data_wr);
    end

    repeat(2) begin          // gap of 2 cycle between operation
    data_wr=new();
    data_rd=new();
    assert(data_wr.randomize() with {wr_en== 1'b0;  din ==0; });
    assert(data_rd.randomize() with { rd_en==1'b0;  });
    fork
      gen2drv_wr.put(data_wr);
      gen2drv_rd.put(data_rd);
    join
    end

    repeat(1) begin          // read data which was written during write cycle 
    data_wr=new();
    data_rd=new();
    assert(data_wr.randomize() with {wr_en== 1'b0;  din == 0; });
    assert(data_rd.randomize() with { rd_en==1'b1;  });
    fork
      gen2drv_wr.put(data_wr);
      gen2drv_rd.put(data_rd);
    join
    end

    repeat(3) begin          // Gap of 3 cycle before next operation
    data_wr=new();
    data_rd=new();
    assert(data_wr.randomize() with {wr_en== 1'b0;  din ==0; });
    assert(data_rd.randomize() with { rd_en==1'b0;  });
    fork
      gen2drv_wr.put(data_wr);
      gen2drv_rd.put(data_rd);
    join
    end
    
    repeat(2) begin          // 2 times write operation
    data_wr=new();
    data_rd=new();
    assert(data_wr.randomize() with {wr_en== 1'b1;  din <100; });
    assert(data_rd.randomize() with {rd_en==1'b0;  });
    fork
      gen2drv_wr.put(data_wr);
      gen2drv_rd.put(data_rd);
    join
    // $display("generator %0p\n",data_wr);
    end

    repeat(4) begin          // gap of 4 cycle between read operaion
    data_wr=new();
    data_rd=new();
    assert(data_wr.randomize() with {wr_en== 1'b0;  din ==0; });
    assert(data_rd.randomize() with { rd_en==1'b0;  });
    fork
      gen2drv_wr.put(data_wr);
      gen2drv_rd.put(data_rd);
    join
    end
    
    repeat(2) begin          // 2 times read operation
    data_wr=new();
    data_rd=new();
    assert(data_wr.randomize() with {wr_en== 1'b0;  din == 0; });
    assert(data_rd.randomize() with { rd_en==1'b1;  });
    fork
      gen2drv_wr.put(data_wr);
      gen2drv_rd.put(data_rd);
    join
    end

    repeat(4) begin          // Gap of 4 cycle between operation
    data_wr=new();
    data_rd=new();
    assert(data_wr.randomize() with {wr_en== 1'b0;  din ==0; });
    assert(data_rd.randomize() with { rd_en==1'b0;  });
    fork
      gen2drv_wr.put(data_wr);
      gen2drv_rd.put(data_rd);
    join
    end

    repeat(3) begin          // write operation for 3 cycle
    data_wr=new();
    data_rd=new();
    assert(data_wr.randomize() with {wr_en== 1'b1;  din <250; });
    assert(data_rd.randomize() with { rd_en==1'b0;  });
    fork
      gen2drv_wr.put(data_wr);
      gen2drv_rd.put(data_rd);
    join
    end

    repeat(2) begin          // Gap of 2 cycle between operation
    data_wr=new();
    data_rd=new();
    assert(data_wr.randomize() with {wr_en== 1'b0;  din ==0; });
    assert(data_rd.randomize() with { rd_en==1'b0;  });
    fork
      gen2drv_wr.put(data_wr);
      gen2drv_rd.put(data_rd);
    join
    end

		repeat(3) begin          // 3 times read operation
    data_wr=new();
    data_rd=new();
    assert(data_wr.randomize() with {wr_en== 1'b0;  din == 0; });
    assert(data_rd.randomize() with { rd_en==1'b1;  });
    fork
      gen2drv_wr.put(data_wr);
      gen2drv_rd.put(data_rd);
    join
    end

		repeat(4) begin          // Gap of 4 cycle between operation
    data_wr=new();
    data_rd=new();
    assert(data_wr.randomize() with {wr_en== 1'b0;  din ==0; });
    assert(data_rd.randomize() with { rd_en==1'b0;  });
    fork
      gen2drv_wr.put(data_wr);
      gen2drv_rd.put(data_rd);
    join
    end

		repeat(4) begin          // write operation for 4 cycle
    data_wr=new();
    data_rd=new();
    assert(data_wr.randomize() with {wr_en== 1'b1;  din <250; });
    assert(data_rd.randomize() with { rd_en==1'b0;  });
    fork
      gen2drv_wr.put(data_wr);
      gen2drv_rd.put(data_rd);
    join
    end

    repeat(4) begin          // Gap of 4 cycle between operation
    data_wr=new();
    data_rd=new();
    assert(data_wr.randomize() with {wr_en== 1'b0;  din ==0; });
    assert(data_rd.randomize() with { rd_en==1'b0;  });
    fork
      gen2drv_wr.put(data_wr);
      gen2drv_rd.put(data_rd);
    join
    end

		repeat(4) begin          // 4 times read operation
    data_wr=new();
    data_rd=new();
    assert(data_wr.randomize() with {wr_en== 1'b0;  din == 0; });
    assert(data_rd.randomize() with { rd_en==1'b1;  });
    fork
      gen2drv_wr.put(data_wr);
      gen2drv_rd.put(data_rd);
    join
    end

		repeat(4) begin          // Gap of 4 cycle between operation
    data_wr=new();
    data_rd=new();
    assert(data_wr.randomize() with {wr_en== 1'b0;  din ==0; });
    assert(data_rd.randomize() with { rd_en==1'b0;  });
    fork
      gen2drv_wr.put(data_wr);
      gen2drv_rd.put(data_rd);
    join
    end


  endtask : start
endclass : fifo_multiple
