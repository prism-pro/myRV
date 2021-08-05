`include "defines.v"
module shifter(data,sa,right,arith,sh);
	input   `REG_BUS data;
	input   [5:0]  sa;
	input          right,arith;
	output  `REG_BUS sh;
	reg     `REG_BUS sh;
	always@(*) begin
		if(!right) 
			sh = data << sa;
		else 
		if(!arith)
			sh = data >> sa;
		else
			sh = $signed(data) >>> sa;
	end
 
endmodule