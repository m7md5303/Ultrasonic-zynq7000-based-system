module rec_unittb ();
parameter FIFO_DATA = 25;
parameter ORDER_IMGS = 50;
logic  rst_n,clk,valid;
logic  rec_en; //the enable signal coming from the decoder
logic  [FIFO_DATA-1:0] buf_in; //the coming data from the buffer to be sent
logic order_come; //to be acknowledged that the user started a sending order
logic send_enB; //the enabling signal for the buffer to start sending the received processed data
logic [FIFO_DATA-1:0] AXI_OUT; //the logic through the AXI port to the PS unit
logic order_full; //indicating the system is unable to receive more orders
logic sending; //a flag indicating there is data transfer occuring
logic no_order; // a flag indicating no orders to send to the PS
logic [6:0] ramadd;
Rec_unit dut (.*);

initial begin
    clk=0;
    forever begin
        #10; clk=~clk;
    end
end
initial begin
    rst_n=0; @(negedge clk);
    rst_n=1;
    valid=1;
    rec_en=0;
    order_come=0;
    buf_in=10;
    repeat (1) @(negedge clk);


    rec_en=1;
    order_come=0;
    buf_in=10;
    repeat (1) @(negedge clk);

    rec_en=0;
    order_come=1;
    buf_in=10;
    repeat (1) @(negedge clk);


    rec_en=0;
    order_come=1;
    buf_in=10;
    repeat (1) @(negedge clk);
    rec_en=0;
    order_come=1;
    buf_in=10;
    repeat (1) @(negedge clk);


    rec_en=1;
    order_come=0;
    buf_in=10;
    repeat (50) @(negedge clk);
    rec_en=1;
    order_come=0;
    buf_in=20;
    @(negedge clk);
        rst_n=0; @(negedge clk);
    rst_n=1;
    rec_en=0;
    order_come=0;
    buf_in=10;
    repeat (1) @(negedge clk);


    rec_en=1;
    order_come=0;
    buf_in=10;
    repeat (1) @(negedge clk);

    rec_en=0;
    order_come=1;
    buf_in=10;
    repeat (1) @(negedge clk);


    rec_en=0;
    order_come=1;
    buf_in=10;
    repeat (1) @(negedge clk);
    rec_en=0;
    order_come=1;
    buf_in=10;
    repeat (1) @(negedge clk);


    rec_en=1;
    order_come=0;
    buf_in=10;
    repeat (50) @(negedge clk);
    rec_en=1;
    order_come=0;
    buf_in=20;
    @(negedge clk);
    $stop;
end




endmodule