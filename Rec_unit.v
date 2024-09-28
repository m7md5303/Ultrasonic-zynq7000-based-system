module Rec_unit (rst_n,clk,rec_en,buf_in,order_come,send_enB,AXI_OUT,order_full,sending,no_order,ramadd,valid,on,off);
parameter FIFO_DATA = 25;
parameter ORDER_IMGS = 50;
//declaring ports
input  rst_n,clk,valid,on,off;
input  rec_en; //the enable signal coming from the decoder
input  [FIFO_DATA-1:0] buf_in; //the coming data from the buffer to be sent
input order_come; //to be acknowledged that the user started a sending order
output send_enB; //the enabling signal for the buffer to start sending the received processed data
output [FIFO_DATA-1:0] AXI_OUT; //the output through the AXI port to the PS unit
output order_full; //indicating the system is unable to receive more orders
output sending; //a flag indicating there is data transfer occuring
output no_order; // a flag indicating no orders to send to the PS
output [6:0] ramadd;//for inserting data in the ramblock
//declaring regs
reg send_enB_tmp,sending_tmp;
reg [FIFO_DATA-1:0] AXI_OUT_tmp;
reg [6:0] ramadd_tmp;
//declaring internal regs
reg [2:0] order_count;//to indicate how many orders are there in the system
reg [5:0] imgs_rec; //indicating the number of samples received
reg [5:0] imgs_sent; //indicating the number of samples sent
wire finish_order;//to indicate a complete order was transferred
//determining the unit functioning enable
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        order_count<=0;
    end
    else begin
        if(order_come) begin
            if(order_count==5)begin
                if(finish_order)begin
                    order_count<=4;
                end
                else begin
                order_count<=5;
                end
            end
            else if(finish_order)begin
               order_count<=order_count; 
            end
            else begin
            order_count<=order_count+1;
            end
        end
        else if(finish_order)begin
            order_count<=order_count-1;
        end
    end
end
//determining the unit mechanism
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin //the resetting scenario
        send_enB_tmp<=0;
        AXI_OUT_tmp<=0;
        imgs_rec<=0;
    end
    else if (rec_en&&on&&!off&&(order_count>0)&&valid) begin
            if(imgs_rec==ORDER_IMGS)begin
                send_enB_tmp<=0;
                imgs_rec<=0;
            end
            else begin
                send_enB_tmp<=1;
                imgs_rec<=imgs_rec+1;
            end
        end
    end

//buffering the input data to the axi port
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        AXI_OUT_tmp<=0;
        imgs_sent<=0;
        sending_tmp<=0;
        ramadd_tmp<=0;
    end
    else if(rec_en&&on&&!off&&(order_count>0)&&valid)begin
        //getting the amount of images sent and handling the finish order signal
        if(imgs_sent==ORDER_IMGS)begin
            imgs_sent<=0;
            sending_tmp<=0;
        end
        else begin
            sending_tmp<=1;
            imgs_sent=imgs_sent+1;
        end
        //sending data through the AXI port
        AXI_OUT_tmp<=buf_in;
        if(ramadd_tmp==99)begin
            ramadd_tmp<=0;
        end
        else begin
        ramadd_tmp<=ramadd_tmp+1;            
        end
    end
end



assign finish_order = (imgs_sent==ORDER_IMGS) ? 1 : 0;
assign order_full = (order_count==5)? 1 : 0;
assign send_enB = send_enB_tmp;
assign sending = sending_tmp;
assign no_order = (!rst_n) ? 1 : (order_count==0) ? 1 : 0;
assign AXI_OUT = AXI_OUT_tmp;
assign ramadd=ramadd_tmp;

endmodule //Rec_unit