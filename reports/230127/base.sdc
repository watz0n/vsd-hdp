create_clock -name clk -period 100 [get_ports {clk}]
create_clock -name sck -period 100 [get_ports {io_sck}]

set_clock_groups -name grp_clks -physically_exclusive -group { clk } -group { sck }

set_input_delay  -clock [get_clocks clk] 20.0 -add_delay [get_ports {serial_in}]
set_output_delay -clock [get_clocks clk] 20.0 -add_delay [get_ports {serial_out}]

set_input_delay  -clock [get_clocks sck] 20.0 -add_delay [get_ports {io_scs io_sdi}]
set_output_delay -clock [get_clocks sck] 20.0 -add_delay [get_ports {io_sdo}]
