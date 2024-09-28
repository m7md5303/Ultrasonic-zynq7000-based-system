package sonar_env_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import sonaragent_pkg::*;
import sonar_scoreboard_pkg::*;
import sonar_coverage_collector_pkg::*;
class sonar_env extends uvm_env;
 `uvm_component_utils(sonar_env)
 sonar_agent agt;
 sonar_scoreboard sb;
 sonar_coverage_collector cov;
   function new(string name = "sonar_env", uvm_component parent = null);
      super.new(name, parent);
   endfunction

    function void build_phase(uvm_phase phase);

       super.build_phase(phase);
       agt = sonar_agent::type_id::create("agt",this);
       sb = sonar_scoreboard::type_id::create("sb",this);
       cov = sonar_coverage_collector::type_id::create("cov",this);
    endfunction : build_phase

        function void connect_phase(uvm_phase phase);
      agt.agt_ap.connect(sb.sb_export);
      agt.agt_ap.connect(cov.cov_export);
      sb.gold_vif_sb=agt.monitor.gold_vif_monitor;
    endfunction
endclass
endpackage