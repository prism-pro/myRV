`include "defines.v"
module ALU (
    
    input wire rst,
    input wire  [3:0] aluop,
    input wire `REG_BUS op1,op2,
    output wire `REG_BUS result,
    output wire eq_flag,
    output wire less_flag
    );
        
    reg  [3:0] block_en;
    wire en_arth, en_logic, en_shift, en_comp;
    wire `REG_BUS op1_arth, `REG_BUS op2_arth;
    wire `REG_BUS op1_logic,`REG_BUS op2_logic;
    wire `REG_BUS op1_shift, [5:0] op2_shift;
    wire `REG_BUS op1_comp, `REG_BUS op2_comp;

    
    //generate block selection 
    assign {en_arth, en_logic, en_shift, en_comp} = block_en;
    always @(*) begin
        if (rst) begin
            block_en = 4'h0;
        end
        else begin
        case (aluop[3:2])
            2'b00 : block_en = 4'h1;
            2'b01 : block_en = 4'h2;
            2'b10 : block_en = 4'h4;
            2'b11 : block_en = 4'h8;
            default: 4'h0;
        endcase
        end
    end

    //ADDER
    wire `REG_BUS result_arth;
    assign op1_arth = en_arth ? op1 : 64'b0;
    assign op2_arth = en_arth ? op2 : 64'b0;
    assign result_arth = aluop[0] ? (op1_arth - op2_arth) :(op1_arth + op2_arth);

    //logic
    reg   `REG_BUS result_logic;
    assign op1_logic = en_logic ? op1 : 64'b0;
    assign op2_logic = en_logic ? op2 : 64'b0;
    always @(*) begin
        case (aluop[1:0])
        2'b00 : result_logic = op1_logic ^ op2_logic;
        2'b10 : result_logic = op1_logic | op2_logic;
        2'b11 : result_logic = op1_logic & op2_logic;
        default :result_logic = 64'b0;
    end

    //shifter
    wire `REG_BUS result_shift;
    assign op1_shift = en_shift ? op1 : 64'b0;
    assign op2_shift = en_shift ? op2[5:0] : 6'b0;
    shifter sh1(.data(op1_shift),
                .sa(op2_shift),
                .right(aluop[0]),
                .arith(aluop[1]),
                .sh(result_shift)
    );
    //comparator
    wire `REG_BUS result_comp;
    assign op1_comp = en_comp ? op1 : 64'b0;
    assign op2_comp = en_comp ? op2 : 64'b0;
    comp comp_1 (.op1(op1_comp),
                .op2(op2_comp),
                .u(aluop[1]),
                .result(result_comp),
                .eq_flag(eq_flag),
                .less_flag(less_flag)
    );
    //output selection
    always @(*) begin
        if (rst) begin
            block_en = 4'h0;
        end
        else begin
        case (aluop[3:2])
            2'b00 : result = result_arth;
            2'b01 : result = result_logic;
            2'b10 : result = result_shift;
            2'b11 : result = result_comp;
            default: 4'h0;
        endcase
        end
    end
endmodule