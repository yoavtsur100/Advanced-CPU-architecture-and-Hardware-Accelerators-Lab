onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group TOP -radix hexadecimal /tb_rv32imscmcu/TOP/CLOCK_50
add wave -noupdate -group TOP -color Cyan -radix decimal /tb_rv32imscmcu/TOP/mclk_cnt_o
add wave -noupdate -group TOP -color Blue -radix hexadecimal /tb_rv32imscmcu/TOP/instruction_o
add wave -noupdate -group TOP -color Magenta -radix hexadecimal /tb_rv32imscmcu/TOP/pc_o
add wave -noupdate -group TOP -radix binary /tb_rv32imscmcu/TOP/KEY
add wave -noupdate -group TOP -radix hexadecimal /tb_rv32imscmcu/TOP/SW
add wave -noupdate -group TOP -color Gold -radix hexadecimal /tb_rv32imscmcu/TOP/LEDR
add wave -noupdate -group TOP -color Gold -radix hexadecimal /tb_rv32imscmcu/TOP/HEX0
add wave -noupdate -group TOP -color Gold -radix hexadecimal /tb_rv32imscmcu/TOP/HEX1
add wave -noupdate -group TOP -color Gold -radix hexadecimal /tb_rv32imscmcu/TOP/HEX2
add wave -noupdate -group TOP -color Gold -radix hexadecimal /tb_rv32imscmcu/TOP/HEX3
add wave -noupdate -group TOP -color Gold -radix hexadecimal /tb_rv32imscmcu/TOP/HEX4
add wave -noupdate -group TOP -color Gold -radix hexadecimal /tb_rv32imscmcu/TOP/HEX5
add wave -noupdate -group TOP -radix hexadecimal /tb_rv32imscmcu/TOP/GPIO(9)
add wave -noupdate -group TOP -radix hexadecimal -childformat {{/tb_rv32imscmcu/TOP/GPIO(39) -radix hexadecimal} {/tb_rv32imscmcu/TOP/GPIO(38) -radix hexadecimal} {/tb_rv32imscmcu/TOP/GPIO(37) -radix hexadecimal} {/tb_rv32imscmcu/TOP/GPIO(36) -radix hexadecimal} {/tb_rv32imscmcu/TOP/GPIO(35) -radix hexadecimal} {/tb_rv32imscmcu/TOP/GPIO(34) -radix hexadecimal} {/tb_rv32imscmcu/TOP/GPIO(33) -radix hexadecimal} {/tb_rv32imscmcu/TOP/GPIO(32) -radix hexadecimal} {/tb_rv32imscmcu/TOP/GPIO(31) -radix hexadecimal} {/tb_rv32imscmcu/TOP/GPIO(30) -radix hexadecimal} {/tb_rv32imscmcu/TOP/GPIO(29) -radix hexadecimal} {/tb_rv32imscmcu/TOP/GPIO(28) -radix hexadecimal} {/tb_rv32imscmcu/TOP/GPIO(27) -radix hexadecimal} {/tb_rv32imscmcu/TOP/GPIO(26) -radix hexadecimal} {/tb_rv32imscmcu/TOP/GPIO(25) -radix hexadecimal} {/tb_rv32imscmcu/TOP/GPIO(24) -radix hexadecimal} {/tb_rv32imscmcu/TOP/GPIO(23) -radix hexadecimal} {/tb_rv32imscmcu/TOP/GPIO(22) -radix hexadecimal} {/tb_rv32imscmcu/TOP/GPIO(21) -radix hexadecimal} {/tb_rv32imscmcu/TOP/GPIO(20) -radix hexadecimal} {/tb_rv32imscmcu/TOP/GPIO(19) -radix hexadecimal} {/tb_rv32imscmcu/TOP/GPIO(18) -radix hexadecimal} {/tb_rv32imscmcu/TOP/GPIO(17) -radix hexadecimal} {/tb_rv32imscmcu/TOP/GPIO(16) -radix hexadecimal} {/tb_rv32imscmcu/TOP/GPIO(15) -radix hexadecimal} {/tb_rv32imscmcu/TOP/GPIO(14) -radix hexadecimal} {/tb_rv32imscmcu/TOP/GPIO(13) -radix hexadecimal} {/tb_rv32imscmcu/TOP/GPIO(12) -radix hexadecimal} {/tb_rv32imscmcu/TOP/GPIO(11) -radix hexadecimal} {/tb_rv32imscmcu/TOP/GPIO(10) -radix hexadecimal} {/tb_rv32imscmcu/TOP/GPIO(9) -radix hexadecimal} {/tb_rv32imscmcu/TOP/GPIO(8) -radix hexadecimal} {/tb_rv32imscmcu/TOP/GPIO(7) -radix hexadecimal} {/tb_rv32imscmcu/TOP/GPIO(6) -radix hexadecimal} {/tb_rv32imscmcu/TOP/GPIO(5) -radix hexadecimal} {/tb_rv32imscmcu/TOP/GPIO(4) -radix hexadecimal} {/tb_rv32imscmcu/TOP/GPIO(3) -radix hexadecimal} {/tb_rv32imscmcu/TOP/GPIO(2) -radix hexadecimal} {/tb_rv32imscmcu/TOP/GPIO(1) -radix hexadecimal} {/tb_rv32imscmcu/TOP/GPIO(0) -radix hexadecimal}} -subitemconfig {/tb_rv32imscmcu/TOP/GPIO(39) {-height 15 -radix hexadecimal} /tb_rv32imscmcu/TOP/GPIO(38) {-height 15 -radix hexadecimal} /tb_rv32imscmcu/TOP/GPIO(37) {-height 15 -radix hexadecimal} /tb_rv32imscmcu/TOP/GPIO(36) {-height 15 -radix hexadecimal} /tb_rv32imscmcu/TOP/GPIO(35) {-height 15 -radix hexadecimal} /tb_rv32imscmcu/TOP/GPIO(34) {-height 15 -radix hexadecimal} /tb_rv32imscmcu/TOP/GPIO(33) {-height 15 -radix hexadecimal} /tb_rv32imscmcu/TOP/GPIO(32) {-height 15 -radix hexadecimal} /tb_rv32imscmcu/TOP/GPIO(31) {-height 15 -radix hexadecimal} /tb_rv32imscmcu/TOP/GPIO(30) {-height 15 -radix hexadecimal} /tb_rv32imscmcu/TOP/GPIO(29) {-height 15 -radix hexadecimal} /tb_rv32imscmcu/TOP/GPIO(28) {-height 15 -radix hexadecimal} /tb_rv32imscmcu/TOP/GPIO(27) {-height 15 -radix hexadecimal} /tb_rv32imscmcu/TOP/GPIO(26) {-height 15 -radix hexadecimal} /tb_rv32imscmcu/TOP/GPIO(25) {-height 15 -radix hexadecimal} /tb_rv32imscmcu/TOP/GPIO(24) {-height 15 -radix hexadecimal} /tb_rv32imscmcu/TOP/GPIO(23) {-height 15 -radix hexadecimal} /tb_rv32imscmcu/TOP/GPIO(22) {-height 15 -radix hexadecimal} /tb_rv32imscmcu/TOP/GPIO(21) {-height 15 -radix hexadecimal} /tb_rv32imscmcu/TOP/GPIO(20) {-height 15 -radix hexadecimal} /tb_rv32imscmcu/TOP/GPIO(19) {-height 15 -radix hexadecimal} /tb_rv32imscmcu/TOP/GPIO(18) {-height 15 -radix hexadecimal} /tb_rv32imscmcu/TOP/GPIO(17) {-height 15 -radix hexadecimal} /tb_rv32imscmcu/TOP/GPIO(16) {-height 15 -radix hexadecimal} /tb_rv32imscmcu/TOP/GPIO(15) {-height 15 -radix hexadecimal} /tb_rv32imscmcu/TOP/GPIO(14) {-height 15 -radix hexadecimal} /tb_rv32imscmcu/TOP/GPIO(13) {-height 15 -radix hexadecimal} /tb_rv32imscmcu/TOP/GPIO(12) {-height 15 -radix hexadecimal} /tb_rv32imscmcu/TOP/GPIO(11) {-height 15 -radix hexadecimal} /tb_rv32imscmcu/TOP/GPIO(10) {-height 15 -radix hexadecimal} /tb_rv32imscmcu/TOP/GPIO(9) {-height 15 -radix hexadecimal} /tb_rv32imscmcu/TOP/GPIO(8) {-height 15 -radix hexadecimal} /tb_rv32imscmcu/TOP/GPIO(7) {-height 15 -radix hexadecimal} /tb_rv32imscmcu/TOP/GPIO(6) {-height 15 -radix hexadecimal} /tb_rv32imscmcu/TOP/GPIO(5) {-height 15 -radix hexadecimal} /tb_rv32imscmcu/TOP/GPIO(4) {-height 15 -radix hexadecimal} /tb_rv32imscmcu/TOP/GPIO(3) {-height 15 -radix hexadecimal} /tb_rv32imscmcu/TOP/GPIO(2) {-height 15 -radix hexadecimal} /tb_rv32imscmcu/TOP/GPIO(1) {-height 15 -radix hexadecimal} /tb_rv32imscmcu/TOP/GPIO(0) {-height 15 -radix hexadecimal}} /tb_rv32imscmcu/TOP/GPIO
add wave -noupdate -group TOP -radix hexadecimal /tb_rv32imscmcu/TOP/RegWrite_ctrl_o
add wave -noupdate -group TOP -radix hexadecimal /tb_rv32imscmcu/TOP/MemWrite_ctrl_o
add wave -noupdate -group TOP -radix hexadecimal /tb_rv32imscmcu/TOP/Branch_ctrl_o
add wave -noupdate -group TOP -radix hexadecimal /tb_rv32imscmcu/TOP/read_data1_o
add wave -noupdate -group TOP -radix hexadecimal /tb_rv32imscmcu/TOP/read_data2_o
add wave -noupdate -group TOP -radix hexadecimal /tb_rv32imscmcu/TOP/write_data_o
add wave -noupdate -group TOP -radix hexadecimal /tb_rv32imscmcu/TOP/alu_res_o
add wave -noupdate -group TOP -radix hexadecimal /tb_rv32imscmcu/TOP/brTaken_o
add wave -noupdate -group TOP -radix hexadecimal /tb_rv32imscmcu/TOP/dtcm_addr_o
add wave -noupdate -group TOP -radix hexadecimal /tb_rv32imscmcu/TOP/dtcm_data_wr_o
add wave -noupdate -group TOP -radix hexadecimal /tb_rv32imscmcu/TOP/dtcm_data_rd_o
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -group Control -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/CTL/instruction_i
add wave -noupdate -group Control -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/CTL/DIVbusy_i
add wave -noupdate -group Control -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/CTL/PChold_ctrl_o
add wave -noupdate -group Control -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/CTL/RegDst_ctrl_o
add wave -noupdate -group Control -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/CTL/ALUSrc_ctrl_o
add wave -noupdate -group Control -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/CTL/MemtoReg_ctrl_o
add wave -noupdate -group Control -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/CTL/RegWrite_ctrl_o
add wave -noupdate -group Control -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/CTL/MemRead_ctrl_o
add wave -noupdate -group Control -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/CTL/MemWrite_ctrl_o
add wave -noupdate -group Control -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/CTL/Branch_ctrl_o
add wave -noupdate -group Control -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/CTL/Jal_ctrl_o
add wave -noupdate -group Control -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/CTL/Jalr_ctrl_o
add wave -noupdate -group Control -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/CTL/UpperIm_ctrl_o
add wave -noupdate -group Control -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/CTL/ALUOp_ctrl_o
add wave -noupdate -group Control -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/CTL/MULop_o
add wave -noupdate -group Control -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/CTL/DIVctrl_o
add wave -noupdate -group Control -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/CTL/WBSrc0_o
add wave -noupdate -group Control -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/CTL/WBSrc1_o
add wave -noupdate -group Control -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/CTL/INTR_i
add wave -noupdate -group Control -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/CTL/INTA_o
add wave -noupdate -group Control -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/CTL/ClearGIE_ctrl_o
add wave -noupdate -group Control -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/CTL/SetGIE_ctrl_o
add wave -noupdate -group Control -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/CTL/WriteTP_ctrl_o
add wave -noupdate -group Control -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/CTL/SelectTypeAddr_ctrl_o
add wave -noupdate -group Control -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/CTL/IntJump_ctrl_o
add wave -noupdate -group Control -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/CTL/IntAccept_ctrl_o
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -group Core -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/rst_i
add wave -noupdate -group Core -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/clk_i
add wave -noupdate -group Core -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/divclk_i
add wave -noupdate -group Core -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/pc_o
add wave -noupdate -group Core -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/instruction_o
add wave -noupdate -group Core -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/RegWrite_ctrl_o
add wave -noupdate -group Core -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/MemWrite_ctrl_o
add wave -noupdate -group Core -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/Branch_ctrl_o
add wave -noupdate -group Core -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/MemRead_ctrl_o
add wave -noupdate -group Core -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/read_data1_o
add wave -noupdate -group Core -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/read_data2_o
add wave -noupdate -group Core -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/write_data_o
add wave -noupdate -group Core -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/alu_res_o
add wave -noupdate -group Core -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/brTaken_o
add wave -noupdate -group Core -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/dtcm_addr_o
add wave -noupdate -group Core -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/dtcm_data_wr_o
add wave -noupdate -group Core -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/dtcm_data_rd_o
add wave -noupdate -group Core -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/mclk_cnt_o
add wave -noupdate -group Core -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/mclk_o
add wave -noupdate -group Core -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/INTR_i
add wave -noupdate -group Core -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/INTA_o
add wave -noupdate -group Core -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/GIE_o
add wave -noupdate -group Core -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/DataBUS
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -group {Interrupt Controller} -radix hexadecimal /tb_rv32imscmcu/TOP/INTC_inst/clk_i
add wave -noupdate -group {Interrupt Controller} -radix hexadecimal /tb_rv32imscmcu/TOP/INTC_inst/rst_i
add wave -noupdate -group {Interrupt Controller} -radix hexadecimal /tb_rv32imscmcu/TOP/INTC_inst/addr_i
add wave -noupdate -group {Interrupt Controller} -radix hexadecimal /tb_rv32imscmcu/TOP/INTC_inst/mem_write_i
add wave -noupdate -group {Interrupt Controller} -radix hexadecimal /tb_rv32imscmcu/TOP/INTC_inst/mem_read_i
add wave -noupdate -group {Interrupt Controller} -radix hexadecimal /tb_rv32imscmcu/TOP/INTC_inst/KEY_pins_i
add wave -noupdate -group {Interrupt Controller} -radix hexadecimal /tb_rv32imscmcu/TOP/INTC_inst/BTIFG_i
add wave -noupdate -group {Interrupt Controller} -radix hexadecimal /tb_rv32imscmcu/TOP/INTC_inst/INTR_o
add wave -noupdate -group {Interrupt Controller} -radix hexadecimal /tb_rv32imscmcu/TOP/INTC_inst/INTA_i
add wave -noupdate -group {Interrupt Controller} -radix hexadecimal /tb_rv32imscmcu/TOP/INTC_inst/GIE_i
add wave -noupdate -group {Interrupt Controller} -radix hexadecimal /tb_rv32imscmcu/TOP/INTC_inst/DataBUS
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -group GPIO -radix hexadecimal /tb_rv32imscmcu/TOP/GPIO_inst/clk_i
add wave -noupdate -group GPIO -radix hexadecimal /tb_rv32imscmcu/TOP/GPIO_inst/rst_i
add wave -noupdate -group GPIO -radix hexadecimal /tb_rv32imscmcu/TOP/GPIO_inst/addr_i
add wave -noupdate -group GPIO -radix hexadecimal /tb_rv32imscmcu/TOP/GPIO_inst/mem_write_i
add wave -noupdate -group GPIO -radix hexadecimal /tb_rv32imscmcu/TOP/GPIO_inst/mem_read_i
add wave -noupdate -group GPIO -radix hexadecimal /tb_rv32imscmcu/TOP/GPIO_inst/DataBUS
add wave -noupdate -group GPIO -radix hexadecimal /tb_rv32imscmcu/TOP/GPIO_inst/SW_pins_i
add wave -noupdate -group GPIO -radix hexadecimal /tb_rv32imscmcu/TOP/GPIO_inst/LEDR_pins_o
add wave -noupdate -group GPIO -radix hexadecimal /tb_rv32imscmcu/TOP/GPIO_inst/HEX0_pins_o
add wave -noupdate -group GPIO -radix hexadecimal /tb_rv32imscmcu/TOP/GPIO_inst/HEX1_pins_o
add wave -noupdate -group GPIO -radix hexadecimal /tb_rv32imscmcu/TOP/GPIO_inst/HEX2_pins_o
add wave -noupdate -group GPIO -radix hexadecimal /tb_rv32imscmcu/TOP/GPIO_inst/HEX3_pins_o
add wave -noupdate -group GPIO -radix hexadecimal /tb_rv32imscmcu/TOP/GPIO_inst/HEX4_pins_o
add wave -noupdate -group GPIO -radix hexadecimal /tb_rv32imscmcu/TOP/GPIO_inst/HEX5_pins_o
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -group FSM -color {Orange Red} /tb_rv32imscmcu/TOP/CORE_inst/CTL/state_q
add wave -noupdate -group FSM -color {Orange Red} /tb_rv32imscmcu/TOP/CORE_inst/CTL/next_state_w
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -group Timer -radix hexadecimal /tb_rv32imscmcu/TOP/Timer_inst/clk_i
add wave -noupdate -group Timer -radix hexadecimal /tb_rv32imscmcu/TOP/Timer_inst/rst_i
add wave -noupdate -group Timer -radix hexadecimal /tb_rv32imscmcu/TOP/Timer_inst/addr_i
add wave -noupdate -group Timer -radix hexadecimal /tb_rv32imscmcu/TOP/Timer_inst/mem_write_i
add wave -noupdate -group Timer -radix hexadecimal /tb_rv32imscmcu/TOP/Timer_inst/mem_read_i
add wave -noupdate -group Timer -radix hexadecimal /tb_rv32imscmcu/TOP/Timer_inst/DataBUS
add wave -noupdate -group Timer -radix hexadecimal /tb_rv32imscmcu/TOP/Timer_inst/CAPIN1_i
add wave -noupdate -group Timer -radix hexadecimal /tb_rv32imscmcu/TOP/Timer_inst/CAPIN2_i
add wave -noupdate -group Timer -radix hexadecimal /tb_rv32imscmcu/TOP/Timer_inst/BTIFG_o
add wave -noupdate -group Timer -radix hexadecimal /tb_rv32imscmcu/TOP/Timer_inst/PWMout_o
add wave -noupdate -group Timer -radix hexadecimal /tb_rv32imscmcu/TOP/Timer_inst/btctl1_q
add wave -noupdate -group Timer -color Red -radix hexadecimal /tb_rv32imscmcu/TOP/Timer_inst/btctl2_q
add wave -noupdate -group Timer -color {Cornflower Blue} -radix hexadecimal /tb_rv32imscmcu/TOP/Timer_inst/btcnt_q
add wave -noupdate -group Timer -radix hexadecimal /tb_rv32imscmcu/TOP/Timer_inst/btcmpr0_q
add wave -noupdate -group Timer -radix hexadecimal /tb_rv32imscmcu/TOP/Timer_inst/btcmpr1_q
add wave -noupdate -group Timer -color {Dark Orchid} -radix hexadecimal /tb_rv32imscmcu/TOP/Timer_inst/btcapr_q
add wave -noupdate -group Timer -radix hexadecimal /tb_rv32imscmcu/TOP/Timer_inst/btcl0_q
add wave -noupdate -group Timer -radix hexadecimal /tb_rv32imscmcu/TOP/Timer_inst/btcl1_q
add wave -noupdate -group Timer -radix hexadecimal /tb_rv32imscmcu/TOP/Timer_inst/cs_ctl1_w
add wave -noupdate -group Timer -radix hexadecimal /tb_rv32imscmcu/TOP/Timer_inst/cs_ctl2_w
add wave -noupdate -group Timer -radix hexadecimal /tb_rv32imscmcu/TOP/Timer_inst/cs_cmpr0_w
add wave -noupdate -group Timer -radix hexadecimal /tb_rv32imscmcu/TOP/Timer_inst/cs_cmpr1_w
add wave -noupdate -group Timer -radix hexadecimal /tb_rv32imscmcu/TOP/Timer_inst/cs_capr_w
add wave -noupdate -group Timer -radix hexadecimal /tb_rv32imscmcu/TOP/Timer_inst/bt_hold_w
add wave -noupdate -group Timer -radix hexadecimal /tb_rv32imscmcu/TOP/Timer_inst/bt_ssel_w
add wave -noupdate -group Timer -radix hexadecimal /tb_rv32imscmcu/TOP/Timer_inst/bt_clr_w
add wave -noupdate -group Timer -radix hexadecimal /tb_rv32imscmcu/TOP/Timer_inst/bt_int_w
add wave -noupdate -group Timer -radix hexadecimal /tb_rv32imscmcu/TOP/Timer_inst/bt_outen_w
add wave -noupdate -group Timer -radix hexadecimal /tb_rv32imscmcu/TOP/Timer_inst/bt_outmd_w
add wave -noupdate -group Timer -radix hexadecimal /tb_rv32imscmcu/TOP/Timer_inst/cap_isel_w
add wave -noupdate -group Timer -radix hexadecimal /tb_rv32imscmcu/TOP/Timer_inst/cap_md_w
add wave -noupdate -group Timer -radix hexadecimal /tb_rv32imscmcu/TOP/Timer_inst/prescaler_cnt_r
add wave -noupdate -group Timer -radix hexadecimal /tb_rv32imscmcu/TOP/Timer_inst/timer_tick_w
add wave -noupdate -group Timer -radix hexadecimal /tb_rv32imscmcu/TOP/Timer_inst/cap_sig_w
add wave -noupdate -group Timer -radix hexadecimal /tb_rv32imscmcu/TOP/Timer_inst/cap_d1_r
add wave -noupdate -group Timer -radix hexadecimal /tb_rv32imscmcu/TOP/Timer_inst/cap_d2_r
add wave -noupdate -group Timer -radix hexadecimal /tb_rv32imscmcu/TOP/Timer_inst/cap_event_w
add wave -noupdate -group Timer -radix hexadecimal /tb_rv32imscmcu/TOP/Timer_inst/btifg_pulse_r
add wave -noupdate -group Timer -radix hexadecimal /tb_rv32imscmcu/TOP/Timer_inst/timer_data_out_w
add wave -noupdate -group Timer -radix hexadecimal /tb_rv32imscmcu/TOP/Timer_inst/drive_bus_w
add wave -noupdate -group Timer -radix hexadecimal /tb_rv32imscmcu/TOP/Timer_inst/pwm_r
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -group Fetch -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/IFE/addr_gen_i
add wave -noupdate -group Fetch -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/IFE/Branch_ctrl_i
add wave -noupdate -group Fetch -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/IFE/brTaken_i
add wave -noupdate -group Fetch -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/IFE/Jal_ctrl_i
add wave -noupdate -group Fetch -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/IFE/Jalr_ctrl_i
add wave -noupdate -group Fetch -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/IFE/alu_res_i
add wave -noupdate -group Fetch -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/IFE/PChold_i
add wave -noupdate -group Fetch -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/IFE/IntAccept_ctrl_i
add wave -noupdate -group Fetch -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/IFE/WriteTP_ctrl_i
add wave -noupdate -group Fetch -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/IFE/pc_o
add wave -noupdate -group Fetch -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/IFE/pc_plus4_o
add wave -noupdate -group Fetch -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/IFE/instruction_o
add wave -noupdate -group Fetch -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/IFE/pc_q
add wave -noupdate -group Fetch -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/IFE/pc_plus4_q
add wave -noupdate -group Fetch -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/IFE/pc_plus4_r
add wave -noupdate -group Fetch -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/IFE/itcm_addr_w
add wave -noupdate -group Fetch -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/IFE/next_pc_w
add wave -noupdate -group Fetch -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/IFE/brTaken_w
add wave -noupdate -group Fetch -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/IFE/rst_q
add wave -noupdate -group Fetch -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/IFE/itcm_addr_next
add wave -noupdate -group Fetch -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/IFE/return_pc_q
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -group Decode -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/ID/GIE_o
add wave -noupdate -group Decode -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/ID/pc_plus4_i
add wave -noupdate -group Decode -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/ID/instruction_i
add wave -noupdate -group Decode -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/ID/dtcm_data_rd_i
add wave -noupdate -group Decode -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/ID/alu_res_i
add wave -noupdate -group Decode -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/ID/RegDst_ctrl_i
add wave -noupdate -group Decode -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/ID/RegWrite_ctrl_i
add wave -noupdate -group Decode -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/ID/MemtoReg_ctrl_i
add wave -noupdate -group Decode -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/ID/ClearGIE_ctrl_i
add wave -noupdate -group Decode -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/ID/SetGIE_ctrl_i
add wave -noupdate -group Decode -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/ID/WriteTP_ctrl_i
add wave -noupdate -group Decode -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/ID/read_data1_o
add wave -noupdate -group Decode -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/ID/read_data2_o
add wave -noupdate -group Decode -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/ID/SignExt_o
add wave -noupdate -group Decode -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/ID/GIE_o
add wave -noupdate -group Decode -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/ID/RF_q
add wave -noupdate -group Decode -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/ID/gie_q
add wave -noupdate -group Decode -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/ID/write_data_w
add wave -noupdate -group Decode -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/ID/opc_w
add wave -noupdate -group Decode -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/ID/rs1_w
add wave -noupdate -group Decode -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/ID/rs2_w
add wave -noupdate -group Decode -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/ID/rd_w
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -group {Register File} -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/ID/RF_q
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -group Execute -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/EXE/read_data1_i
add wave -noupdate -group Execute -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/EXE/read_data2_i
add wave -noupdate -group Execute -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/EXE/sign_extend_i
add wave -noupdate -group Execute -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/EXE/UpperIm_ctrl_i
add wave -noupdate -group Execute -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/EXE/ALUOp_ctrl_i
add wave -noupdate -group Execute -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/EXE/ALUSrc_ctrl_i
add wave -noupdate -group Execute -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/EXE/pc_i
add wave -noupdate -group Execute -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/EXE/divclk_i
add wave -noupdate -group Execute -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/EXE/MULop_i
add wave -noupdate -group Execute -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/EXE/Div_ctrl_i
add wave -noupdate -group Execute -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/EXE/WBSrc0_i
add wave -noupdate -group Execute -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/EXE/WBSrc1_i
add wave -noupdate -group Execute -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/EXE/rst_i
add wave -noupdate -group Execute -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/EXE/brTaken_o
add wave -noupdate -group Execute -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/EXE/alu_res_o
add wave -noupdate -group Execute -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/EXE/addr_gen_o
add wave -noupdate -group Execute -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/EXE/Divbusy_o
add wave -noupdate -group Execute -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/EXE/ain_w
add wave -noupdate -group Execute -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/EXE/bin_w
add wave -noupdate -group Execute -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/EXE/sub_res_w
add wave -noupdate -group Execute -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/EXE/ltu_res_w
add wave -noupdate -group Execute -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/EXE/eq_res_w
add wave -noupdate -group Execute -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/EXE/msbneq_res_w
add wave -noupdate -group Execute -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/EXE/alu_res_r
add wave -noupdate -group Execute -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/EXE/brTaken_w
add wave -noupdate -group Execute -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/EXE/resmul_w
add wave -noupdate -group Execute -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/EXE/RESIDUE_w
add wave -noupdate -group Execute -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/EXE/QUOTIENT_w
add wave -noupdate -group Execute -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/EXE/residue_mclk_reg
add wave -noupdate -group Execute -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/EXE/quotient_mclk_reg
add wave -noupdate -group Execute -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/EXE/AoutSync_w
add wave -noupdate -group Execute -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/EXE/BoutSync_w
add wave -noupdate -group Execute -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/EXE/MULorDIV_w
add wave -noupdate -group Execute -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/EXE/Div_ctrl_q1
add wave -noupdate -group Execute -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/EXE/Div_ctrl_q2
add wave -noupdate -group Execute /tb_rv32imscmcu/TOP/CORE_inst/EXE/Div_ctrl_q3
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -group Div -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/EXE/DIV/DIVCLK_i
add wave -noupdate -group Div -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/EXE/DIV/DIVRST_i
add wave -noupdate -group Div -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/EXE/DIV/DIVENA_i
add wave -noupdate -group Div -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/EXE/DIV/DIVIDEND_i
add wave -noupdate -group Div -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/EXE/DIV/DIVISOR_i
add wave -noupdate -group Div -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/EXE/DIV/DIVBUSY_o
add wave -noupdate -group Div -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/EXE/DIV/QUOTIENT_o
add wave -noupdate -group Div -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/EXE/DIV/RESIDUE_o
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -group Memory -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/MEM/dtcm_addr_i
add wave -noupdate -group Memory -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/MEM/dtcm_data_wr_i
add wave -noupdate -group Memory -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/MEM/MemRead_ctrl_i
add wave -noupdate -group Memory -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/MEM/MemWrite_ctrl_i
add wave -noupdate -group Memory -radix hexadecimal /tb_rv32imscmcu/TOP/CORE_inst/MEM/dtcm_data_rd_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1667072 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 326
configure wave -valuecolwidth 225
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
WaveRestoreZoom {131166464 ps} {132833536 ps}
