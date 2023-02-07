// TODO: change these paths if you move the Memory or RegFile instantiation
// to a different module

`ifdef SYN
    `define RF_PATH   RF
`elsif RGL
    `define RF_PATH   RF
`else
    `define RF_PATH   rv151.soc.rf
`endif

`ifdef SYN
    `define DMEM_PATH rv151.\soc.dmem0
    `define DME0_PATH rv151.\soc.dmem0
    `define DME1_PATH rv151.\soc.dmem1
    `define DME2_PATH rv151.\soc.dmem2
    `define DME3_PATH rv151.\soc.dmem3
    `define IMEM_PATH rv151.\soc.imem0
    `define IME0_PATH rv151.\soc.imem0
    `define IME1_PATH rv151.\soc.imem1
    `define IME2_PATH rv151.\soc.imem2
    `define IME3_PATH rv151.\soc.imem3
    `define BIOS_PATH rv151.\soc.bios_mem0
    `define BIO0_PATH rv151.\soc.bios_mem0
    `define BIO1_PATH rv151.\soc.bios_mem1
`elsif RGL
    `define DMEM_PATH rv151.\soc.dmem0
    `define DME0_PATH rv151.\soc.dmem0
    `define DME1_PATH rv151.\soc.dmem1
    `define DME2_PATH rv151.\soc.dmem2
    `define DME3_PATH rv151.\soc.dmem3
    `define IMEM_PATH rv151.\soc.imem0
    `define IME0_PATH rv151.\soc.imem0
    `define IME1_PATH rv151.\soc.imem1
    `define IME2_PATH rv151.\soc.imem2
    `define IME3_PATH rv151.\soc.imem3
    `define BIOS_PATH rv151.\soc.bios_mem0
    `define BIO0_PATH rv151.\soc.bios_mem0
    `define BIO1_PATH rv151.\soc.bios_mem1
`else
    `define DMEM_PATH rv151.soc.dmem0
    `define DME0_PATH rv151.soc.dmem0
    `define DME1_PATH rv151.soc.dmem1
    `define DME2_PATH rv151.soc.dmem2
    `define DME3_PATH rv151.soc.dmem3
    `define IMEM_PATH rv151.soc.imem0
    `define IME0_PATH rv151.soc.imem0
    `define IME1_PATH rv151.soc.imem1
    `define IME2_PATH rv151.soc.imem2
    `define IME3_PATH rv151.soc.imem3
    `define BIOS_PATH rv151.soc.bios_mem0
    `define BIO0_PATH rv151.soc.bios_mem0
    `define BIO1_PATH rv151.soc.bios_mem1
    `define CSR_PATH  rv151.soc.tohost_csr
`endif
