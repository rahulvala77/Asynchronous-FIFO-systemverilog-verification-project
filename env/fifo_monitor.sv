//-----------------------------------------------------------------------------------------------------------------------
//CLASS - RD_MONITOR
//Description - To get data packets from DUT through interface and put that data packets in to scoreboard
//-----------------------------------------------------------------------------------------------------------------------
class fifo_monitor;
 
  //Declaration of instances for interface
  virtual fifo_interface.wr_mon_mp wr_mon_inf;
  virtual fifo_interface.rd_mon_mp rd_mon_inf; 

  fifo_xtn wr_sample_pkt;     // instances for transactions class write
  fifo_xtn1 rd_sample_pkt;    // instances for transactions class read
 
  //Mailboxes to send data packets to scoreboard
  mailbox #(fifo_xtn) mon2sb_wr;
  mailbox #(fifo_xtn1) mon2sb_rd;

	//Mailboxes to send data packets to reference model
  mailbox #(fifo_xtn) mon2ref_wr;
  mailbox #(fifo_xtn1) mon2ref_rd;

  //function new initializes class properties in the constructor when object is created
  function new(virtual fifo_interface.wr_mon_mp wr_mon_inf,virtual fifo_interface.rd_mon_mp rd_mon_inf,mailbox #(fifo_xtn)mon2sb_wr,
               mailbox #(fifo_xtn1) mon2sb_rd,mailbox #(fifo_xtn) mon2ref_wr,mailbox #(fifo_xtn1) mon2ref_rd);
    this.wr_mon_inf = wr_mon_inf;
    this.rd_mon_inf =rd_mon_inf;
    this.mon2sb_wr = mon2sb_wr;
    this.mon2sb_rd = mon2sb_rd;
		this.mon2ref_wr = mon2ref_wr;
    this.mon2ref_rd = mon2ref_rd;
  endfunction : new

//---------------------------------------------------------------------------------------------
//TASK - START (call from environment class)
//Description - To get write and read data packets from DUT through interface and put that
//              in scoreboard
//---------------------------------------------------------------------------------------------
  task start();
    fork
      wr_mon;
      rd_mon;
    join_none
  endtask : start

  task wr_mon(); 
    forever begin
    wr_sample_pkt=new();
    @(wr_mon_inf.wr_mon_cb) begin
      wr_sample_pkt.din         =  wr_mon_inf.wr_mon_cb.din;
      wr_sample_pkt.wr_en       = wr_mon_inf.wr_mon_cb.wr_en;
      wr_sample_pkt.full        = wr_mon_inf.wr_mon_cb.full;
      wr_sample_pkt.almost_full = wr_mon_inf.wr_mon_cb.almost_full;
      wr_sample_pkt.wr_ack      = wr_mon_inf.wr_mon_cb.wr_ack;
      wr_sample_pkt.wr_err      = wr_mon_inf.wr_mon_cb.wr_err;
      end
    mon2sb_wr.put(wr_sample_pkt);
		mon2ref_wr.put(wr_sample_pkt);
    end
  endtask : wr_mon

  task rd_mon();
    forever begin
    rd_sample_pkt=new();
    @(rd_mon_inf.rd_mon_cb) begin
      rd_sample_pkt.rd_en       = rd_mon_inf.rd_mon_cb.rd_en;
      rd_sample_pkt.dout        = rd_mon_inf.rd_mon_cb.dout;
      rd_sample_pkt.empty       = rd_mon_inf.rd_mon_cb.empty;
      rd_sample_pkt.almost_empty= rd_mon_inf.rd_mon_cb.almost_empty;
      rd_sample_pkt.rd_ack      = rd_mon_inf.rd_mon_cb.rd_ack;
      rd_sample_pkt.rd_err      = rd_mon_inf.rd_mon_cb.rd_err;
      end
    mon2sb_rd.put(rd_sample_pkt);
		mon2ref_rd.put(rd_sample_pkt);
    end
  endtask : rd_mon
endclass: fifo_monitor
