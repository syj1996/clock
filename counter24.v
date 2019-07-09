module counter24(clk,rst,Cout,EN,Q);
 input clk,rst,EN;
 output reg Cout;
 output reg [7:0]Q;

always @ (posedge clk or negedge rst)
begin 
if(!rst) Q <=0;
else if(~EN) Q<=Q;
else if(Q==8'd35) begin Q<=8'd0;Cout<=1;end 
else 
begin 
Cout<=0;
if(Q==8'd9)  Q<=8'd16; 
else if(Q==8'd25) Q<=8'd32;
else Q <= Q+1;
end;
end
endmodule 