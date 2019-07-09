module counter6(clk,rst,Cout,Q);
 input clk,rst;
 output reg Cout;
 output reg [3:0]Q;
always @ (posedge clk or negedge rst)
begin 
if(!rst) Q <=0;
else if(Q==4'd6) begin Q<=0;Cout<=~Cout;end 
      else Q <= Q+1; 
end
endmodule 