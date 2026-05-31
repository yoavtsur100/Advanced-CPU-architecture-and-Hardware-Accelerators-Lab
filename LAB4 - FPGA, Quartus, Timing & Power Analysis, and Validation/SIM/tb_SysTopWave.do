onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tb_system_top/RST
add wave -noupdate -radix hexadecimal /tb_system_top/CLK
add wave -noupdate -radix hexadecimal /tb_system_top/ENA
add wave -noupdate -color Cyan -itemcolor Cyan -radix binary /tb_system_top/ALUFN
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -radix decimal -childformat {{/tb_system_top/L0/PWM_Part/counter_q(15) -radix decimal} {/tb_system_top/L0/PWM_Part/counter_q(14) -radix decimal} {/tb_system_top/L0/PWM_Part/counter_q(13) -radix decimal} {/tb_system_top/L0/PWM_Part/counter_q(12) -radix decimal} {/tb_system_top/L0/PWM_Part/counter_q(11) -radix decimal} {/tb_system_top/L0/PWM_Part/counter_q(10) -radix decimal} {/tb_system_top/L0/PWM_Part/counter_q(9) -radix decimal} {/tb_system_top/L0/PWM_Part/counter_q(8) -radix decimal} {/tb_system_top/L0/PWM_Part/counter_q(7) -radix decimal} {/tb_system_top/L0/PWM_Part/counter_q(6) -radix decimal} {/tb_system_top/L0/PWM_Part/counter_q(5) -radix decimal} {/tb_system_top/L0/PWM_Part/counter_q(4) -radix decimal} {/tb_system_top/L0/PWM_Part/counter_q(3) -radix decimal} {/tb_system_top/L0/PWM_Part/counter_q(2) -radix decimal} {/tb_system_top/L0/PWM_Part/counter_q(1) -radix decimal} {/tb_system_top/L0/PWM_Part/counter_q(0) -radix decimal}} -subitemconfig {/tb_system_top/L0/PWM_Part/counter_q(15) {-radix decimal} /tb_system_top/L0/PWM_Part/counter_q(14) {-radix decimal} /tb_system_top/L0/PWM_Part/counter_q(13) {-radix decimal} /tb_system_top/L0/PWM_Part/counter_q(12) {-radix decimal} /tb_system_top/L0/PWM_Part/counter_q(11) {-radix decimal} /tb_system_top/L0/PWM_Part/counter_q(10) {-radix decimal} /tb_system_top/L0/PWM_Part/counter_q(9) {-radix decimal} /tb_system_top/L0/PWM_Part/counter_q(8) {-radix decimal} /tb_system_top/L0/PWM_Part/counter_q(7) {-radix decimal} /tb_system_top/L0/PWM_Part/counter_q(6) {-radix decimal} /tb_system_top/L0/PWM_Part/counter_q(5) {-radix decimal} /tb_system_top/L0/PWM_Part/counter_q(4) {-radix decimal} /tb_system_top/L0/PWM_Part/counter_q(3) {-radix decimal} /tb_system_top/L0/PWM_Part/counter_q(2) {-radix decimal} /tb_system_top/L0/PWM_Part/counter_q(1) {-radix decimal} /tb_system_top/L0/PWM_Part/counter_q(0) {-radix decimal}} /tb_system_top/L0/PWM_Part/counter_q
add wave -noupdate -color {Blue Violet} -itemcolor {Blue Violet} -radix hexadecimal /tb_system_top/PWMout
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -radix decimal /tb_system_top/Y_i
add wave -noupdate -radix decimal /tb_system_top/X_i
add wave -noupdate -radix decimal /tb_system_top/ALUout
add wave -noupdate -group Flags -radix hexadecimal /tb_system_top/V
add wave -noupdate -group Flags -radix hexadecimal /tb_system_top/Z
add wave -noupdate -group Flags -radix hexadecimal /tb_system_top/C
add wave -noupdate -group Flags -radix hexadecimal /tb_system_top/Neg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {971830 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 327
configure wave -valuecolwidth 240
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
WaveRestoreZoom {0 ps} {2156868 ps}
