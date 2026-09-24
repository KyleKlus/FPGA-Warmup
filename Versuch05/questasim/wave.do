onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /fpga_audiofx_tb/fpga_audiofx_inst/test_l_inst/clock
add wave -noupdate /fpga_audiofx_tb/fpga_audiofx_inst/test_l_inst/smp_valid
add wave -noupdate /fpga_audiofx_tb/fpga_audiofx_inst/test_l_inst/smp_data
add wave -noupdate /fpga_audiofx_tb/fpga_audiofx_inst/test_l_inst/smp_ack
add wave -noupdate /fpga_audiofx_tb/fpga_audiofx_inst/test_l_inst/aout_sync
add wave -noupdate /fpga_audiofx_tb/fpga_audiofx_inst/test_l_inst/aout_data
add wave -noupdate /fpga_audiofx_tb/fpga_audiofx_inst/test_l_inst/ain_sync
add wave -noupdate /fpga_audiofx_tb/fpga_audiofx_inst/test_l_inst/ain_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 331
configure wave -valuecolwidth 39
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 10000
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {450600 ns} {550600 ns}
