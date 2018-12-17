#-- Lattice Semiconductor Corporation Ltd.
#-- Synplify OEM project file

#device options
set_option -technology ECP5U
set_option -part LFE5U_85F
set_option -package BG381C
set_option -speed_grade -6

#compilation/mapping options
set_option -symbolic_fsm_compiler true
set_option -resource_sharing true

#use verilog 2001 standard option
set_option -vlog_std v2001

#map options
set_option -frequency auto
set_option -maxfan 1000
set_option -auto_constrain_io 0
set_option -disable_io_insertion false
set_option -retiming false; set_option -pipe true
set_option -force_gsr false
set_option -compiler_compatible 0
set_option -dup false

set_option -default_enum_encoding default

#simulation options


#timing analysis options



#automatic place and route (vendor) options
set_option -write_apr_constraint 1

#synplifyPro options
set_option -fix_gated_and_generated_clocks 1
set_option -update_models_cp 0
set_option -resolve_multiple_driver 0


#-- add_file options
add_file -vhdl {/mt/lattice/diamond/3.7_x64/cae_library/synthesis/vhdl/ecp5u.vhd}
add_file -vhdl -lib "work" {/home/guest/src/fpga/usb-serial/usb-serial-demo/proj/lattice/ulx3s/ulx3s_v20_85f_serial/top/ulx3s_usbserial.vhd}
add_file -vhdl -lib "work" {/home/guest/src/fpga/usb-serial/usb-serial-demo/lattice/ulx3s/clocks/clk_25M_100M_7M5_12M_60M.vhd}
add_file -vhdl -lib "work" {/home/guest/src/fpga/fpga_spi_oled/oled.vhd}
add_file -vhdl -lib "work" {/home/guest/src/fpga/fpga_spi_oled/oled_font_pack.vhd}
add_file -vhdl -lib "work" {/home/guest/src/fpga/fpga_spi_oled/oled_init_pack.vhd}

#-- top module name
set_option -top_module ulx3s_usbtest

#-- set result format/file last
project -result_file {/home/guest/src/fpga/usb-serial/usb-serial-demo/proj/lattice/ulx3s/ulx3s_v20_85f_serial/project/project_project.edi}

#-- error message log file
project -log_file {project_project.srf}

#-- set any command lines input by customer


#-- run Synplify with 'arrange HDL file'
project -run hdl_info_gen -fileorder
project -run
