module buffer (
    input wire aclk,                        // Clock signal
    input wire aresetn,                        // Reset signal
    //cpu interface
    input wire CPU_read_request,           //cpu wants to Read data
    output reg data_valid,
    output reg [24:0] buffer_data_out     // Data output to AXI interface

);

    //fifo interface
    wire [11:0] fifo_rd_data;         // Data from FIFO (12 bits)
    wire fifo_empty;                 //fifo empty signal to privent reading when the fifo is empty 
    reg fifo_rd_en;               // request data from the fifo


    // Registers for image tags and data tracking
    reg [4:0] momentary_image_out='b0;  // Momentary image tag output
    reg [3:0] order_image_out='b0;      // Order image tag output
    reg [3:0] sending_order_out='b0;     // Sending order tag output


    // Averaging variables
    wire [12:0] sum;
    wire [12:0] average;
    reg [11:0] last_data;
    reg [11:0] before_last_data;

    //calculate the sum of the last two proccessed datas
    assign sum = last_data +before_last_data;

    //calculate the average
    assign average=sum >> 1;


     // FIFO Instantiation
FIFO #(
  .FIFO_WIDTH(12),  // Set the FIFO width
  .FIFO_DEPTH(100)   // Set the FIFO depth
) fifo_inst (
  .clk(aclk),                // Connect the clock signal
  .rst_n(aresetn),            // Connect the reset signal (active low)
  .wr_en(),            // Connect the write enable signal
  .rd_en(fifo_rd_en),            // Connect the read enable signal
  .data_in(),        // Connect the data input bus
  .data_out(fifo_rd_data),      // Connect the data output bus
  .full(),              // Connect the full flag output
  .empty(fifo_empty),             // Connect the empty flag output
  .wr_ack(),                //connect the write ack signal
  .rd_ack()                  //connect the read ack signal
);



    always @(posedge aclk) begin
        if (!aresetn) begin
            buffer_data_out <= 25'b0;
            momentary_image_out <= 'b1;
            order_image_out <= 'b1;
            sending_order_out <= 'b1;
            last_data<='b0;
            before_last_data<='b0;
            data_valid<='b0;
            fifo_rd_en<='b0;
        end else begin
            // Read from buffer
            if (CPU_read_request && fifo_empty==1'b0 && fifo_rd_en==1'b0) begin
                fifo_rd_en<=1'b1;
                data_valid<=0;
            end 
            else if(CPU_read_request && fifo_rd_en==1'b1)begin
                // fifo_rd_en<='b0;
                if(momentary_image_out>2 && (fifo_rd_data<(2*average)+300) )begin
                    buffer_data_out<={fifo_rd_data,momentary_image_out,order_image_out,sending_order_out};
                    last_data<=fifo_rd_data;
                end
                else begin
                    buffer_data_out<={average,momentary_image_out,order_image_out,sending_order_out};
                    last_data<=average;
                end
                data_valid<=1;
                before_last_data<=last_data;
                momentary_image_out<=momentary_image_out+1;
                if(momentary_image_out== 10 )begin
                    momentary_image_out<=0;
                    order_image_out<=order_image_out+1;
                end
                if(order_image_out== 5 )begin
                    order_image_out<=0;
                    sending_order_out<=sending_order_out+1;
                end
            end else begin
                fifo_rd_en<=0;
            end
        end
    end

endmodule
