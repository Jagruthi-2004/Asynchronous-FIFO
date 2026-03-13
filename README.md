# Asynchronous-FIFO
Asynchronous FIFO design and verification using Verilog HDL | Dual clock domain with Gray code pointer synchronization | RTL simulation &amp; functional verification
Asynchronous FIFO — RTL Design & Verification
A complete RTL implementation of an Asynchronous FIFO (First-In First-Out) buffer supporting independent read and write clock domains, commonly used in digital systems for safe data transfer across clock domain crossings (CDC).
Tech Stack & Tools

Verilog HDL — RTL Design
ModelSim / iverilog — Functional Simulation
GTKWave — Waveform Visualization
Xilinx Vivado / Quartus — Synthesis (optional)

Design Specs

Independent Write Clock (wclk) and Read Clock (rclk)
Configurable data width and FIFO depth
Gray code based pointer synchronization to avoid metastability
Full (wfull) and Empty (rempty) flag generation
2-FF synchronizer for safe CDC

Architecture Overview
Write Domain          |       Read Domain
----------------------|-----------------------
wdata → Write Ptr     |   Read Ptr → rdata
wfull flag            |   rempty flag
Gray-coded wptr  ───► | ◄─── Gray-coded rptr
       (2-FF Sync)    |    (2-FF Sync)
Key Features
Clock Domains --> 2 (Independent Read & Write)
Pointer Encoding-->Gray Code
Metastability--> Handling 2-stage FF Synchronizer
Flags --> Full, Empty, Almost Full/Empty
Memory Type  --> Dual-port SRAM (register array)
