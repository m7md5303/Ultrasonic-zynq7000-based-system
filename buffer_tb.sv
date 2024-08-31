`timescale 1ns / 1ps

module buffer_tb;

    // Parameters
    reg aclk;                        // Clock signal
    reg aresetn;                     // Reset signal (active low)
    
    // CPU interface signals
    reg CPU_read_request;            // CPU read request signal
    wire data_valid;                 // Data valid signal
    wire [24:0] buffer_data_out;     // Data output from buffer

    
    // Instantiate the buffer module
    buffer uut (
        .aclk(aclk),
        .aresetn(aresetn),
        .CPU_read_request(CPU_read_request),
        .data_valid(data_valid),
        .buffer_data_out(buffer_data_out)
    );
    

    // Clock generation
    initial begin
        aclk = 0;
        forever #5 aclk = ~aclk;  // 10ns period clock (100MHz)
    end

    // Reset sequence
    initial begin
        @(negedge aclk)
        aresetn = 0;                // Apply reset
        #20;
        aresetn = 1;                // Release reset after 20ns
    end

    // Test sequence
    initial begin
        // Initialize signals
        CPU_read_request = 0;

        // Wait for reset to be released
        @(posedge aresetn);         
       CPU_read_request=1;
        // End simulation
        #1000;
        $stop;
    end

endmodule
