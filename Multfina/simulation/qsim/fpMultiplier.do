onerror {quit -f}
vlib work
vlog -work work fpMultiplier.vo
vlog -work work fpMultiplier.vt
vsim -novopt -c -t 1ps -L cycloneive_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.toplevelmMULT_vlg_vec_tst
vcd file -direction fpMultiplier.msim.vcd
vcd add -internal toplevelmMULT_vlg_vec_tst/*
vcd add -internal toplevelmMULT_vlg_vec_tst/i1/*
add wave /*
run -all
