onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tb_datapath/clk
add wave -noupdate -radix hexadecimal /tb_datapath/rst
add wave -noupdate -group control /tb_datapath/DTCM_wr_i
add wave -noupdate -group control /tb_datapath/Cin_i
add wave -noupdate -group control /tb_datapath/Cout_i
add wave -noupdate -group control /tb_datapath/DTCM_addr_in_i
add wave -noupdate -group control /tb_datapath/DTCM_out_i
add wave -noupdate -group control /tb_datapath/Ain_i
add wave -noupdate -group control /tb_datapath/RFin_i
add wave -noupdate -group control /tb_datapath/RFout_i
add wave -noupdate -group control /tb_datapath/IRin_i
add wave -noupdate -group control /tb_datapath/PCin_i
add wave -noupdate -group control /tb_datapath/Imm1_in_i
add wave -noupdate -group control /tb_datapath/Imm2_in_i
add wave -noupdate -group control /tb_datapath/ALUFN_i
add wave -noupdate -group control /tb_datapath/RFaddr_rd_i
add wave -noupdate -group control /tb_datapath/RFaddr_wr_i
add wave -noupdate -group control /tb_datapath/PCsel_i
add wave -noupdate -radix hexadecimal /tb_datapath/TBactive
add wave -noupdate -radix hexadecimal /tb_datapath/DTCM_tb_addr_out
add wave -noupdate -radix hexadecimal /tb_datapath/DTCM_tb_addr_in
add wave -noupdate -radix hexadecimal /tb_datapath/ITCM_tb_addr_in
add wave -noupdate -radix hexadecimal /tb_datapath/DTCM_tb_in
add wave -noupdate -color {Dark Slate Gray} -itemcolor {Dark Slate Gray} -radix hexadecimal /tb_datapath/ITCM_tb_in
add wave -noupdate -radix hexadecimal /tb_datapath/DTCM_tb_wr
add wave -noupdate -radix hexadecimal /tb_datapath/ITCM_tb_wr
add wave -noupdate -group Opcodes /tb_datapath/mov_o
add wave -noupdate -group Opcodes /tb_datapath/done_in_o
add wave -noupdate -group Opcodes /tb_datapath/and_o
add wave -noupdate -group Opcodes /tb_datapath/or_o
add wave -noupdate -group Opcodes /tb_datapath/xor_o
add wave -noupdate -group Opcodes /tb_datapath/jnc_o
add wave -noupdate -group Opcodes /tb_datapath/jc_o
add wave -noupdate -group Opcodes /tb_datapath/jmp_o
add wave -noupdate -group Opcodes /tb_datapath/sub_o
add wave -noupdate -group Opcodes /tb_datapath/add_o
add wave -noupdate -group Opcodes /tb_datapath/Nflag_o
add wave -noupdate -group Opcodes /tb_datapath/Zflag_o
add wave -noupdate -group Opcodes /tb_datapath/Cflag_o
add wave -noupdate -group Opcodes /tb_datapath/ld_o
add wave -noupdate -group Opcodes /tb_datapath/st_o
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -radix hexadecimal /tb_datapath/UnitDataPath/busData_w
add wave -noupdate -radix hexadecimal /tb_datapath/UnitDataPath/Imm1toBus_w
add wave -noupdate -radix hexadecimal /tb_datapath/UnitDataPath/Imm2toBus_w
add wave -noupdate -color {Cornflower Blue} -itemcolor {Dark Orchid} -radix hexadecimal /tb_datapath/UnitDataPath/UnitPC/current_pc_q
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -radix hexadecimal /tb_datapath/UnitDataPath/UnitRF/WregData
add wave -noupdate -radix hexadecimal /tb_datapath/UnitDataPath/UnitRF/RregData
add wave -noupdate -color Gold -itemcolor Gold -radix hexadecimal -childformat {{/tb_datapath/UnitDataPath/UnitRF/sysRF(0) -radix hexadecimal} {/tb_datapath/UnitDataPath/UnitRF/sysRF(1) -radix hexadecimal} {/tb_datapath/UnitDataPath/UnitRF/sysRF(2) -radix hexadecimal} {/tb_datapath/UnitDataPath/UnitRF/sysRF(3) -radix hexadecimal} {/tb_datapath/UnitDataPath/UnitRF/sysRF(4) -radix hexadecimal} {/tb_datapath/UnitDataPath/UnitRF/sysRF(5) -radix hexadecimal} {/tb_datapath/UnitDataPath/UnitRF/sysRF(6) -radix hexadecimal} {/tb_datapath/UnitDataPath/UnitRF/sysRF(7) -radix hexadecimal} {/tb_datapath/UnitDataPath/UnitRF/sysRF(8) -radix hexadecimal} {/tb_datapath/UnitDataPath/UnitRF/sysRF(9) -radix hexadecimal} {/tb_datapath/UnitDataPath/UnitRF/sysRF(10) -radix hexadecimal} {/tb_datapath/UnitDataPath/UnitRF/sysRF(11) -radix hexadecimal} {/tb_datapath/UnitDataPath/UnitRF/sysRF(12) -radix hexadecimal} {/tb_datapath/UnitDataPath/UnitRF/sysRF(13) -radix hexadecimal} {/tb_datapath/UnitDataPath/UnitRF/sysRF(14) -radix hexadecimal} {/tb_datapath/UnitDataPath/UnitRF/sysRF(15) -radix hexadecimal}} -expand -subitemconfig {/tb_datapath/UnitDataPath/UnitRF/sysRF(0) {-color Gold -itemcolor Gold -radix hexadecimal} /tb_datapath/UnitDataPath/UnitRF/sysRF(1) {-color Gold -itemcolor Gold -radix hexadecimal} /tb_datapath/UnitDataPath/UnitRF/sysRF(2) {-color Gold -itemcolor Gold -radix hexadecimal} /tb_datapath/UnitDataPath/UnitRF/sysRF(3) {-color Gold -itemcolor Gold -radix hexadecimal} /tb_datapath/UnitDataPath/UnitRF/sysRF(4) {-color Gold -itemcolor Gold -radix hexadecimal} /tb_datapath/UnitDataPath/UnitRF/sysRF(5) {-color Gold -itemcolor Gold -radix hexadecimal} /tb_datapath/UnitDataPath/UnitRF/sysRF(6) {-color Gold -itemcolor Gold -radix hexadecimal} /tb_datapath/UnitDataPath/UnitRF/sysRF(7) {-color Gold -itemcolor Gold -radix hexadecimal} /tb_datapath/UnitDataPath/UnitRF/sysRF(8) {-color Gold -itemcolor Gold -radix hexadecimal} /tb_datapath/UnitDataPath/UnitRF/sysRF(9) {-color Gold -itemcolor Gold -radix hexadecimal} /tb_datapath/UnitDataPath/UnitRF/sysRF(10) {-color Gold -itemcolor Gold -radix hexadecimal} /tb_datapath/UnitDataPath/UnitRF/sysRF(11) {-color Gold -itemcolor Gold -radix hexadecimal} /tb_datapath/UnitDataPath/UnitRF/sysRF(12) {-color Gold -itemcolor Gold -radix hexadecimal} /tb_datapath/UnitDataPath/UnitRF/sysRF(13) {-color Gold -itemcolor Gold -radix hexadecimal} /tb_datapath/UnitDataPath/UnitRF/sysRF(14) {-color Gold -itemcolor Gold -radix hexadecimal} /tb_datapath/UnitDataPath/UnitRF/sysRF(15) {-color Gold -itemcolor Gold -radix hexadecimal}} /tb_datapath/UnitDataPath/UnitRF/sysRF
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {605874 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 302
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
WaveRestoreZoom {0 ps} {1855488 ps}
