`include "defines.v"
module comp (op1,op2,u,result,eq_flag);
input wire `REG_BUS op1,op2;
input wire u; //high means unsigned comparation 
output wire  `REG_BUS result;
output reg  eq_flag;
reg  re;
always @(*) begin
    if(u)
        begin
            if (op1[63]<op2[63]) begin
                re = 1'b1;
            end 
            else if(op1[63]>op2[63]) begin
                re = 1'b0;
            end
            else begin
                re = (op1[62:0]<op2[62:0]);
            end    
        end
        
    else   begin
        if (op1[63]<op2[63]) begin
                re = 1'b0;
            end 
            else if(op1[63]>op2[63]) begin
                re = 1'b1;
            end
            else begin
                re = (op1[62:0]<op2[62:0]);
            end
    end
end

always @(*) begin
    if(op1 == op2) 
    begin
        eq_flag = 1'b1;
    end
    else
    begin
        eq_flag = 1'b0;
    end
end

assign result = {64{re}};
endmodule