`include "defines.v"
module shifter(
	input   [`REG_BUS] data,
	input   [5:0]  sa,
	input          right,arith,
	output reg [`REG_BUS] sh
	);

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