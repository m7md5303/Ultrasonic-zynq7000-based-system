import uvm_pkg::*;
`include "uvm_macros.svh"
import sonar_test_pkg::*;

module top ();
bit clk;
initial begin
    forever begin
        #10 clk=~clk;
    end
end
golden_inter_ref gold_if(clk);
sonar_inter sonarif (clk);
TOP DUT (sonarif.clk,sonarif.rst_n,sonarif.received_data,sonarif.no_order,sonarif.outputDAC,sonarif.read_add,sonarif.rd_en,sonarif.read_data);
goldenmodel Gold(gold_if);
    initial begin
        uvm_config_db #(virtual sonar_inter)::set(null,"uvm_test_top","SONAR_IF",sonarif);
        uvm_config_db #(virtual golden_inter_ref)::set(null,"uvm_test_top","GOLDEN_IF",gold_if);
        run_test("sonar_test");
    end
endmodule