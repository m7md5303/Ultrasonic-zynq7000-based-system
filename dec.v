module Decoder #(
    parameter DATA_WIDTH = 32,  // Parameter for the width of received_data
    parameter AMOUNT_WIDTH = 8 // Parameter for the width of received_data
)(
    input wire clk,                            // Clock signal
    input wire rst_n,                            // Reset signal (active high)
    input wire [DATA_WIDTH-1:0] received_data, // Parametrized input from the AXI interface
    output reg on,
    output reg off,
    output reg increase,
    output reg decrease,
    output reg valid,
    output reg receive,
    output reg send,
    output reg [AMOUNT_WIDTH-1:0] amount // Parametrized amount for DAC
);

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
    if (!rst_n) begin
        // Reset all outputs to their default state
        on <= 0;
        off <= 0;
        increase <= 0;
        decrease <= 0;
        valid <= 0;
        receive <= 0;
        send <= 0;
        amount <= 0;
    end else begin
        // Update valid signal

        // If valid = 0, do nothing (keep previous states)
            // Ensure on and off are inverses; if both are high or both are low, no action
            if (received_data[0] && ~received_data[1]) begin
                on <= 1;
                off <= 0;
            end else if (~received_data[0] && received_data[1]) begin
                on <= 0;
                off <= 1;
              end else if(~received_data[0]&&~received_data[1])begin 
                on<=0;
                off<=0;
            end
             else begin
                on <= 0;
                off <= 0;
                amount <= 0;
            end

            // Ensure only one of increase or decrease is active at a time
            if (received_data[2] && ~received_data[3]) begin
                increase <= 1;
                decrease <= 0;
            end else if (~received_data[2] && received_data[3]) begin
                increase <= 0;
                decrease <= 1;
            end else if(~received_data[2]&&~received_data[3])begin 
                increase<=0;
                decrease<=0;
            end
                else begin
                increase <= 0;
                decrease <= 0;
                amount <= 0;
            end
            //send & receive
            send<=received_data[5];
            receive<=received_data[4];
            // The amount field is taken from the remaining bits of received_data
            amount <= received_data[14:7];
            //valid
            if((!(received_data[2]&&received_data[3]))&&(!(received_data[0]&&received_data[1]))&&received_data[6])begin
                valid<=1;
            end
            else begin
                valid<=0;
            end
        end
    end


endmodule

