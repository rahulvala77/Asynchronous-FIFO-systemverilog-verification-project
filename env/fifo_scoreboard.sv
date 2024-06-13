//-----------------------------------------------------------------------------------------------------------------------
//CLASS - SCOREBOARD
//Description - This class is under TOP and responsible for comparing two packets coming from monitor and reference model
//-----------------------------------------------------------------------------------------------------------------------
class fifo_scoreboard;

  fifo_xtn mon2sb_pkt_wr;// instances for transactions class write
  fifo_xtn1 mon2sb_pkt_rd;// instances for transactions class read

  fifo_xtn ref2sb_pkt_wr;// instances for transactions class write
  fifo_xtn1 ref2sb_pkt_rd;// instances for transactions class read
  virtual fifo_interface reset_drv_inf;

  fifo_xtn cov_data1;// instances for transactions class write coverage
  fifo_xtn1 cov_data2;// instances for transactions class read coverage

	fifo_xtn cov_wr;						// instances for transactions class write coverage
	fifo_xtn1 cov_rd;					// instances for transactions class read coverage

  fifo_mem mem_h;

  //Mailboxes to receive data from reference model and read monitor
  mailbox #(fifo_xtn) mon2sb_wr;
  mailbox #(fifo_xtn1) mon2sb_rd;

  mailbox #(fifo_xtn) ref2sb_wr;
  mailbox #(fifo_xtn1) ref2sb_rd;

//covergroup for fifo_full_test
  covergroup fifo_xtn_cvg_full;
    
    WR_ENB: coverpoint cov_data1.wr_en{bins ZERO = {0};  bins ONE = {1}; }
    DATA_IN: coverpoint cov_data1.din iff(cov_data1.wr_en && reset_drv_inf.clear_n){bins din1 ={[0:50]};
                                                           bins din2 ={[51:100]};
                                                           bins din3 ={[101:150]};
                                                           bins din4 ={[151:200]};
                                                           bins din5 ={[201:255]}; }

    FULL: coverpoint cov_data1.full iff(cov_data1.wr_en && reset_drv_inf.clear_n){bins ZERO = {0};  bins ONE = {1}; }
    ALMOST_FULL : coverpoint cov_data1.almost_full iff(cov_data1.wr_en && reset_drv_inf.clear_n){bins ZERO = {0};  bins ONE = {1}; }

    FULL_X_ALMOST_FULL : cross FULL, ALMOST_FULL{ignore_bins my_ignore =binsof(FULL) intersect{1} && binsof(ALMOST_FULL) intersect{0};}
   
    FULL_trans: coverpoint {mem_h.queue.size(), cov_data1.full} iff(cov_data1.wr_en && reset_drv_inf.clear_n)
                               {bins cb_full_trans = ('b1111_0 =>'b10000_1);}
   
    ALMOST_FULL_trans: coverpoint {mem_h.queue.size(), cov_data1.almost_full} iff(cov_data1.wr_en && reset_drv_inf.clear_n)
                               {bins cb_almost_full_TRANS = ('b1110_0 =>'b1111_1);} 
    
    WR_ACK: coverpoint cov_data1.wr_ack iff(cov_data1.wr_en && reset_drv_inf.clear_n){bins ZERO = {0};  bins ONE = {1}; }
    WR_ERR: coverpoint cov_data1.wr_err iff(cov_data1.wr_en && reset_drv_inf.clear_n){bins ZERO = {0};  bins ONE = {1}; } 
    WR_ACK_X_WR_ERR: cross WR_ACK, WR_ERR{ignore_bins my_ignore1 =binsof(WR_ACK) intersect{1} && binsof(WR_ERR) intersect{1}; ignore_bins my_ignore2 =binsof(WR_ACK) intersect{0} && binsof(WR_ERR) intersect{0};}
    WR_ACK_TRANS: coverpoint cov_data1.wr_ack iff(cov_data1.wr_en && reset_drv_inf.clear_n){bins ONETOZERO = (1=>0);}
    WR_ERR_TRANS: coverpoint cov_data1.wr_err iff(cov_data1.wr_en && reset_drv_inf.clear_n){bins ZEROTOONE = (0=>1);}

  endgroup 

  //covergroup for fifo_empty_test
  covergroup fifo_xtn1_cvg_empty;
    
    RD_ENB: coverpoint cov_data2.rd_en iff(reset_drv_inf.clear_n){bins ZERO = {0};  bins ONE = {1}; }
    DATA_OUT: coverpoint cov_data2.dout iff(cov_data2.rd_en && reset_drv_inf.clear_n){bins d_out1 = {[0:50]};
                                                             bins d_out2 = {[51:100]};
                                                             bins d_out3 = {[101:150]};
                                                             bins d_out4 = {[151:200]};
                                                             bins d_out5 = {[201:255]};}
    EMPTY: coverpoint cov_data2.empty iff(cov_data2.rd_en && reset_drv_inf.clear_n){bins ZERO = {0};  bins ONE = {1};}
    ALMOST_EMPTY : coverpoint cov_data2.almost_empty iff(cov_data2.rd_en && reset_drv_inf.clear_n){bins ZERO = {0};  bins ONE = {1}; }
    EMPTY_X_ALMOST_EMPTY : cross EMPTY,ALMOST_EMPTY{ignore_bins my_ignore =binsof(EMPTY) intersect{1} && binsof(ALMOST_EMPTY) intersect{0};}

    EMPTY_TRANS: coverpoint {mem_h.queue.size(),cov_data2.empty} iff(cov_data2.rd_en && reset_drv_inf.clear_n)
                            {bins cb_empty_trans = ('b1_0 =>'b0_1);}

    ALMOST_EMPTY_TRANS: coverpoint {mem_h.queue.size(),cov_data2.almost_empty} iff(cov_data2.rd_en && reset_drv_inf.clear_n)
                            {bins cb_almost_empty_trans = ('b10_0 =>'b1_1); bins sb_almost_empty_one =('b1_1 => 'b0_1);} 
    
    RD_ACK: coverpoint cov_data2.rd_ack iff(cov_data2.rd_en && reset_drv_inf.clear_n){bins ZERO = {0};  bins ONE = {1}; }
    RD_ERR: coverpoint cov_data2.rd_err iff(cov_data2.rd_en && reset_drv_inf.clear_n){bins ZERO = {0};  bins ONE = {1}; }
    RD_ACK_X_RD_ERR:cross RD_ACK, RD_ERR{ignore_bins my_ignore1 =binsof(RD_ACK) intersect{1} && binsof(RD_ERR) intersect{1}; ignore_bins my_ignore2 =binsof(RD_ACK) intersect{0} && binsof(RD_ERR) intersect{0};}
    RD_ACK_TRANS: coverpoint cov_data2.rd_ack iff(cov_data2.rd_en && reset_drv_inf.clear_n){bins ZEROTOONE = (0=>1); bins ONETOZERO = (1=>0);}
    RD_ERR_TRANS: coverpoint cov_data2.rd_err iff(cov_data2.rd_en && reset_drv_inf.clear_n){bins ZEROTOONE = (0=>1); bins ONETOZERO = (1=>0);}
    
  endgroup

  //coverage for fifo_reset_test
  covergroup reset_cvg_wr;
	  RESET: coverpoint reset_drv_inf.clear_n{bins ZERO = {0};  bins ONE = {1}; }
    WR_ENB: coverpoint cov_data1.wr_en{bins ZERO = {0};  bins ONE = {1}; }
	  RESET_X_WR_ENB : cross RESET, WR_ENB {ignore_bins my_ignore = binsof(RESET) intersect{0} && binsof(WR_ENB) intersect{1};}
    FULL: coverpoint cov_data1.full{bins ZERO = {0};  bins ONE = {1}; }
    ALMOST_FULL : coverpoint cov_data1.almost_full {bins ZERO = {0};  bins ONE = {1}; }
    RESET_X_FULL : cross RESET,FULL {ignore_bins my_ignore = binsof(RESET) intersect{0} && binsof(FULL) intersect{0};}
    RESET_X_ALMOST_FULL : cross RESET, ALMOST_FULL{ignore_bins my_ignore = binsof(RESET) intersect{0} && binsof(ALMOST_FULL) intersect{0};}

    FULL_AFTER_RESET : coverpoint {reset_drv_inf.clear_n,cov_wr.full} {bins cb_full_reset_trans = ('b1_0 => 'b0_1);}

    ALMOST_FULL_AFTER_RESET : coverpoint {reset_drv_inf.clear_n,cov_wr.full} {bins cb_almost_full_reset_trans = ('b1_0 => 'b0_1);}

	endgroup : reset_cvg_wr

  covergroup reset_cvg_rd;
    RESET: coverpoint reset_drv_inf.clear_n{bins ZERO = {0};  bins ONE = {1}; }
    RD_ENB: coverpoint {cov_data2.rd_en}{bins ZERO = {0};  bins ONE = {1}; }
	  RESET_X_RD_ENB : cross RESET, RD_ENB {ignore_bins my_ignore = binsof(RESET) intersect{0} && binsof(RD_ENB) intersect{1};}
    EMPTY: coverpoint {cov_data2.empty}{bins ZERO = {0};  bins ONE = {1};}
    ALMOST_EMPTY : coverpoint {cov_data2.almost_empty}{bins ZERO = {0};  bins ONE = {1}; }
    RESET_X_EMPTY : cross RESET,EMPTY{ignore_bins my_ignore = binsof(RESET) intersect{0} && binsof(EMPTY) intersect{0};}
    RESET_X_ALMOST_EMPTY : cross RESET, ALMOST_EMPTY {ignore_bins my_ignore = binsof(RESET) intersect{0} && binsof(ALMOST_EMPTY) intersect{0};}

    EMPTY_AFTER_RESET : coverpoint {reset_drv_inf.clear_n,cov_rd.empty} {bins cb_full_reset_trans = ('b1_0 => 'b0_1);}

    ALMOST_EMPTY_AFTER_RESET : coverpoint {reset_drv_inf.clear_n,cov_rd.almost_empty} {bins cb_almost_full_reset_trans = ('b1_0 => 'b0_1);}

  endgroup: reset_cvg_rd

  //coverage for the fifo_multiple_test
  covergroup fifo_xtn_cvg_multiple;
    
    WR_ENB: coverpoint cov_data1.wr_en{bins ZERO = {0};  bins ONE = {1}; }
    WR_ACK: coverpoint cov_data1.wr_ack iff(cov_data1.wr_en){bins ONE = {1}; }
    WR_ACK_TRANS: coverpoint cov_data1.wr_ack {bins ZEROTOONE = (0=>1); bins ONETOZERO = (1=>0);}
    
  endgroup 

  covergroup fifo_xtn1_cvg_multiple;

    RD_ENB: coverpoint {cov_data2.rd_en}{bins ZERO = {0};  bins ONE = {1}; }
    EMPTY: coverpoint cov_data2.empty iff(cov_data2.rd_en && reset_drv_inf.clear_n){bins ZERO = {0};  bins ONE = {1};}
    ALMOST_EMPTY : coverpoint cov_data2.almost_empty iff(cov_data2.rd_en){bins ZERO = {0};  bins ONE = {1}; }
    EMPTY_X_ALMOST_EMPTY : cross EMPTY,ALMOST_EMPTY{ignore_bins my_ignore =binsof(EMPTY) intersect{1} && binsof(ALMOST_EMPTY) intersect{0};}

    EMPTYTRANS: coverpoint cov_data2.empty iff(cov_data2.rd_en && reset_drv_inf.clear_n){bins ZEROTOONE = (0=>1); bins ONETOZERO = (1=>0);}
    ALMOST_EMPTY_TRANS: coverpoint cov_data2.almost_empty iff(cov_data2.rd_en && reset_drv_inf.clear_n){bins ZEROTOONE = (0=>1); bins ONETOZERO = (1=>0);}
    RD_ACK: coverpoint cov_data2.rd_ack iff(cov_data2.rd_en && reset_drv_inf.clear_n){ bins ONE = {1}; }
    RD_ACK_TRANS: coverpoint cov_data2.rd_ack {bins ZEROTOONE = (0=>1); bins ONETOZERO = (1=>0);}
    
  endgroup

  //coverage for the fifo_both_test
	covergroup fifo_xtn_cvg_both;
    
    WR_ENB: coverpoint cov_data1.wr_en{bins ZERO = {0};  bins ONE = {1}; }
    WR_ACK: coverpoint cov_data1.wr_ack iff(cov_data1.wr_en){ bins ONE = {1}; }
    WR_ACK_TRANS: coverpoint cov_data1.wr_ack {bins ZEROTOONE = (0=>1); bins ONETOZERO = (1=>0);}
    
  endgroup 

  covergroup fifo_xtn1_cvg_both;

    RD_ENB: coverpoint {cov_data2.rd_en}{bins ZERO = {0};  bins ONE = {1}; }
    RD_ACK: coverpoint cov_data2.rd_ack iff(cov_data2.rd_en){ bins ONE = {1}; }
    RD_ACK_TRANS: coverpoint cov_data2.rd_ack {bins ZEROTOONE = (0=>1); bins ONETOZERO = (1=>0);}
   
  endgroup

  // function new initializes class properties in the constructor when object is created
  function new(mailbox #(fifo_xtn)mon2sb_wr,mailbox #(fifo_xtn1) mon2sb_rd,mailbox #(fifo_xtn)ref2sb_wr,
               mailbox #(fifo_xtn1)ref2sb_rd,virtual fifo_interface reset_drv_inf,fifo_mem mem_h);
    this.mon2sb_wr=mon2sb_wr;
    this.mon2sb_rd=mon2sb_rd;
    this.ref2sb_wr=ref2sb_wr;
    this.ref2sb_rd=ref2sb_rd;
    this.reset_drv_inf=reset_drv_inf;
    this.mem_h = mem_h;
    fifo_xtn_cvg_full = new();
    fifo_xtn1_cvg_empty = new();
		fifo_xtn_cvg_both = new();
    fifo_xtn1_cvg_both = new();
		fifo_xtn_cvg_multiple = new();
    fifo_xtn1_cvg_multiple = new();
		reset_cvg_wr = new();
		reset_cvg_rd = new();

  endfunction : new

//-----------------------------------------------------------------------------------------------------------------------
//TASK - START (call from environment class)
//Description - this task will start comparing data packets coming from read monitor and reference model
//-----------------------------------------------------------------------------------------------------------------------
  task start();
    fork
      data_wr_compare;
      data_rd_compare;
    join_none
  endtask : start

  task data_wr_compare;
    forever begin
			ref2sb_wr.get(ref2sb_pkt_wr);
      mon2sb_wr.get(mon2sb_pkt_wr);
      cov_data1=ref2sb_pkt_wr;
      fifo_xtn_cvg_full.sample();
			fifo_xtn_cvg_both.sample();
			fifo_xtn_cvg_multiple.sample();
			cov_wr=ref2sb_pkt_wr;
		  reset_cvg_wr.sample();	

      if(mon2sb_pkt_wr.din == ref2sb_pkt_wr.din) $display("TIME = %0t, PASS => din DATA MATCHED",$time);
      else $display("TIME = %0t, FAILED => din DATA NOT MATCHED",$time);

      if(mon2sb_pkt_wr.wr_en == ref2sb_pkt_wr.wr_en) $display("TIME = %0t, PASS => wr_en DATA MATCHED",$time);
      else $display("TIME = %0t, FAILED => wr_en DATA NOT MATCHED",$time);

      if(mon2sb_pkt_wr.full == ref2sb_pkt_wr.full) $display("TIME = %0t, PASS => full DATA MATCHED",$time);
      else $display("TIME = %0t, FAILED => full DATA NOT MATCHED",$time);

      if(mon2sb_pkt_wr.almost_full == ref2sb_pkt_wr.almost_full) $display("TIME = %0t, PASS => almost_full DATA MATCHED",$time);
      else $display("TIME = %0t, FAILED => almost_full DATA NOT MATCHED",$time);

      if(mon2sb_pkt_wr.wr_ack == ref2sb_pkt_wr.wr_ack) $display("TIME = %0t, PASS => wr_ack DATA MATCHED",$time);
      else $display("TIME = %0t, FAILED => wr_ack DATA NOT MATCHED",$time);

      if(mon2sb_pkt_wr.wr_err == ref2sb_pkt_wr.wr_err) $display("TIME = %0t, PASS => wr_err DATA MATCHED",$time);
      else $display("TIME = %0t, FAILED => wr_err DATA NOT MATCHED",$time);
    end
  endtask : data_wr_compare

  task data_rd_compare;
    forever begin
      mon2sb_rd.get(mon2sb_pkt_rd);
      ref2sb_rd.get(ref2sb_pkt_rd);
      cov_data2=ref2sb_pkt_rd;
      fifo_xtn1_cvg_empty.sample();
			fifo_xtn1_cvg_both.sample();
			fifo_xtn1_cvg_multiple.sample();
			cov_rd=ref2sb_pkt_rd;
		  reset_cvg_rd.sample();	

      if(mon2sb_pkt_rd.dout == ref2sb_pkt_rd.dout) $display("TIME = %0t, PASS => dout DATA MATCHED",$time);
      else $display("TIME = %0t, FAILED => dout DATA NOT MATCHED",$time);

      if(mon2sb_pkt_rd.rd_en == ref2sb_pkt_rd.rd_en) $display("TIME = %0t, PASS => rd_en DATA MATCHED",$time);
      else $display("TIME = %0t, FAILED => rd_en DATA NOT MATCHED",$time);

      if(mon2sb_pkt_rd.empty == ref2sb_pkt_rd.empty) $display("TIME = %0t, PASS => empty DATA MATCHED",$time);
      else $display("TIME = %0t, FAILED => empty DATA NOT MATCHED",$time);

      if(mon2sb_pkt_rd.almost_empty == ref2sb_pkt_rd.almost_empty) $display("TIME = %0t, PASS => almost_empty DATA MATCHED",$time);
      else $display("TIME = %0t, FAILED => almost_empty DATA NOT MATCHED",$time);

      if(mon2sb_pkt_rd.rd_ack == ref2sb_pkt_rd.rd_ack) $display("TIME = %0t, PASS => rd_ack DATA MATCHED",$time);
      else $display("TIME = %0t, FAILED => rd_ack DATA NOT MATCHED",$time);

      if(mon2sb_pkt_rd.rd_err == ref2sb_pkt_rd.rd_err) $display("TIME = %0t, PASS => rd_err DATA MATCHED",$time);
      else $display("TIME = %0t, FAILED => rd_err DATA NOT MATCHED",$time);
    end
  endtask : data_rd_compare

endclass : fifo_scoreboard
