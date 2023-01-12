# HDP-RV151 Project Data-Base, Hardware

* Author: wats0n.edx@gmail.com (Watson Huang)

------

> RTL Simulation :

```
//Test RV32I functionality, RTL simulation only
$ make sim/cpu_tb_bmem.v

//Test BSPI load to BIOS-MEM behavior
$ make sim/bspi_tb_bmem.v

//Test UART Echo from RX to TX
$ make sim/echo_tb_bmem.v
```

> Synthesis (Yosys) :

```
$ make syn
```

> GATE/SYN Simulation :

```
//Test BSPI load to BIOS-MEM behavior
$ make sim-syn/bspi_tb_bmem.v

//Test UART Echo from RX to TX
$ make sim-syn/echo_tb_bmem.v
```

> STA :

```
//perform typical-typical STA detail report
$ make sta-tt

//perform multi-corner STA report summary
$ make sta-mc
```

------