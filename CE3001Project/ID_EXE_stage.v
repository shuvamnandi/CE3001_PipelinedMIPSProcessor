`include "define.v"

module ID_EXE_stage (
	
	input  clk,  rst, wen_in1, mem_read_in, mem_write_in, mem_to_reg_in, jal_in,
	input [`DSIZE-1:0] rdata1_in,
	input [`DSIZE-1:0] rdata2_in1,
	input [`DSIZE-1:0] rdata2_in2,
	input [`DSIZE-1:0] imm_in,
	input [3:0] opcode_in,
	input [`ASIZE-1:0]waddr_in, 
	input [`ISIZE-1:0]nPC_in,
	input branch_in,
	output reg wen_out1, mem_read_out, mem_write_out, mem_to_reg_out, jal_out,
	output reg [`DSIZE-1:0] rdata1_out,
	output reg [`DSIZE-1:0] rdata2_out1,
	output reg [`DSIZE-1:0] rdata2_out2,
	output reg [`DSIZE-1:0] imm_out,
	output reg [3:0] opcode_out,
	output reg[`ASIZE-1:0]waddr_out,
	output reg [`ISIZE-1:0]nPC_out,
	output reg branch_out
	);



//here we have not taken write enable (wen) as it is always 1 for R and I type instructions.
//ID_EXE register to save the values.

always @ (posedge clk) begin
	if(rst)
	begin
		wen_out1<=0;
		mem_read_out<=0;
		mem_write_out<=0;
		mem_to_reg_out<=0;
		waddr_out <= 0;
		rdata1_out <= 0;
		rdata2_out1 <= 0;
		rdata2_out2 <= 0;
		imm_out<=0;
		opcode_out<=0;
		nPC_out<=0;
		branch_out<=0;
		jal_out<=0;
	end
   else
	begin
		wen_out1<=wen_in1;
		mem_read_out<=mem_read_in;
		mem_write_out<=mem_write_in;
		mem_to_reg_out<=mem_to_reg_in;
		waddr_out <= waddr_in;
		rdata1_out <= rdata1_in;
		rdata2_out1 <= rdata2_in1;
		rdata2_out2 <= rdata2_in2;
		imm_out<=imm_in;
		opcode_out<=opcode_in;
		nPC_out<=nPC_in;
		branch_out<=branch_in;
		jal_out<=jal_in;
	end
 
end
endmodule


