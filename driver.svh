package sonar_driver_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import sonar_config_pkg::*;
import sonar_sequence_item_pkg::*;
class sonar_driver extends uvm_driver#(sonar_sequence_item);
   `uvm_component_utils(sonar_driver)

    virtual sonar_inter sonar_vif_driver;
    virtual golden_inter_ref gold_vif_driver;
    sonar_config sonar_cfg;
    sonar_sequence_item stim_seq_item;

   function new(string name = "sonar_driver", uvm_component parent = null);
      super.new(name, parent);
   endfunction

   function void build_phase(uvm_phase phase);
   super.build_phase(phase);

   if(!uvm_config_db #(sonar_config)::get(this , "" , "CFG" , sonar_cfg))begin
      `uvm_fatal("build_phase","unable to get configuration object in the driver")
   end
   endfunction

   task run_phase(uvm_phase phase);
   super.run_phase(phase);
      forever begin
         stim_seq_item = sonar_sequence_item::type_id::create("stim_seq_item");
         seq_item_port.get_next_item(stim_seq_item);
         sonar_vif_driver.rst_n = stim_seq_item.rst_n;
         gold_vif_driver.rst_n = stim_seq_item.rst_n;
         sonar_vif_driver.received_data = stim_seq_item.received_data;
         gold_vif_driver.received_data = stim_seq_item.received_data;
         @(negedge sonar_vif_driver.clk);
         seq_item_port.item_done();
      end
   endtask

endclass
endpackage