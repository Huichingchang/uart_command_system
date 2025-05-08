`timescale 1ns/1ps
module cdc_sync(
	input wire clk_dst, //目標時脈域(例如主系統)
	input wire rst,     //非同步置信號
	input wire signal_src,  //來源時脈域訊號(如rx_done)
	output reg signal_dst   //同步到目標域的版本
);

	reg sync_ff1, sync_ff2;
	
	always @(posedge clk_dst or posedge rst) begin
		if(rst) begin
			sync_ff1 <= 1'b0;
			sync_ff2 <= 1'b0;
			signal_dst <= 1'b0;
		end else begin
			sync_ff1 <= signal_src;
			sync_ff2 <= sync_ff1;
			signal_dst <= sync_ff2;
		end
	end
endmodule