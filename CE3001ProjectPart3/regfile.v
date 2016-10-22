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
					//Part 3
					regdata[0] <=6;//initialization regdata[0] 
					regdata[1] <=66;//initialization regdata[1]
					regdata[2] <=0;//initialization regdata[2] 
					regdata[3] <=1;//initialization regdata[3] 
					regdata[7] <=0;//initialization regdata[7] 
					regdata[8] <=66;//initialization regdata[8]
					
				end
			else
				regdata[waddr] <= ((wen == 1)) ? wdata : regdata[waddr];
		end
	assign rdata1 = ((wen) && (waddr == raddr1)) ? wdata : regdata[raddr1];
	assign rdata2 = ((wen) && (waddr == raddr2)) ? wdata : regdata[raddr2];

endmodule 
