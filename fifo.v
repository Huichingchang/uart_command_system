module fifo #(
	parameter DATA_WIDTH = 8,
	parameter DEPTH = 16
)(
	input wire clk,
	input wire rst,
	input wire wr_en,
	input wire rd_en,
	input wire [DATA_WIDTH-1:0] din,
	output reg [DATA_WIDTH-1:0] dout,
	output reg full,
	output reg empty
	
);
	localparam PTR_WIDTH = $clog2(DEPTH);

	reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
	reg [PTR_WIDTH-1:0] wr_ptr, rd_ptr;
	reg [PTR_WIDTH:0] count;
	
	always @(posedge clk or posedge rst) begin
	     if (rst) begin
		wr_ptr <= 0;
		rd_ptr <= 0;
		count <= 0;
		full <= 0;
		empty <= 1;
	     end else begin
	         if (wr_en && !full) begin
	            mem[wr_ptr]  <= din;
	            wr_ptr <= wr_ptr + 1;
		    count <= count + 1;
		 end
		 if (rd_en && !empty) begin
		    dout <= mem[rd_ptr];
		    rd_ptr <= rd_ptr + 1;
		    count <= count - 1;
		 end
		 full <= (count == DEPTH);
		 empty <= (count == 0);
	     end
	end
endmodule	