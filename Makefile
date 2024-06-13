# Makefile for FIFO
RTL= ../rtl/*.sv
work= work #library name
TEST= ../test/fifo_test.sv
INC = +incdir+../test/ +incdir+../env/ 
INF = ../env/fifo_interface.sv
PKG = ../test/fifo_pkg.sv
TOP1 = ../top/top.sv
TOP = top

COVOP = -coverage -novopt -sva -sv_seed random
VSIMOPT= +access +r -sva
VSIMBATCH1= -c -do "coverage save -onexit -directive -cvg -codeall fifo_cov1.ucdb;add wave -r /*;run -all; exit"
VSIMBATCH2= -c -do "coverage save -onexit -directive -cvg -codeall fifo_cov2.ucdb;add wave -r /*;run -all; exit"
VSIMBATCH3= -c -do "coverage save -onexit -directive -cvg -codeall fifo_cov3.ucdb;add wave -r /*;run -all; exit"
VSIMBATCH4= -c -do "coverage save -onexit -directive -cvg -codeall fifo_cov4.ucdb;add wave -r /*;run -all; exit"
VSIMBATCH5= -c -do "coverage save -onexit -directive -cvg -codeall fifo_cov5.ucdb;add wave -r /*;run -all; exit"




help:
	@echo ===========================================================================================================
	@echo " clean   	=>  clean the earlier log and intermediate files.       							"
	@echo " sv_cmp    	=>  Create library and compile the code.                   	  			"
	@echo " TC1       	=>  To compile and run the testcase1 in batch mode.									" 
	@echo " TC2        	=>  To compile and run the testcase2 in batch mode.									" 
	@echo " TC3       	=>  To compile and run the testcase3 in batch mode.									"
	@echo " TC4        	=>  To compile and run the testcase4 in batch mode.									" 
	@echo " TC5       	=>  To compile and run the testcase5 in batch mode.									"
	@echo " regress 	=>  clean, compile and run testcases TC1 and TC2,TC3,TC4,TC5 in batch mode.	" 
	
	@echo " report_12   =>  To merge coverage reports for testcases TC1,TC2,TC3, TC4 and TC5 "												   
	@echo " cov_report  =>  To view the coverage report.												           	"
	@echo ===========================================================================================================

cmp:
	vlib $(work)
	vmap $(work)
	vlog -coveropt 3 +cover +acc -work $(work) $(RTL) $(INF) $(PKG) $(TOP1) $(INC)

test1:
	vsim -novopt top +TEST1


fw:
	vsim -novopt $(TOP) +fifo_full

fwr:
	vsim -novopt $(TOP) +fifo_empty

freset:
	vsim -novopt $(TOP) +fifo_reset

fmulti:
	vsim -novopt $(TOP) +fifo_multiple

fboth:
	vsim -novopt $(TOP) +fifo_both
	
	
TC1:
	vsim $(VSIMBATCH1) $(COVOP) -wlf "wave_file1.wlf" -l test1.log work.top +fifo_full
	vcover report -html fifo_cov1.ucdb

	
TC2:
	vsim $(VSIMBATCH2) $(COVOP) -wlf "wave_file2.wlf" -l test2.log work.top +fifo_empty
	vcover report -html fifo_cov2.ucdb

TC3:
	vsim $(VSIMBATCH3) $(COVOP) -wlf "wave_file3.wlf" -l test3.log work.top +fifo_reset 	
	vcover report -html fifo_cov3.ucdb

TC4:
	vsim $(VSIMBATCH4) $(COVOP) -wlf "wave_file4.wlf" -l test4.log work.top +fifo_multiple
	vcover report -html fifo_cov4.ucdb

TC5:
	vsim $(VSIMBATCH5) $(COVOP) -wlf "wave_file5.wlf" -l test5.log work.top +fifo_both
	vcover report -html fifo_cov5.ucdb


report_12:
	vcover merge fifo_cov.ucdb fifo_cov1.ucdb fifo_cov2.ucdb fifo_cov3.ucdb fifo_cov4.ucdb fifo_cov5.ucdb 
	vcover report -details -html fifo_cov.ucdb

regress: 	clean cmp TC1 TC2 TC3 TC4 TC5 report_12
 
report:
	firefox covhtmlreport/index.html&
code:
	vcover report -details -html fifo_cov.ucdb
	
clean:
	rm -rf transcript* *log*  vsim.wlf fcover* covhtml* fifo_cov* *.wlf modelsim.ini
	clear

