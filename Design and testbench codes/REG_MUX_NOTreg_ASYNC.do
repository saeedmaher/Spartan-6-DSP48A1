vlib work
vlog MUX_REG.v REG_MUX_tb2.v
vsim -voptargs=+acc work.REG_MUX_tb2  
add wave *
run -all
#quit -sim