onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tb_rv32im_pipeline/CORE/EXE/ain_w
add wave -noupdate -radix hexadecimal /tb_rv32im_pipeline/CORE/EXE/bin_w
add wave -noupdate -expand -group TOP -radix hexadecimal /tb_rv32im_pipeline/rst_i
add wave -noupdate -expand -group TOP -radix hexadecimal /tb_rv32im_pipeline/clk_i
add wave -noupdate -expand -group TOP -color Violet -itemcolor Violet -radix hexadecimal /tb_rv32im_pipeline/clkcnt_o
add wave -noupdate -expand -group TOP -expand -group PC -radix hexadecimal /tb_rv32im_pipeline/IFpc_o
add wave -noupdate -expand -group TOP -expand -group PC -radix hexadecimal /tb_rv32im_pipeline/IDpc_o
add wave -noupdate -expand -group TOP -expand -group PC -color Tan -itemcolor Tan -radix hexadecimal /tb_rv32im_pipeline/EXpc_o
add wave -noupdate -expand -group TOP -expand -group PC -radix hexadecimal /tb_rv32im_pipeline/MEMpc_o
add wave -noupdate -expand -group TOP -expand -group PC -radix hexadecimal /tb_rv32im_pipeline/WBpc_o
add wave -noupdate -expand -group TOP -group INSTRUCTION -radix hexadecimal /tb_rv32im_pipeline/IFinstruction_o
add wave -noupdate -expand -group TOP -group INSTRUCTION -radix hexadecimal /tb_rv32im_pipeline/IDinstruction_o
add wave -noupdate -expand -group TOP -group INSTRUCTION -radix hexadecimal /tb_rv32im_pipeline/EXinstruction_o
add wave -noupdate -expand -group TOP -group INSTRUCTION -radix hexadecimal /tb_rv32im_pipeline/MEMinstruction_o
add wave -noupdate -expand -group TOP -group INSTRUCTION -radix hexadecimal /tb_rv32im_pipeline/WBinstruction_o
add wave -noupdate -expand -group TOP -radix hexadecimal /tb_rv32im_pipeline/STRIGGER_o
add wave -noupdate -expand -group TOP -color Cyan -itemcolor Cyan -radix hexadecimal /tb_rv32im_pipeline/FHCNT_o
add wave -noupdate -expand -group TOP -color Blue -itemcolor Blue -radix hexadecimal /tb_rv32im_pipeline/STCNT_o
add wave -noupdate -expand -group TOP -radix hexadecimal /tb_rv32im_pipeline/BPADDR_i
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -group IFETCH /tb_rv32im_pipeline/CORE/IFE/PCwrite_i
add wave -noupdate -group IFETCH /tb_rv32im_pipeline/CORE/IFE/Jalr_ctrl_i
add wave -noupdate -group IFETCH -color {Slate Blue} -itemcolor {Slate Blue} /tb_rv32im_pipeline/CORE/IFE/Branch_or_jal_i
add wave -noupdate -group IFETCH /tb_rv32im_pipeline/CORE/IFE/addr_gen_i
add wave -noupdate -group IFETCH /tb_rv32im_pipeline/CORE/IFE/alu_res_i
add wave -noupdate -group IFETCH /tb_rv32im_pipeline/CORE/IFE/pc_o
add wave -noupdate -group IFETCH /tb_rv32im_pipeline/CORE/IFE/pc_plus4_o
add wave -noupdate -group IFETCH /tb_rv32im_pipeline/CORE/IFE/instruction_o
add wave -noupdate -group IFETCH /tb_rv32im_pipeline/CORE/IFE/pc_q
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -group IDECODE /tb_rv32im_pipeline/CORE/ID/wb_data_i
add wave -noupdate -group IDECODE /tb_rv32im_pipeline/CORE/ID/wb_pc_plus4_i
add wave -noupdate -group IDECODE /tb_rv32im_pipeline/CORE/ID/RegDst_i
add wave -noupdate -group IDECODE /tb_rv32im_pipeline/CORE/ID/instruction_i
add wave -noupdate -group IDECODE /tb_rv32im_pipeline/CORE/ID/RegWrite_ctrl_i
add wave -noupdate -group IDECODE /tb_rv32im_pipeline/CORE/ID/WriteRegister_i
add wave -noupdate -group IDECODE /tb_rv32im_pipeline/CORE/ID/read_data1_o
add wave -noupdate -group IDECODE /tb_rv32im_pipeline/CORE/ID/read_data2_o
add wave -noupdate -group IDECODE /tb_rv32im_pipeline/CORE/ID/rs1_o
add wave -noupdate -group IDECODE /tb_rv32im_pipeline/CORE/ID/rs2_o
add wave -noupdate -group IDECODE /tb_rv32im_pipeline/CORE/ID/rd_o
add wave -noupdate -group IDECODE /tb_rv32im_pipeline/CORE/ID/SignExt_o
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -radix decimal -childformat {{/tb_rv32im_pipeline/CORE/ID/RF_q(0) -radix decimal} {/tb_rv32im_pipeline/CORE/ID/RF_q(1) -radix decimal} {/tb_rv32im_pipeline/CORE/ID/RF_q(2) -radix decimal} {/tb_rv32im_pipeline/CORE/ID/RF_q(3) -radix decimal} {/tb_rv32im_pipeline/CORE/ID/RF_q(4) -radix decimal} {/tb_rv32im_pipeline/CORE/ID/RF_q(5) -radix decimal} {/tb_rv32im_pipeline/CORE/ID/RF_q(6) -radix decimal} {/tb_rv32im_pipeline/CORE/ID/RF_q(7) -radix decimal} {/tb_rv32im_pipeline/CORE/ID/RF_q(8) -radix decimal} {/tb_rv32im_pipeline/CORE/ID/RF_q(9) -radix decimal} {/tb_rv32im_pipeline/CORE/ID/RF_q(10) -radix decimal} {/tb_rv32im_pipeline/CORE/ID/RF_q(11) -radix decimal} {/tb_rv32im_pipeline/CORE/ID/RF_q(12) -radix decimal} {/tb_rv32im_pipeline/CORE/ID/RF_q(13) -radix decimal} {/tb_rv32im_pipeline/CORE/ID/RF_q(14) -radix decimal} {/tb_rv32im_pipeline/CORE/ID/RF_q(15) -radix decimal} {/tb_rv32im_pipeline/CORE/ID/RF_q(16) -radix decimal} {/tb_rv32im_pipeline/CORE/ID/RF_q(17) -radix decimal} {/tb_rv32im_pipeline/CORE/ID/RF_q(18) -radix decimal} {/tb_rv32im_pipeline/CORE/ID/RF_q(19) -radix decimal} {/tb_rv32im_pipeline/CORE/ID/RF_q(20) -radix decimal} {/tb_rv32im_pipeline/CORE/ID/RF_q(21) -radix decimal} {/tb_rv32im_pipeline/CORE/ID/RF_q(22) -radix decimal} {/tb_rv32im_pipeline/CORE/ID/RF_q(23) -radix decimal} {/tb_rv32im_pipeline/CORE/ID/RF_q(24) -radix decimal} {/tb_rv32im_pipeline/CORE/ID/RF_q(25) -radix decimal} {/tb_rv32im_pipeline/CORE/ID/RF_q(26) -radix decimal} {/tb_rv32im_pipeline/CORE/ID/RF_q(27) -radix decimal} {/tb_rv32im_pipeline/CORE/ID/RF_q(28) -radix decimal} {/tb_rv32im_pipeline/CORE/ID/RF_q(29) -radix decimal} {/tb_rv32im_pipeline/CORE/ID/RF_q(30) -radix decimal} {/tb_rv32im_pipeline/CORE/ID/RF_q(31) -radix decimal}} -expand -subitemconfig {/tb_rv32im_pipeline/CORE/ID/RF_q(0) {-height 15 -radix decimal} /tb_rv32im_pipeline/CORE/ID/RF_q(1) {-height 15 -radix decimal} /tb_rv32im_pipeline/CORE/ID/RF_q(2) {-height 15 -radix decimal} /tb_rv32im_pipeline/CORE/ID/RF_q(3) {-height 15 -radix decimal} /tb_rv32im_pipeline/CORE/ID/RF_q(4) {-height 15 -radix decimal} /tb_rv32im_pipeline/CORE/ID/RF_q(5) {-color Coral -height 15 -itemcolor Coral -radix decimal} /tb_rv32im_pipeline/CORE/ID/RF_q(6) {-height 15 -radix decimal} /tb_rv32im_pipeline/CORE/ID/RF_q(7) {-height 15 -radix decimal} /tb_rv32im_pipeline/CORE/ID/RF_q(8) {-color {Indian Red} -height 15 -itemcolor {Indian Red} -radix decimal} /tb_rv32im_pipeline/CORE/ID/RF_q(9) {-height 15 -radix decimal} /tb_rv32im_pipeline/CORE/ID/RF_q(10) {-height 15 -radix decimal} /tb_rv32im_pipeline/CORE/ID/RF_q(11) {-height 15 -radix decimal} /tb_rv32im_pipeline/CORE/ID/RF_q(12) {-height 15 -radix decimal} /tb_rv32im_pipeline/CORE/ID/RF_q(13) {-height 15 -radix decimal} /tb_rv32im_pipeline/CORE/ID/RF_q(14) {-height 15 -radix decimal} /tb_rv32im_pipeline/CORE/ID/RF_q(15) {-height 15 -radix decimal} /tb_rv32im_pipeline/CORE/ID/RF_q(16) {-height 15 -radix decimal} /tb_rv32im_pipeline/CORE/ID/RF_q(17) {-height 15 -radix decimal} /tb_rv32im_pipeline/CORE/ID/RF_q(18) {-height 15 -radix decimal} /tb_rv32im_pipeline/CORE/ID/RF_q(19) {-height 15 -radix decimal} /tb_rv32im_pipeline/CORE/ID/RF_q(20) {-height 15 -radix decimal} /tb_rv32im_pipeline/CORE/ID/RF_q(21) {-height 15 -radix decimal} /tb_rv32im_pipeline/CORE/ID/RF_q(22) {-height 15 -radix decimal} /tb_rv32im_pipeline/CORE/ID/RF_q(23) {-height 15 -radix decimal} /tb_rv32im_pipeline/CORE/ID/RF_q(24) {-height 15 -radix decimal} /tb_rv32im_pipeline/CORE/ID/RF_q(25) {-height 15 -radix decimal} /tb_rv32im_pipeline/CORE/ID/RF_q(26) {-height 15 -radix decimal} /tb_rv32im_pipeline/CORE/ID/RF_q(27) {-height 15 -radix decimal} /tb_rv32im_pipeline/CORE/ID/RF_q(28) {-color {Medium Slate Blue} -height 15 -itemcolor {Medium Slate Blue} -radix decimal} /tb_rv32im_pipeline/CORE/ID/RF_q(29) {-color {Medium Slate Blue} -height 15 -itemcolor {Medium Slate Blue} -radix decimal} /tb_rv32im_pipeline/CORE/ID/RF_q(30) {-color {Medium Slate Blue} -height 15 -itemcolor {Medium Slate Blue} -radix decimal} /tb_rv32im_pipeline/CORE/ID/RF_q(31) {-height 15 -radix decimal}} /tb_rv32im_pipeline/CORE/ID/RF_q
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -group CONTROL /tb_rv32im_pipeline/CORE/CTL/instruction_i
add wave -noupdate -group CONTROL /tb_rv32im_pipeline/CORE/CTL/RegDst_ctrl_o
add wave -noupdate -group CONTROL /tb_rv32im_pipeline/CORE/CTL/ALUSrc_ctrl_o
add wave -noupdate -group CONTROL /tb_rv32im_pipeline/CORE/CTL/MemtoReg_ctrl_o
add wave -noupdate -group CONTROL /tb_rv32im_pipeline/CORE/CTL/RegWrite_ctrl_o
add wave -noupdate -group CONTROL /tb_rv32im_pipeline/CORE/CTL/MemRead_ctrl_o
add wave -noupdate -group CONTROL /tb_rv32im_pipeline/CORE/CTL/MemWrite_ctrl_o
add wave -noupdate -group CONTROL /tb_rv32im_pipeline/CORE/CTL/Branch_ctrl_o
add wave -noupdate -group CONTROL /tb_rv32im_pipeline/CORE/CTL/Jal_ctrl_o
add wave -noupdate -group CONTROL -color Gold -itemcolor Gold /tb_rv32im_pipeline/CORE/CTL/Jalr_ctrl_o
add wave -noupdate -group CONTROL /tb_rv32im_pipeline/CORE/CTL/UpperIm_ctrl_o
add wave -noupdate -group CONTROL /tb_rv32im_pipeline/CORE/CTL/ALUOp_ctrl_o
add wave -noupdate -group CONTROL /tb_rv32im_pipeline/CORE/CTL/MULop_o
add wave -noupdate -group CONTROL /tb_rv32im_pipeline/CORE/CTL/WBSrc_o
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -group EXECUTE -radix hexadecimal /tb_rv32im_pipeline/CORE/EXE/pc_i
add wave -noupdate -group EXECUTE -radix hexadecimal /tb_rv32im_pipeline/CORE/EXE/sign_extend_i
add wave -noupdate -group EXECUTE -radix hexadecimal /tb_rv32im_pipeline/CORE/EXE/read_data2_i
add wave -noupdate -group EXECUTE -radix hexadecimal /tb_rv32im_pipeline/CORE/EXE/read_data1_i
add wave -noupdate -group EXECUTE -radix hexadecimal /tb_rv32im_pipeline/CORE/EXE/UpperIm_ctrl_i
add wave -noupdate -group EXECUTE -radix hexadecimal /tb_rv32im_pipeline/CORE/EXE/forward_Ain_i
add wave -noupdate -group EXECUTE -radix hexadecimal /tb_rv32im_pipeline/CORE/EXE/wb_data_i
add wave -noupdate -group EXECUTE -radix hexadecimal /tb_rv32im_pipeline/CORE/EXE/alu_res_i
add wave -noupdate -group EXECUTE -radix hexadecimal /tb_rv32im_pipeline/CORE/EXE/forward_Bin_i
add wave -noupdate -group EXECUTE -radix hexadecimal /tb_rv32im_pipeline/CORE/EXE/ALUSrc_ctrl_i
add wave -noupdate -group EXECUTE -radix hexadecimal /tb_rv32im_pipeline/CORE/EXE/ALUOp_ctrl_i
add wave -noupdate -group EXECUTE -radix hexadecimal /tb_rv32im_pipeline/CORE/EXE/MULop_i
add wave -noupdate -group EXECUTE -radix hexadecimal /tb_rv32im_pipeline/CORE/EXE/addr_gen_o
add wave -noupdate -group EXECUTE -radix hexadecimal /tb_rv32im_pipeline/CORE/EXE/alu_res_o
add wave -noupdate -group EXECUTE -color Plum -itemcolor Plum -radix hexadecimal /tb_rv32im_pipeline/CORE/EXE/Jal_ctrl_i
add wave -noupdate -group EXECUTE -color Plum -itemcolor Plum -radix hexadecimal /tb_rv32im_pipeline/CORE/EXE/Branch_ctrl_i
add wave -noupdate -group EXECUTE -color Plum -itemcolor Plum -radix hexadecimal /tb_rv32im_pipeline/CORE/EXE/Branch_or_jal_o
add wave -noupdate -group EXECUTE -radix hexadecimal /tb_rv32im_pipeline/CORE/EXE/MULres_o
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -expand -group MEMORY -radix hexadecimal /tb_rv32im_pipeline/CORE/MEM/Jalr_ctrl_i
add wave -noupdate -expand -group MEMORY -radix hexadecimal /tb_rv32im_pipeline/CORE/MEM/Branch_or_jal_i
add wave -noupdate -expand -group MEMORY -color Violet -itemcolor Violet -radix hexadecimal /tb_rv32im_pipeline/CORE/MEM/dtcm_addr_i
add wave -noupdate -expand -group MEMORY -color Violet -itemcolor Violet -radix hexadecimal /tb_rv32im_pipeline/CORE/MEM/dtcm_data_wr_i
add wave -noupdate -expand -group MEMORY -color {Sky Blue} -itemcolor {Sky Blue} -radix hexadecimal /tb_rv32im_pipeline/CORE/MEM/MemWrite_ctrl_i
add wave -noupdate -expand -group MEMORY -radix decimal /tb_rv32im_pipeline/CORE/MEM/MULres_i
add wave -noupdate -expand -group MEMORY -radix hexadecimal /tb_rv32im_pipeline/CORE/MEM/MULop_i
add wave -noupdate -expand -group MEMORY -radix hexadecimal /tb_rv32im_pipeline/CORE/MEM/MemRead_ctrl_i
add wave -noupdate -expand -group MEMORY -radix hexadecimal /tb_rv32im_pipeline/CORE/MEM/Flush_o
add wave -noupdate -expand -group MEMORY -radix decimal /tb_rv32im_pipeline/CORE/MEM/dtcm_data_rd_o
add wave -noupdate -expand -group MEMORY -radix hexadecimal /tb_rv32im_pipeline/CORE/MEM/MULres_o
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -group {WRITE BACK} -color Gold -itemcolor Gold -radix decimal /tb_rv32im_pipeline/CORE/WB/dtcm_data_rd_i
add wave -noupdate -group {WRITE BACK} -color Gold -itemcolor Gold -radix hexadecimal /tb_rv32im_pipeline/CORE/WB/ALUres_i
add wave -noupdate -group {WRITE BACK} -radix hexadecimal /tb_rv32im_pipeline/CORE/WB/MULres_i
add wave -noupdate -group {WRITE BACK} -radix hexadecimal /tb_rv32im_pipeline/CORE/WB/MemtoReg_ctrl_i
add wave -noupdate -group {WRITE BACK} -radix hexadecimal /tb_rv32im_pipeline/CORE/WB/WBSrc_i
add wave -noupdate -group {WRITE BACK} -radix hexadecimal /tb_rv32im_pipeline/CORE/WB/wb_data_o
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -expand -group {FORWARD UNIT} -radix hexadecimal /tb_rv32im_pipeline/CORE/FU/ExMem_rd_i
add wave -noupdate -expand -group {FORWARD UNIT} -radix hexadecimal /tb_rv32im_pipeline/CORE/FU/ExMem_RegWrite_i
add wave -noupdate -expand -group {FORWARD UNIT} -radix hexadecimal /tb_rv32im_pipeline/CORE/FU/MemWB_rd_i
add wave -noupdate -expand -group {FORWARD UNIT} -radix hexadecimal /tb_rv32im_pipeline/CORE/FU/MEM_WB_RegWrite_i
add wave -noupdate -expand -group {FORWARD UNIT} -radix hexadecimal /tb_rv32im_pipeline/CORE/FU/IDEX_rs1_i
add wave -noupdate -expand -group {FORWARD UNIT} -radix hexadecimal /tb_rv32im_pipeline/CORE/FU/IDEX_rs2_i
add wave -noupdate -expand -group {FORWARD UNIT} -radix hexadecimal /tb_rv32im_pipeline/CORE/FU/forward_Ain_o
add wave -noupdate -expand -group {FORWARD UNIT} -radix hexadecimal /tb_rv32im_pipeline/CORE/FU/forward_Bin_o
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -group STALL /tb_rv32im_pipeline/CORE/ST/IFID_instruction_i
add wave -noupdate -group STALL /tb_rv32im_pipeline/CORE/ST/IDEX_rd_i
add wave -noupdate -group STALL /tb_rv32im_pipeline/CORE/ST/IDEX_MemRead_i
add wave -noupdate -group STALL /tb_rv32im_pipeline/CORE/ST/stall_o
add wave -noupdate -group STALL /tb_rv32im_pipeline/CORE/ST/PCwrite_o
add wave -noupdate -group STALL /tb_rv32im_pipeline/CORE/ST/IFID_write_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2270466 ps} 0} {{Cursor 2} {16698892 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 443
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
WaveRestoreZoom {1589085 ps} {2810916 ps}
