module CNT_002(clk,rst,EN,Cout);
 input clk,rst,EN;
 output reg Cout;
reg [23:0]Q; 
always @ (posedge clk or negedge rst)
begin 
if(!rst) Q <=0;
else if(~EN) Q<=Q;
else if(Q==24'd9999999) begin Q<=0;Cout=~Cout;end
else Q <= Q+1;
end
endmodule 