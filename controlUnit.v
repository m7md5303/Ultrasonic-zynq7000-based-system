module ControlUnit (clk,rst_n,sendEnable,ValidSignal,AmountSignal,increaseSignal,
decreaseSignal,onSignal,offSignal,outputDAC,rec_en,buf_in,send_enB,AXI_OUT,no_order);
//declaring ports and internal signals
input clk,rst_n,sendEnable,ValidSignal,increaseSignal,decreaseSignal,onSignal,offSignal,rec_en;
input [7:0] AmountSignal;
input [24:0] buf_in;
output send_enB,AXI_OUT,no_order;
output [11:0] outputDAC;
wire order_full,order;
//instantiation of the sending unit
SendingUnit send(.clk(clk),.rst_n(rst_n),.order_full(order_full),.sendEnable(sendEnable),
.ValidSignal(ValidSignal),.AmountSignal(AmountSignal),.increaseSignal(increaseSignal),
.decreaseSignal(decreaseSignal),.onSignal(onSignal),
.offSignal(offSignal),.outputDAC(outputDAC),.order(order));
//instantiation of the receiving unit
Rec_unit receive(.rst_n(rst_n),.clk(clk),.rec_en(rec_en),
.buf_in(buf_in),.order_come(order),
.send_enB(send_enB),.AXI_OUT(AXI_OUT),.order_full(order_full),
.sending(sending),.no_order(no_order));

endmodule


