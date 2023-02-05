# HDP-RV151 Project Data-Base, Hardware

* Author: wats0n.edx@gmail.com (Watson Huang)

------

> RTL Simulation :

```
//Test RV32I functionality, RTL simulation only
$ make sim/cpu_tb_bmem.fst

//Test BSPI load to BIOS-MEM behavior
$ make sim/bspi_tb_bmem.fst

//Test UART Echo from RX to TX
$ make sim/echo_tb_bmem.fst

//Test GPIO
$ make sim/gpio_tb_bmem.fst
```

> Synthesis (Yosys) :

```
$ make syn
```

> GATE/SYN Simulation :

```
$ make sim-syn/bspi_tb_bmem.fst
$ make sim-syn/echo_tb_bmem.fst
$ make sim-syn/gpio_tb_bmem.fst
```

> STA :

```
//perform typical-typical STA detail report
$ make sta-tt

//perform multi-corner STA report summary
$ make sta-mc
```

> Routed-Gatel-Level (RGL) Simulation

* copy verilog netlist without power-port from `results/final/verilog/gl/`

```
$ make sim-rgl/bspi_tb_bmem.fst
$ make sim-rgl/echo_tb_bmem.fst
$ make sim-rgl/gpio_tb_bmem.fst
```

> Routed-Gatel-Level (RGL) Simulation + SDF, but with SDF read error

* copy sdf file form `results/final/verilog/sdf` 

    * SDF-Type:
        * Max : RC-Worst
        * Min : RC-Best
        * Nom : RC-Typical

```
$ make sim-rgl-nom/bspi_tb_bmem.fst
$ make sim-rgl-max/bspi_tb_bmem.fst
$ make sim-rgl-min/bspi_tb_bmem.fst
```

* SDF Read Error:
    * Incomplete SDF Support: https://github.com/steveicarus/iverilog/issues/509#issuecomment-841794369

------