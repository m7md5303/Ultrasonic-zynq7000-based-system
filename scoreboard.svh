package sonar_scoreboard_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import sonar_sequence_item_pkg::*;
import sonar_config_pkg::*;
parameter DATA_WIDTH = 32;
class sonar_scoreboard extends uvm_scoreboard;
   `uvm_component_utils(sonar_scoreboard)
    uvm_analysis_export #(sonar_sequence_item) sb_export;
    uvm_tlm_analysis_fifo #(sonar_sequence_item) sb_fifo;
    sonar_sequence_item seq_item_sb;
    virtual golden_inter_ref gold_vif_sb;
    logic no_order_ref;
    logic [FIFO_DATA-1:0] read_data_ref;
    logic [11:0] outputDAC_ref;
   int order_count_ref=0;
   int error_count = 0;
   int correct_count = 0;

//constructor
   function new(string name = "sonar_scoreboard", uvm_component parent = null);
      super.new(name, parent);
   endfunction

//build phase
   function void build_phase(uvm_phase phase);
   super.build_phase(phase);
        sb_export = new("sb_export",this);
        sb_fifo = new("sb_fifo",this);
   endfunction

//connect phase  
   function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        sb_export.connect(sb_fifo.analysis_export);
    endfunction
   
//run phase
   task run_phase (uvm_phase phase);
    super.run_phase(phase);
    forever begin
      sb_fifo.get(seq_item_sb);
      if((seq_item_sb.no_order!=gold_vif_sb.no_order)||(seq_item_sb.outputDAC!=gold_vif_sb.outputDAC))begin
      if((seq_item_sb.no_order!=gold_vif_sb.no_order))begin
         `uvm_error("runphase" , $sformatf("error no order at %0t",$time))
         error_count++;
      end
      if((seq_item_sb.outputDAC!=gold_vif_sb.outputDAC))begin
         `uvm_error("runphase" , $sformatf("error outputDAC at %0t",$time))
         error_count++;
      end
      end
      else begin
         correct_count++;
         `uvm_info("run_phase", $sformatf("correct at %0t",$time), UVM_MEDIUM)
      end
    end
   endtask

//report phase
   function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("report_phase",$sformatf("Total successful transactions: %0d",correct_count),UVM_MEDIUM);
        `uvm_info("report_phase",$sformatf("Total failed transactions: %0d ",error_count),UVM_MEDIUM);
    endfunction
endclass
endpackage