package sonaragent_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import sonarsequencer_pkg::*;
import sonar_driver_pkg::*;
import sonar_monitor_Pkg::*;
import sonar_config_pkg::*;
import sonar_sequence_item_pkg::*;

class sonar_agent extends uvm_agent;
   `uvm_component_utils(sonar_agent)

   sonar_driver driver;
   sonar_sequencer sequencer;
   sonar_monitor monitor;
   sonar_config cfg;

   uvm_analysis_port #(sonar_sequence_item) agt_ap;
   function new(string name = "sonar_agent", uvm_component parent = null);
      super.new(name, parent);
   endfunction

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db #(sonar_config)::get(this , "" , "CFG" , cfg))
        `uvm_fatal("build_phase" , "Unable to get configuration object in agent component")
        //
      driver = sonar_driver::new("driver", this);
      sequencer = sonar_sequencer::new("sequencer", this);
      monitor = sonar_monitor::new("monitor", this);
      agt_ap = new("agt_ap",this);
   endfunction

   function void connect_phase (uvm_phase phase);
   monitor.mon_ap.connect(agt_ap);
   driver.sonar_vif_driver = cfg.sonar_vif_config;
   driver.gold_vif_driver = cfg.gold_vif_config;
   //
   monitor.sonar_vif_monitor = cfg.sonar_vif_config;
   monitor.gold_vif_monitor = cfg.gold_vif_config;
   //
   driver.seq_item_port.connect(sequencer.seq_item_export);
   endfunction

endclass
endpackage