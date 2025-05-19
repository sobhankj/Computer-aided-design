	alias clc ".main clear"
	
	clc
	exec vlib work
	vmap work work
	
	set TB					"test_bench"
	set hdl_path			"../src/hdl"
	set inc_path			"../src/inc"
	
	# set run_time			"1 us"
	set run_time			"-all"

#============================ Add verilog files  ===============================
# Pleas add other module here	
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/adder.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/controller.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/datapath.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/LUT.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/memory_address.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/mult.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/mux_group_outside.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/mux_group_pipe.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/mux2.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/n_plus.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/pipe.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/register_group_outside.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/register_group_pipe.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/register_temp.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/register.v

		
	vlog 	+acc -incr -source  +incdir+$inc_path +define+SIM 	./tb/$TB.v
	onerror {break}

#================================ simulation ====================================

	vsim	-voptargs=+acc -debugDB $TB


#======================= adding signals to wave window ==========================


	add wave -hex -group 	 	{TB}				sim:/$TB/*
	add wave -hex -group 	 	{top}				sim:/$TB/uut/*	
	add wave -hex -group -r		{all}				sim:/$TB/*

#=========================== Configure wave signals =============================
	
	configure wave -signalnamewidth 2
    

#====================================== run =====================================

	run $run_time 
	