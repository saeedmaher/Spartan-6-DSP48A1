vlib work
vlog MUX_REG.v REG_MUX_tb4.v
vsim -voptargs=+acc work.REG_MUX_tb4  
add wave *
run -all
#quit -sim