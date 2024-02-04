/*module ALU(A,B,Result,ALUControl,Overflow,Carry,Zero,Negative);
   
    input [31:0] A,B;
    input [2:0] ALUControl;
    output [31:0] Overflow,Carry,Zero,Negative;
    output [31:0] Result;

    // Interim wire
    wire [31:0] a_or_b;
    wire [31:0] a_and_b;
    wire [31:0] not_b;
    wire [31:0] mux_1;
    wire [31:0] Sum;
    wire [31:0] mux_2;
    wire [31:0] slt;

    // logical design:

    // AND Operation
    assign a_and_b = A & B;

    // OR Operation
    assign a_or_b = A | B;

    // NOT Operation
    assign not_b = ~B;

    // Ternary Operator (implement Mux for 2's compliment to get subtraction operation)
    assign mux_1 = (ALUControl[0] == 1'b0) ? B : not_b;

    // Addition / Subtraction Operation
    assign {cout,Sum} = A + mux_1 + ALUControl[0];

    //zero Extension
    assign slt = {31'b0000000000000000000000000000000,Sum[31]};

    // Designing 4 by 1 Mux
    assign mux_2 = (ALUControl[2:0] == 3'b000) ? Sum : 
                   (ALUControl[2:0] == 3'b001) ? Sum :
                   (ALUControl[2:0] == 3'b010) ? a_and_b :
                   (ALUControl[2:0] == 3'b011) ? a_or_b :
                   (ALUControl[2:0] == 3'b101) ? slt : 32'h00000000 ; 
    
    assign Result = mux_2;

    // Flags Asignment

    // zero flag
    assign Zero = &(~Result);      /* if all the bits are zeros(0000) first do 1's complement(1111) then
                                      ANDing them would result 1 (flags 1 for on and 0 for off)*/
    // Negative flag
    /*assign Negative = Result[31];  // MSB of Result i.e 31st bit check number's signs.

    // Carry flag
    assign Carry = cout & (~ALUControl[1]);   

    //Overflow flag
    assign Overflow = (~ALUControl[1]) & (A[31] ^ Sum[31]) & (~(A[31] ^ B[31] ^ ALUControl[0]));


endmodule*/

module ALU(A,B,Result,ALUControl,OverFlow,Carry,Zero,Negative);

    input [31:0]A,B;
    input [2:0]ALUControl;
    output Carry,OverFlow,Zero,Negative;
    output [31:0]Result;

    wire Cout;
    wire [31:0]Sum;

    assign {Cout,Sum} = (ALUControl[0] == 1'b0) ? A + B :
                                          (A + ((~B)+1)) ;
    assign Result = (ALUControl == 3'b000) ? Sum :
                    (ALUControl == 3'b001) ? Sum :
                    (ALUControl == 3'b010) ? A & B :
                    (ALUControl == 3'b011) ? A | B :
                    (ALUControl == 3'b101) ? {{31{1'b0}},(Sum[31])} : {32{1'b0}};
    
    assign OverFlow = ((Sum[31] ^ A[31]) & 
                      (~(ALUControl[0] ^ B[31] ^ A[31])) &
                      (~ALUControl[1]));
    assign Carry = ((~ALUControl[1]) & Cout);
    assign Zero = &(~Result);
    assign Negative = Result[31];

endmodule