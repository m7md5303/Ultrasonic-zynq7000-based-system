package sonarsequencer_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import sonar_sequence_item_pkg::*;
class sonar_sequencer extends uvm_sequencer#(sonar_sequence_item);
   `uvm_component_utils(sonar_sequencer)
    function new(string name="sonar_sequencer",uvm_component parent=null);
     super.new(name,parent);
    endfunction
endclass
endpackage