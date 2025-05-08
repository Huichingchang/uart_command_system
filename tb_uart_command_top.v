`timescale 1ns/1ps
module tb_uart_command_top;

	reg clk, rst, rx;
	wire tx, led;
	
	// Instantiation of top module
	uart_command_top uut(
		.clk(clk),
		.rst(rst),
		.rx(rx),
		.tx(tx),
		.led(led)
	);
	
	// 50MHz clock = 20ns period
	always #10 clk = ~clk;
	
   // 傳送 UART byte (LSB first)
	task send_uart_byte(input [7:0] data);
		integer i;
		begin	 
			$display("[%t] Sending UART Byte: 0x%h", $time, data);
			rx = 0;  // start bit
			#160;  // 假設1/baud = 160ns
			
			// data bits (LSB first)
			for (i = 0; i < 8; i = i + 1) begin
				rx = data[i];
				#160;
			end
			
			rx = 1; // stop bit
			#160;
		end
	endtask 
	
	//初始化與UART傳輸指令A1
	initial begin
		clk = 0;
		rst = 1;
		rx = 1;
		
		#100;
		rst = 0;
		#100;
		
	   //===傳送指令 0xA1: LED ON ===
		send_uart_byte(8'hA1);
		$display("時間%t: 發送指令0xA1(LED ON)", $time);
		#2000;
	
		//===傳送指令 0xA2: LED OFF ===
		send_uart_byte(8'hA2);
		$display("[%t] Sent CMD A2 (LED OFF)", $time);
		#2000;
		
		//===傳送指令 0xB1: READ LED ===
		send_uart_byte(8'hB1);
		$display("[%t] Sent CMD B1 (READ LED)", $time);
		#2000;
		
		//===傳送指令 0xC1: RESET ===
		send_uart_byte(8'hC1);
		$display("[%t] Sent CMD C1 (RESET)", $time);
		#2000;
		
		$display("[%t] Simulation complete", $time);
		$finish;
	end
	


endmodule
