`timescale 1ns / 1ps
`include "define.v"

module pipelined_regfile_4stage(clk, rst, fileid, PCOUT,res, INST, aluop, rdata1, rdata2, rdata1_ID_EXE, rdata2_ID_EXE_mux, rdata2_ID_EXE_pure, aluop_ID_EXE, waddr_out_ID_EXE, aluout, waddr_out_EXE_WB, aluout_EXE_WB,aluout_DM_WB,waddr_out_DM_WB,dm_out_DM_WB,branch_out_ID_EXE);

input clk;													
input	rst;
input fileid; 
output [`DSIZE-1:0] dm_out_DM_WB;//Third Pipeline variable
output [`DSIZE-1:0] aluout_DM_WB;//Third Pipeline variable
output [`ASIZE-1:0] waddr_out_DM_WB;//Third Pipeline variable
output [`ISIZE-1:0] PCOUT;
output [`DSIZE-1:0] rdata1;
output [`DSIZE-1:0] rdata1_ID_EXE;
output [`DSIZE-1:0] rdata2;
output [`DSIZE-1:0] rdata2_ID_EXE_mux;
output [`DSIZE-1:0] rdata2_ID_EXE_pure;
output [`ISIZE-1:0] res;
output [`DSIZE-1:0] INST;
output [3:0] aluop;
output [3:0] aluop_ID_EXE;
output [`ASIZE-1:0] waddr_out_ID_EXE;	
output [`DSIZE-1:0] aluout;				
output [`ASIZE-1:0] waddr_out_EXE_WB;	
output [`DSIZE-1:0] aluout_EXE_WB;
output branch_out_ID_EXE; // No idea if we can give this as an output, nevertheless, I gave it									
 	 
//Program counter
wire [`ISIZE-1:0]PCIN;
wire [`ISIZE-1:0]nPC_out_ID_EXE;
wire mem_read;
wire mem_read_ID_EXE;
wire mem_read_EXE_WB;
wire PCSrc; // The output of the branch and zero And Gate
wire mem_write;
wire mem_write_ID_EXE;
wire mem_write_EXE_WB;
wire MemtoReg_DM_WB;//Third pipleine variable
wire wen_out_DM_WB;//Third pipeline variable
wire mem_to_reg;
wire mem_to_reg_ID_EXE;
wire mem_to_reg_EXE_WB;
wire zero_out; // For the branch instruction
wire wen;
wire wen_out_ID_EXE;
wire wen_out_EXE_WB;
wire [`DSIZE-1:0] rdata2_EXE_WB;
wire [`DSIZE-1:0] dm_data_out;
wire branch_cont; // The wire which is coming out of the control having thr branch bit
wire reg_dst;
wire alu_src;
wire [`ASIZE-1:0] read_addr2;
wire [`DSIZE-1:0] alu_input2;
wire [`DSIZE-1:0] write_data_reg;
wire [`ISIZE-1:0] PC_value;

assign PCSrc=(branch_out_ID_EXE)&&(zero_out); // The and gate to choose whether to take the branch or not
assign PCIN = PCOUT + 16'b1; //increments PC to PC +1
assign PC_value = (PCSrc==1) ? (res):(PCIN); 
PC1 pc(.clk(clk),.rst(rst),.nextPC(PC_value),.currPC(PCOUT));//PCOUT is your PC value and PCIN is your next PC
//instruction memory
instruction_memory im( .clk(clk), .rst(rst), .mem_read(1'b1), .wen(1'b0), .addr(PCOUT), .data_in(16'b0), .fileid(4'b0),.data_out(INST));//note that memory read is having one clock cycle delay as memory is a slow operation

data_memory dm( .clk(clk), .rst(rst), .wen(mem_write_EXE_WB), .mem_read(mem_read_EXE_WB), .addr(aluout_EXE_WB), .data_in(rdata2_EXE_WB), .fileid(4'b0010), .data_out(dm_data_out));

//here we are not taking the multiplexers for initialization as initialization is done within reg file itself.


control C0 (.inst(INST[15:12]),.wen(wen), .aluop(aluop), .mem_read(mem_read), .mem_write(mem_write), .regDst(reg_dst), .ALUSrc(alu_src), .MemToReg(mem_to_reg),.branch(branch_cont));

assign read_addr2=(reg_dst==1)? INST[11:8]: INST[3:0]; // The multiplexer which is supposed to either take rt/imm or rd


regfile  RF0 ( .clk(clk), .rst(rst), .wen(wen_out_DM_WB), .raddr1(INST[7:4]), .raddr2(read_addr2), .waddr(waddr_out_DM_WB), .wdata(write_data_reg), .rdata1(rdata1), .rdata2(rdata2));//note that waddr needs to come from pipeline register 


//sign extension for immediate needs to be done for I type instuction.
//you can add that here
wire [`DSIZE-1:0] imm;
wire [`DSIZE-1:0] imm_ID_EXE;
assign imm={{12{INST[3]}}, {{INST[3:0]}}};
assign alu_input2=(alu_src==1)?imm:rdata2;
assign res=imm_ID_EXE+nPC_out_ID_EXE; // the adder for the branch instruction
ID_EXE_stage PIPE1(.clk(clk), .rst(rst), .wen_in1(wen),.nPC_in(PCIN), .mem_read_in(mem_read), .mem_write_in(mem_write), .mem_to_reg_in(mem_to_reg), .rdata1_in(rdata1), .rdata2_in1(alu_input2), .rdata2_in2(rdata2), .imm_in(imm),.opcode_in(aluop), .waddr_in(INST[11:8]), .wen_out1(wen_out_ID_EXE), .mem_read_out(mem_read_ID_EXE), .mem_write_out(mem_write_ID_EXE), .mem_to_reg_out(mem_to_reg_ID_EXE), .waddr_out(waddr_out_ID_EXE), .imm_out(imm_ID_EXE), .rdata1_out(rdata1_ID_EXE), .rdata2_out1(rdata2_ID_EXE_mux), .rdata2_out2(rdata2_ID_EXE_pure),.nPC_out(nPC_out_ID_EXE), .opcode_out(aluop_ID_EXE),.branch_in(branch_cont),.branch_out(branch_out_ID_EXE));

alu ALU0 (.a(rdata1_ID_EXE), .b(rdata2_ID_EXE_mux), .op(aluop_ID_EXE), .imm(imm_ID_EXE), .out(aluout),.zero(zero_out));//ALU takes its input from pipeline register

EXE_DM_stage PIPE2(.clk(clk), .rst(rst), .wen_in2(wen_out_ID_EXE), .mem_read_in(mem_read_ID_EXE), .mem_write_in(mem_write_ID_EXE), .mem_to_reg_in(mem_to_reg_ID_EXE), .waddr_in(waddr_out_ID_EXE), .aluout_in(aluout), .read_data2_in(rdata2_ID_EXE_pure), .wen_out2(wen_out_EXE_WB), .mem_read_out(mem_read_EXE_WB), .mem_write_out(mem_write_EXE_WB), .mem_to_reg_out(mem_to_reg_EXE_WB), .waddr_out(waddr_out_EXE_WB), .aluout_out(aluout_EXE_WB), .read_data2_out(rdata2_EXE_WB));

assign write_data_reg=(MemtoReg_DM_WB==1)? (aluout_DM_WB) : (dm_out_DM_WB); // write_data_reg is to be written in Register file
//This is the instantiation of the third pipeline, now just need to change the variables in other modules' instantiation
DM_WB_stage PIPE3(.clk(clk),.rst(rst),.MemtoReg_in(mem_to_reg_EXE_WB),.wen_in(wen_out_EXE_WB),.aluout_in(aluout_EXE_WB),.waddr_in(waddr_out_EXE_WB),.dm_in(dm_data_out),.dm_out(dm_out_DM_WB),.wen_out(wen_out_DM_WB),.MemtoReg_out(MemtoReg_DM_WB),.aluout_out(aluout_DM_WB),.waddr_out(waddr_out_DM_WB));

endmodule
