package sonar_monitor_Pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import sonar_sequence_item_pkg::*;

class sonar_monitor extends uvm_monitor;
   `uvm_component_utils(sonar_monitor)
    virtual sonar_inter sonar_vif_monitor;
    virtual golden_inter_ref gold_vif_monitor;
    sonar_sequence_item rsp_seq_item;
    uvm_analysis_port #(sonar_sequence_item) mon_ap;

   function new(string name = "sonar_monitor", uvm_component parent = null);
      super.new(name, parent);
   endfunction

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      mon_ap = new("mon_ap",this);
   endfunction : build_phase


   task run_phase(uvm_phase phase);
      super.run_phase(phase);
      forever begin
         rsp_seq_item = sonar_sequence_item::type_id::create("rsp_seq_item");
         @(negedge sonar_vif_monitor.clk);
         rsp_seq_item.rst_n = sonar_vif_monitor.rst_n;
         rsp_seq_item.received_data = sonar_vif_monitor.received_data;
         rsp_seq_item.no_order = sonar_vif_monitor.no_order;
         rsp_seq_item.read_data = sonar_vif_monitor.read_data;
         rsp_seq_item.outputDAC = sonar_vif_monitor.outputDAC;
         //
         rsp_seq_item.no_order_ref = gold_vif_monitor.no_order;
         rsp_seq_item.outputDAC_ref = gold_vif_monitor.outputDAC;
         //
         mon_ap.write(rsp_seq_item);
         `uvm_info("run_Phase",rsp_seq_item.convert2string(),UVM_HIGH)
      end
   endtask
endclass
endpackage