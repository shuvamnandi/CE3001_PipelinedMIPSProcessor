// Register File module
`include "define.v"

module regfile (
	clk,
	rst,
	wen,
	raddr1, 
	raddr2, 
	waddr, 
	wdata, 
	rdata1,
	rdata2
	);


    
	input clk;
	input rst;
	input wen;
	input [`ASIZE-1:0] raddr1; 
	input [`ASIZE-1:0] raddr2; 
	input [`ASIZE-1:0] waddr; 
	input [`DSIZE-1:0] wdata; 

	output [`DSIZE-1:0] rdata1;
	output [`DSIZE-1:0] rdata2;



	reg [`DSIZE-1:0] regdata [0:`NREG-1];
	
integer i;

	always@(posedge clk)
		begin
			if(rst)
				begin
					for (i=0; i<`NREG; i=i+1)
						regdata[i] <=0;
					//Part 1 and 2
					regdata[1] <=5;//initialization regdata[1] is initialized with 5.
					regdata[2] <=1;//initialization regdata[2] is initialized with 1.
					regdata[3] <=4;//initialization regdata[3] is initialized with 4.
					regdata[5] <=1;//initialization regdata[5] is initialized with 4.
				end
			else
				regdata[waddr] <= ((wen == 1)) ? wdata : regdata[waddr];
		end
	assign rdata1 = ((wen) && (waddr == raddr1)) ? wdata : regdata[raddr1];
	assign rdata2 = ((wen) && (waddr == raddr2)) ? wdata : regdata[raddr2];

endmodule 
