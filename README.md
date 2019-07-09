# 数字电子计数实验 数字钟的制作
#### 数电实验数字钟基于quartus2设计时分秒实现 置零rst  使能EN 调时SI  调分FI  下载到康芯实验开发板KX2C5F(Altera EP@C5+EPCS1)、
**采用异步计数，秒计数器产生进位信号，作为分计数器的时钟信号**
## 二十四进制与六十进制输出采用如下
```
  always @ (posedge clk or negedge rst)
begin  
	if(!rst) Q <=0;    //置零信号
	else if(~EN) Q<=Q; //使能信号
	else if(Q==8'd89) begin Q<=8'd0;Cout<=1;end 
	else 
	    begin 
		Cout<=0;
		if(Q==8'd9)  Q<=8'd16; 
		else if(Q==8'd25) Q<=8'd32;
		else if(Q==8'd41) Q<=8'd48;
		else if(Q==8'd57) Q<=8'd64;
		else if(Q==8'd73) Q<=8'd80;
		else Q <= Q+1;
		end
end 
```
>>用八位二进制 0000 1001  表示9   二进制值为9   进位后为 0001 0000  表示10<br>
>>用八位二进制 0001 1001  表示19  二进制值为25  进位后为 0010 0000  表示20<br>
>>用八位二进制 0010 1001  表示29  二进制值为41  进位后为 0011 0000  表示30<br>
>>用八位二进制 0011 1001  表示39  二进制值为57  进位后为 0100 0000  表示40<br>
>>用八位二进制 0100 1001  表示49  二进制值为73  进位后为 0001 0000  表示50<br>
>>用八位二进制 0101 1001  表示59  二进制值为89  进位后为 0101 1001  表示60<br>
* * *
## 译码模块
**根据六十进制与二十四进制产生的BCD码为两个BCD码的连接<br>
Q[0-7]=8'b00101001 表示29<br>
Q[0-3]表示为个位数的BCD码，Q[4-7]表示为十位数的BCD码，先区分后按照BCD码赋值**
```
module yima(Q,Q1,Q2);
input [7:0]Q;
output reg [6:0]Q1;
output reg [6:0]Q2;
reg [3:0]q1;
reg [3:0]q2;
always @ (Q)
begin 
q1[0]=Q[0];
q1[1]=Q[1];
q1[2]=Q[2];
q1[3]=Q[3];
q2[0]=Q[4];
q2[1]=Q[5];
q2[2]=Q[6];
q2[3]=Q[7];
Q1=7'b0000000;
Q2=7'b0000000;
case(q1)
4'b0000:Q1=7'b0111111;
4'b0001:Q1=7'b0000110;
4'b0010:Q1=7'b1011011;
4'b0011:Q1=7'b1001111;
4'b0100:Q1=7'b1100110;
4'b0101:Q1=7'b1101101;
4'b0110:Q1=7'b1111100;
4'b0111:Q1=7'b0000111;
4'b1000:Q1=7'b1111111;
4'b1001:Q1=7'b1100111;
default:Q1=7'b0000000;
endcase
case(q2)
4'b0000:Q2=7'b0111111;
4'b0001:Q2=7'b0000110;
4'b0010:Q2=7'b1011011;
4'b0011:Q2=7'b1001111;
4'b0100:Q2=7'b1100110;
4'b0101:Q2=7'b1101101;
4'b0110:Q2=7'b1111100;
4'b0111:Q2=7'b0000111;
4'b1000:Q2=7'b1111111;
4'b1001:Q2=7'b1100111;
default:Q2=7'b0000000;
endcase
end 
endmodule 
```
* * *
## 调时分实现
**CNT_002(clk,rst,EN,Clk); //产生1秒的时钟信号
CNT_003(clk,rst,EN,Clk1);  //产生用于调节时钟的信号频率稍快
counter60(Clk,rst,Cs,EN,Q1); //秒计数
assign q11=Clk;              //用数码管小数点7管脚作为秒的表示
assign Cs1=Cs||(~FI&&Clk1);  // 当FI为1时即按键未按下不进行调试 FI为0时进行调时
counter60(Cs1,rst,CF,EN,Q2); 
yima(Q2,q21,q22);
assign CF1=CF||(~SI&&Clk1);  // 当SI为1时即按键未按下不进行调试 SI为0时进行调时
counter24(CF1,rst,Cout,EN,Q3);
yima(Q3,q31,q32);**
```
module time1(clk,rst,EN,q11,q21,q22,q31,q32,Cout,FI,SI);
input clk,rst,EN,FI,SI;
output Cout,q11;
output [6:0]q21;
output [6:0]q22;
output [6:0]q31;
output [6:0]q32;
wire  [7:0]Q1;
wire  [7:0]Q2;
wire  [7:0]Q3;
wire Clk,Clk1,Cs,CF,Cs1,CF1;
CNT_002(clk,rst,EN,Clk);
CNT_003(clk,rst,EN,Clk1);
counter60(Clk,rst,Cs,EN,Q1);
assign q11=Clk;
assign Cs1=Cs||(~FI&&Clk1);
counter60(Cs1,rst,CF,EN,Q2);
yima(Q2,q21,q22);
assign CF1=CF||(~SI&&Clk1);
counter24(CF1,rst,Cout,EN,Q3);
yima(Q3,q31,q32);
endmodule 
```
