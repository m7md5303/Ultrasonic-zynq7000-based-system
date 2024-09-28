interface sonar_inter(clk);
parameter DATA_WIDTH = 32;
parameter FIFO_DATA=25;
    input bit clk;          
    logic rst_n;                      
    logic [6:0] read_add;           
    logic [DATA_WIDTH-1:0] received_data; 
    logic rd_en;                    
    logic [FIFO_DATA-1:0] read_data; 
    logic no_order;                 
    logic [11:0] outputDAC;         

 modport dut_mp (
        input clk,
        input rst_n,
        input  read_add,
        input  received_data,
        input rd_en,
        output  read_data,
        output no_order,
        output outputDAC
    );
endinterface 