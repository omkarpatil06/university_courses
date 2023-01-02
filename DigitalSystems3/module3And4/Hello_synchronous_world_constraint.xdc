#Inputs
set_property PACKAGE_PIN V17 [get_ports CLK]
    set_property IOSTANDARD LVCMOS33 [get_ports CLK]
set_property PACKAGE_PIN U18 [get_ports IN]
        set_property IOSTANDARD LVCMOS33 [get_ports IN]

#Outputs
set_property PACKAGE_PIN E19 [get_ports OUT]
    set_property IOSTANDARD LVCMOS33 [get_ports OUT]
set_property PACKAGE_PIN U16 [get_ports OUTBAR]
        set_property IOSTANDARD LVCMOS33 [get_ports OUTBAR]


set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets CLK_IBUF]