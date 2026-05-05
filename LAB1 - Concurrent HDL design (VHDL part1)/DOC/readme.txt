Project Overview:
In this lab, we gained practical experience in parallel hardware design using VHDL, focusing on a Bottom-Up design methodology. We began by implementing basic building blocks and progressively integrated them into larger functional units: the Adder/Subtractor, Shifter, and Logic modules. Finally, we integrated these units into a single Top-level entity. This hierarchical approach ensured that the ALUout and status flags (Z, N, C, V) are generated accurately for every operation.
The system module is:
INPUTS: 
*  input signal X.
*  input signal Y.
*  control signal ALUFN where ALUFN[4:3] choose the selected module (01 -> AdderSub, 10 -> Shifter, 11 -> Logic), and each module act differently with control of ALUFN[2:0].


OUTPUTS :
* System outputs will contained flags - Z,N,C,V that defines the result important informarion. 
Z is for zero vector result. 
N is for Negative result as defined by a negative signed numbers (MSB = 1). 
C is for carry result that may be caused from shifting or from adding/subtracting operation that cause for lost of information.
V flag meant for ADD/SUB operation when the result cannot happen. 
(example: positive+positive=negative)
Therefore we will use the V flag to define whenever the result cannot be trust.
* ALUout - The system output according to the module selected.




The VHD file:
LOGIC.VHD:
* Performs bitwise logic operations (AND, OR, XOR, etc.) between X and Y based on ALUFN[2:0].


SHIFTER.VHD:
* This module performs according to the ALUFN input a barrel-shifter based shift, where if ALUFN[2:0] = 000 then we will shift to the left and if ALUFN[2:0] = 001 we will shift to the right. 
We decided to implement the module by going through all k layers (where k=log_2⁡n) and for each layer we will perform a shift accordingly so that if the bit in the relevant layer in X is 0 we will not perform a shift and then the origin of the layer will be the same as the entry and otherwise we will perform a shift according to the layer.


AdderSub.VHD: 
* This module performs Math operation between the input vectors X and Y according opcode ALUFN[2:0]. It operates by using it’s sub-module FA (full-adder) to operate ADD/SUB/NEG/DOUBLE INC/DOUBLE DEC operations.
 Note that the ADDER/SUBTRACTER is performed by Y+X or Y + (Not (X)).
 DOUBLE INC/DOUBLE DEC performed on the input Y vector only by changing X vector value for ‘2’ value in decimal and then using the same adder/subtracter. 
 NEG operation is performed on the input X vector by using Y vector as zero vector and subtracting X vector.
 
FullAdder.VHD:
* This is the basic building block used by the AdderSub module. It receives X, Y and Cin bits and outputs the Sum and Cout bits.


AuxPackage.VHD:
* This file contains in the form of a package all the components that we would like to use throughout the laboratory.


Top.VHD:
* This module wraps the entire system and implements a structural design hierarchy. It receives the input vectors X, Y and the control signal ALUFN to manage the data flow between sub-modules. Based on the operation code ALUFN[4:3], the Top module selects which functional unit is active: "01" for Adder/Subtractor, "10" for Shifter, or "11" for Logic. The module is responsible for multiplexing the results from the various units into a single output vector, ALUout, and generating the status flags Z, N, C, and V based on the operation's outcome.
*  To achieve lower power consumption, the design includes logic gates at the inputs of the sub-modules. These gates ensure that signals make transitions only when the specific module is selected by ALUFN[4:3], preventing unnecessary switching activity.






Created by Yoav Tsur and Elad Lavi.