A repository for recording VSD-HDP program as below program link.

Program: [SKY130-based ASIC Design Projects](https://www.vlsisystemdesign.com/hdp/)

Progress-Status: [hdp-pregress-status.md](hdp-pregress-status.md)

- watz0n (Watson Huang), wats0n.edx@gmail.com

------

# VSD-HDP Progress Status

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

![d0t1i1](images/day0-tool1-yosys1.png)
![d0t1i2](images/day0-tool1-yosys2.png)
![d0t1i3](images/day0-tool1-yosys3.png)

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

![d0t2i1](images/day0-tool2-opensta1.png)
![d0t2i2](images/day0-tool2-opensta2.png)
![d0t2i3](images/day0-tool2-opensta3.png)
![d0t2i4](images/day0-tool2-opensta4.png)

### Tool: ngspice

Installation Source:
> https://sourceforge.net/projects/ngspice/files/ng-spice-rework/38/
Download File:
> ngspice-38.tar.gz

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

![d0t3i1](images/day0-tool3-ngspice1.png)
![d0t3i2](images/day0-tool3-ngspice2.png)
![d0t3i3](images/day0-tool3-ngspice3.png)

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

![d1t4i1](images/day1-tool4-iverilog1.png)
![d1t4i2](images/day1-tool4-iverilog2.png)
![d1t4i3](images/day1-tool4-iverilog3.png)

### Tool: gtkwave

Apply Ubuntu-20.04 official gtkwave builds

Installation Flow:
```
$ sudo apt install libcanberra-gtk-module libcanberra-gtk3-module gtkwave
```

Progress Images:

![d1t5i1](images/day1-tool5-gtkwave1.png)


### Day1-Lab1: Logic Cell Simulation

Work-Flow:
```
$ cd verilog_files
$ iverilog good_mux.v tb_good_mux.v
$ ./a.out
$ gtkwave tb_good_mux.vcd
```

Progress Images:

![d1l1p1](images/day1-lab1-p1.png)

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

![d1l2p1](images/day1-lab2-p1.png)
![d1l2p2](images/day1-lab2-p2.png)
![d1l2p3](images/day1-lab2-p3.png)

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

![d2l1p1](images/day2-lab1-p1.png)
![d2l1p2](images/day2-lab1-p2.png)

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

![d2l2p1](images/day2-lab2-p1.png)
![d2l2p2](images/day2-lab2-p2.png)
![d2l2p3](images/day2-lab2-p3.png)

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

![d2l3p1](images/day2-lab3-p1.png)
![d2l3p2](images/day2-lab3-p2.png)
![d2l3p3](images/day2-lab3-p3.png)

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

![d2l4p1](images/day2-lab4-p1.png)
![d2l4p2](images/day2-lab4-p2.png)

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

![ ](images/day3-lab1-p1.png)
![ ](images/day3-lab1-p2.png)
![ ](images/day3-lab1-p3.png)
![ ](images/day3-lab1-p4.png)
![ ](images/day3-lab1-p5.png)
![ ](images/day3-lab1-p6.png)

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

![ ](images/day3-lab2-p1.png)
![ ](images/day3-lab2-p2.png)

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

![ ](images/day3-lab3-p1.png)
![ ](images/day3-lab3-p2.png)
![ ](images/day3-lab3-p3.png)
![ ](images/day3-lab3-p4.png)

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

![ ](images/day3-lab4-p1.png)
![ ](images/day3-lab4-p2.png)
![ ](images/day3-lab4-p3.png)

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
![ ](images/day3-lab5-p1.png)
![ ](images/day3-lab5-p2.png)
![ ](images/day3-lab5-p3.png)

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
![ ](images/day3-lab6-p1.png)
![ ](images/day3-lab6-p2.png)
![ ](images/day3-lab6-p3.png)
![ ](images/day3-lab6-p4.png)
![ ](images/day3-lab6-p5.png)

------