vlib work
vlog MUX_REG.v REG_MUX_tb1.v
vsim -voptargs=+acc work.REG_MUX_tb1  
add wave *
run -all
#quit -sim