
`timescale 1ns / 1ps

`define ZERO_WORD  64'h00000000_00000000   
`define REG_BUS    [63 : 0]     
`define LOW_WORD    31:0
`define HIGH_WORD   63:32

//ALU parameters:
`define ALU_ADD   4'h0
`define ALU_SUB   4'h1
`define ALU_XOR   4'h4
`define ALU_OR    4'h6
`define ALU_AND   4'h7
`define ALU_SL    4'h8
`define ALU_SRL   4'h9
`define ALU_SRA   4'hB
`define ALU_COMP  4'hC
`define ALU_COMPU 4'hE