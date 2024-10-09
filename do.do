vlib work
vlog -f sonar_files.txt +cover
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover
coverage save sonar.ucdb -onexit
run -all