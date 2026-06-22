LAB5 – RISC-V RV32IM Processor Implementation


Advanced CPU Architecture and Hardware Accelerators Lab – 361-1-4693
This project implements a fully functional RV32IM RISC-V processor on a Cyclone V FPGA board (DE10-Lite), in two separate implementations:


-Task 1 – Single-Cycle: Each instruction completes in exactly one clock cycle.
- Task 2 – Pipelined: A classic 5-stage pipeline (IF → ID → EX → MEM → WB) with full hazard detection and resolution.


Both implementations are verified against a RARS golden reference model across four benchmark test programs.


Created by **Yoav Tsur and Elad Lavi**.






Input and Output Description


CLOCK_50_iInput-50 MHz system master clock
KEY0_i-Input  Active-low push-button for synchronous reset (first press releases the CPU from power-up hold) 
SW_i[7:0]- Input -Switches for Signal-Tap trigger address (word address of breakpoint PC) 


clkcnt_o[15:0]` -Output -16-bit clock cycle counter (resets on KEY0, counts from start of execution) 
IFpc_o- Output -Program Counter at the Fetch (IF) stage 
IFinstruction_o- Output -Instruction word at the Fetch (IF) stage 
IDpc_o IDinstruction_o -Output - PC and instruction at the Decode (ID) stage 
EXpc_o EXinstruction_o- Output -PC and instruction at the Execute (EX) stage 
MEMpc_o MEMinstruction_o=Output -PC and instruction at the Memory (MEM) stage 
WBpc_o WBinstruction_o- Output- PC and instruction at the Write-Back (WB) stage 
STRIGGER_o-Output -Signal-Tap trigger: goes HIGH when IFpc[9:2] = SW[7:0] 
FHCNT_o[7:0]- Output - 8-bit flush event counter (counts pipeline flushes due to taken branches) 
STCNT_o[7:0] Output - 8-bit stall cycle counter (counts Load-Use hazard stall cycles) 






















Task 1 – Single-Cycle Implementation




All five datapath stages (Fetch, Decode, Execute, Memory, Write-Back) are completed within a single clock cycle. There are no pipeline registers between stages and no hazard handling is required.


VHD Files


cond_compilation_package.vhd
Defines all conditional compilation constants that control the memory configuration and simulation/synthesis mode:
-G_MODELSIM – Selects between ModelSim (1) and Quartus/FPGA (0) mode.
- G_WORD_GRANULARITY` – Selects word-addressed (True) or byte-addressed (False) memory.


const_package.vhd
Defines all instruction-level constants: opcode values, ALU operation codes, and RISC-V instruction format fields used throughout the datapath and control unit.


aux_package.vhd
A VHDL package declaring all component interfaces used across the project (IFETCH, IDECODE, EXECUTE, DMEMORY, etc.), enabling structural instantiation in the core top-level file.


IFETCH.VHD
Implements the Instruction Fetch stage. Contains the Instruction Tightly Coupled Memory (ITCM) instantiated as an Altera altsyncram ROM, pre-initialized from a .hex file. Computes PC+4 via a combinational adder and selects the next PC value using two multiplexers: one for branch/JAL targets and one for JALR targets. The PC register updates synchronously on the rising clock edge.


IDECODE.VHD
Implements the Instruction Decode stage. Contains the 32×32-bit Register File with two asynchronous read ports and one synchronous write port (clocked on the falling edge to enable same-cycle read-after-write). Performs sign-extension of immediate fields for all RISC-V instruction formats (I, S, B, U, J types).


CONTROL.VHD
Implements the combinational Control Unit. Decodes the 7-bit opcode and generates all control signals: RegWrite, MemWrite, MemRead, MemtoReg, ALUSrc, Branch, Jal, Jalr, UpperIm, ALUOp, MULop, and WBSrc. Supports all RV32IM instruction types (R, I, S, B, U, J) including the MUL instruction extension.


EXECUTE.VHD
Implements the Execute stage. Contains the main ALU that performs arithmetic (ADD, SUB, SLT, SLTU), logical (AND, OR, XOR), shift (SLL, SRL, SRA), and comparison operations based on the 5-bit ALUOp control signal. Also computes the branch/JAL target address by adding the sign-extended immediate to the PC. The branch condition (brTaken) is resolved combinationally here. Integrates the multiplier_16bit sub-module for MUL operations.


multiplier_16bit.vhd
Implements a combinational 16-bit×16-bit multiplier supporting the RV32M MUL instruction extension. Uses a two-stage decomposition: splits the 16-bit operands into 8-bit halves, computes four 16-bit partial products (P0–P3), sums the cross-terms (P1+P2), and accumulates all partial products with appropriate bit-shifts to produce a 32-bit result.


DMEMORY.VHD
Implements the Memory stage. Contains the Data Tightly Coupled Memory (DTCM) instantiated as an Altera altsyncram in single-port mode, pre-initialized from a .hex file. Supports synchronous write (on the inverted clock edge) and combinational read. Also selects between the ALU result and the multiplier result based on WBSrc.


RV32I_CORE.vhd
The structural top-level of the single-cycle processor. Instantiates and interconnects all five stage modules (IFETCH, IDECODE, CONTROL, EXECUTE, DMEMORY) using internal signals. Manages the PLL instantiation (active when G_MODELSIM=0) or direct clock bypass (when G_MODELSIM=1). Includes a free-running 16-bit clock counter that resets synchronously and counts cycles from reset release.


FPGA_Top_SingleCycle.vhd
The FPGA top-level wrapper for the single-cycle implementation. Directly maps physical board signals (CLOCK_50, SW0 for reset) to the RV32I_CORE ports. Exposes all internal signals as outputs for Signal-Tap probing and hardware verification.


PLL.vhd
An Altera altpll megafunction-generated component. Takes the 50 MHz board oscillator and divides it to produce a stable lower-frequency internal clock for the processor core. Active only when G_MODELSIM=0 (FPGA synthesis mode).


































 Task 2 – Pipelined Implementation


A classic 5-stage in-order pipeline: IF → ID → EX → MEM → WB. Pipeline registers separate each stage. The design includes:
- Load-Use Hazard Detection – inserts one stall cycle (bubble into ID/EX register).
- Control Hazard Resolution – flushes the three instructions after a taken branch (resolved in MEM stage).
- Data Forwarding – forwards EX→EX and MEM→EX paths to eliminate most RAW hazards without stalling.
- Power-Up Reset Latch – holds the CPU in reset until KEY0 is pressed at least once after FPGA configuration.




cond_compilation_package_pipeline.vhd
Same role as in the single-cycle design but for the pipelined version. Key parameters:
- G_MODELSIM – 0 for FPGA synthesis (enables PLL), 1 for ModelSim simulation (bypasses PLL).
- G_ADDRWIDTH / `G_DATA_WORDSNUM` – Must match the depth of the .hex 


const_package_pipeline.vhd
Defines all RISC-V opcode and ALU operation code constants for use throughout the pipeline stages.


aux_package_pipeline.vhd
Declares all pipelined component interfaces for structural instantiation in the core.


IFETCH_pipeline.vhd
Implements the Instruction Fetch (IF) pipeline stage. Contains the ITCM (altsyncram ROM) pre-initialized from a .hex file. Computes PC+4 combinationally and selects the next PC through two multiplexers controlled by Branch_or_jal and Jalr_ctrl. The PC register updates synchronously with stall support via the PCwrite_i enable signal.


IDECODE_pipeline.vhd
Implements the Instruction Decode (ID) pipeline stage. Contains the 32×32-bit Register File with asynchronous reads and a synchronous write port (falling-edge clocked). Performs sign-extension of all immediate formats. Outputs register values and sign-extended immediate to the ID/EX pipeline register.


CONTROL_pipeline.vhd
Implements the combinational Control Unit for the pipeline. Decodes opcode and funct3/funct7 fields to generate all pipeline control signals. When a stall is inserted, control signals are zeroed (NOP bubble).


EXECUTE_pipeline.vhd
Implements the Execute (EX) pipeline stage. Contains the main ALU performing all RV32IM arithmetic, logical, shift, and comparison operations. Selects ALU operands through forwarding multiplexers. Computes the branch/JAL target address. Instantiates the 16-bit multiplier sub-module for MUL support.
DMEMORY_pipeline.vhd
Implements the Memory (MEM) pipeline stage. Contains the DTCM (altsyncram single-port) pre-initialized from a .hex file, with synchronous write and asynchronous read. Generates the Flush_o signal when a taken branch is detected, triggering a 3-cycle flush of the IF/ID/EX pipeline registers.


WriteBack_pipeline.vhd
Implements the Write-Back (WB) pipeline stage. Selects between the DTCM read data and the ALU/multiplier result using multiplexers controlled by MemtoReg and WBSrc. Outputs the final write-back data to the register file.


Forwarding_unit.vhd
Implements the Data Forwarding Unit. Compares the source register addresses (rs1, rs2) of the EX-stage instruction with the destination register addresses (rd) of the MEM-stage and WB-stage instructions. Generates 2-bit forwarding select signals (ForwardA, ForwardB) to route the correct data to the ALU inputs, eliminating most RAW data hazards without stalling.


Stall_cond_unit.vhd
Implements the Hazard Detection / Stall Condition Unit. Detects Load-Use hazards: when the EX-stage instruction is a load (MemRead=1) and its destination register matches a source register of the immediately following ID-stage instruction. When detected, de-asserts PCwrite and IFID_write (freezing IF and ID stages) and inserts a NOP bubble into EX for one cycle.


RV32I_CORE_pipeline.vhd
The structural top-level of the pipelined processor. Instantiates and interconnects all five pipeline stage modules and the two hazard-handling units. Contains all five inter-stage pipeline registers as synchronous processes with synchronous reset. Includes three free-running counters:
- `mclk_cnt_q` – Total clock cycle counter.
- `stl_cnt_q` – Stall cycle counter (increments when stall=1).
- `fhl_cnt_q` – Flush cycle counter (increments when MEM_flush=1).


Also generates STRIGGER_w: goes HIGH when IFpc[9:2] = SW[7:0], used as the Signal-Tap hardware trigger for breakpoint-based verification.


FPGA_Top_pipeline.vhd
The FPGA top-level wrapper for the pipelined implementation. Key features:
- **Power-Up Reset Latch:** A flip-flop that initializes to '0' and latches to '1' upon the first press of KEY0, preventing the CPU from executing on uninitialized memories immediately after FPGA configuration.
- Routes SW_i[7:0] to BPADDR_i for Signal-Tap trigger address selection.




PLL_pipeline.vhd
An Altera altpll megafunction-generated component. Uses a ×1/÷2 configuration to produce a stable 25 MHz internal clock from the 50 MHz board oscillator. Active only when G_MODELSIM=0.