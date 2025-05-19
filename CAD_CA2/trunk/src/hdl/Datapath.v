`timescale 1ns/1ns
// `include "shared_parameters.vh"

module datapath #(parameter NUM_BIT = 4, NUM_REG = 4, ADDR_REG = 2, PAR_WRITE = 2, PAR_READ = 1)
(clk, rst, init, wen, din, dout, full, empty, ready, valid, inc_w, inc_r);

    input clk, rst, init, wen, inc_w, inc_r;
    input [(PAR_WRITE * NUM_BIT ) - 1 : 0] din;
    output [(PAR_READ * NUM_BIT ) - 1: 0] dout;
    output full, empty, ready, valid;


    //  write pointer counter-registre
    wire [$clog2(NUM_REG) : 0] write_pointer;
    write_pointer_counter write_pointer_counter(.clk(clk), .rst(rst), .init_cnt(init), .inc_cnt(inc_w), .cnt_out(write_pointer));

    //  read pointer counter-register
    wire [$clog2(NUM_REG) : 0] read_pointer;
    read_pointer_counter read_pointer_counter(.clk(clk), .rst(rst), .init_cnt(init), .inc_cnt(inc_r), .cnt_out(read_pointer));

    //  +/-
    wire [$clog2(NUM_REG) : 0] read_min_write, write_min_read;
    difference_calculator difference_calculator(.write_pointer(write_pointer), .read_pointer(read_pointer), .read_min_write(read_min_write), .write_min_read(write_min_read));

    // adder that adds write_pointer and 1
    wire [$clog2(NUM_REG) : 0] wp_plus_one;
    semi_adder semi_adder(.first_operand(write_pointer), .second_operand(3'b001), .result(wp_plus_one));

    // comparators 1-4
    comparator_READY comparator_1(.first_operand(read_min_write), .second_operand(3'b010), .result(ready));
    comparator_VALID comparator_2(.first_operand(write_min_read), .second_operand(3'b001), .result(valid));
    comparator comparator_3(.first_operand(write_pointer), .second_operand(read_pointer), .result(empty));
    comparator comparator_4(.first_operand(wp_plus_one), .second_operand(read_pointer), .result(full));

    //buffer
    Buffer Buffer(.clk(clk), .rst(rst), .wen(wen), .waddr(write_pointer), .raddr(read_pointer), .din(din), .dout(dout));

    
endmodule
