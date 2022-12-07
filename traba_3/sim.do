#Cria a biblioteca work
vlib work
vmap work work

#Compila os dois modulos
vcom -work work divisor.vhd
vcom -work work traba_2.vhd
vcom -work work testbench.vhd


#Simula o arquivo testebench
vsim -voptargs=+acc -t 1ns +notimingchecks work.testbench

#do wave.do

run 100ns