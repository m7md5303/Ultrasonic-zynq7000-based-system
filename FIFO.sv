////////////////////////////////////////////////////////////////////////////////
// Author: Saber Mahmoud
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design with read and write acks
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO #(parameter FIFO_WIDTH = 32,
  parameter FIFO_DEPTH = 8
  )(
  input clk,
  input rst_n,
  input wr_en,
  input rd_en,
  input [FIFO_WIDTH-1:0] data_in,
  output reg [FIFO_WIDTH-1:0] data_out,
  output full,
  output  empty, 
  output reg wr_ack,
  output reg rd_ack
  );
  localparam max_fifo_addr = $clog2(FIFO_DEPTH);
  reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];
  reg [max_fifo_addr-1:0] wr_ptr=0, rd_ptr =0;
  reg [max_fifo_addr:0] count=0;

  initial begin

    for (int i = 0 ;i<FIFO_DEPTH ;i++) begin
      mem[wr_ptr] = i;
      wr_ack = 1;
      wr_ptr = wr_ptr + 1;
      count = count + 1;
    end


  end

  logic almostfull, almostempty, underflow;
  logic overflow;

  always @(posedge clk) begin
    if (!rst_n) begin
      // wr_ptr <= 0;
      // wr_ack <=0;
      // count <= 0;
    end
    //adding brakets to make sure the operations is in right sequence
    else if (wr_en && (count < FIFO_DEPTH)) begin
      mem[wr_ptr] <= data_in;
      wr_ack <= 1;
      wr_ptr <= wr_ptr + 1;
      count <= count + 1;
    end
    else begin 
      wr_ack <= 0; 
      //should be logic and(&&) not bit wise and (&) 
      if (full && wr_en)
        overflow <= 1;
      else
        overflow <= 0;
    end
  end

  always @(posedge clk) begin
    if (!rst_n) begin
      rd_ptr <= 0;
      underflow<=0;
      rd_ack<=0;
    end
    else if (rd_en && count != 0) begin
      data_out <= mem[rd_ptr];
      rd_ack<=1;
      rd_ptr <= rd_ptr + 1;
      count <= count - 1;
    end
    //making the underflow seq
    else begin  
      rd_ack<=0;
      if (empty && rd_en)
        underflow <= 1;
      else
        underflow <= 0;
    end
  end

  assign full = (count === FIFO_DEPTH) ? 1 : 0;
  assign empty = (count === 0) ? 1 : 0;
  assign almostfull = (count === FIFO_DEPTH-1) ? 1 : 0; 
  assign almostempty = (count === 1) ? 1 : 0;



endmodule
