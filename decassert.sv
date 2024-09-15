module decsva (clk,rst_n,received_data,on,off,increase,decrease,valid,send,receive,amount);
parameter DATA_WIDTH = 15;
parameter AMOUNT_WIDTH = 8;
input clk,rst_n;
input [DATA_WIDTH-1:0] received_data;
input on,off,increase,decrease,valid,send,receive;
input [AMOUNT_WIDTH-1:0] amount;
//assertions
property resetcheck;
@(posedge clk) ($fell(rst_n)) |=>(!{on,off,increase,decrease,valid,send,receive,amount});
endproperty
assert property (resetcheck);

property validcheck;
@(posedge clk) disable iff(rst_n)((received_data[0]&&received_data[1])||(received_data[2]&&received_data[3])) |=>(!(valid));
endproperty
assert property (validcheck);

property sendcheck;
@(posedge clk) disable iff(!rst_n) ((received_data[5]&&received_data[6])) |=>((send));
endproperty
assert property (sendcheck);

property receivecheck;
@(posedge clk) disable iff(!rst_n)((received_data[4]&&received_data[6])) |=>((receive));
endproperty
assert property (receivecheck);

property increasecheck;
@(posedge clk) disable iff(!rst_n)((received_data[2]&&received_data[6]&&!received_data[3])) |=>((increase));
endproperty
assert property (increasecheck);

property decreasecheck;
@(posedge clk)disable iff(!rst_n) ((received_data[3]&&received_data[6]&&!received_data[2])) |=>((decrease));
endproperty
assert property (decreasecheck);




endmodule