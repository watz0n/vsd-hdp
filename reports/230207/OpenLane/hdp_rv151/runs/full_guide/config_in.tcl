set ::env(PDK) {sky130A}
set ::env(PDKPATH) {/mnt/d/project/OpenLane/pdks/sky130A}
set ::env(STD_CELL_LIBRARY) {sky130_fd_sc_hd}
set ::env(SCLPATH) {/mnt/d/project/OpenLane/pdks/sky130A/sky130_fd_sc_hd}
set ::env(DESIGN_DIR) {/openlane/designs/hdp_rv151}
set ::env(DESIGN_NAME) {hdp_rv151}
set ::env(VERILOG_FILES) {/openlane/designs/hdp_rv151/src/hdp_rv151.v /openlane/designs/hdp_rv151/src/rv151_soc.v /openlane/designs/hdp_rv151/src/core/rv151_alu.v /openlane/designs/hdp_rv151/src/core/rv151_brh.v /openlane/designs/hdp_rv151/src/core/rv151_core.v /openlane/designs/hdp_rv151/src/core/rv151_ctl.v /openlane/designs/hdp_rv151/src/core/rv151_imm.v /openlane/designs/hdp_rv151/src/core/rv151_rgf.v /openlane/designs/hdp_rv151/src/io/bspi.v /openlane/designs/hdp_rv151/src/io/bspi_aff.v /openlane/designs/hdp_rv151/src/io/bspi_bif.v /openlane/designs/hdp_rv151/src/io/bspi_oif.v /openlane/designs/hdp_rv151/src/io/uart.v /openlane/designs/hdp_rv151/src/io/uart_receiver.v /openlane/designs/hdp_rv151/src/io/uart_transmitter.v}
set ::env(CLOCK_PORT) {clk io_clk io_sck}
set ::env(CLOCK_PERIOD) {100.0}
set ::env(EXTRA_LEFS) {/openlane/designs/hdp_rv151/../../pdks/sky130A/libs.ref/sky130_sram_macros/lef/sky130_sram_2kbyte_1rw1r_32x512_8.lef}
set ::env(EXTRA_GDS_FILES) {/openlane/designs/hdp_rv151/../../pdks/sky130A/libs.ref/sky130_sram_macros/gds/sky130_sram_2kbyte_1rw1r_32x512_8.gds}
set ::env(EXTRA_LIBS) {/openlane/designs/hdp_rv151/../../pdks/sky130A/libs.ref/sky130_sram_macros/lib/sky130_sram_2kbyte_1rw1r_32x512_8_TT_1p8V_25C.lib}
set ::env(VDD_NETS) {vccd1}
set ::env(GND_NETS) {vssd1}
set ::env(FP_PDN_MACRO_HOOKS) {soc.bios_mem0 vccd1 vssd1 vccd1 vssd1, soc.bios_mem1 vccd1 vssd1 vccd1 vssd1, soc.dmem0 vccd1 vssd1 vccd1 vssd1, soc.dmem1 vccd1 vssd1 vccd1 vssd1, soc.imem0 vccd1 vssd1 vccd1 vssd1, soc.imem1 vccd1 vssd1 vccd1 vssd1}
set ::env(FP_SIZING) {absolute}
set ::env(PL_TARGET_DENSITY) {0.5}
set ::env(RT_MAX_LAYER) {met4}
set ::env(DIE_AREA) {0 0 2450 2050}
set ::env(MACRO_PLACEMENT_CFG) {/openlane/designs/hdp_rv151/macro_placement.cfg}
set ::env(BASE_SDC_FILE) {/openlane/designs/hdp_rv151/base.sdc}
set ::env(SYNTH_STRATEGY) {AREA 0}
set ::env(SYNTH_SIZING) {1}
set ::env(SYNTH_FLAT_TOP) {1}
set ::env(ROUTING_CORES) {4}
set ::env(FP_PIN_ORDER_CFG) {/openlane/designs/hdp_rv151/pin_order.cfg}
set ::env(MAGIC_DRC_USE_GDS) {0}
set ::env(QUIT_ON_MAGIC_DRC) {0}
set ::env(RUN_KLAYOUT_XOR) {0}
set ::env(DESIGN_IS_CORE) {1}
