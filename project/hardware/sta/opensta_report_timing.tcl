# Copyright 2023 Hwa-Shan (Watson) Huang
# Author: watson.edx@gmail.com

# This file is cope with other script files which defiend corner library.
# e.g. opensta_delay_calc_tt.tcl

read_verilog ./syn/rv151_soc_syn.v

link_design rv151_soc

create_clock -name clk -period 100.0 { clk }
create_clock -name sck -period 100.0 { io_sck }

set_input_delay -clock clk 0 { serial_in }
set_output_delay -clock clk 0 { serial_out }

set_input_delay -clock sck 0 { io_scs io_sdi }
set_output_delay -clock sck 0 { io_sdo }

set_clock_groups -name grp_clks -physically_exclusive -group { clk } -group { sck }

set_false_path -from { io_bcf }
set_false_path -to { io_hlt io_irc }

#WNS
report_worst_slack -digits 4 -max >wns.log
#WHS
report_worst_slack -digits 4 -min >whs.log
#TNS
report_tns -digits 4 >tns.log
