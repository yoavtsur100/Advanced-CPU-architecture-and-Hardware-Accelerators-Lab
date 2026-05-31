onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_top_fpga/CLK_50MHZ
add wave -noupdate /tb_top_fpga/KEY
add wave -noupdate /tb_top_fpga/SW
add wave -noupdate /tb_top_fpga/LEDR
add wave -noupdate -group HEXLCD -radix hexadecimal /tb_top_fpga/HEX0
add wave -noupdate -group HEXLCD -radix hexadecimal /tb_top_fpga/HEX1
add wave -noupdate -group HEXLCD -radix hexadecimal /tb_top_fpga/HEX2
add wave -noupdate -group HEXLCD -radix hexadecimal /tb_top_fpga/HEX3
add wave -noupdate -group HEXLCD -radix hexadecimal /tb_top_fpga/HEX4
add wave -noupdate -group HEXLCD -radix hexadecimal /tb_top_fpga/HEX5
add wave -noupdate -expand -group PWM /tb_top_fpga/GPIO9
add wave -noupdate -expand -group PWM /tb_top_fpga/DUT/DSPart/ENA
add wave -noupdate -expand -group PWM /tb_top_fpga/DUT/DSPart/RST
add wave -noupdate -group FLAGS /tb_top_fpga/DUT/DSPart/V
add wave -noupdate -group FLAGS /tb_top_fpga/DUT/DSPart/Z
add wave -noupdate -group FLAGS /tb_top_fpga/DUT/DSPart/C
add wave -noupdate -group FLAGS /tb_top_fpga/DUT/DSPart/Neg
add wave -noupdate /tb_top_fpga/DUT/DSPart/PWMout
add wave -noupdate -radix decimal /tb_top_fpga/DUT/regX
add wave -noupdate -radix decimal /tb_top_fpga/DUT/regY
add wave -noupdate /tb_top_fpga/DUT/regALU
add wave -noupdate -radix decimal /tb_top_fpga/DUT/DSPart/ALUout
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {544248 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 381
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {530352 ps} {969648 ps}
