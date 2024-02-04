`include "PC.v"
`include "Instruction_memory.v"
`include "Register_file.v"
`include "Sign_extend.v"
`include "ALU.v"
`include "Control_Unit_Top.v"
`include "Data_memory.v"
`include "PC_Adder.v"

module Single_cycle_top(clk,rst);
   input clk,rst;

   //Declaration of internal wires
   wire [31:0] PCF;                         //wire between Instruction_Memory and Register_file
   wire [31:0] InstrF;                      //wire between program_counter and Instruction_Memory
   wire [31:0] RD1_TOP;                     //wire between Register_file and ALU
   wire [31:0] Imm_Ext_TOP;                 //wire between Imm_Ext and ALU  
   wire [2:0] ALUControl_TOP;               //wire between control_unit and ALU 
   wire [31:0] ALU_Result;                  //wire between ALU and Data_memory 
   wire RegWrite;                           //wire between Control_Unit and Register_file 
   wire [31:0] ReadData;                    //wire between Data_memory and Register_file
   wire [31:0] PCPlus4;                     //wire between PC_Adder and PC
   wire [31:0] RD2_TOP;                     //wire between Register_file and Data_memory
   wire [1:0] ImmSrc;
   wire MemWrite;


   PC_Module PC(.clk(clk),
                .rst(rst),
                .PC(PCF),
                .PC_Next(PCPlus4)
                );

    PC_Adder PC_Adder(
                      .a(PCF),
                      .b(32'd4),
                      .c(PCPlus4)
                     );
    Instruction_Memory IM(.rst(rst),
                          .A(PCF),
                          .RD(InstrF)
                          );

    Register_file Reg_file(.A1(InstrF[19:15]),
                           .A2(InstrF[24:20]),
                           .A3(InstrF[11:7]),
                           .WD3(ReadData),
                           .WE3(RegWrite),
                           .RD1(RD1_TOP),
                           .RD2(RD2_TOP),
                           .clk(clk),
                           .rst(rst)
                           );
   
    Sign_Extend Sign_Ext(.In(InstrF),
                         .ImmSrc(ImmSrc[0]),
                         .Imm_Ext(Imm_Ext_TOP)
                         );
 
    ALU ALU(
            .A(RD1_TOP),
            .B(Imm_Ext_TOP),
            .Result(ALU_Result),
            .ALUControl(ALUControl_TOP),
            .OverFlow(),
            .Carry(),
            .Zero(),
            .Negative()
           ); 

    Control_Unit_Top Control_Unit_Top(
                                      .Op(InstrF[6:0]),
                                      .RegWrite(RegWrite),
                                      .ImmSrc(ImmSrc),
                                      .ALUSrc(),
                                      .MemWrite(),
                                      .ResultSrc(),
                                      .Branch(),
                                      .funct3(InstrF[14:12]),
                                      .funct7(),
                                      .ALUControl(ALUControl_TOP)
                                      );

   data_memory Data_memory(
                           .A(ALU_Result),
                           .WD(RD2_TOP),
                           .RD(ReadData),
                           .WE(MemWrite),
                           .clk(clk),
                           .rst(rst)
                           );
endmodule