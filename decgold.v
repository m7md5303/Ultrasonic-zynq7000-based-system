module decgold (clk,rst_n,received_data,on,off,increase,decrease
,valid,send,receive,amount);
parameter DATA_WIDTH = 32;
parameter AMOUNT_WIDTH = 8;
input clk,rst_n;
input [DATA_WIDTH-1:0] received_data;
output reg on,off,increase,decrease,valid,send,receive;
output reg [AMOUNT_WIDTH-1:0] amount;

// Bits assignment within the received_data word
// Bit 0: On
// Bit 1: Off
// Bit 2: Increase
// Bit 3: Decrease
// Bit 4: Receive
// Bit 5: Send
// Bit 6: Valid
// Bits [DATA_WIDTH-1:7]: Amount (remaining bits)


always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        on<=0;
        off<=0;
        increase<=0;
        decrease<=0;
        valid<=0;
        send<=0;
        receive<=0;
        amount<=0;
    end
    else begin
        if((received_data[6])&&(!(received_data[0]&&received_data[1]))&&(!(received_data[2]&&received_data[3])))begin
        on<=received_data[0];
        off<=received_data[1];
        increase<=received_data[2];
        decrease<=received_data[3];
        valid<=received_data[6];
        send<=received_data[5];
        receive<=received_data[4];
        amount<=received_data[DATA_WIDTH-1:7];
        end
        else begin
        on<=0;
        off<=0;
        increase<=0;
        decrease<=0;
        valid<=0;
        send<=0;
        receive<=0;
        amount<=0;
        end
    end
end



endmodule //decgold