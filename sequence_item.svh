package sonar_sequence_item_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
parameter DATA_WIDTH = 32;
parameter FIFO_DATA = 25;
class sonar_sequence_item extends uvm_sequence_item;
`uvm_object_utils(sonar_sequence_item)                          
rand logic rst_n;                          
rand logic [DATA_WIDTH-1:0] received_data;
logic no_order,no_order_ref;
logic [FIFO_DATA-1:0] read_data,read_data_ref;
logic [11:0] outputDAC,outputDAC_ref;
//
function new(string name = "sonar_sequence_item");
  super.new(name);
endfunction
//
function string convert2string();
    return $sformatf ("%s reset = %0b, received data = %0b, no_order = %0b, read_data = %0b, outputDAC=%0b",super.convert2string(),rst_n,received_data,no_order,read_data,outputDAC);
endfunction
//
constraint resetting { rst_n dist {0:=5,1:=95};}
constraint valid_cnstr {received_data[6] dist {1:=75,0:=25};}
constraint on_off {
    received_data[0] dist {1:=60,0:=40};
    received_data[1] dist {0:=60,1:=40};
}
endclass
endpackage