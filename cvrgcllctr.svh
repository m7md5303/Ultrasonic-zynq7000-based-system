package sonar_coverage_collector_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import sonar_sequence_item_pkg::*;
class sonar_coverage_collector extends uvm_component;
    `uvm_component_utils(sonar_coverage_collector)
    uvm_analysis_export #(sonar_sequence_item) cov_export;
    uvm_tlm_analysis_fifo #(sonar_sequence_item) cov_fifo;
    sonar_sequence_item seq_item_cov;

    covergroup cg ;
reset_cp: coverpoint seq_item_cov.rst_n{
    bins zeros={0};
	bins ones={1};
}
controlword_cp: coverpoint seq_item_cov.received_data;

cross reset_cp , controlword_cp;
increase_cp: coverpoint seq_item_cov.received_data[2];
decrease_cp: coverpoint seq_item_cov.received_data[3];

outputDAC_cp: coverpoint seq_item_cov.outputDAC;

cross increase_cp , outputDAC_cp;
cross decrease_cp , outputDAC_cp;

send_cp: coverpoint seq_item_cov.received_data[5];
receive_cp: coverpoint seq_item_cov.received_data[4];

no_order_cp: coverpoint seq_item_cov.no_order;

cross no_order_cp , controlword_cp;

    endgroup
function new(string name="sonar_coverage_collector",uvm_component parent=null);
    super.new(name,parent);
    cg=new();
endfunction

 
 function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cov_export=new("cov_export",this);
    cov_fifo=new("cov_fifo",this);
 endfunction

 function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    cov_export.connect(cov_fifo.analysis_export);
 endfunction


 task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
        cov_fifo.get(seq_item_cov);
        cg.sample();
    end
 endtask

    endclass
    endpackage