`timescale 1ns / 1ps
`include "define.v"

module DM_WB_stage(
    input clk, rst, MemtoReg_in, wen_in,
    input [`DSIZE-1:0] aluout_in,
    input [`ASIZE-1:0] waddr_in,
	 input [`DSIZE-1:0] dm_in,
	 output reg [`DSIZE-1:0] dm_out,
    output reg wen_out,
    output reg MemtoReg_out,
    output reg [`DSIZE-1:0]aluout_out,
    output reg [`ASIZE-1:0] waddr_out
    );
always @(posedge clk)
begin
	if(rst)
	begin
		wen_out<=0;
		MemtoReg_out<=0;
		aluout_out<=0;			
		waddr_out<=0;
		dm_out<=0;
	end
	else
	begin
		dm_out<=dm_in;
		wen_out<=wen_in;
		MemtoReg_out<=MemtoReg_in;
		aluout_out<=aluout_in;
		waddr_out<=waddr_in;
	end
end
endmodule
