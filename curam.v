module curam (clk,rst_n,wr_add,read_add,wr_data,read_data,wr_en,rd_en);
    input clk,rst_n,wr_en,rd_en;
    input [6:0] wr_add,read_add;
    input [24:0] wr_data;
    output [24:0] read_data;
    reg [24:0] read_data_tmp;

    //declaring the memory
    reg [24:0] curam [99:0]; 
    //write mechanism
    always @(posedge clk ) begin
        if(wr_en)begin
            curam [wr_add] <=wr_data;
        end
    end
    //read mechanism
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            read_data_tmp<=0;
        end
        else begin
            if(rd_en)begin
                read_data_tmp<=curam[read_add];
            end
        end
    end

assign read_data=read_data_tmp;

endmodule