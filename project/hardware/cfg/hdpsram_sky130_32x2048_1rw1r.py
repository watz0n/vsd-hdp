# Copyright 2023 Hwa-Shan (Watson) Huang
# Author: watson.edx@gmail.com

"""
OpenRAM configuration file for two-port (1rw and 1r) 8KB SRAM
"""
word_size = 32 # Bits
num_words = 2048
human_byte_size = "{:.0f}kbytes".format((word_size * num_words)/1024/8)

# Allow byte writes
write_size = 8 # Bits

# Single port
num_rw_ports = 1
num_r_ports = 1
num_w_ports = 0
#num_spare_rows = 1
#num_spare_cols = 1
ports_human = '1rw1r'

tech_name = "sky130"

#=== Only has TT lib, but it's analytical_delay
#nominal_corner_only = True

#=== Generate TT/FF/SS lib, but all are analytical_delay
# Or you can specify particular corners
# Process corners to characterize
process_corners = [ "TT" ]
# Voltage corners to characterize
supply_voltages = [ 1.8 ]
# Temperature corners to characterize
temperatures = [ 25 ]

# Local wordlines have issues with met3 power routing for now
#local_array_size = 16

route_supplies = "ring"
#route_supplies = "left"
#check_lvsdrc = True
check_lvsdrc = False
uniquify = True
#perimeter_pins = False
#netlist_only = True
#analytical_delay = False

output_name = "hdp_{tech_name}_sram_{human_byte_size}_{ports_human}_{word_size}x{num_words}_{write_size}".format(**locals())
output_path = "macro/{output_name}".format(**locals())
