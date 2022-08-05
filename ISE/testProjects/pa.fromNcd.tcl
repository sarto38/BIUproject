
# PlanAhead Launch Script for Post PAR Floorplanning, created by Project Navigator

create_project -name MainProject -dir "C:/ISE/MainProject/planAhead_run_2" -part xa6slx75fgg484-3
set srcset [get_property srcset [current_run -impl]]
set_property design_mode GateLvl $srcset
set_property edif_top_file "C:/ISE/MainProject/FPGA_top.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/ISE/MainProject} }
set_property target_constrs_file "FPGA_top.ucf" [current_fileset -constrset]
add_files [list {FPGA_top.ucf}] -fileset [get_property constrset [current_run]]
link_design
read_xdl -file "C:/ISE/MainProject/FPGA_top.ncd"
if {[catch {read_twx -name results_1 -file "C:/ISE/MainProject/FPGA_top.twx"} eInfo]} {
   puts "WARNING: there was a problem importing \"C:/ISE/MainProject/FPGA_top.twx\": $eInfo"
}
