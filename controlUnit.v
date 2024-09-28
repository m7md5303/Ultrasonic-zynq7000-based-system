module ControlUnit (clk,rst_n,sendEnable,ValidSignal,AmountSignal,increaseSignal,
decreaseSignal,onSignal,offSignal,outputDAC,rec_en,buf_in,send_enB,no_order,sending
,read_add,rd_en,read_data);
parameter FIFO_DATA=25;
//declaring ports and internal signals
input clk,rst_n,sendEnable,ValidSignal,increaseSignal,decreaseSignal,onSignal,offSignal,rec_en,rd_en;
input [7:0] AmountSignal;
input [24:0] buf_in;
input [6:0] read_add;
output send_enB,no_order,sending;
output [11:0] outputDAC;
output [FIFO_DATA-1:0] read_data;
wire order_full,order;
wire [6:0] wr_add;
wire wr_en;
wire [FIFO_DATA-1:0] AXI_OUT;
//instantiation of the sending unit
SendingUnit send(.clk(clk),.rst_n(rst_n),.order_full(order_full),.sendEnable(sendEnable),
.ValidSignal(ValidSignal),.AmountSignal(AmountSignal),.increaseSignal(increaseSignal),
.decreaseSignal(decreaseSignal),.onSignal(onSignal),
.offSignal(offSignal),.outputDAC(outputDAC),.order(order));
//instantiation of the receiving unit
Rec_unit receive(.rst_n(rst_n),.clk(clk),.rec_en(rec_en),
.buf_in(buf_in),.order_come(order),
.send_enB(send_enB),.AXI_OUT(AXI_OUT),.order_full(order_full),
.sending(sending),.no_order(no_order),.ramadd(wr_add),.valid(ValidSignal),.on(onSignal),.off(offSignal));
//declaring the ram in which the transmitted data is stored temporarily
curam ram(.clk(clk),.rst_n(rst_n),.wr_add(wr_add),.read_add(read_add),.wr_data(AXI_OUT),
.read_data(read_data),.wr_en(sending),.rd_en(rd_en));
endmodule


