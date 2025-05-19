`timescale 1ns/1ns
module datapath(clk, rst, init, x, n, ready, overflow, valid, y , sel);
    input clk, rst, init , sel;
    input [7:0] x;
    input [2:0] n;
    output ready, overflow, valid;
    output [31:0] y;

    assign ready_temp = ready;

    wire [3:0] n_out;
    n_plus np(.n(n), .n_out(n_out));
    // assign n_out = {1'b0, n + 3'b001};

    wire [31:0] rgoy, rgot, mgoy, mgot, p1y, p1t, rgp1y, rgp1t, mem_pipe1;
    wire [7:0] rgox, mgox, p1x, rgp1x;
    wire [3:0] rgon, mgon, p1n, rgp1n, address1;
    wire rgo_overflow, rgo_valid, mgo_overflow, mgo_valid, p1_overflow, p1_valid,
         rgp1_overflow, rgp1_valid;

    wire [31:0] p2y, p2t, mgp2y, mgp2t, rgp2y, rgp2t, mem_pipe2;
    wire [7:0] p2x, mgp2x, rgp2x;
    wire [3:0] p2n, mgp2n, rgp2n, address2;
    wire p2_overflow, p2_valid, mgp2_overflow, mgp2_valid, rgp2_overflow, rgp2_valid;

    wire [31:0] p3y, p3t, mgp3y, mgp3t, rgp3y, rgp3t, mem_pipe3;
    wire [7:0] p3x, mgp3x, rgp3x;
    wire [3:0] p3n, mgp3n, rgp3n, address3;
    wire p3_overflow, p3_valid, mgp3_overflow, mgp3_valid, rgp3_overflow, rgp3_valid;

    wire [31:0] p4y, p4t, mgp4y, mgp4t, rgp4y, rgp4t, mem_pipe4;
    wire [7:0] p4x, mgp4x, rgp4x;
    wire [3:0] p4n, mgp4n, rgp4n, address4;
    wire p4_overflow, p4_valid, mgp4_overflow, mgp4_valid, rgp4_overflow, rgp4_valid;

    LookupTable lut(
        .addr1(address1), .addr2(address2), .addr3(address3), .addr4(address4), 
        .mem_pipe1(mem_pipe1), .mem_pipe2(mem_pipe2), .mem_pipe3(mem_pipe3), .mem_pipe4(mem_pipe4)
    );

    register_group_outside reg_group_out(
        .clk(clk), .rst(rst), .ld(ready_temp), .init(init), .inp_x(x), .inp_n(n_out), .out_y(rgoy), 
        .out_x(rgox), .out_t(rgot), .out_n(rgon), .out_ovf(rgo_overflow), .out_valid(rgo_valid)
    );
    mux_group_outside mux_group_out (
        .select(sel), .y_past(rgp4y), .y_new(rgoy), .t_past(rgp4t), .t_new(rgot), .x_past(rgp4x), .x_new(rgox), .ovf_past(rgp4_overflow), .ovf_new(rgo_overflow),
        .valid_past(rgp4_valid), .valid_new(rgo_valid), .n_past(rgp4n), .n_new(rgon), .y(mgoy), .t(mgot), .x(mgox), .ovf(mgo_overflow), .v(mgo_valid), .n(mgon)
    );
    // mux_group_outside mux_group_out (
    //     .select(sel), .y_past(rgp4y), .y_new(32'b0), .t_past(rgp4t), .t_new({1'b0 , 31'b1111111111111111111111111111111}), .x_past(rgp4x), .x_new(x), .ovf_past(rgp4_overflow), .ovf_new(1'b0),
    //     .valid_past(rgp4_valid), .valid_new(1'b0), .n_past(rgp4n), .n_new(n_out), .y(mgoy), .t(mgot), .x(mgox), .ovf(mgo_overflow), .v(mgo_valid), .n(mgon)
    // );

    // pipe 1
    memory_address mem_addr_p1(.n(n_out), .n_pipe(mgon), .address(address1));

    pipe pipe1(
        .n_reg_past(mgon), .x_reg_past(mgox), .temp_reg_past(mgot), .y_reg_past(mgoy), .inp_mem(mem_pipe1), 
        .n_reg_next(p1n), .x_reg_next(p1x), .temp_reg_next(p1t), .y_reg_next(p1y), .ovf_next(p1_overflow), .valid_next(p1_valid)
    );

    // mux_group_pipe_special mux_group_pipe1(
    //     .nsel(rgp4n) , .y_past(mgoy), .y_next(p1y), .t_past(mgot), .t_next(p1t), .x_past(mgox), .x_next(p1x), .ovf_past(mgo_overflow), .ovf_next(p1_overflow),
    //     .valid_past(mgo_valid), .valid_next(p1_valid), .n_past(mgon), .n_next(p1n), .y(mgp1y), .t(mgp1t), .x(mgp1x), .ovf(mgp1_overflow), .v(mgp1_valid), .n(mgp1n)
    // );

    // register_group_pipe reg_group_pipe1(
    //     .clk(clk), .rst(rst), .init(init), .inp_y(mgp1y), .inp_t(mgp1t), .inp_x(mgp1x), .inp_n(mgp1n), .inp_ovf(mgp1_overflow), .inp_valid(mgp1_valid),
    //     .out_y(rgp1y), .out_t(rgp1t), .out_x(rgp1x), .out_n(rgp1n), .out_ovf(rgp1_overflow), .out_valid(rgp1_valid)
    // );
    register_group_pipe reg_group_pipe1(
        .clk(clk), .rst(rst), .init(init), .inp_y(p1y), .inp_t(p1t), .inp_x(p1x), .inp_n(p1n), .inp_ovf(p1_overflow), .inp_valid(p1_valid),
        .out_y(rgp1y), .out_t(rgp1t), .out_x(rgp1x), .out_n(rgp1n), .out_ovf(rgp1_overflow), .out_valid(rgp1_valid)
    );

    // pipe2
    memory_address mem_addr_p2(.n(n_out), .n_pipe(rgp1n), .address(address2));

    pipe pipe2(
        .n_reg_past(rgp1n), .x_reg_past(rgp1x), .temp_reg_past(rgp1t), .y_reg_past(rgp1y), .inp_mem(mem_pipe2),
        .n_reg_next(p2n), .x_reg_next(p2x), .temp_reg_next(p2t), .y_reg_next(p2y), .ovf_next(p2_overflow), .valid_next(p2_valid)
    );

    mux_group_pipe mux_group_pipe2(
        .valid(rgp1_valid), .overflow(rgp1_overflow), .y_past(rgp1y), .y_next(p2y), .t_past(rgp1t), .t_next(p2t), .x_past(rgp1x), .x_next(p2x), .ovf_past(rgp1_overflow), .ovf_next(p2_overflow),
        .valid_past(rgp1_valid), .valid_next(p2_valid), .n_past(rgp1n), .n_next(p2n), .y(mgp2y), .t(mgp2t), .x(mgp2x), .ovf(mgp2_overflow), .v(mgp2_valid), .n(mgp2n)
    );

    register_group_pipe reg_group_pipe2(
        .clk(clk), .rst(rst), .init(init), .inp_y(mgp2y), .inp_t(mgp2t), .inp_x(mgp2x), .inp_n(mgp2n), .inp_ovf(mgp2_overflow), .inp_valid(mgp2_valid),
        .out_y(rgp2y), .out_t(rgp2t), .out_x(rgp2x), .out_n(rgp2n), .out_ovf(rgp2_overflow), .out_valid(rgp2_valid)
    );

    // pipe3
    memory_address mem_addr_p3(.n(n_out), .n_pipe(rgp2n), .address(address3));

    pipe pipe3(
        .n_reg_past(rgp2n), .x_reg_past(rgp2x), .temp_reg_past(rgp2t), .y_reg_past(rgp2y), .inp_mem(mem_pipe3),
        .n_reg_next(p3n), .x_reg_next(p3x), .temp_reg_next(p3t), .y_reg_next(p3y), .ovf_next(p3_overflow), .valid_next(p3_valid)
    );

    mux_group_pipe mux_group_pipe3(
        .valid(rgp2_valid), .overflow(rgp2_overflow), .y_past(rgp2y), .y_next(p3y), .t_past(rgp2t), .t_next(p3t), .x_past(rgp2x), .x_next(p3x), .ovf_past(rgp2_overflow), .ovf_next(p3_overflow),
        .valid_past(rgp2_valid), .valid_next(p3_valid), .n_past(rgp2n), .n_next(p3n), .y(mgp3y), .t(mgp3t), .x(mgp3x), .ovf(mgp3_overflow), .v(mgp3_valid), .n(mgp3n)
    );

    register_group_pipe reg_group_pipe3(
        .clk(clk), .rst(rst), .init(init), .inp_y(mgp3y), .inp_t(mgp3t), .inp_x(mgp3x), .inp_n(mgp3n), .inp_ovf(mgp3_overflow), .inp_valid(mgp3_valid),
        .out_y(rgp3y), .out_t(rgp3t), .out_x(rgp3x), .out_n(rgp3n), .out_ovf(rgp3_overflow), .out_valid(rgp3_valid)
    );

    // pipe4
    memory_address mem_addr_p4(.n(n_out), .n_pipe(rgp3n), .address(address4));

    pipe pipe4(
        .n_reg_past(rgp3n), .x_reg_past(rgp3x), .temp_reg_past(rgp3t), .y_reg_past(rgp3y), .inp_mem(mem_pipe4),
        .n_reg_next(p4n), .x_reg_next(p4x), .temp_reg_next(p4t), .y_reg_next(p4y), .ovf_next(p4_overflow), .valid_next(p4_valid)
    );

    mux_group_pipe mux_group_pipe4(
        .valid(rgp3_valid), .overflow(rgp3_overflow), .y_past(rgp3y), .y_next(p4y), .t_past(rgp3t), .t_next(p4t), .x_past(rgp3x), .x_next(p4x), .ovf_past(rgp3_overflow), .ovf_next(p4_overflow),
        .valid_past(rgp3_valid), .valid_next(p4_valid), .n_past(rgp3n), .n_next(p4n), .y(mgp4y), .t(mgp4t), .x(mgp4x), .ovf(mgp4_overflow), .v(mgp4_valid), .n(mgp4n)
    );

    register_group_pipe reg_group_pipe4(
        .clk(clk), .rst(rst), .init(init), .inp_y(mgp4y), .inp_t(mgp4t), .inp_x(mgp4x), .inp_n(mgp4n), .inp_ovf(mgp4_overflow), .inp_valid(mgp4_valid),
        .out_y(rgp4y), .out_t(rgp4t), .out_x(rgp4x), .out_n(rgp4n), .out_ovf(rgp4_overflow), .out_valid(rgp4_valid)
    );

    // assign ready = (p4n == 0 || p4n >= 4'd9);
    assign ready = (rgp4n == 0 || rgp4n >= 4'd9) || overflow;
    assign y = rgp4y;
    assign overflow = rgp4_overflow;
    assign valid = rgp4_valid;
endmodule