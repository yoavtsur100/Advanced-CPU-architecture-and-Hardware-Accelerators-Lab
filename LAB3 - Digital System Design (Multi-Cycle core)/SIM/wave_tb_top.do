onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tb_top/clk
add wave -noupdate -radix hexadecimal /tb_top/rst
add wave -noupdate -radix hexadecimal /tb_top/ena
add wave -noupdate -radix hexadecimal /tb_top/tp_TBactive_w
add wave -noupdate -group TB -radix hexadecimal /tb_top/tp_DTCM_tb_addr_out_w
add wave -noupdate -group TB -radix hexadecimal /tb_top/tp_DTCM_tb_addr_in_w
add wave -noupdate -group TB -radix hexadecimal /tb_top/tp_DTCM_tb_in_w
add wave -noupdate -group TB -radix hexadecimal /tb_top/tp_DTCM_tb_out_w
add wave -noupdate -group TB -radix hexadecimal /tb_top/tp_DTCM_tb_wr_w
add wave -noupdate -group TB -radix hexadecimal /tb_top/tp_ITCM_tb_wr_w
add wave -noupdate -group TB -radix hexadecimal /tb_top/tp_ITCM_tb_in_w
add wave -noupdate -group TB -radix hexadecimal /tb_top/tp_ITCM_tb_addr_in_w
add wave -noupdate -color White -itemcolor White -radix hexadecimal /tb_top/done
add wave -noupdate -color Gold -itemcolor Gold -radix hexadecimal /tb_top/UnitTop/UnitControl/prv_state
add wave -noupdate -color Gold -itemcolor Gold -radix hexadecimal /tb_top/UnitTop/UnitControl/nxt_state
add wave -noupdate -group OPC -radix hexadecimal /tb_top/UnitTop/UnitDataPath/mov_o
add wave -noupdate -group OPC -radix hexadecimal /tb_top/UnitTop/UnitDataPath/done_in_o
add wave -noupdate -group OPC -radix hexadecimal /tb_top/UnitTop/UnitDataPath/and_o
add wave -noupdate -group OPC -radix hexadecimal /tb_top/UnitTop/UnitDataPath/or_o
add wave -noupdate -group OPC -radix hexadecimal /tb_top/UnitTop/UnitDataPath/xor_o
add wave -noupdate -group OPC -radix hexadecimal /tb_top/UnitTop/UnitDataPath/jc_o
add wave -noupdate -group OPC -radix hexadecimal /tb_top/UnitTop/UnitDataPath/jmp_o
add wave -noupdate -group OPC -radix hexadecimal /tb_top/UnitTop/UnitDataPath/sub_o
add wave -noupdate -group OPC -radix hexadecimal /tb_top/UnitTop/UnitDataPath/add_o
add wave -noupdate -group OPC -radix hexadecimal /tb_top/UnitTop/UnitDataPath/ld_o
add wave -noupdate -group OPC -radix hexadecimal /tb_top/UnitTop/UnitDataPath/st_o
add wave -noupdate -group OPC -color Coral -itemcolor Coral -radix hexadecimal /tb_top/UnitTop/UnitDataPath/jnc_o
add wave -noupdate -group Flags -color Violet -itemcolor Violet -radix hexadecimal /tb_top/UnitTop/UnitDataPath/Cflag_o
add wave -noupdate -group Flags -radix hexadecimal /tb_top/UnitTop/UnitDataPath/Nflag_o
add wave -noupdate -group Flags -radix hexadecimal /tb_top/UnitTop/UnitDataPath/Zflag_o
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -color Cyan -itemcolor Cyan -radix hexadecimal -childformat {{/tb_top/UnitTop/UnitDataPath/UnitRF/sysRF(0) -radix hexadecimal} {/tb_top/UnitTop/UnitDataPath/UnitRF/sysRF(1) -radix hexadecimal} {/tb_top/UnitTop/UnitDataPath/UnitRF/sysRF(2) -radix hexadecimal} {/tb_top/UnitTop/UnitDataPath/UnitRF/sysRF(3) -radix hexadecimal} {/tb_top/UnitTop/UnitDataPath/UnitRF/sysRF(4) -radix hexadecimal} {/tb_top/UnitTop/UnitDataPath/UnitRF/sysRF(5) -radix hexadecimal} {/tb_top/UnitTop/UnitDataPath/UnitRF/sysRF(6) -radix hexadecimal} {/tb_top/UnitTop/UnitDataPath/UnitRF/sysRF(7) -radix hexadecimal} {/tb_top/UnitTop/UnitDataPath/UnitRF/sysRF(8) -radix hexadecimal} {/tb_top/UnitTop/UnitDataPath/UnitRF/sysRF(9) -radix hexadecimal} {/tb_top/UnitTop/UnitDataPath/UnitRF/sysRF(10) -radix hexadecimal} {/tb_top/UnitTop/UnitDataPath/UnitRF/sysRF(11) -radix hexadecimal} {/tb_top/UnitTop/UnitDataPath/UnitRF/sysRF(12) -radix hexadecimal} {/tb_top/UnitTop/UnitDataPath/UnitRF/sysRF(13) -radix hexadecimal} {/tb_top/UnitTop/UnitDataPath/UnitRF/sysRF(14) -radix hexadecimal} {/tb_top/UnitTop/UnitDataPath/UnitRF/sysRF(15) -radix hexadecimal}} -subitemconfig {/tb_top/UnitTop/UnitDataPath/UnitRF/sysRF(0) {-color Cyan -height 15 -itemcolor Cyan -radix hexadecimal} /tb_top/UnitTop/UnitDataPath/UnitRF/sysRF(1) {-color Cyan -height 15 -itemcolor Cyan -radix hexadecimal} /tb_top/UnitTop/UnitDataPath/UnitRF/sysRF(2) {-color Cyan -height 15 -itemcolor Cyan -radix hexadecimal} /tb_top/UnitTop/UnitDataPath/UnitRF/sysRF(3) {-color Cyan -height 15 -itemcolor Cyan -radix hexadecimal} /tb_top/UnitTop/UnitDataPath/UnitRF/sysRF(4) {-color Cyan -height 15 -itemcolor Cyan -radix hexadecimal} /tb_top/UnitTop/UnitDataPath/UnitRF/sysRF(5) {-color Cyan -height 15 -itemcolor Cyan -radix hexadecimal} /tb_top/UnitTop/UnitDataPath/UnitRF/sysRF(6) {-color Cyan -height 15 -itemcolor Cyan -radix hexadecimal} /tb_top/UnitTop/UnitDataPath/UnitRF/sysRF(7) {-color Cyan -height 15 -itemcolor Cyan -radix hexadecimal} /tb_top/UnitTop/UnitDataPath/UnitRF/sysRF(8) {-color Cyan -height 15 -itemcolor Cyan -radix hexadecimal} /tb_top/UnitTop/UnitDataPath/UnitRF/sysRF(9) {-color Cyan -height 15 -itemcolor Cyan -radix hexadecimal} /tb_top/UnitTop/UnitDataPath/UnitRF/sysRF(10) {-color Cyan -height 15 -itemcolor Cyan -radix hexadecimal} /tb_top/UnitTop/UnitDataPath/UnitRF/sysRF(11) {-color Cyan -height 15 -itemcolor Cyan -radix hexadecimal} /tb_top/UnitTop/UnitDataPath/UnitRF/sysRF(12) {-color Cyan -height 15 -itemcolor Cyan -radix hexadecimal} /tb_top/UnitTop/UnitDataPath/UnitRF/sysRF(13) {-color Cyan -height 15 -itemcolor Cyan -radix hexadecimal} /tb_top/UnitTop/UnitDataPath/UnitRF/sysRF(14) {-color Cyan -height 15 -itemcolor Cyan -radix hexadecimal} /tb_top/UnitTop/UnitDataPath/UnitRF/sysRF(15) {-color Cyan -height 15 -itemcolor Cyan -radix hexadecimal}} /tb_top/UnitTop/UnitDataPath/UnitRF/sysRF
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -color {Dark Orchid} -itemcolor {Dark Orchid} -radix hexadecimal /tb_top/UnitTop/UnitDataPath/UnitPC/current_pc_q
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -group {Control } -radix hexadecimal /tb_top/UnitTop/UnitControl/done_o
add wave -noupdate -group {Control } -radix hexadecimal /tb_top/UnitTop/UnitControl/DTCM_wr_o
add wave -noupdate -group {Control } -radix hexadecimal /tb_top/UnitTop/UnitControl/Cin_o
add wave -noupdate -group {Control } -radix hexadecimal /tb_top/UnitTop/UnitControl/Cout_o
add wave -noupdate -group {Control } -radix hexadecimal /tb_top/UnitTop/UnitControl/DTCM_addr_in_o
add wave -noupdate -group {Control } -radix hexadecimal /tb_top/UnitTop/UnitControl/DTCM_out_o
add wave -noupdate -group {Control } -radix hexadecimal /tb_top/UnitTop/UnitControl/Ain_o
add wave -noupdate -group {Control } -radix hexadecimal /tb_top/UnitTop/UnitControl/RFin_o
add wave -noupdate -group {Control } -radix hexadecimal /tb_top/UnitTop/UnitControl/RFout_o
add wave -noupdate -group {Control } -radix hexadecimal /tb_top/UnitTop/UnitControl/IRin_o
add wave -noupdate -group {Control } -radix hexadecimal /tb_top/UnitTop/UnitControl/PCin_o
add wave -noupdate -group {Control } -radix hexadecimal /tb_top/UnitTop/UnitControl/Imm1_in_o
add wave -noupdate -group {Control } -radix hexadecimal /tb_top/UnitTop/UnitControl/Imm2_in_o
add wave -noupdate -group {Control } -radix hexadecimal /tb_top/UnitTop/UnitControl/ALUFN_o
add wave -noupdate -group {Control } -radix hexadecimal /tb_top/UnitTop/UnitControl/RFaddr_rd_o
add wave -noupdate -group {Control } -radix hexadecimal /tb_top/UnitTop/UnitControl/RFaddr_wr_o
add wave -noupdate -group {Control } -radix hexadecimal /tb_top/UnitTop/UnitControl/PCsel_o
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -group DataPath -radix hexadecimal /tb_top/UnitTop/UnitDataPath/busData_w
add wave -noupdate -group DataPath -radix hexadecimal /tb_top/UnitTop/UnitDataPath/ALUtoC_w
add wave -noupdate -group DataPath -radix hexadecimal /tb_top/UnitTop/UnitDataPath/AtoALU_w
add wave -noupdate -group DataPath -radix hexadecimal /tb_top/UnitTop/UnitDataPath/CtoBus_w
add wave -noupdate -group DataPath -radix hexadecimal /tb_top/UnitTop/UnitDataPath/Imm1toBus_w
add wave -noupdate -group DataPath -radix hexadecimal /tb_top/UnitTop/UnitDataPath/Imm2toBus_w
add wave -noupdate -group DataPath -radix hexadecimal /tb_top/UnitTop/UnitDataPath/RFtoBus_w
add wave -noupdate -group DataPath -radix hexadecimal /tb_top/UnitTop/UnitDataPath/RaAddress_w
add wave -noupdate -group DataPath -radix hexadecimal /tb_top/UnitTop/UnitDataPath/RbAddress_w
add wave -noupdate -group DataPath -radix hexadecimal /tb_top/UnitTop/UnitDataPath/RcAddress_w
add wave -noupdate -group DataPath -radix hexadecimal /tb_top/UnitTop/UnitDataPath/WriteAddrRF_w
add wave -noupdate -group DataPath -radix hexadecimal /tb_top/UnitTop/UnitDataPath/ReadAddrRF_w
add wave -noupdate -group DataPath -radix hexadecimal /tb_top/UnitTop/UnitDataPath/rbAndrc_w
add wave -noupdate -group DataPath -radix hexadecimal /tb_top/UnitTop/UnitDataPath/opIRtoALU_w
add wave -noupdate -group DataPath -radix hexadecimal /tb_top/UnitTop/UnitDataPath/bustoRF_w
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {941641 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 315
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
WaveRestoreZoom {0 ps} {1839104 ps}
