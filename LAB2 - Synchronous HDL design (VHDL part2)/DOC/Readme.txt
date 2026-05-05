Project Overview:
In this laboratory, we will design a synchronous digital system that detects valid sub-series for a given conditional value. We have designed the system top module by using Adder sub-module. The system’s primary goal is to identify sequences where the difference between two consecutive N-bit samples (x[j-1] - x[j-2]) remains constant and matches a specific value determined by the Detection code input. 
Input and Output Description:
* Data Inputs (x): The system samples the value of x (An n-bit wide vector representing the incoming data stream) at every rising edge of clk, provided that ena is high. These samples are stored in a two-stage pipeline to calculate the arithmetic difference.
* clk(clock): The system's primary timing signal. All operations are synchronized to the rising edge of this signal.
* rst (Reset): An active-high control signal. When asserted, it initializes the system by clearing the sampling registers and sequence counter, forcing the Detector output to 0.
* ena (enable): A control signal that governs system operation. If de-asserted ('0'), the system enters a "frozen" state where it ignores new samples and pauses the counter.
* DetectionCode: A selection input that defines the required arithmetic difference for detection. It maps values (0–3) to the expected differences (1–4) according to the project specifications.
* Detection Flag - OUTPUT: This logical signal is 1 only when the system identifies a valid sub-series that meets the difference criteria. It returns to 0 immediately if the sequence is broken or the system is reset.


The VHD file:
AuxPackage.VHD:
* This file contains in the form of a package all the components that we would like to use throughout the laboratory.
Adder.VHD:
* This module implements a generic ripple adder.
Top.VHD:
* This module wraps the entire system and implements a structural and behavioral design hierarchy. We were asked to separate the task into 3 processes:
1. Sampling Process: Responsible for sampling the input data stream x. It uses a two-stage pipeline to store the current and previous samples.
2. Logic & Calculation Process: This stage performs the arithmetic operation using a structural Ripple Carry Adder. It calculates the difference between the samples and compares it against the expected value. A valid signal is asserted if matches.
3. Counting & Detection Process: This process manages a synchronous counter. Only when the enable is '1' and the valid signal is asserted, the counter increments. If the valid signal drops or a reset occurs, the counter is cleared to 0. Once the counter reaches the threshold , the detector output is asserted to 1.


Created by Yoav Tsur and Elad Lavi.