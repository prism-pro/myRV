
//--xuezhen--

`include "defines.v"

module exe_stage(
  input wire rst,
  input wire [3 : 0]aluop,
  //input wire [7 : 0]inst_opcode,

  input wire [`REG_BUS] rs1_data,
  input wire [`REG_BUS] rs2_data,
  input wire [`REG_BUS] imm_data,
  input wire [`REG_BUS] pc_value,
  input wire op1,
  input wire op2,
  output wire eq_flag,
  output wire less_flag,

  output wire  [`REG_BUS] rd_data
);

wire [`REG_BUS] operant1 = (op1) ? rs1_data : pc_value;
wire [`REG_BUS] operant2 = (op2) ? rs2_data : imm_data;


ALU alu(.rst(rst),
        .aluop(aluop),
        .op1(operant1),
        .op2(operant2),
        .result(rd_data),
        .eq_flag(eq_flag),
        .less_flag(less_flag)
);

endmodule
