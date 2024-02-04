module Single_cycle_top_tb();

    reg clk = 1'b1,rst;

    Single_cycle_top Single_cycle_top(
                                      .clk(clk),
                                      .rst(rst)
    );

    initial begin
       $dumpfile ("Single cycle.vcd");
       $dumpvars(0);
    end

    always begin
      clk = ~clk;
      #50;
    end

    initial begin
      rst = 1'b0;
      #100;

      rst = 1'b1;
      #200;
      $finish;
    end
endmodule