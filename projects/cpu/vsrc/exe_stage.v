
//--xuezhen--

`include "defines.v"

module exe_stage(
  input wire rst,
  input wire [3 : 0]aluop,
  input wire [7 : 0]inst_opcode,
  input wire [`REG_BUS]op1,
  input wire [`REG_BUS]op2,
  
  output wire [4 : 0]inst_type_o,
  output wire  [`REG_BUS]rd_data
);

assign inst_type_o = inst_type_i;

ALU alu(.rst(rst),
        .aluop(aluop),
        .op1(op1),
        .op2(op2),
        .result(rd_data)
);



endmodule
