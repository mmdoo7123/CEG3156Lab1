onerror {quit -f}
vlib work
vlog -work work CEG3156Lab1.vo
vlog -work work CEG3156Lab1.vt
vsim -novopt -c -t 1ps -L cycloneive_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.adder_vlg_vec_tst
vcd file -direction CEG3156Lab1.msim.vcd
vcd add -internal adder_vlg_vec_tst/*
vcd add -internal adder_vlg_vec_tst/i1/*
add wave /*
run -all
