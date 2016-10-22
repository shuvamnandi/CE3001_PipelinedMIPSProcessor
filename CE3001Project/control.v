//control unit for write enable and ALU control

`include "define.v"
module control(
  input [3:0] inst, 
  output reg wen,
  output reg mem_read,
  output reg mem_write,
  output reg regDst,
  output reg ALUSrc,
  output reg MemToReg,
  output reg branch,
  output reg jump,
  output reg jr,
  output reg jal,
  output reg [3:0] aluop
  );
  
  initial
  begin
	wen = 0;
	mem_read = 0;
	mem_write = 0;
	regDst = 0;
	ALUSrc = 0;
	MemToReg = 1;
	branch=0;
	jump=0;
	jr=0;
	jal=0;
  end
  
  always@(*)
 	 begin
		wen = 1;
		mem_read = 0;
		mem_write = 0;
		regDst = 0;
		ALUSrc = 0;
		MemToReg = 1;
		branch = 0;
		aluop = inst[3:0];
		jump=0;
		jr=0;
		jal=0;
		if(aluop==4'b1000) // LOAD WORD
		begin
			ALUSrc = 1;
			mem_read = 1;
			MemToReg = 0;
		end
		if(aluop==4'b1001) // STORE WORD 
		begin
			wen = 0;
			ALUSrc = 1;
			wen = 0;
			mem_write = 1;
			regDst = 1;
		end
		if(aluop==4'b0100|aluop==4'b0101)//SRL and SLL
		begin
			ALUSrc = 1;
		end
		if(aluop==4'b1010)// Branch if Equal
		begin
			wen = 0;
			branch = 1;
			regDst = 1;
		end
		if(aluop==4'b1011)// JMP
		begin
			wen = 0;
			jump = 1;
		end
		if(aluop==4'b1100)// JPR
		begin
			wen = 0;
			jr = 1;
		end
		if(aluop==4'b1101)// JAL
		begin
			wen = 1;
			jr = 1;
			jal = 1;
		end
	end
endmodule
