`include "define.v"// defines


module alu(
   a,   //1st operand
   b,   //2nd operand
   op,   //4-bit operand
   imm,   //16-bit immediate operand for shift/rotate
   out,   //output
	zero   //zer flag bit for branch 
   );

   input [`DSIZE-1:0] a, b;
   input [3:0] op;
   input [`DSIZE-1:0] imm;
   output reg [`DSIZE-1:0] out;
   output reg zero;
	
      
always @(a or b or op or imm)
begin
   case(op)
       `ADD: out = a+b;
       `SUB: out = a - b;
       `AND: out = a & b;
       `XOR: out = a^b;
       `SLL: out = a << imm;
       `SRL: out = a >> imm;
       `COM: out = a<=b;
       `MUL: out = a*b;
       `LW: out = a + imm;
		 `SW: out = a + imm;
		 `BEQ: out = a - b;

   endcase
	
	if(out==0)
		zero=1;
	else
		zero=0;
end

endmodule
   
       
