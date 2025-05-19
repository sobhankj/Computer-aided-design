`timescale 1ns/1ns
// `include "shared_params.vh"


module write_pointer_counter #(parameter NUM_REG = 4 , NUMP1 = 5, PAR_WRITE = 2)(clk, rst, init_cnt, inc_cnt, cnt_out);

    input clk, rst, init_cnt, inc_cnt;
    output reg [($clog2(NUM_REG)) : 0] cnt_out;

    always @(posedge clk, posedge rst) begin
        if(rst)
            cnt_out <= {$clog2(NUM_REG){1'b0}};
        else if(init_cnt)
            cnt_out <= {$clog2(NUM_REG){1'b0}};
        else if (inc_cnt) begin
            if (cnt_out + PAR_WRITE >= NUM_REG) begin
                cnt_out <= (cnt_out + PAR_WRITE) % NUMP1;
            end
            else begin
                cnt_out <= cnt_out + PAR_WRITE;
            end
        end
    end
endmodule


module read_pointer_counter #(parameter NUM_REG = 4 , NUMP1 = 5, PAR_READ = 1)(clk, rst, init_cnt, inc_cnt, cnt_out);

    input clk, rst, init_cnt, inc_cnt;
    output reg [($clog2(NUM_REG)) : 0] cnt_out;

    always @(posedge clk, posedge rst) begin
        if(rst)
            cnt_out <= {$clog2(NUM_REG){1'b0}};
        else if(init_cnt)
            cnt_out <= {$clog2(NUM_REG){1'b0}};
        else if (inc_cnt) begin
            if (cnt_out + PAR_READ >= NUM_REG) begin
                cnt_out <= (cnt_out + PAR_READ) % NUMP1;
            end
            else begin
                cnt_out <= cnt_out + PAR_READ;
            end
        end
    end
endmodule


module comparator #(parameter NUM_BIT = 4, NUM_REG = 4, ADDR_REG = 2, 
                PAR_WRITE = 2, PAR_READ = 1)(first_operand, second_operand, result);
    input [($clog2(NUM_REG)) : 0] first_operand, second_operand;
    output reg result;

    always @(*) begin
        if(first_operand == second_operand)
            result <= 1'b1;
        else
            result <= 1'b0;
    end
endmodule

module comparator_READY #(parameter NUM_REG = 4)(first_operand , second_operand , result);
    input [($clog2(NUM_REG)) : 0] first_operand, second_operand;
    output reg result;

    assign result = (first_operand > second_operand)? 1'b1 : 1'b0;
endmodule

module comparator_VALID #(parameter NUM_REG = 4)(first_operand , second_operand , result);
    input [($clog2(NUM_REG)) : 0] first_operand, second_operand;
    output reg result;

    assign result = (first_operand >= second_operand)? 1'b1 : 1'b0;
endmodule

module difference_calculator #(parameter NUM_REG = 4 , NUMP1 = 5)(write_pointer, read_pointer, read_min_write, write_min_read);
    input [($clog2(NUM_REG)) : 0] write_pointer, read_pointer;
    output reg [($clog2(NUM_REG)) : 0] read_min_write, write_min_read;

    //is for read - write
    assign read_min_write = (read_pointer <= write_pointer) ? (read_pointer - write_pointer) + NUMP1
                                                                 : read_pointer - write_pointer;
    //is for write - read
    assign write_min_read = ((write_pointer < read_pointer)) ? (write_pointer - read_pointer) + NUMP1
                                                                 : write_pointer - read_pointer;

endmodule

module semi_adder #(parameter NUM_REG = 4 , NUMP1 = 5)(first_operand, second_operand, result);
    input [($clog2(NUM_REG)) : 0] first_operand, second_operand;
    output reg [($clog2(NUM_REG)) : 0] result;

    assign result = ((first_operand + second_operand) >= NUMP1) ? (first_operand + second_operand) % NUMP1
                                                                  : first_operand + second_operand;
endmodule