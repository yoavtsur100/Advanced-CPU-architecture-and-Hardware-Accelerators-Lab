onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tb_control/rst
add wave -noupdate -radix hexadecimal /tb_control/ena
add wave -noupdate -radix hexadecimal /tb_control/clk
add wave -noupdate -group Opcodes -radix hexadecimal /tb_control/mov
add wave -noupdate -group Opcodes -radix hexadecimal /tb_control/done
add wave -noupdate -group Opcodes -radix hexadecimal /tb_control/and_op
add wave -noupdate -group Opcodes -radix hexadecimal /tb_control/or_op
add wave -noupdate -group Opcodes -radix hexadecimal /tb_control/xor_op
add wave -noupdate -group Opcodes -radix hexadecimal /tb_control/jnc
add wave -noupdate -group Opcodes -radix hexadecimal /tb_control/jc
add wave -noupdate -group Opcodes -radix hexadecimal /tb_control/jmp
add wave -noupdate -group Opcodes -radix hexadecimal /tb_control/sub
add wave -noupdate -group Opcodes -radix hexadecimal /tb_control/add
add wave -noupdate -group Opcodes -radix hexadecimal /tb_control/Nflag
add wave -noupdate -group Opcodes -radix hexadecimal /tb_control/Zflag
add wave -noupdate -group Opcodes -radix hexadecimal /tb_control/Cflag
add wave -noupdate -group Opcodes -radix hexadecimal /tb_control/ld
add wave -noupdate -group Opcodes -radix hexadecimal /tb_control/st
add wave -noupdate -color {Medium Blue} -itemcolor {Medium Blue} -radix hexadecimal /tb_control/done_FSM
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -radix hexadecimal /tb_control/DTCM_wr
add wave -noupdate -radix hexadecimal /tb_control/Cin
add wave -noupdate -radix hexadecimal /tb_control/Cout
add wave -noupdate -radix hexadecimal /tb_control/DTCM_addr_in
add wave -noupdate -radix hexadecimal /tb_control/DTCM_out
add wave -noupdate -radix hexadecimal /tb_control/Ain
add wave -noupdate -radix hexadecimal /tb_control/RFin
add wave -noupdate -radix hexadecimal /tb_control/RFout
add wave -noupdate -radix hexadecimal /tb_control/IRin
add wave -noupdate -radix hexadecimal /tb_control/PCin
add wave -noupdate -radix hexadecimal /tb_control/Imm1_in
add wave -noupdate -radix hexadecimal /tb_control/Imm2_in
add wave -noupdate -radix hexadecimal /tb_control/ALUFN
add wave -noupdate -radix hexadecimal /tb_control/RFaddr_rd
add wave -noupdate -radix hexadecimal /tb_control/RFaddr_wr
add wave -noupdate -radix hexadecimal /tb_control/PCsel
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -color Gold -itemcolor Gold -radix hexadecimal /tb_control/ControlUnit/prv_state
add wave -noupdate -color Gold -itemcolor Gold -radix hexadecimal /tb_control/ControlUnit/nxt_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {184 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 227
configure wave -valuecolwidth 99
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
WaveRestoreZoom {0 ps} {953 ps}
