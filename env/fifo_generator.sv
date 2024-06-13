//-----------------------------------------------------------------------------------------------------------------------
//CLASS - GENERATOR
//Description - To generate stimulus for DUT
//-----------------------------------------------------------------------------------------------------------------------

class fifo_generator;

  fifo_xtn data_wr;          // instances for transactions class write
  fifo_xtn1 data_rd;     // instances for transactions class read
 
  //Mailboxes to send data packets to driver
  mailbox #(fifo_xtn) gen2drv_wr;
  mailbox #(fifo_xtn1) gen2drv_rd;

  //function new initializes class properties in the constructor when object is created

  function new(mailbox #(fifo_xtn) gen2drv_wr,  mailbox #(fifo_xtn1) gen2drv_rd);
    this.gen2drv_wr=gen2drv_wr;
    this.gen2drv_rd=gen2drv_rd;
  endfunction : new

//-----------------------------------------------------------------------------------------------------------------------
////TASK - START (call from environment class)
//Description - To generate write and read stimulus for DUT
//-----------------------------------------------------------------------------------------------------------------------
  virtual task start();
    fork
      gen_wr;
      gen_rd;
    join_none
  endtask : start

//-----------------------------------------------------------------------------------------------------------------------
////TASK - gen_wr (call from start task)
//Description - To generate write stimulus for DUT
//-----------------------------------------------------------------------------------------------------------------------
  task gen_wr;
    repeat(4) begin 
    data_wr=new();
    assert(data_wr.randomize() with {wr_en== 1'b0; din < 100; });
    gen2drv_wr.put(data_wr);
    end

    repeat(17) begin
    data_wr=new();
    assert(data_wr.randomize() with {wr_en==1'b1;  din < 150; });
    gen2drv_wr.put(data_wr);
    $display(" TIME = %0t ,RAHUL = generator %0p\n",$time,data_wr);
    end

    repeat(4) begin 
    data_wr=new();
    assert(data_wr.randomize() with {wr_en== 1'b0; din <200; });
    gen2drv_wr.put(data_wr);
    // $display("generator %0p\n",data_wr);
    end
  endtask : gen_wr

//-----------------------------------------------------------------------------------------------------------------------
////TASK - gen_rd (call from start task)
//Description - To generate read stimulus for DUT
//-----------------------------------------------------------------------------------------------------------------------
  task gen_rd;
    repeat(25) begin
    data_rd=new();
    assert(data_rd.randomize() with { rd_en ==1'b0; });
    gen2drv_rd.put(data_rd);
    //$display(" TIME = %0t ,generator %0p\n",$time,data_rd);
    end
    
    repeat(18) begin 
    data_rd=new();
    assert(data_rd.randomize() with {rd_en== 1'b1;   });
    gen2drv_rd.put(data_rd);
    // $display("generator %0p\n",data_wr);
    end
  endtask : gen_rd
endclass : fifo_generator

