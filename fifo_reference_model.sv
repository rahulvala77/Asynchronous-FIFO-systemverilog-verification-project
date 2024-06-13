//-----------------------------------------------------------------------------------------------------------------------
//CLASS - REFERENCE MODEL
//Description - This class is under TOP and responsible for generating output as per input data packets get from write monitor
//-----------------------------------------------------------------------------------------------------------------------
class fifo_reference_model;

  fifo_xtn wr_mon2ref_pkt;      // instances for transactions class write
  fifo_xtn1 rd_mon2ref_pkt;     // instances for transactions class read

  fifo_xtn ref_pkt_wr;          //instances for transactions class write
  fifo_xtn1 ref_pkt_rd;         // instances for transactions class read

  logic wr1_ack,wr1_err;
  logic rd1_ack,rd1_err;
  logic [7:0] dout1;
 
  //Mailboxes to get data from write monitor and put the data in scoreboard
  mailbox #(fifo_xtn) mon2ref_wr;
  mailbox #(fifo_xtn1) mon2ref_rd;
  mailbox #(fifo_xtn) ref2sb_wr;
  mailbox #(fifo_xtn1) ref2sb_rd;
  fifo_mem mem_h;

  //Declaration of instances for interface
  virtual fifo_interface reset_drv_inf;

// function new initializes class properties in the constructor when object is created
  function new(mailbox #(fifo_xtn) mon2ref_wr,mailbox #(fifo_xtn1) mon2ref_rd,mailbox #(fifo_xtn) ref2sb_wr,
               mailbox #(fifo_xtn1) ref2sb_rd,virtual fifo_interface reset_drv_inf,fifo_mem mem_h);

    this.mon2ref_wr=mon2ref_wr;
    this.mon2ref_rd=mon2ref_rd;
    this.ref2sb_wr = ref2sb_wr;
    this.ref2sb_rd = ref2sb_rd;
    this.reset_drv_inf=reset_drv_inf;
    this.mem_h = mem_h;
  endfunction : new

//-----------------------------------------------------------------------------------------------------------------------
//TASK - START (call from environment class)
//Description - this task will start generating output signals as per input signals get from write monitor
//-----------------------------------------------------------------------------------------------------------------------
  task start;
    fork
      ref_model_wr;
      ref_model_rd;
    join_none
  endtask : start

  task ref_model_wr();
    forever begin
      ref_pkt_wr = new();
      mon2ref_wr.get(wr_mon2ref_pkt);
 
      if(reset_drv_inf.clear_n == 1'b0) begin
   
      mem_h.queue.delete();
      $display("the contents of mem_h.mem_h.queue are %0p and the size is %0d", mem_h.queue, mem_h.queue.size);
      ref_pkt_wr.full  =1'b1;
      ref_pkt_wr.almost_full =1'b1;
      
      end
      else begin
        if(wr_mon2ref_pkt.wr_en && mem_h.queue.size()!=16)begin
        mem_h.queue.push_back(wr_mon2ref_pkt.din);
        $display("time = %0t contents of mem_h.queue are %0p and the size is %0d",$time, mem_h.queue, mem_h.queue.size);
        ref_pkt_wr.din = wr_mon2ref_pkt.din;
        ref_pkt_wr.wr_en = wr_mon2ref_pkt.wr_en;
        wr1_ack = 1'b1;
        wr1_err = 1'b0;
        flags_wr();
        end
      else if (wr_mon2ref_pkt.wr_en && mem_h.queue.size()==16) begin
        ref_pkt_wr.din = wr_mon2ref_pkt.din;
        ref_pkt_wr.wr_en = wr_mon2ref_pkt.wr_en;
        wr1_ack = 1'b0;
        wr1_err = 1'b1;
        $display("Time = %0t FIFO is ************FULL********* can not WRITE DATA",$time);
        flags_wr();
        end

      else begin
        ref_pkt_wr.din = wr_mon2ref_pkt.din;
        ref_pkt_wr.wr_en = wr_mon2ref_pkt.wr_en;
        wr1_ack = 1'b0;
        wr1_err = 1'b0;
        flags_wr();
        end

      end
      ref_pkt_wr.wr_err = wr1_err;
      ref_pkt_wr.wr_ack = wr1_ack;

      ref2sb_wr.put(ref_pkt_wr);
    end
  endtask : ref_model_wr

  task ref_model_rd();
    forever begin
      ref_pkt_rd = new();
      mon2ref_rd.get(rd_mon2ref_pkt);

      if(reset_drv_inf.clear_n == 1'b0) begin
   
      mem_h.queue.delete();
      $display("the contents of mem_h.queue are %0p and the size is %0d", mem_h.queue, mem_h.queue.size);
      ref_pkt_rd.empty  =1'b1;
      ref_pkt_rd.almost_empty =1'b1;
      end

      else begin
        if(rd_mon2ref_pkt.rd_en && mem_h.queue.size()!=0)begin
      
          dout1 = mem_h.queue.pop_front();
          $display("time = %0t contents of mem_h.queue are %0p and the size is %0d",$time, mem_h.queue, mem_h.queue.size);
          ref_pkt_rd.rd_en = rd_mon2ref_pkt.rd_en;
          rd1_ack = 1'b1;
          rd1_err = 1'b0;
          flags_rd();
          end

        else if (rd_mon2ref_pkt.rd_en && mem_h.queue.size()==0) begin 
          ref_pkt_rd.rd_en = rd_mon2ref_pkt.rd_en;
          dout1 = rd_mon2ref_pkt.dout;
          rd1_ack = 1'b0;
          rd1_err = 1'b1;
          $display("Time = %0t FIFO is ***************EMPTY************** can not Read data",$time);
          flags_rd();
          end

        else begin
          ref_pkt_rd.rd_en = rd_mon2ref_pkt.rd_en;
          dout1  = rd_mon2ref_pkt.dout;
          rd1_ack = 1'b0;
          rd1_err = 1'b0;
          flags_rd();
          end
      end
     
      ref_pkt_rd.dout = dout1;
      ref_pkt_rd.rd_ack = rd1_ack;
      ref_pkt_rd.rd_err = rd1_err;
    
      ref2sb_rd.put(ref_pkt_rd);
     
    end
  endtask : ref_model_rd

  task flags_wr();
    if(mem_h.queue.size == 16) begin
      ref_pkt_wr.full = 1'b1;
      ref_pkt_wr.almost_full = 1'b1;
      end
  
    else if(mem_h.queue.size == 15) begin
      ref_pkt_wr.full = 1'b0;
      ref_pkt_wr.almost_full = 1'b1;
      end
     
    else begin
      ref_pkt_wr.full = 1'b0;
      ref_pkt_wr.almost_full = 1'b0;
      end
 
  endtask : flags_wr

  task flags_rd();
    if(mem_h.queue.size() == 1) begin
      ref_pkt_rd.almost_empty = 1'b1;
      ref_pkt_rd.empty = 1'b0;
      end
     
    else if(mem_h.queue.size() == 0) begin 
      ref_pkt_rd.almost_empty = 1'b1;
      ref_pkt_rd.empty = 1'b1;
      end
  
    else begin
      ref_pkt_rd.almost_empty = 1'b0;
      ref_pkt_rd.empty = 1'b0;
      end

  endtask :flags_rd
endclass : fifo_reference_model
