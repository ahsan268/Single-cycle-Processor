module Register_file(A1,A2,A3,WD3,WE3,RD1,RD2,clk,rst);
   input [4:0] A1,A2,A3;
   input [31:0] WD3;
   input clk,rst,WE3;
   output [31:0] RD1,RD2;

   //creation of memory
   reg [31:0] Register [31:0];

   //read functionality

   assign RD1 = (!rst) ? 32'h00000000 : Register[A1];
   assign RD2 = (!rst) ? 32'h00000000 : Register[A2];

   always @ (posedge clk) begin
     if (WE3)
     begin
     Register[A3] <= WD3;
     end
   end

   initial begin
     Register[9] = 32'h00000030; 
     Register[6] = 32'h00000040; 
     Register[11] = 32'h00000028;
     Register[12] = 32'h00000030;
   end

endmodule