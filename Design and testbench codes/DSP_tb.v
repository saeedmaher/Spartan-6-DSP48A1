module DSP_tb();
reg [17:0]A_tb,B_tb,D_tb,BCIN_tb;
reg [47:0]C_tb;
reg CARRYIN_tb;
wire [35:0]M_tb;
wire [47:0]P_tb;
wire CARRYOUT_tb,CARRYOUTF_tb; 
reg clk_tb;
reg [7:0]opmode_tb; 
reg CEA_tb,CEB_tb,CEC_tb,CECARRYIN_tb,CED_tb,CEM_tb,CEOPMODE_tb,CEP_tb;
reg RSTA_tb,RSTB_tb,RSTC_tb,RSTCARRYIN_tb,RSTD_tb,RSTM_tb,RSTOPMODE_tb,RSTP_tb;
wire [17:0]BCOUT_tb;
wire [47:0]PCOUT_tb;
reg [47:0]PCIN_tb;  
// self checking regs
reg [35:0]M_expected;
reg [47:0]P_expected;
reg [17:0]BCOUT_expected;
reg [47:0]PCOUT_expected;
reg CARRYOUT_expected,CARRYOUTF_expected;

DSP dut (A_tb,B_tb,C_tb,D_tb,BCIN_tb,CARRYIN_tb,M_tb,P_tb,CARRYOUT_tb,CARRYOUTF_tb,clk_tb,opmode_tb,CEA_tb,CEB_tb,CEC_tb,CECARRYIN_tb,CED_tb,CEM_tb,CEOPMODE_tb,CEP_tb,RSTA_tb,RSTB_tb,RSTC_tb,RSTCARRYIN_tb,RSTD_tb,RSTM_tb,RSTOPMODE_tb,RSTP_tb,BCOUT_tb,PCOUT_tb,PCIN_tb);

initial begin
    clk_tb=0;
    forever begin
        #10
        clk_tb = ~clk_tb;
    end
end

initial begin
    // reset check
    RSTA_tb=1;
    RSTB_tb=1;
    RSTC_tb=1;
    RSTCARRYIN_tb=1;RSTD_tb=1;
    RSTM_tb=1;
    RSTOPMODE_tb=1;
    RSTP_tb=1;
    A_tb=$random;
    B_tb=$random;
    D_tb=$random;
    C_tb=$random;
    BCIN_tb=$random;
    PCIN_tb=$random;    
    CARRYIN_tb=$random;
    opmode_tb=$random;
    CEA_tb=0;
    CEB_tb=0;
    CEC_tb=0;
    CECARRYIN_tb=0;
    CED_tb=0;
    CEM_tb=0;
    CEOPMODE_tb=0;
    CEP_tb=0;
    @(negedge clk_tb);
    M_expected=0;
    P_expected=0;
    BCOUT_expected=0;
    PCOUT_expected=0;
    CARRYOUT_expected=0;
    CARRYOUTF_expected=0;
    if (M_expected != M_tb || P_expected != P_tb || BCOUT_expected != BCOUT_tb || PCOUT_expected != PCOUT_tb || CARRYOUT_expected != CARRYOUT_tb || CARRYOUTF_expected != CARRYOUTF_tb) begin
      $display("Error in reset");
      $stop;
    end
    RSTA_tb=0;
    RSTB_tb=0;
    RSTC_tb=0;
    RSTCARRYIN_tb=0;RSTD_tb=0;
    RSTM_tb=0;
    RSTOPMODE_tb=0;
    RSTP_tb=0;
    CEA_tb=1;
    CEB_tb=1;
    CEC_tb=1;
    CECARRYIN_tb=1;
    CED_tb=1;
    CEM_tb=1;
    CEOPMODE_tb=1;
    CEP_tb=1;

    // path 1 check
    A_tb=20;
    B_tb=10;
    C_tb=350;
    D_tb=25;
    BCIN_tb=$random;
    PCIN_tb=$random;
    CARRYIN_tb=$random;
    opmode_tb=8'b1101_1101;
    repeat(4) @(negedge clk_tb);
    M_expected='h12c;
    P_expected='h32;
    BCOUT_expected='hf;
    PCOUT_expected='h32;
    CARRYOUT_expected=0;
    CARRYOUTF_expected=0;
    if (M_expected != M_tb || P_expected != P_tb || BCOUT_expected != BCOUT_tb || PCOUT_expected != PCOUT_tb || CARRYOUT_expected != CARRYOUT_tb || CARRYOUTF_expected != CARRYOUTF_tb) begin
      $display("Error in path 1");
      $stop;
    end

    // check path 2
    BCIN_tb=$random;
    PCIN_tb=$random;
    CARRYIN_tb=$random;
    opmode_tb=8'b0001_0000;
    repeat(3) @(negedge clk_tb);
    M_expected='h2bc;
    P_expected='h0;
    BCOUT_expected='h23;
    PCOUT_expected='h0;
    CARRYOUT_expected=0;
    CARRYOUTF_expected=0;
    if (M_expected != M_tb || P_expected != P_tb || BCOUT_expected != BCOUT_tb || PCOUT_expected != PCOUT_tb || CARRYOUT_expected != CARRYOUT_tb || CARRYOUTF_expected != CARRYOUTF_tb) begin
      $display("Error in path 2");
      $stop;
    end    

    // check path 3
    BCIN_tb=$random;
    PCIN_tb=$random;
    CARRYIN_tb=$random;
    opmode_tb=8'b0000_1010;
    repeat(3) @(negedge clk_tb);
    M_expected='hc8;
    BCOUT_expected='ha;
    if (M_expected != M_tb || P_expected != P_tb || BCOUT_expected != BCOUT_tb || PCOUT_expected != PCOUT_tb || CARRYOUT_expected != CARRYOUT_tb || CARRYOUTF_expected != CARRYOUTF_tb) begin
      $display("Error in path 3");
      $stop;
    end    

    // check path 4
    A_tb=5;
    B_tb=6;
    C_tb=350;
    D_tb=25;
    BCIN_tb=$random;
    PCIN_tb=3000;
    CARRYIN_tb=$random;
    opmode_tb=8'b1010_0111;
    repeat(3) @(negedge clk_tb);
    M_expected='h1e;
    BCOUT_expected='h6;
    P_expected='hfe6fffec0bb1;
    PCOUT_expected='hfe6fffec0bb1;
    CARRYOUT_expected=1;
    CARRYOUTF_expected=1;
    if (M_expected != M_tb || P_expected != P_tb || BCOUT_expected != BCOUT_tb || PCOUT_expected != PCOUT_tb || CARRYOUT_expected != CARRYOUT_tb || CARRYOUTF_expected != CARRYOUTF_tb) begin
      $display("Error in path 4");
      $stop;
    end

$stop;
end

endmodule
