// Asynchronous FIFO

`define	WIDTH	8
`define	DEPTH	16

module async_fifo
(input wr_clk,		// clock to synchronize writing functions of the FIFO.
input [`WIDTH-1:0]din,	// input data synchronous to write clock wr_clk.
input wr_en,		// write enable requesting to write data synchronous to write clock wr_clk.
input rd_clk,		// clock to synchronize reading functions of the FIFO.
input rd_en,		// read enable requesting to read data synchronous to read clock rd_clk.
input clear_n,		// asynchronous active low reset to reset all pointers, flags and functions.
output logic full,almost_full,	// active high output flags to respectively indicate no space and one space left for writing operations synchronous to write clock wr_clk. 
output logic wr_ack,wr_err,	// active high handshake signals to respectively indicate success and failure in writing operation synchronous to write clock wr_clk.
output logic almost_empty,empty,// active high output flags to respectively indicate one data and no data left for reading operations synchronous to read clock rd_clk.
output logic rd_ack,rd_err,	// active high handshake signals to respectively indicate success and failure in reading operation synchronous to read clock rd_clk
output logic [`WIDTH-1:0]dout);	// output data synchronous to read  clock rd_clk.

`pragma protect data_method = "aes128-cbc"
`pragma protect key_keyowner = "Mentor Graphics Corporation"
`pragma protect key_method = "rsa"
`pragma protect key_keyname = "MGC-VERIF-SIM-RSA-2"
`pragma protect begin
logic [$clog2(`DEPTH)-1:0] wptr;	//write pointer
logic [$clog2(`DEPTH)-1:0] rptr;	//read pointer

logic [`WIDTH-1:0]mem[`DEPTH-1:0];	//declaring memory for FIFO.

logic flag,w_ack,w_err,r_ack,r_err;

always @(posedge wr_clk,negedge clear_n)//Write logic of the FIFO Synchronous to the write clock wr_clk
begin
	wr_ack<=w_ack;
	wr_err<=w_err;

	if(!clear_n)				// Asynchronous Reset
	begin
		full<=1'b1;
		almost_full<=1'b1;
		almost_empty<=1'b1;
		empty<=1'b1;
		wptr<=0;
		rptr<=0;
		flag<=1'b1;
	end
	
	else if(wr_en)				// Responding to write request
	begin
		/*if(flag)
		begin
		almost_full<=1'b0;
		full<=1'b0;
		flag<=1'b0;
		end
		else */if(full)			// In case the fifo is full then write error signal is activated
			begin
				w_err<=1'b1;
				w_ack<=1'b0;
			end
		else if(almost_full)		// In case the fifo is almost full then write acknowledge signal is activated and full flag is activated.
			begin
				mem[wptr]<=din;
				wptr<=wptr+1;
				w_ack<=1'b1;
				w_err<=1'b0;
			end
		else				// In case the fifo is nowhere near full simply write acknowledge is provided.
			begin
				mem[wptr]<=din;
				wptr<=wptr+1;
				w_ack<=1'b1;
				w_err<=1'b0;
			end
	end
	else
	begin
		w_ack<=1'b0;
		w_err<=1'b0;
	end

	if(flag)
	begin
		almost_full<=1'b0;
		full<=1'b0;
		flag<=1'b0;
	end
	else
	begin
		almost_full<=almost_full;
		full<=full;
	end
end

always @(posedge rd_clk,negedge clear_n)//Read logic of the FIFO Synchronous to the read clock rd_clk
begin
	rd_err<=r_err;
	rd_ack<=r_ack;
	if(!clear_n)				// Asynchronous Reset
	begin
		full<=1'b1;
		almost_full<=1'b1;
		almost_empty<=1'b1;
		empty<=1'b1;
		wptr<=0;
		rptr<=0;
		flag<=1'b1;
	end
	else if(rd_en)				// Responding to read request
	begin
		if(empty)
			begin
				r_ack<=1'b0;
				r_err<=1'b1;
			end
		else if(almost_empty)
			begin
				dout<=mem[rptr];
				rptr<=rptr+1;
				r_ack<=1'b1;
				r_err<=1'b0;
			end
		else
			begin
				dout<=mem[rptr];
				rptr<=rptr+1;
				r_ack<=1'b1;
				r_err<=1'b0;
			end
	end
	else
	begin
		r_ack<=1'b0;
		r_err<=1'b0;
	end

end

always @(wptr,rptr)				// Combinational block to generate flags
begin
	if((rptr==0&&wptr==`DEPTH-1)||(rptr-wptr==1))
		begin
			full=1'b0;
			empty=1'b0;
			almost_full=1'b1;
			almost_empty=1'b0;
		end
	else if((rptr==`DEPTH-1&&wptr==0)||(wptr-rptr==1))
		begin
			full=1'b0;
			empty=1'b0;
			almost_full=1'b0;
			almost_empty=1'b1;
		end
	else if(rptr==wptr&&almost_empty)
		begin
			full=1'b0;
			empty=1'b1;
			almost_full=1'b0;
			almost_empty=1'b1;
		end
	else if(rptr==wptr&&almost_full)
		begin
			full=1'b1;
			empty=1'b0;
			almost_full=1'b1;
			almost_empty=1'b0;
		end
	else
		begin
			full=1'b0;
			empty=1'b0;
			almost_full=1'b0;
			almost_empty=1'b0;
		end
end

/*always @(posedge wr_clk)				// Block to generate full  almost_full flags
begin
	if((rptr==0&&wptr==`DEPTH-1)||(rptr-wptr==1))
		begin
			full=1'b0;
			almost_full=1'b1;
		end
	else if((rptr==`DEPTH-1&&wptr==0)||(wptr-rptr==1))
		begin
			full=1'b0;	
			almost_full=1'b0;
		end
	else if(rptr==wptr&&almost_empty)
		begin
			full=1'b0;
			almost_full=1'b0;
		end
	else if(rptr==wptr&&almost_full)
		begin
			full=1'b1;
			almost_full=1'b1;
		end
	else
		begin
			full=1'b0;
			almost_full=1'b0;
		end
end

always @(posedge rd_clk)				// Block to generate empty and almost_empty  flags
begin
	if((rptr==0&&wptr==`DEPTH-1)||(rptr-wptr==1))
		begin
			empty=1'b0;
			almost_empty=1'b0;
		end
	else if((rptr==`DEPTH-1&&wptr==0)||(wptr-rptr==1))
		begin
			empty=1'b0;
			almost_empty=1'b1;
		end
	else if(rptr==wptr&&almost_empty)
		begin
			empty=1'b1;
			almost_empty=1'b1;
		end
	else if(rptr==wptr&&almost_full)
		begin
			empty=1'b0;
			almost_empty=1'b0;
		end
	else
		begin
			empty=1'b0;
			almost_empty=1'b0;
		end
end */

/*always @(posedge clear_n)
begin

	full<=1'b0;
	almost_full<=1'b0;

end*/

endmodule
`pragma protect end
