module goldenmodel (golden_inter_ref.DUT_gold golddut);
logic clk,rst_n;

logic no_order;
logic [11:0] outputDAC;
logic [golddut.DATA_WIDTH-1:0] received_data;
logic on,off,send,increase,decrease,order_came,valid,receive,finished_order;
logic [7:0] amount;
//
assign clk = golddut.clk;
assign rst_n = golddut.rst_n;
assign received_data = golddut.received_data;
//
always @(*) begin
assign golddut.no_order = no_order;
assign golddut.outputDAC = outputDAC;    
end
//
int order_count,img_count;
//
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        order_count<=0;
        img_count<=0;
        outputDAC<=0;
        amount<=0;
        order_came<=0;
        on<=0;
        off<=0;
        increase<=0;
        decrease<=0;
        receive<=0;
        send<=0;
        valid<=0;
    end
    else begin
        on<=received_data[0];
        off<=received_data[1];
        increase<=received_data[2];
        decrease<=received_data[3];
        receive<=received_data[4];
        send<=received_data[5];
        valid<=received_data[6];
        amount<=received_data[14:7];
        ////////////////////////////
        if(on&&!off&&valid&&(increase^decrease)&&send&&order_count<5)begin
            order_came<=1;
            if(increase)begin
                 outputDAC <= outputDAC + amount*16;
            end
            else if (decrease)begin
                outputDAC <= outputDAC - amount*16;
            end
        end
        else if(on&&!off&&valid&&!(increase||decrease)&&send&&order_count<5)begin
            outputDAC<=outputDAC;
            order_came<=1;
        end
        else begin
            order_came<=0;
            outputDAC<=0;
        end
        ////////////////////////////
        if(order_came)begin
            if(order_count==5)begin
                if(finished_order)begin
                    order_count<=4;
                end
                else begin
                  order_count<=5;  
                end
            end
            else if (finished_order)begin
                order_count<=order_count;
            end
            else begin
                order_count<=order_count+1;
            end
        end
        else if(finished_order) begin
            if(order_count==0) begin
                order_count<=0;
            end
            else begin
            order_count<=order_count-1;
            end
        end
        ////////////////////////////
        if(on&&!off&&valid&&!(increase&&decrease)&&receive&&order_count>0)
            if(img_count==50)begin
                img_count=0;
            end
            else begin
                img_count<=img_count+1;
            end
    end
end
//
assign finished_order = (img_count==50)? 1: 0;
assign no_order = (!rst_n)? 1 : (!order_count)? 1 : 0;
endmodule //goldenmodel