# Copyright 2023 Hwa-Shan (Watson) Huang
# Author: watson.edx@gmail.com

read_liberty ./lib/openram/hdp_sky130_sram_8kbytes_1rw1r_32x2048_8_TT_1p8V_25C.lib
read_liberty ./lib/openram/hdp_sky130_sram_8kbytes_1rw_32x2048_8_TT_1p8V_25C.lib
read_liberty ./lib/sky130/sky130_fd_sc_hd__tt_025C_1v80.lib

source ./sta/opensta_report_timing.tcl

file mkdir ./sta/log

report_checks -digits 4 -no_line_splits -path_delay min > ./sta/log/opensta_tt_min_path.log
report_checks -digits 4 -no_line_splits -path_delay max > ./sta/log/opensta_tt_max_path.log
report_checks

exit