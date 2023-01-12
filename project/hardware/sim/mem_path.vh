// TODO: change these paths if you move the Memory or RegFile instantiation
// to a different module

`ifdef FPGA
    `define RF_PATH   cpu.rf
    `define DMEM_PATH cpu.dmem
    `define IMEM_PATH cpu.imem
    `define BIOS_PATH cpu.bios_mem
    `define CSR_PATH  cpu.tohost_csr
`else //FPGA
`ifdef SYN
    `define RF_PATH   RF
`else
    `define RF_PATH   soc.rf
`endif
    `define DMEM_PATH soc.dmem0
    `define DME0_PATH soc.dmem0
    `define DME1_PATH soc.dmem1
    `define IMEM_PATH soc.imem0
    `define IME0_PATH soc.imem0
    `define IME1_PATH soc.imem1
    `define BIOS_PATH soc.bios_mem
    `define CSR_PATH  soc.tohost_csr
`endif //FPGA
