# Copyright 2023 Hwa-Shan (Watson) Huang
# Author: watson.edx@gmail.com

# This file is cope with other script files which defiend corner library.
# e.g. opensta_delay_calc_tt.tcl

read_verilog ./rgl/hdp_rv151.nl.v

link_design hdp_rv151

create_clock -name clk -period 100.0 [get_ports {clk}]
create_clock -name sck -period 100.0 [get_ports {io_sck}]
create_clock -name ick -period 100.0 [get_ports {io_clk}]

set_clock_groups -name grp_clks -physically_exclusive -group { clk } -group { sck } -group { ick }

set_timing_derate -early 0.95
set_timing_derate -late 1.05

set_input_delay  -clock [get_clocks sck] 30.0 -add_delay [get_ports {io_scs io_sdi}]
set_output_delay -clock [get_clocks sck] 30.0 -add_delay [get_ports {io_sdo}]

set_input_delay  -clock [get_clocks clk] 30.0 -add_delay [get_ports {gpio_in[*]}]
set_output_delay -clock [get_clocks clk] 30.0 -add_delay [get_ports {gpio_out[*] gpio_oeb[*]}]
set_input_delay  -clock [get_clocks clk] 30.0 -add_delay [get_ports {serial_in}]
set_output_delay -clock [get_clocks clk] 30.0 -add_delay [get_ports {serial_out}]
set_input_delay  -clock [get_clocks clk] 30.0 -add_delay [get_ports {io_cslt}]

set_input_delay  -clock [get_clocks ick] 15.0 -add_delay [get_ports {gpio_in[*]}]
set_output_delay -clock [get_clocks ick] 15.0 -add_delay [get_ports {gpio_out[*] gpio_oeb[*]}]
set_input_delay  -clock [get_clocks ick] 15.0 -add_delay [get_ports {serial_in}]
set_output_delay -clock [get_clocks ick] 15.0 -add_delay [get_ports {serial_out}]
set_input_delay  -clock [get_clocks ick] 15.0 -add_delay [get_ports {io_cslt}]


set_false_path -from { io_bcf }
set_false_path -to { io_hlt io_irc }

read_spef ./rgl/spef/mc/hdp_rv151.nom.spef

#WNS
report_worst_slack -digits 4 -max >wns.log
#WHS
report_worst_slack -digits 4 -min >whs.log
#TNS
report_tns -digits 4 >tns.log