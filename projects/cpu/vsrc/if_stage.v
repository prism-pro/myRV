
//--xuezhen--

`include "defines.v"

module if_stage(
  input wire clk,
  input wire rst,
  input wire eq_flag,
  input wire less_flag,
  input wire link,
  input wire pc_jump,
  input wire pc_b_eq,
  input wire pc_b_less,
  input wire pc_b_n,
  input wire `REG_BUS rs1_data,
  input wire `REG_BUS imm_data,
  

  output wire `REG_BUS inst_addr,
  output wire         inst_ena
  
);

reg [`REG_BUS]pc;
wire pc_op1 = pc_jump & link;
reg pc_op2;
always @(*) begin
  if (rst == 1'b1) begin
    pc_op2 = 1'b1;
  end
  else if(pc_jump == 1'b1)
  begin
    pc_op2 = 1'b0;
  end
  else 
  begin
    case({pc_b_eq, pc_b_less,pc_b_n})
    3'b100: pc_op2 = !eq_flag;
    3'b101: pc_op2 = eq_flag;
    3'b010: pc_op2 = !less_flag;
    3'b011: pc_op2 = less_flag;
    default: pc_op2 = 1'b1;
  endcase
  end
end

// fetch an instruction
always@( posedge clk )
begin
  if( rst == 1'b1 )
  begin
    pc <= `ZERO_WORD ;
  end
  else
  begin
    pc <= (pc_op1) ? rs1_data :pc  + (pc_op2) ? 64'd4 : imm_data ;
  end
end

assign inst_addr = pc;
assign inst_ena  = ( rst == 1'b1 ) ? 0 : 1;


endmodule
