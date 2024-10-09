package sonar_test_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import sonar_env_pkg::*;
import sonar_config_pkg::*;
import sonar_sequence_pkg::*;
import sonaragent_pkg::*;
class sonar_test extends uvm_test;
   `uvm_component_utils(sonar_test)

   sonar_env env;
   sonar_config cfg;
   virtual sonar_inter sonar_vif_test;
   virtual golden_inter_ref gold_vif_test;
   sonar_reset_sequence rstseq;
   sonar_send_sequence sendseq;
   sonar_receive_sequence recseq;
   sonar_increase_sequence incseq;
   sonar_decrease_sequence decseq;
   sonar_rand_all_sequence rndseq;

   function new(string name = "sonar_test", uvm_component parent = null);
      super.new(name, parent);
   endfunction

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      env = sonar_env::type_id::create("env", this);
      cfg = sonar_config::type_id::create("cfg" , this);
      rstseq = sonar_reset_sequence::type_id::create("rstseq" , this);
      sendseq = sonar_send_sequence::type_id::create("sendseq" , this);
      recseq = sonar_receive_sequence::type_id::create("recseq" , this);
      incseq = sonar_increase_sequence::type_id::create("incseq" , this);
      decseq = sonar_decrease_sequence::type_id::create("decseq" , this);
      rndseq = sonar_rand_all_sequence::type_id::create("rndseq" , this);

              if(!uvm_config_db #(virtual sonar_inter)::get(this,"","SONAR_IF",cfg.sonar_vif_config))
        `uvm_fatal("build_phase","Test - Unable to get the virtual interface of the SONAR from the uvm_config_db")
        
        if(!uvm_config_db #(virtual golden_inter_ref)::get(this,"","GOLDEN_IF",cfg.gold_vif_config))
        `uvm_fatal("build_phase","Test - Unable to get the virtual golden interface of the SONAR from the uvm_config_db")
        uvm_config_db #(sonar_config)::set(this,"*","CFG",cfg);

   endfunction

   task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    `uvm_info("run_phase","reset_deasserted",UVM_LOW)
    rstseq.start(env.agt.sequencer);
    `uvm_info("run_phase","reset_asserted",UVM_LOW)
    //
    `uvm_info("run_phase","send_asserted",UVM_LOW)
    sendseq.start(env.agt.sequencer);
    `uvm_info("run_phase","send_deasserted",UVM_LOW)
    //
    `uvm_info("run_phase","receive_asserted",UVM_LOW)
    recseq.start(env.agt.sequencer);
    `uvm_info("run_phase","receive_deasserted",UVM_LOW)
    //
    `uvm_info("run_phase","increase_asserted",UVM_LOW)
    incseq.start(env.agt.sequencer);
    `uvm_info("run_phase","increase_deasserted",UVM_LOW)
    //
    `uvm_info("run_phase","decrease_asserted",UVM_LOW)
    decseq.start(env.agt.sequencer);
    `uvm_info("run_phase","decrease_deasserted",UVM_LOW)
    //
    repeat(8)begin
    `uvm_info("run_phase","send_asserted",UVM_LOW)
    sendseq.start(env.agt.sequencer);
    `uvm_info("run_phase","send_deasserted",UVM_LOW)  
    end
    //
    repeat(800)begin
    `uvm_info("run_phase","receive_asserted",UVM_LOW)
    recseq.start(env.agt.sequencer);
    `uvm_info("run_phase","receive_deasserted",UVM_LOW) 
    end
    //
    `uvm_info("run_phase","reset_deasserted",UVM_LOW)
    rstseq.start(env.agt.sequencer);
    `uvm_info("run_phase","reset_asserted",UVM_LOW)
    //
    `uvm_info("run_phase","rand",UVM_LOW)
    rndseq.start(env.agt.sequencer);
    `uvm_info("run_phase","rand finished",UVM_LOW)
    phase.drop_objection(this);
   endtask
endclass
endpackage