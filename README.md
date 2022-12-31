A repository for recording VSD-HDP program as below program link.

Program: [SKY130-based ASIC Design Projects](https://www.vlsisystemdesign.com/hdp/)

- watz0n (Watson Huang), wats0n.edx@gmail.com

------

# VSD-HDP Progress Status

------

Quick-Link:<br />
[Day0](#Day0)<br />
[Day1](#Day1)<br />
[Day2](#Day2)<br />
[Day3](#Day3)<br />
[Day4](#Day4)<br />
[Day5](#Day5)<br />
[Day6](#Day6)<br />
[Day7](#Day7)<br />
[Day8](#Day8)<br />
[Day9](#Day9)<br />
[Day10](#Day10)<br />
[Day11](#Day11)<br />
[Day12](#Day12)<br />

------

## Day0

Build Environment: Windows-11 + Ubuntu-20.04(WSL2)
Note: Update OS to Win11 for systemd feature in WSL2

### Tool: Yosys

Installation Guide:
> https://yosyshq.readthedocs.io/projects/sby/en/latest/install.html#yosys-yosys-smtbmc-and-abc

Installed Dependency:
```
$ sudo apt-get install build-essential clang bison flex libreadline-dev \
                       gawk tcl-dev libffi-dev git mercurial graphviz   \
                       xdot pkg-config python python3 libftdi-dev gperf \
                       libboost-program-options-dev autoconf libgmp-dev \
                       cmake curl
```
Installation Flow:
```
$ git clone https://github.com/YosysHQ/yosys
$ cd yosys
$ make -j4
$ sudo make install
```

Progress Images:

![d0t1i1](images/day0-tool1-yosys1.png)<br />
![d0t1i2](images/day0-tool1-yosys2.png)<br />
![d0t1i3](images/day0-tool1-yosys3.png)<br />

### Tool: OpenSTA

Installation Guide:
> https://github.com/The-OpenROAD-Project/OpenSTA#installing-with-cmake

Additional Dependency:
```
$ sudo apt-get install swig
```
Installation Flow:
```
$ git clone https://github.com/The-OpenROAD-Project/OpenSTA.git
$ cd OpenSTA
$ mkdir build
$ cd build
$ cmake ..
$ make
$ sudo make install
```

Progress Images:

![d0t2i1](images/day0-tool2-opensta1.png)<br />
![d0t2i2](images/day0-tool2-opensta2.png)<br />
![d0t2i3](images/day0-tool2-opensta3.png)<br />
![d0t2i4](images/day0-tool2-opensta4.png)<br />

### Tool: ngspice

Installation Source:
> https://sourceforge.net/projects/ngspice/files/ng-spice-rework/38/
Download File:
> ngspice-38.tar.gz

Additional Dependency:
```
$ sudo apt install libxaw7-dev
```

Installation Guide:
> https://github.com/ngspice/ngspice/blob/master/INSTALL
Chapter:
> 1.2 Install from tarball (e.g. ngspice-26.tar.gz)

Installation Flow:
```
$ tar -zxvf ngspice-38.tar.gz
$ cd ngspice-38
$ mkdir release
$ cd release
$ ../configure  --with-x --with-readline=yes --disable-debug
$ make
$ sudo make install
```

Progress Images:

![d0t3i1](images/day0-tool3-ngspice1.png)<br />
![d0t3i2](images/day0-tool3-ngspice2.png)<br />
![d0t3i3](images/day0-tool3-ngspice3.png)<br />

------

## Day1

Goals:
1. Install Verilog Simulation Tools (iverilog, gtkwave)
2. Perform Synthesis Lab by Yosys

Lecture-Notes:
* Multiple Cell Driving Strength for timing issue adjustion (hold-time)
* PVT - Process, Voltage Temperature
    * Process : Fabrication Variation
    * Voltage : Operation Speed and Leakage Current
    * Temperature : Semiconductor is sensitive to environment condition
* `.lib` file
    * technology("cmos")
    * operating_conditions
    * cell("..."), area field
    * `.pp` : power-port abbreviation

### Tool: iverilog

Installation Source:
> https://github.com/steveicarus/iverilog/releases/tag/v11_0
Download File:
> iverilog-11_0.tar.gz

Installation Guide:
>https://github.com/steveicarus/iverilog#compilation

Installation Flow:
```
$ tar zxvf iverilog-11_0.tar.gz
$ cd iverilog-11_08
$ sh autoconf.sh
$ ./configure
$ make
$ sudo make install
```

Progress Images:

![d1t4i1](images/day1-tool4-iverilog1.png)<br />
![d1t4i2](images/day1-tool4-iverilog2.png)<br />
![d1t4i3](images/day1-tool4-iverilog3.png)<br />

### Tool: gtkwave

Apply Ubuntu-20.04 official gtkwave builds

Installation Flow:
```
$ sudo apt install libcanberra-gtk-module libcanberra-gtk3-module gtkwave
```

Progress Images:

![d1t5i1](images/day1-tool5-gtkwave1.png)<br />


### Day1-Lab1: Logic Cell Simulation

Work-Flow:
```
$ cd verilog_files
$ iverilog good_mux.v tb_good_mux.v
$ ./a.out
$ gtkwave tb_good_mux.vcd
```

Progress Images:

![d1l1p1](images/day1-lab1-p1.png)<br />

### Day1-Lab2: Logic Cell Synthesis

Work-Flow:
```
$ yosys
> read_liberty -lib ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> read_verilog good_mux.v
> synth -top good_mux
> abc -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
//--- Dot-Viewer
> show
//---
> write_verilog -noattr good_mux_netlist.v
//--- Shell Command
>!gvim good_mux_netlist.v
//---
```

Progress Images:

![d1l2p1](images/day1-lab2-p1.png)<br />
![d1l2p2](images/day1-lab2-p2.png)<br />
![d1l2p3](images/day1-lab2-p3.png)<br />

------

## Day2

Goals:
1. Logic-Cell Synthesis Lab
2. Data Flip-Flop Synthesis Lab
3. Observe Yosys logic optimization

Lecture-Notes:
* NAND is stack NMOS, should be faster than NOR which is stack PMOS.
* Combinational Circuit would produce glitches, need Data Flip-Flop (DFF) to latch stable output states.
* Initial DFF value: Reset(0)/Set(1)+Sync/Async
* Interesting Optimisations: reduce multiply operation to shift-bits operation.

### Day2-Lab1: Module Hierarchy/Flatten Synthsis

Work-Flow:
```
$ yosys
> read_liberty -lib ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> read_verilog multiple_modules.v
> synth -top multiple_modules
> abc -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> show multiple_modules
> write_verilog -noattr multiple_modules_hier.v
> flatten
> write_verilog -noattr multiple_modules_flat.v
```

Progress Images:

![d2l1p1](images/day2-lab1-p1.png)<br />
![d2l1p2](images/day2-lab1-p2.png)<br />

### Day2-Lab2: Flip-Flop (Sequential Logic) Simulation

Work-Flow:
```
$ iverilog dff_asyncres.v tb_dff_asyncres.v
$ ./a.out
$ gtkwave tb_dff_asyncres.vcd
$ iverilog dff_async_set.v tb_dff_async_set.v
$ ./a.out
$ gtkwave tb_dff_async_set.vcd
$ iverilog dff_syncres.v tb_dff_syncres.v
$ ./a.out
$ gtkwave tb_dff_syncres.vcd
```

Progress Images:

![d2l2p1](images/day2-lab2-p1.png)<br />
![d2l2p2](images/day2-lab2-p2.png)<br />
![d2l2p3](images/day2-lab2-p3.png)<br />

### Day2-Lab3: Flip-Flop (Sequential Logic) Synthesis

Work-Flow:
```
$ yosys
> read_liberty -lib ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> read_verilog dff_asyncres.v
> synth -top dff_asyncres
> dfflibmap -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> abc -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> show
> read_verilog dff_async_set.v
> synth -top dff_async_set
> dfflibmap -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> abc -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> show
> read_verilog dff_syncres.v
> synth -top dff_syncres
> dfflibmap -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> abc -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> show
```

Progress Images:

![d2l3p1](images/day2-lab3-p1.png)<br />
![d2l3p2](images/day2-lab3-p2.png)<br />
![d2l3p3](images/day2-lab3-p3.png)<br />

### Day2-Lab4: Interesting Optimization

Work-Flow:
```
$ yosys
> read_liberty -lib ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> read_verilog mult_2.v
> synth -top mul2
> abc -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> write_verilog -noattr mult2_net.v
> show
> read_verilog mult_8.v
> synth -top mult8
> abc -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> write_verilog -noattr mult8_net.v
> show
```

Progress Images:

![d2l4p1](images/day2-lab4-p1.png)<br />
![d2l4p2](images/day2-lab4-p2.png)<br />

------

## Day3

Goals:
1. Combinational Logic Synthesis Optimization
2. Sequential Logic Synthesis Optimization

Lecture-Notes:
* Optimization for reducing Area and Power
    * Constant Propagation
        * Sequential Logic need to consider reset/set if identical to D-pin behavior
    * Boolean Logic Optimization
        * K-MAP, Quine-McCluskey
* State Optimization
    * Cloning, Physical Aware for Placement Graph Optimization
    * Retiming, make combinational logic delay is nearly equality in multi-phase pipe-line
* Unused output optimization, remove no output dependency resources

### Day3-Lab1: Combinational Logic Optimization - Synthesis

Work-Flow:
```
$ cd verilog_files
$ yosys
> read_liberty -lib ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> read_verilog opt_check.v
> synth -top opt_check
> opt_clean -purge
> abc -liberty  ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> show
> read_verilog opt_check2.v
> synth -top opt_check2
> opt_clean -purge
> abc -liberty  ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> show
> read_verilog opt_check3.v
> synth -top opt_check3
> opt_clean -purge
> abc -liberty  ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> show
//--- Multiple Modules, need flatten
> read_verilog opt_check4.v
> synth -top opt_check4
> flatten
> opt_clean -purge
> abc -liberty  ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> show
```

Progress Images:

![d3l1p1](images/day3-lab1-p1.png)<br />
![d3l1p2](images/day3-lab1-p2.png)<br />
![d3l1p3](images/day3-lab1-p3.png)<br />
![d3l1p4](images/day3-lab1-p4.png)<br />
![d3l1p5](images/day3-lab1-p5.png)<br />
![d3l1p6](images/day3-lab1-p6.png)<br />

### Day3-Lab2: Sequential Logic Optimization - Simulation

Work-Flow:
```
$ iverilog dff_const1.v tb_dff_const1.v
$ ./a.out
$ gtkwave tb_dff_const1.vcd
$ iverilog dff_const2.v tb_dff_const2.v
$ ./a.out
$ gtkwave tb_dff_const2.vcd
```

Progress Images:

![d3l2p1](images/day3-lab2-p1.png)<br />
![d3l2p2](images/day3-lab2-p2.png)<br />

### Day3-Lab3: Sequential Logic Optimization - Synthesis

Work-Flow:
```
$ yosys
> read_liberty -lib ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> read_verilog dff_const1.v
> synth -top dff_const1
> dfflibmap -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> abc -liberty  ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> show
> read_verilog dff_const2.v
> synth -top dff_const2
> abc -liberty  ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> show
```

Progress Images:

![d3l3p1](images/day3-lab3-p1.png)<br />
![d3l3p2](images/day3-lab3-p2.png)<br />
![d3l3p3](images/day3-lab3-p3.png)<br />
![d3l3p4](images/day3-lab3-p4.png)<br />

### Day3-Lab4: Stack Flip-Flop - Simulation

Work-Flow:
```
$ iverilog dff_const3.v tb_dff_const3.v
$ ./a.out
$ gtkwave tb_dff_const3.vcd
$ iverilog dff_const4.v tb_dff_const4.v
$ ./a.out
$ gtkwave tb_dff_const4.vcd
$ iverilog dff_const5.v tb_dff_const5.v
$ ./a.out
$ gtkwave tb_dff_const5.vcd
```

Progress Images:

![d3l4p1](images/day3-lab4-p1.png)<br />
![d3l4p2](images/day3-lab4-p2.png)<br />
![d3l4p3](images/day3-lab4-p3.png)<br />

### Day3-Lab5: Stack Flip-Flop - Synthesis

Work-Flow:
```
$ yosys
> read_liberty -lib ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> read_verilog dff_const3.v
> synth -top dff_const3
> dfflibmap -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> abc -liberty  ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> show
> read_verilog dff_const4.v
> synth -top dff_const4
> dfflibmap -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> abc -liberty  ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> show
> read_verilog dff_const5.v
> synth -top dff_const5
> dfflibmap -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> abc -liberty  ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> show
```

Progress Images:

![d3l5p1](images/day3-lab5-p1.png)<br />
![d3l5p2](images/day3-lab5-p2.png)<br />
![d3l5p3](images/day3-lab5-p3.png)<br />

### Day3-Lab6: Unused Output - Synthesis

Work-Flow:
```
$ yosys
> read_liberty -lib ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> read_verilog counter_opt.v
> synth -top counter_opt
> dfflibmap -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> abc -liberty  ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> show
> read_verilog counter_opt2.v
> synth -top counter_opt2
> dfflibmap -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> abc -liberty  ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> show
```

Progress Images:

![d3l61](images/day3-lab6-p1.png)<br />
![d3l62](images/day3-lab6-p2.png)<br />
![d3l63](images/day3-lab6-p3.png)<br />
![d3l64](images/day3-lab6-p4.png)<br />
![d3l65](images/day3-lab6-p5.png)<br />

------

## Day4

Goals:
1. Gate-Level Simulation Flow
2. Behavior (RTL) v.s. Synthesis (Gate) simulate result mismatch issue

Lecture-Notes:
* Ensuring the timing requirement is met for Gate-Level Models with delay-annotated.
* Behavior (RTL) v.s. Synthesis (Gate) Simulation Mismatch
    1. Missing sensitivity list
        * always@(sensitivity-list), usually apply always(*), (*) means evaluate all chagnes in statements
    2. Blocking v.s. Non-Blocking Assignment
    3. Non-Standard (non-synthsizable) Verilog coding
* Blocking v.s. Non-Blocking
    * Blocking evaluate statements in order sequence, may incur latch to hold previous evaluated result
    * Non-Blocking evaluate statements in the same time, if LHS has multiple evaluations, use last/bottom one
* Use Non-Blocking for sequential circuit coding is perform better synthesis quality

### Day4-Lab1: Gate-Level Simulation (GLS)

Work-Flow:
```
$ iverilog ternary_operator_mux.v tb_ternary_operator_mux.v
$ ./a.out
$ gtkwave tb_ternary_operator_mux.vcd
$ yosys
> read_liberty -lib ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> read_verilog ternary_operator_mux.v
> synth -top ternary_operator_mux
> abc -liberty  ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> write_verilog -noattr ternary_operator_mux_net.v
> show

$ iverilog ../my_lib/verilog_model/primitives.v ../my_lib/verilog_model/sky130_fd_sc_hd.v ternary_operator_mux_net.v tb_ternary_operator_mux.v
$ ./a.out
$ gtkwave tb_ternary_operator_mux.vcd

```

Progress Images:

![d4l1p1](images/day4-lab1-p1.png)<br />
![d4l1p2](images/day4-lab1-p2.png)<br />
![d4l1p3](images/day4-lab1-p3.png)<br />

### Day4-Lab2: Bad MUX Synthsis-Behavior Mismatch

Work-Flow:
```
$ iverilog bad_mux.v tb_bad_mux.v
$ ./a.out
$ gtkwave tb_bad_mux.vcd
$ yosys
> read_liberty -lib ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> read_verilog bad_mux.v
> synth -top bad_mux
> abc -liberty  ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> write_verilog -noattr bad_mux_net.v
> show

$ iverilog ../my_lib/verilog_model/primitives.v ../my_lib/verilog_model/sky130_fd_sc_hd.v bad_mux_net.v tb_bad_mux.v
$ ./a.out
$ gtkwave tb_bad_mux.vcd
```

Progress Images:

![d4l2p1](images/day4-lab2-p1.png)<br />
![d4l2p2](images/day4-lab2-p2.png)<br />
![d4l2p3](images/day4-lab2-p3.png)<br />

### Day4-Lab3: Synthsis-Behavior Simulation Mismatch for Blocking Statement

Work-Flow:
```
$ iverilog blocking_caveat.v tb_blocking_caveat.v
$ ./a.out
$ gtkwave tb_blocking_mux.vcd
$ yosys
> read_liberty -lib ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> read_verilog blocking_caveat.v
> synth -top blocking_caveat
> abc -liberty  ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> write_verilog -noattr blocking_caveat_net.v
> show

$ iverilog ../my_lib/verilog_model/primitives.v ../my_lib/verilog_model/sky130_fd_sc_hd.v blocking_caveat_net.v tb_blocking_caveat.v
$ ./a.out
$ gtkwave tb_blocking_mux.vcd
//--- test expect behavior simulation
$ iverilog blocking_caveat_exp.v tb_blocking_caveat.v
$ ./a.out
$ gtkwave tb_blocking_mux.vcd
```

Progress Images:

![d4l3p1](images/day4-lab3-p1.png)<br />
![d4l3p2](images/day4-lab3-p2.png)<br />
![d4l3p3](images/day4-lab3-p3.png)<br />

Test Expect-Behavior RTL simulation:

![d4l3p4](images/day4-lab3-p4.png)<br />
![d4l3p5](images/day4-lab3-p5.png)<br />

------

## Day5

Goals:
1. If-Else/Case Statement Usage and Malfunctional Style
2. For-Loop/For-Generate Usage

Lecture-Notes:
* If-Else Statement
    1. priority logic, may lead to long stack multiplexers
    2. Incomplete If-Else statement would produce `inferred latches`
```
if(cnd1)
    y=a;
else if(cnd2)
    y=b;
```
![d5lcp1](images/day5-lec-p1.png)<br />

* Case Statement
    1. balanced multiplexer to reduce gate delay
    2. Imcomplete case statements would produce `inferred latches`
        * without default keyword and conditions not complete
        * LHS under each conditions are not identical
    3. Malfunction from overlapping case conditions
        * be careful with `?` (any-value) in conditions
        * overlapping means multiple conditions are evaluated at same time

* For-Loop
    * evaluating expressions for wide MUX/deMUX
```
//--- 2:1 MUX by case

output y;
input i0,i1;

always@(*) begin
    case(sel)
        1'b0: y=i0;
        i'b1: y=i1;
    endcase
end

//--- 32:1 MUX by For-Loop

output       y;
input [31:0] inp;

integer i;
always@(*) begin
    for(i=0; i<32; i=i+1) begin
        if(i==sel)
            y=inp[i];
    end
end

//--- 1:8 deMUX by For-Loop

output [7:0] out;
input        inp;

integer i;
always@(*) begin
    out[7:0] = 8'h0;
    for(i=0; i<8; i=i+1) begin
        if(i==sel)
            out=inp;
    end
end

```
    
* For-Generate
    * instantiating multiple same source modules

```
output [7:0] y;
input  [7:0] in1, in2;

genvar i;
generate
    for(i=0; i<8; i=i+1) begin
        and u_and(.a(in1[i]), .b(in2[i]), .c(y[i]))
    end
endgenerate

```

### Day5-Lab1: Imcomplete If-Else Statements

Work-Flow:
```
$ iverilog incomp_if.v tb_incomp_if.v
$ ./a.out
$ gtkwave tb_incomp_if.vcd
$ yosys
> read_liberty -lib ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> read_verilog incomp_if.v
> synth -top incomp_if
> abc -liberty  ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> show

$ iverilog incomp_if2.v tb_incomp_if2.v
$ ./a.out
$ gtkwave tb_incomp_if2.vcd
$ yosys
> read_liberty -lib ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> read_verilog incomp_if2.v
> synth -top incomp_if2
> abc -liberty  ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> show
```

Progress Images:

![d5l1p1](images/day5-lab1-p1.png)<br />
![d5l1p2](images/day5-lab1-p2.png)<br />
![d5l1p3](images/day5-lab1-p3.png)<br />
![d5l1p4](images/day5-lab1-p4.png)<br />

### Day5-Lab2: Incomplete Case Statements

Work-Flow:
```
$ iverilog incomp_case.v tb_incomp_case.v
$ ./a.out
$ gtkwave tb_incomp_case.vcd
$ yosys
> read_liberty -lib ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> read_verilog incomp_case.v
> synth -top incomp_case
> abc -liberty  ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> show

$ iverilog comp_case.v tb_comp_case.v
$ ./a.out
$ gtkwave tb_comp_case.vcd
$ yosys
> read_liberty -lib ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> read_verilog comp_case.v
> synth -top comp_case
> abc -liberty  ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> show

$ yosys
> read_liberty -lib ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> read_verilog partial_case_assign.v
> synth -top partial_case_assign
> abc -liberty  ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> show

$ iverilog bad_case.v tb_bad_case.v
$ ./a.out
$ gtkwave tb_bad_case.vcd
$ yosys
> read_liberty -lib ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> read_verilog bad_case.v
> synth -top bad_case
> abc -liberty  ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
> write_verilog -noattr bad_case_net.v
$ iverilog ../my_lib/verilog_model/primitives.v ../my_lib/verilog_model/sky130_fd_sc_hd.v bad_case_net.v tb_bad_case.v
$ ./a.out
$ gtkwave tb_bad_case.vcd

```

Progress Images:

![d5l2p1](images/day5-lab2-p1.png)<br />
![d5l2p2](images/day5-lab2-p2.png)<br />
![d5l2p3](images/day5-lab2-p3.png)<br />
![d5l2p4](images/day5-lab2-p4.png)<br />
![d5l2p5](images/day5-lab2-p5.png)<br />
![d5l2p6](images/day5-lab2-p6.png)<br />
![d5l2p7](images/day5-lab2-p7.png)<br />
![d5l2p8](images/day5-lab2-p8.png)<br />

### Day5-Lab3: For Loop and For Generate

Work-Flow:
```
$ iverilog mux_generate.v tb_mux_generate.v
$ ./a.out
$ gtkwave tb_mux_generate.vcd

$ iverilog demux_case.v tb_demux_case.v
$ ./a.out
$ gtkwave tb_demux_case.vcd
$ iverilog demux_generate.v tb_demux_generate.v
$ ./a.out
$ gtkwave tb_demux_generate.vcd

$ iverilog fa.v rca.v tb_rca.v
$ ./a.out
$ gtkwave tb_rca.vcd

```

Progress Images:

![d5l3p1](images/day5-lab3-p1.png)<br />
![d5l3p2](images/day5-lab3-p2.png)<br />
![d5l3p3](images/day5-lab3-p3.png)<br />

------

## Day6

Topic: Design Preparation 

Goals:
    1. Synthesizable RTL and Testbench Ready
    2. Behavior and Synthesis Simlation Consistancy

Status: In-progress, development-stage brief: [project.md](project.md)

To-Be-Done: Update summary result in here while finalized process

------

## Day7

Topic: Basic SDC constraints

Goals:
1. Logic Synthesis Flow by Design-Compiler from Synopsys
2. Basic Logic Synthesis knowledge introduction

Lecture-Note:

    * Logic Synthesis
        1. RTL+.LIB->Netlist(Gates)
        2. .LIB is collection of logic modules from same function but different strengeh/timing variation
            * Need Cells that work fast enough to meet required performance (setup-time)
            * Need Cells that work slow enough to avoid contamination (hold-time)
    * Design Compiler
        1. SDC, synopsys design constraints, industry standard constraint for EDA automation
        2. .LIB, design library which contains the standard cell information
        3. .DB, same as .LIB for DC import related libraries
        4. .DDC, Synopsys's proprietary format for libraries
        5. SDC for timing-constraint, UPF for power-constraint
    * Design(RTL) + Library (.DB) + SDC -> Verilog Netlist + DDC + Synthesis Reports
    * Implementation Flow for ASIC
        `[RTL]->[SYN]->[DFT]->[FP]->[CTS]->[PnR]->[GDS]`
    * DC Synthesis Flow:
        1. Read STD Cell/Tech .lib
        2. Read Design (Verilog/VHDL, Design .LIB)
        3. Read Design Constraints (SDC)
        4. Link the Design
        5. Synthesize the Design
        6. Generate Report and Analyze QoR
    * Library Name : `sky130_fd_sc_hd_tt_025C_1v80.lib`
        * fd -> fundary, sc -> standard cell, hd->high-density, tt->typical-typical, 025C-> 25 degree temperature, 1v80->1.8V
    * PVT -> Power/Voltage/Temerature
        * PVT corner -> typical/fast/slow
    * DC Operation Flow
```
    $dc_shell
    >read_verilog lab1.v
    >read_db sky130.db
    >set link_library {* sky130.db}
    >link
    >compile
    >write -f verilog -out lib1_net_sky130.v
    >write -f ddc -out lib1.ddc
```
    * Design Visison
```
    $design_vision
    >start gui
    //---
    >read_ddc lab1.ddc
    //--- Use GTECH (gech.db) /standard.sldb
    >read_verlog lib1_net_sky130.v
```
    * Start-up Script to set environment
        * File-Name: `.synopsys_dc.setup`, put in home directory

    * TCL Quick Reference
```
    * set a [ expr $a + $b ]
    * if { cond } { true-stat } else { false-stat }
    * echo "hello world"
    * while { cond } { loop-stat }
    * for { init } {  cond } { end-op } { loop-stat }
    * foreach <var-name> <list-name> { statements }
    //DC only
    * foreach <var-name> <collection-name> { statements }
    * get_lib_cells */*and* > get collection
    * source script.tcl
```

    * STA
        * Max (Setup) and Min (Hold) delay constraints
        * Delay for Cells:
            1. Input Transition (Driving Slew-Rate)
            2. Output Load (Capcitance)
        * Timing Arc
            * Combinational Cell: input port to output port changes elasped time
            * Sequential Cell:
                1. Clock to Q -> DFF
                2. Clock to D + D to Q -> D-Latch (DLAT)

![lds01](images/lec-dc-sta01.png)<br />
        
        * Timing-Path:
            * Start Point : 1. Input-Port 2. Clock Pin of Register
            * End Point : 1. Output-Port 2. D Pin of Register
![lds02](images/lec-dc-sta02.png)<br />          
        
        * Timing-Path Constraint:
            * REG2REG: Clock Constraint
            * REG2OUT: Output External Delay + Clock Constraint
            * IN2REG: Input External Delay + Clock Constraint

![lds03](images/lec-dc-sta03.png)<br />

        * IO Constraint:
            * Delay isn't ideal as zero -> Consider input transition and output load
            * Rule of Thumb: 70% Eternal Delay, 30% Internal Delay from Clock constraint
        
        * .LIB Timing:
            * `default_+max_transition` in ps
            * C_load = C_pin+C_net+SUM(C_input_cap) -> max capcitance limit
            * Add buffer to balance high fanout driving strength
        
        * Delay Model Table
            * X-Axis: Output Load (pf)
            * Y-Axis: Input Transition (ns)
        
        * Unateness -> If only 1-pin changes, if output pin has same behavior
            * Positive: AND, OR
            * Negative: NOT, NAND, NOR
            * Non: XOR, DFF


------

## Day8

Topic: Advanced SDC contraints

Goals:
1. Clock/Input/Output Constraint Details
2. Useful DC commands

Lecture-Note:
    
    * Constraint for Clock
        * Before CTS, clock is an ideal network for Synthesis stage
        * Post-CTS generate real clock
    * Clock Generation
        1. Oscillator
        2. PLL
        3. External Clock Source
    * Real Clock : Ideal Clock + Jitter + Skew
        * Jitter : physical world stochastic behavior
        * Skew : Routing topographical delay
    * Clock Modeling
        1. Period
        2. Source Latency
        3. Clock Network Latency
        4. Clock Skew
        5. Jitter
    * Clock Skew+Jitter => Clock Uncertainty

    * Define `net` : connecting of two or more pins or ports in target design region

![lds04](images/lec-dc-sta04.png)<br />  

    * DC-Shell Operations
```
    > get_ports *clk*;
    > get_ports * -filter "direction == in";
    > get_ports * -filter "direction == out";
    > get_clocks * -filter "period > 10";
    > get_attribute [ get_clocks my_clk ] period ;
    > get_attribute [ get_clocks my_clk ] is_generated ;
    > report_clocks my_clk ;
```
    * Hierarchical/Physical Cell/PIn
```
    > get_cells * -hier
    > get_attribute [ get_cells <cell-name> ] is_hierarchical
```
    * Clock Constraint
        * Uncertainty in different stage
            * Jitter+Skew for CTS
            * Jitter only for PnR
```
    > create_clock -name <clk-name> -period <time> [get_ports <clk-port>] ;
    > set_clock_latency <time> <clk-name>
    > create_clock -name <clk-name> -period <time> [get_ports <clk-port>] -wave { <rise-time-point> <fall-time-point> } ;
```
    * Input IO Modeling
```
    > set_input_delay -max <time> -clock [get_clocks <clk-name>] [get_ports <port-name>] ;
    > set_input_delay -min <time> -clock [get_clocks <clk-name>] [get_ports <port-name>] ;
    > set_input_transition -max <unit> [get_ports <port-name>]
    > set_input_transition -min <unit> [get_ports <port-name>]
```
    * Output IO Modeling
```
    > set_output_delay -max <time> -clock [get_clocks <clk_name>] [get_ports <port-name>]
    > set_output_delay -min <time> -clock [get_clocks <clk_name>] [get_ports <port-name>]
    > set_output_load -max <cap_unit> [get_ports <port-name>]
    > set_output_load -min <cap_unit> [get_ports <port-name>]
```
![lds05](images/lec-dc-sta05.png)<br />  

    * DC-Shell Lab
``` 
    > get_cells/get_ports/get_nets/get_clocks/get_pins
    > all_connected <net-name>
    > regex <pattern> <expression> # return 1 when pattern match expression, otherwise 0
    > get_attribnute [get_pins <pin-name>] clock # report if this is clock pin
    > get_attribnute [get_pins <pin-name>] clocks # report clocks reach to this pin
    > current_design # report name of top module
    > report_clocks *
    > remove_clock <clk_name>
```
    * Clock Network Modeling
```
    > set_clock_latency -source <time> [get_clocks <clk_name>] # source latency (clock source)
    > set_clock_latency <time> [get_clocks <clk_name>] # network latency (to top module)
    > set_clock_uncertainty -setup <time> [get_clocks <clk_name>]
    > set_clock_uncertainty -hold <time> [get_clocks <clk_name>]
    > report_timing
    > report_timing -to <pin-name>
    > report_timing -to <pin-name> -delay min
    > report_timing -from <pin-name>
    > report_timing -verbose
    > report_port -verbose
    > report_timing -from <pin-name> -trans -net -cap -nosplit
    > report_timing -from <pin-name> -trans -net -cap -nosplit -delay_type min # Hold time
    > set_input_transition -max <amount> [get_ports <port-name>]
    > set_input_transition -min <amount> [get_ports <port-name>]
        # add input transition, input pin data arrival time is increased
    > set_load -max <amount> [get_ports <port-name>]
    > set_load -min <amount> [get_ports <port-name>]
        # add output load, output pin data arrival time is increased
```
    * Generated Clock
        * Handle clock physically variation like long-delay from input to output port.
```
    > create_generated_clock -name <gen-clk-name> -master [get_clocks <base-clk>] -source [get_port <src-port>] -div 1 [get_ports <dst-port>]
    > reset_design # restart a new design
    > get_generated_clocks
```
    * Constraint for pure combinational path from input to output port
        1. set_max_latency
        2. virtual clock

![lds06](images/lec-dc-sta06.png)<br />  

```
    > set_max_latency <time> -from [get_ports <input>] -to [get_ports <output>]
    > create_clock -name <vclk> -period <time> # if path has no clock definition point, virtual clock inferred

    > set_input_delay -max <time> -clock [get_clocks <vclk>] [get_ports <input>]
    > set_output_delay -max <time> -clock [get_clocks <vclk>] [get_ports <output>]
    > set_input_delay -max <time> -clock [get_clocks <vclk>] -clock_fall [get_ports <input>] # for virtual negedge sampling DFF
    > set_output_delay -max <time> -clock [get_clocks <vclk>] -clock_fall [get_ports <output>] # for virtual negedge sampling DFF
    
    > set_driving_cell -lib_cell <lib_cell_name> <ports>

    > all_inputs/all_outputs/all_clocks/all_registers
    > all_fanout -from <pin/port name> (-endpoints_only -flat)
    > all_fanin -to <pin/port name> (-endpoints_only -flat)
    > get_cells -of_objects [get_pins <pin-name>]
    > report_timing -to <output-port> -sig <unit> # report decimal number
```

    * Multi-Cycle Path

![lds07](images/lec-dc-sta07.png)<br />
    
    * Output Isolation between External and Internal Path

![lds08](images/lec-dc-sta08.png)<br />  

```
    > set_multicycle_path -setup <num> -from <pin/port> -to <pin/port>
    > set_multicycle_path -hold <num> -from <pin/port> -to <pin/port>
    > set_false_path -from <pin/port> -to <pin/port>
    > set_false_path -through <net/pin>
    > set_isolate_ports -type buffer <output-ports>
    // retiming applied in compile option, not SDC command
```

------

## Day9

Topic: Contraint Development

Goals:
1. Try the ideal Timing Constraint for Project Design
2. Analysis OpenSTA results to tune the constraint for design

Status: In-progress, development-stage brief: [project.md](project.md)

To-Be-Done: Update summary result in here while finalized process

------

## Day10

Topic: Introduction to STA and importance of MOSFETs in STA/EDA

Goals:
1. Fundamental N/P MOSFET Simulation from SPICE model
2. Know the pitfall on standard cell from basic circuit element (MOSFET)

Lecture Notes:
* Circuit Design
    * Fundamental combination from N/P MOSFETs to Funcational Gate Cells
    * Analysis Delay and Safe-Margin by SPICE system
    * Get Delay-Table `f(Input-Slew,Output-Load)` from SPICE modelling to verify STA correctness
* N-MOS
    * P-Substract, n+ Diffusion Region
    * Isolation Region (SiO2), PolySi or Metal Gate
    * 4-Terminal element, G (Gate), S (Source), D (Drain), B (Body)
* Threshold Voltage
    * Vs=0, Vd=0, Vgs large enough to perform `Strong Inversion` point `(Vt)`, diode B-S and B-D are off
    * Increase Vgs, electrons from `n+` are drawn to the region under gate `G` as strong inversion
    * The conductivity of S-D path is modulated by Vgs strength
    * Add Vsb voltage, additional potential is required for strong inversion
    * `Vto` means threshold voltage at Vsb=0, a function of manufacturing process

* SPICE Simulation

SPICE File: day1_nfet_idvds_L1p2_W1p8.spice
```
*Model Description
.param temp=27

*Including sky130 library files
.lib "sky130_fd_pr/models/sky130.lib.spice" tt

*Netlist Description
XM1 Vdd n1 0 0 sky130_fd_pr__nfet_01v8 w=1.8 l=1.2
R1 n1 in 55
Vdd vdd 0 1.8V
Vin in 0 1.8V

*simulation commands
.op
.dc Vdd 0 1.8 0.1 Vin 0 1.8 0.2

.control
run
display
setplot dc1
.endc

.end

```

[1] SPICE NMOS id/vds Diagram<br />
![d10l1p1](images/day10_lab1_p1.png)<br />  

------

## Day11

Topic: Basics of NMOS Drain current (Id) vs Drain-to-source Voltage (Vds)

Goals:
1. Syntax and Parameters for SPICE modelling
2. Graphically Id to Vds, Id to Vgs relationship from SPICE

Lecture-Note:
* Resistive Operation
    * At Vgs>Vt condition with small Vds
    * Affect by Effective Channel Length
    * Currents in this condition
        * Drift Current, from the difference of potential voltage
        * Diffusion Current, from the difference of carrier concentration
    * Id = `Kn'*(W/L)*((Vgs-Vt)*Vds-(Vds**2)/2)` = `Kn*((Vgs-Vt)*Vds-(Vds**2)/2)`
        * `Kn'`, as porocess transconductance
        * `Kn=Kn'*(W/L)`, as gain factor
    * While `(Vgs-Vt)>>Vds`, Id ~= `Kn*((Vgs-Vt)*Vds)`, linear function by Vds
* Saturation Region
    * Pinch-Off from `(Vgs-Vds)<=Vt`, electron channel under the gate begins to disappear
    * Channel Voltage clamp to (Vgs-Vt)
        * Id(sat) = `Kn((Vgs-Vt)*(Vgs-Vt)-((Vgs-Vt)**2)/2)` = `Kn/2*(Vgs-Vt)**2`
    * Seems a perfect current source from equation, but affected by  Vds in reality
        * Id(sat) = `Kn/2*((Vgs-Vt)**2)*(1+lambda*Vds)`

* SPICE Simulation

SPICE File: day2_nfet_idvds_L0p25_W0p375.spice
```
*Model Description
.param temp=27

*Including sky130 library files
.lib "sky130_fd_pr/models/sky130.lib.spice" tt

*Netlist Description
XM1 Vdd n1 0 0 sky130_fd_pr__nfet_01v8 w=0.375 l=0.25
R1 n1 in 55
Vdd vdd 0 1.8V
Vin in 0 1.8V

*simulation commands
.op
.dc Vdd 0 1.8 0.1 Vin 0 1.8 0.2

.control
run
display
setplot dc1
.endc

.end
```

SPICE File: day2_nfet_idvgs_L0p25_W0p375.spice
```
*Model Description
.param temp=27

*Including sky130 library files
.lib "sky130_fd_pr/models/sky130.lib.spice" tt

*Netlist Description
XM1 Vdd n1 0 0 sky130_fd_pr__nfet_01v8 w=0.375 l=0.25
R1 n1 in 55
Vdd vdd 0 1.8V
Vin in 0 1.8V

*simulation commands
.op
*remove Vdd variation
.dc Vin 0 1.8 0.1 

.control
run
display
setplot dc1
.endc

.end
```

[1] SPICE NMOS id/vds Diagram, small area but keep same ratio from day10 <br />
![d11l1p1](images/day11_lab1_p1.png)<br />  

[2] SPICE NMOS id/vgs Diagram <br />
![d11l2p1](images/day11_lab2_p1.png)<br />  

------

## Day12 

Topic: Velocity Saturation and basics of CMOS inverter VTC

Goals:
1. Velocity Saturation from Channel Length Difference
2. Voltage-Transfer Characteristics (VTC) for CMOS inverter

Lecture-Note:
* Velocity Saturation Effect
    * Long-Channel (>250nm)
    * Short-Channel (<250nm)
    * Id = `Kn*((Vgt-Vmin)-(Vmin**2)/2)*(1+lambda*Vds)`
    * Vmin = `min(Vgt, Vds, Vd(Sat))`

|Long-Chan. |Short-Chan.|
|-----------|-----------|
|Cut-Off    |Cut-Off    |
|Resistive  |Resistive  |
|           |Vel-Sat    |
|Saturation |Saturation |

* Voltage-Transfer Characteristics (VTC)
    * Transistor
        * Switch Off when `|Vgs|<|Vt|`
        * Switch On when `|Vgs|>|Vt|`
    * CMOS inverter => NOT Gate, PMOS+NMOS

* Assume CMOS inverter in 0-2V range

|Vin |Vout|PMOS|NMOS|
|----|----|----|----|
|0   |2   |LIN |OFF |
|~0.5|~1.5|LIN |SAT |
|1   |1   |SAT |SAT |
|~1.5|~0.5|SAT |LIN |
|2   |0   |OFF |LIN |

* SPICE Simulation

[1] Long-Channel vs Short-Channel<br />
![d12l1p1](images/day12_lab1_p1.png)<br />  

SPICE File: day3_inv_vtc_W0p084_W0n084.spice
```
*Model Description
.param temp=27


*Including sky130 library files
.lib "sky130_fd_pr/models/sky130.lib.spice" tt

*Netlist Description
XM1 out in vdd vdd sky130_fd_pr__pfet_01v8 w=0.84 l=0.15
XM2 out in 0 0 sky130_fd_pr__nfet_01v8 w=0.84 l=0.15
Cload out 0 50fF
Vdd vdd 0 1.8V
Vin in 0 1.8V

*simulation commands
.op
.dc Vin 0 1.8 0.01

.control
run
setplot dc1
display
.endc

.end
```
[2] VTC from identical (W/L) P/NMOS<br />
![d12l2p1](images/day12_lab2_p1.png)<br />  

------

## Day13

Topic: CMOS Switching threshold and dynamic simulations

Goals:
1. Switching Threshold and Quality for CMOS inverter
2. Switching Transition Delay Timing

Lecture-Note:
* Switching Threshold
    * `Vm`, should near the middle of VTC on CMOS inverter
    * `Vm` = `R`*Vdd/(1+`R`), `R`=`(Rp*(Wp/Lp)*Vdp)/(Rn*(Wn/Ln)*Vdn)`

* Transition Delay
    * Rise-Delay, Input 0 then Output 1
    * Fall-Delay, Input 1 then Output 0
    * Find balanced rise/fall delay based on fixed `(Wp/Lp)`, search in variable `(Wn/Ln)`
    * From Device Physics, Ron(PMOS) ~= 2.5*Ron(NMOS)
    * Regular inverter/buffer preferred for data-path

* SPICE Simulation

SPICE File: day3_inv_vtc_W0p084_W0n036.spice
```
*Model Description
.param temp=27

*Including sky130 library files
.lib "sky130_fd_pr/models/sky130.lib.spice" tt

*Netlist Description
XM1 out in vdd vdd sky130_fd_pr__pfet_01v8 w=0.84 l=0.15
XM2 out in 0 0 sky130_fd_pr__nfet_01v8 w=0.36 l=0.15
Cload out 0 50fF
Vdd vdd 0 1.8V
Vin in 0 1.8V

*simulation commands
.op
.dc Vin 0 1.8 0.01

.control
run
setplot dc1
display
.endc

.end
```

[1] VTC from Balanced P/NMOS Driving Strength<br />
![d13l1p1](images/day13_lab1_p1.png)<br />  

SPICE File: day3_inv_tran_W0p084_W0n036.spice
```
*Model Description
.param temp=27

*Including sky130 library files
.lib "sky130_fd_pr/models/sky130.lib.spice" tt

*Netlist Description
XM1 out in vdd vdd sky130_fd_pr__pfet_01v8 w=0.84 l=0.15
XM2 out in 0 0 sky130_fd_pr__nfet_01v8 w=0.36 l=0.15
Cload out 0 50fF
Vdd vdd 0 1.8V
Vin in 0 PULSE(0V 1.8V 0 0.1ns 0.1ns 2ns 4ns)

*simulation commands
.tran 1n 10n

.control
run
.endc

.end
```

[2] Inverter Switching Transition Diagram<br />
![d13l2p1](images/day13_lab2_p1.png)<br />  

|ITEM      |TIME (ns) |
|----------|----------|
|Rise-Delay| 0.34693  |
|Fall-Delay| 0.26531  |

------