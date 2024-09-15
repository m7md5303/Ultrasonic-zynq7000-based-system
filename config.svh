package sonar_config_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
class sonar_config extends uvm_object;
    `uvm_object_utils(sonar_config)
    virtual sonar_inter sonar_vif_config;
    virtual golden_inter_ref gold_vif_config; 
    
    function new (string name = "sonar_config");
        super.new(name);
    endfunction
endclass
    
endpackage