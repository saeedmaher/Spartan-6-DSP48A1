module DSP(A,B,C,D,BCIN,CARRYIN,M,P,CARRYOUT,CARRYOUTF,clk,opmode,CEA,CEB,CEC,CECARRYIN,CED,CEM,CEOPMODE,CEP,RSTA,RSTB,RSTC,RSTCARRYIN,RSTD,RSTM,RSTOPMODE,RSTP,BCOUT,PCOUT,PCIN);
parameter A0REG = 0;
parameter A1REG = 1; 
parameter B0REG = 0; 
parameter B1REG = 1; 
parameter CREG = 1; 
parameter DREG = 1; 
parameter MREG = 1; 
parameter PREG = 1; 
parameter CARRYINREG = 1; 
parameter CARRYOUTREG = 1;
parameter OPMODEREG = 1;
parameter CARRYINSEL = "OPMODE5";
parameter B_INPUT  = "DIRECT";
parameter RSTTYPE = "SYNC";
input [17:0]A,B,D,BCIN;
input [47:0]C;
input CARRYIN;
output [35:0]M;
output [47:0]P;
output CARRYOUT,CARRYOUTF; 
input clk;
input [7:0]opmode; 
input CEA,CEB,CEC,CECARRYIN,CED,CEM,CEOPMODE,CEP;
input RSTA,RSTB,RSTC,RSTCARRYIN,RSTD,RSTM,RSTOPMODE,RSTP;
// cascade ports
output [17:0]BCOUT;
output [47:0]PCOUT;
input [47:0]PCIN;  
wire [17:0] B0_reg_in;
wire[7:0]OPMODEREG_out;
wire [17:0] A0REG_out,B0REG_out,DREG_out;
wire [47:0] CREG_out;
wire [17:0] A1REG_out;
wire [17:0]pre_AS_result; // Pre adder/subtractor result
wire [17:0] B1_REG_in,B1REG_out;
wire [35:0]mult,MREG_out;
wire CYI_in,CYI_REG_out;
reg [47:0]X_MUX,Z_MUX;
wire [47:0]post_AS_result; // post adder/subtractor result
wire CYO_in;

assign B0_reg_in = (B_INPUT == "DIRECT")? B:
                   (B_INPUT == "CASCADE")? BCIN:0;

 REG_MUX #(.WIDTH(8), .register(OPMODEREG), .TYPE(RSTTYPE)) REG_OPMODE (clk,RSTOPMODE,CEOPMODE,opmode,OPMODEREG_out);
 REG_MUX #(.WIDTH(18), .register(A0REG), .TYPE(RSTTYPE)) REG_A0 (clk,RSTA,CEA,A,A0REG_out);
 REG_MUX #(.WIDTH(18), .register(B0REG), .TYPE(RSTTYPE)) REG_B0 (clk,RSTB,CEB,B0_reg_in,B0REG_out);
 REG_MUX #(.WIDTH(48), .register(CREG), .TYPE(RSTTYPE)) REG_C (clk,RSTC,CEC,C,CREG_out);
 REG_MUX #(.WIDTH(18), .register(DREG), .TYPE(RSTTYPE)) REG_D (clk,RSTD,CED,D,DREG_out);
 REG_MUX #(.WIDTH(18), .register(A1REG), .TYPE(RSTTYPE)) REG_A1 (clk,RSTA,CEA,A0REG_out,A1REG_out);

assign pre_AS_result = (OPMODEREG_out[6])? (DREG_out-B0REG_out):(DREG_out+B0REG_out);
assign B1_REG_in = (OPMODEREG_out[4])? pre_AS_result:B0REG_out;
 REG_MUX #(.WIDTH(18), .register(B1REG), .TYPE(RSTTYPE)) REG_B1 (clk,RSTB,CEB,B1_REG_in,B1REG_out);

assign mult = B1REG_out*A1REG_out;
 REG_MUX #(.WIDTH(36), .register(MREG), .TYPE(RSTTYPE)) REG_M (clk,RSTM,CEM,mult,MREG_out);

assign CYI_in = (CARRYINSEL == "CARRYIN")? CARRYIN:
                   (CARRYINSEL == "OPMODE5")? OPMODEREG_out[5]:0;

 REG_MUX #(.WIDTH(1), .register(CARRYINREG), .TYPE(RSTTYPE)) REG_CYI (clk,RSTCARRYIN,CECARRYIN,CYI_in,CYI_REG_out);

always @(*) begin
    case (OPMODEREG_out[1:0])
        0: X_MUX = 0;
        1: X_MUX = {12'b0,MREG_out};
        2: X_MUX = P;
        3: X_MUX = {DREG_out[11:0],A1REG_out,B1REG_out};
    endcase
end

always @(*) begin
    case (OPMODEREG_out[3:2])
        0: Z_MUX = 0;
        1: Z_MUX = PCIN;
        2: Z_MUX = P;
        3: Z_MUX = CREG_out;
    endcase
end

assign M = MREG_out;

assign {CYO_in,post_AS_result} = (OPMODEREG_out[7])? (Z_MUX-(X_MUX+CYI_REG_out)):(Z_MUX+X_MUX+CYI_REG_out);

 REG_MUX #(.WIDTH(1), .register(CARRYOUTREG), .TYPE(RSTTYPE)) REG_CYO (clk,RSTCARRYIN,CECARRYIN,CYO_in,CARRYOUT);
 REG_MUX #(.WIDTH(48), .register(PREG), .TYPE(RSTTYPE)) REG_P (clk,RSTP,CEP,post_AS_result,P);

assign PCOUT=P;
assign CARRYOUTF=CARRYOUT;
assign BCOUT=B1REG_out;



endmodule

