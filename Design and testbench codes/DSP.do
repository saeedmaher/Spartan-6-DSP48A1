vlib work
vlog MUX_REG.v MAIN_DSP.v DSP_tb.v
vsim -voptargs=+acc work.DSP_tb  
add wave *
run -all
#quit -sim