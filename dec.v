module Decoder #(
    parameter DATA_WIDTH = 8  // Parameter for the width of received_data
)(
    input wire clk,                            // Clock signal
    input wire rst,                            // Reset signal (active high)
    input wire [DATA_WIDTH-1:0] received_data, // Parametrized input from the AXI interface
    output reg on,
    output reg off,
    output reg increase,
    output reg decrease,
    output reg valid,
    output reg receive,
    output reg send,
    output reg [DATA_WIDTH-1:0] amount // Parametrized amount for DAC
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

always @(posedge clk or posedge rst) begin
    if (rst) begin
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
        valid <= received_data[6];

        // If valid = 0, do nothing (keep previous states)
        if (valid) begin
            // Ensure on and off are inverses; if both are high or both are low, no action
            if (received_data[0] && ~received_data[1]) begin
                on <= 1;
                off <= 0;
            end else if (~received_data[0] && received_data[1]) begin
                on <= 0;
                off <= 1;
            end else begin
                on <= 0;
                off <= 0;
                valid=0;
            end

            // Ensure only one of increase or decrease is active at a time
            if (received_data[2] && ~received_data[3]) begin
                increase <= 1;
                decrease <= 0;
            end else if (~received_data[2] && received_data[3]) begin
                increase <= 0;
                decrease <= 1;
            end else begin
                increase <= 0;
                decrease <= 0;
                valid=0;
            end
            // Ensure only one of send or recieve is active at a time
            if (received_data[4] && ~received_data[5]) begin
                receive <= 1;
                send <= 0;
            end else if (~received_data[2] && received_data[3]) begin
                receive <= 0;
                send <= 1;
            end else begin
                receive <= 0;
                send <= 0;
                valid=0;
            end

            // The amount field is taken from the remaining bits of received_data
            amount <= received_data[DATA_WIDTH-1:7];

            
        end
    end
end

endmodule

