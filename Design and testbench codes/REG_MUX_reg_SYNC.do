vlib work
vlog MUX_REG.v REG_MUX_tb3.v
vsim -voptargs=+acc work.REG_MUX_tb3  
add wave *
run -all
#quit -sim