
read_verilog ./syn/rv151_soc_syn.v

link_design rv151_soc

create_clock -name clk -period 100 { clk }
create_clock -name sck -period 100 { io_sck }

set_input_delay -clock clk 0 { serial_in }
set_output_delay -clock clk 0 { serial_out }

set_input_delay -clock sck 0 { io_scs io_sdi }
set_output_delay -clock sck 0 { io_sdo }

set_clock_groups -name grp_clks -physically_exclusive -group { clk } -group { sck }

set_false_path -from { io_bcf }
set_false_path -to { io_hlt io_irc }

#report_checks -digits 4 -no_line_splits -path_delay min > ./syn/opensta_min_path.log
#report_checks -digits 4 -no_line_splits -path_delay max > ./syn/opensta_max_path.log
#report_checks

#WNS
report_worst_slack -digits 4 -max >wns.log
#WHS
report_worst_slack -digits 4 -min >whs.log
#TNS
report_tns -digits 4 >tns.log
