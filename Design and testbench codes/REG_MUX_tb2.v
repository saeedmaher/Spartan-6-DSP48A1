module REG_MUX_tb2(); 
reg D_tb,clk_tb,rst_tb,clk_en_tb;
wire Q_tb;

REG_MUX #(.register(0), .TYPE("ASYNC")) dut (clk_tb,rst_tb,clk_en_tb,D_tb,Q_tb);

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
    #5

    rst_tb=0;
    repeat (30) begin
      D_tb=$random;
      #5;
    end 

    $stop;
end

endmodule
