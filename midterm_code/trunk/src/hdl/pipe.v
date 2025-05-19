`timescale 1ns/1ns
module pipe(n_reg_past, x_reg_past, temp_reg_past, y_reg_past, inp_mem,
            n_reg_next, x_reg_next, temp_reg_next, y_reg_next, ovf_next, valid_next);
    
    output ovf_next, valid_next;

    input [31:0] temp_reg_past, y_reg_past;
    output [31:0] temp_reg_next, y_reg_next;

    input [7:0] x_reg_past;
    output[7:0] x_reg_next;

    input[3:0] n_reg_past;
    output[3:0] n_reg_next;

    input [31:0] inp_mem;

    wire [31:0] res_tx;
    wire [31:0] res_txm;
    wire temp;
    wire [31:0] x2_temp = {x_reg_past, 24'b0};

    mult #(.size(32)) mult_temp_past_and_x_past(.inp1(temp_reg_past), .inp2(x2_temp), .mult_output(res_tx));
    mult #(.size(32)) mult_t_x_m(.inp1(res_tx), .inp2(inp_mem), .mult_output(res_txm));
    adder #(.size(32)) adder_res(.inp1(res_txm), .inp2(y_reg_past), .out(y_reg_next));
    adder #(.size(4)) adder_n(.inp1(n_reg_past), .inp2(4'b1111), .out(n_reg_next));
    assign x_reg_next = x_reg_past;

    assign ovf_next = (y_reg_past[31] & res_txm[31] & ~(y_reg_next[31])) || (~(y_reg_past[31]) & ~(res_txm[31]) & y_reg_next[31]);
    assign temp = (~|n_reg_next);
    mux2_to_1 #(.size(1)) mux_temp(.inp1(temp), .inp2(1'b0), .sel(ovf_next), .out(valid_next));
    assign temp_reg_next = res_tx;


















    // assign n_reg_next = n_reg_past - 3'b001;

    // mult make_new_temp(.inp1(temp_reg_past), .inp2({x_reg_past,24'b0}), .mult_output(y_reg_next));

    // mult make_new_element(.inp1(temp_reg_next), .inp2(const0), .mult_output(new_element));

    // adder add_new_element(.inp1(new_element), .inp2(y_reg_past), .out(y_reg_next));

    // OverflowCheck check_overflow(.int1(new_element), .int2(y_reg_past), .out(y_reg_next), .Overflow(ovf_check_out));

    // assign ovf_next = ovf_past | ovf_check_out;

    // isValid check_valid(.num(x_reg_next), .isZero(valid_check_out));

    // mux2 #(.WIDTH(1)) make_valid (.in0(valid_check_out), .in1(1'b0), .sel(ovf_next), .out(valid_next));
    
endmodule