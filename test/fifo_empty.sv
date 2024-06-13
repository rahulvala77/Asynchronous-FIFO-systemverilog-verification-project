//-----------------------------------------------------------------------------------------------------------------------
//CLASS - FIFO_empty - child class of GENERATOR
//Description - To generate stimulus for DUT . //FIFO WRITING and READING //MAKE FIFO FULL THEN READ AND MAKE IT EMPTY.
//-----------------------------------------------------------------------------------------------------------------------


class fifo_empty extends fifo_generator;

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

    repeat(2) begin          //Initial gap for 2  cycle   
    data_wr=new();
    data_rd=new();
    assert(data_wr.randomize() with {wr_en== 1'b0;  din ==0; });
    assert(data_rd.randomize() with { rd_en==1'b0;  });
    fork
      gen2drv_wr.put(data_wr);
      gen2drv_rd.put(data_rd);
    join
    end
    
    repeat(17) begin         // 17 times write to make FIFO FULL and make WR_ERR 1
    data_wr=new();
    data_rd=new();
    assert(data_wr.randomize() with {wr_en== 1'b1;  din <250; });
    assert(data_rd.randomize() with { rd_en==1'b0;  });
    fork
      gen2drv_wr.put(data_wr);
      gen2drv_rd.put(data_rd);
    join
    $display("generator %0p\n",data_wr);
    end

    repeat(4) begin          // After writing operation then make WR_EN zero for 4 cycle to end reading operation
    data_wr=new();
    data_rd=new();
    assert(data_wr.randomize() with {wr_en== 1'b0;  din ==0; });
    assert(data_rd.randomize() with { rd_en==1'b0;  });
    fork
      gen2drv_wr.put(data_wr);
      gen2drv_rd.put(data_rd);
    join
    end

    repeat(17) begin         // 17 times read to make FIFO EMPTY and make RD_ERR 1
    data_wr=new();
    data_rd=new();
    assert(data_wr.randomize() with {wr_en== 1'b0;  din ==0; });
    assert(data_rd.randomize() with { rd_en==1'b1;  });
    fork
      gen2drv_wr.put(data_wr);
      gen2drv_rd.put(data_rd);
    join
    end

    repeat(4) begin          //  After reading operation then make RD_EN zero for 4 cycle to end read operation
    data_wr=new();
    data_rd=new();
    assert(data_wr.randomize() with {wr_en== 1'b0;  din ==0; });
    assert(data_rd.randomize() with { rd_en==1'b0;  });
    fork
      gen2drv_wr.put(data_wr);
      gen2drv_rd.put(data_rd);
    join
    end
   
    repeat(5) begin          // Again writing some data to cover the transition of RD_ERR (1 -> 0)  
    data_wr=new();
    data_rd=new();
    assert(data_wr.randomize() with {wr_en== 1'b1;  din <250; });
    assert(data_rd.randomize() with { rd_en==1'b0;  });
    fork
      gen2drv_wr.put(data_wr);
      gen2drv_rd.put(data_rd);
    join
    $display("generator %0p\n",data_wr);
    end

    repeat(3) begin          //  Gap between writing and reading operation
    data_wr=new();
    data_rd=new();
    assert(data_wr.randomize() with {wr_en== 1'b0;  din ==0; });
    assert(data_rd.randomize() with { rd_en==1'b0;  });
    fork
      gen2drv_wr.put(data_wr);
      gen2drv_rd.put(data_rd);
    join
    // $display("generator %0p\n",data_wr);
    end

    repeat(7) begin          // Again reading the data which was written to make FIFO empty again
    data_wr=new();
    data_rd=new();
    assert(data_wr.randomize() with {wr_en== 1'b0;  din ==0; });
    assert(data_rd.randomize() with { rd_en==1'b1;  });
    fork
      gen2drv_wr.put(data_wr);
      gen2drv_rd.put(data_rd);
    join
    // $display("generator %0p\n",data_wr);
    end

   
  
  endtask :start 
endclass: fifo_empty
