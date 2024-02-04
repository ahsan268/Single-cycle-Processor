module data_memory(A,WD,RD,WE,clk,rst);
   input [31:0] A,WD;
   input clk,WE,rst;
   output [31:0] RD;

   //creation of memory
   reg [31:0] data_mem [1023:0];

   // read
   //assign RD = (WE == 1'b0) ? data_mem[A] : 32'h00000000;
  

   //write
   always @(posedge clk) begin
        if (WE)
        begin
        data_mem[A] <= WD;
        end
    end

     assign RD = (~rst) ? 32'd0 : data_mem[A] ;

    initial begin
      data_mem[44] = 32'h00000030;
      data_mem[56] = 32'h00000002;
    end

endmodule