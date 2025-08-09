module REG_MUX(clk,rst,clk_en,D,Q);
parameter register = 1;
parameter TYPE = "SYNC";
parameter WIDTH = 1;
input [WIDTH-1:0]D;
input clk,rst,clk_en;
output reg [WIDTH-1:0]Q;
generate
  if(register == 1) begin
        if(TYPE == "SYNC") begin
        always @(posedge clk) begin
            if(rst) begin
              Q<=0;
            end
            else if(clk_en) begin
              Q<=D;
            end
        end
        end
      else begin
        always @(posedge clk or posedge rst) begin
            if (rst) begin
              Q<=0;
            end
            else begin
              if(clk_en) begin
                Q<=D;              
              end
            end
            end
        end       
  end
  else begin
    always @(*) begin
      Q=D;
    end
  end
endgenerate
endmodule
