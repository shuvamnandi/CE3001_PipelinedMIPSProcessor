`timescale 1ns / 1ps
`include "define.v"

module EXE_DM_stage(
    input clk, rst, wen_in2, mem_read_in, mem_write_in, mem_to_reg_in, jal_in,
	 input [`ASIZE-1:0] waddr_in, 
	 input [`DSIZE-1:0] aluout_in,
	 input [`DSIZE-1:0] read_data2_in,
    input [`ISIZE-1:0] nPC_in,
	 output reg wen_out2, mem_read_out, mem_write_out, mem_to_reg_out, jal_out, 
	 output reg[`ASIZE-1:0] waddr_out,
	 output reg[`DSIZE-1:0] aluout_out,
	 output reg[`DSIZE-1:0] read_data2_out,
	 output reg[`ISIZE-1:0] nPC_out
    );
	 
always@(posedge clk)
begin
	if(rst)
	begin
		wen_out2<=0;
		mem_read_out<=0;
		mem_write_out<=0;
		mem_to_reg_out<=0;
		waddr_out<=0;
		aluout_out<=0;
		read_data2_out<=0;
		jal_out<=0;
		nPC_out<=0;
	end
	else begin
		wen_out2<=wen_in2;
		mem_read_out<=mem_read_in;
		mem_write_out<=mem_write_in;
		mem_to_reg_out<=mem_to_reg_in;
		waddr_out<=waddr_in;
		aluout_out<=aluout_in;
		read_data2_out<=read_data2_in;
		jal_out<=jal_in;
		nPC_out<=nPC_in;
	end
end
endmodule
