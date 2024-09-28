interface golden_inter_ref (clk);
parameter DATA_WIDTH = 32;
input bit clk;
logic rst_n, no_order;
logic [DATA_WIDTH-1:0] received_data;
logic [11:0] outputDAC;

modport DUT_gold (
input clk,rst_n,received_data,
output no_order,outputDAC
);

endinterface