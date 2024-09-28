module TOP (clk,rst_n,received_data,no_order,outputDAC,read_add,rd_en,read_data);
//decleration of parameters
parameter DATA_WIDTH = 32;  // Parameter for the width of received_data
parameter FIFO_DATA=25;
//declaration of ports
input clk,rst_n;
input[6:0] read_add;
input  [DATA_WIDTH-1:0] received_data; // Parametrized input from the AXI interface
input rd_en;
output [FIFO_DATA-1:0] read_data;
output no_order;
output [11:0]outputDAC;
// Declarition of the wire signals.
wire clk,rst_n,send_enB,data_valid,send,valid,increase,decrease,on,off,receive,no_order,sending;
wire [7:0] amount;
wire [FIFO_DATA-1:0] read_data,buf_in;
// The Instantiation of the modules.
//buffer
buffer buf_top(
    .aclk(clk),                        // Clock signal
    .aresetn(rst_n),                        // Reset signal
    //cpu interface
    .CPU_read_request(send_enB),           //cpu wants to Read data
     .data_valid(data_valid),
     .buffer_data_out(buf_in)     // Data output to AXI interface
);
//control unit
ControlUnit cutop(.clk(clk),.rst_n(rst_n),.sendEnable(send),
.ValidSignal(valid),.AmountSignal(amount),.increaseSignal(increase),
.decreaseSignal(decrease),.onSignal(on),.offSignal(off),.outputDAC(outputDAC),.rec_en(receive),
.buf_in(buf_in),.send_enB(send_enB),.no_order(no_order),.sending(sending)
,.read_add(read_add),.rd_en(rd_en),.read_data(read_data));
//decoder
Decoder dectop(
    .clk(clk),                            // Clock signal
    .rst_n(rst_n),                            // Reset signal (active high)
    .received_data(received_data), // Parametrized input from the AXI interface
    .on(on),
    .off(off),
    .increase(increase),
    .decrease(decrease),
    .valid(valid),
    .receive(receive),
    .send(send),
    .amount(amount) // Parametrized amount for DAC
);

endmodule //TOP