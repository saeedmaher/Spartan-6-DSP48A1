module REG_MUX_tb3(); 
reg D_tb,clk_tb,rst_tb,clk_en_tb;
wire Q_tb;

REG_MUX #(.register(1), .TYPE("SYNC")) dut (clk_tb,rst_tb,clk_en_tb,D_tb,Q_tb);

initial begin
    clk_tb=0;
    forever begin
        #10
        clk_tb = ~clk_tb;
    end
end

initial begin
    rst_tb=1;
    D_tb=1;
    clk_en_tb=1;
    @(negedge clk_tb);

    rst_tb=0;
    repeat (30) begin
      D_tb=$random;
      clk_en_tb=$random;
      @(negedge clk_tb);
    end 

    $stop;
end

endmodule
