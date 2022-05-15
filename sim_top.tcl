	alias clc ".main clear"
	
	clc
	exec vlib work
	vmap work work
	
	set TB					tb
	set hdl_path			""
	set inc_path			""
	
	set run_time			"1 us"
#	set run_time			"-all"

#============================ Add verilog files  ===============================
# Pleas add other module here	
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/*.v

	vlog 	+acc -incr -source  +incdir+$inc_path +define+SIM 	./tb/$TB.v
	onerror {break}

#================================ simulation ====================================

	vsim	-voptargs=+acc -debugDB $TB


#======================= adding signals to wave window ==========================


	add wave -uns -group 	 	{TB}				sim:/$TB/*
	add wave -uns -group 	 	{top}				sim:/$TB/uut/*	
	add wave -uns -group -r		{all}				sim:/$TB/*

#=========================== Configure wave signals =============================
	
	configure wave -signalnamewidth 2
    

#====================================== run =====================================

	run $run_time 
	