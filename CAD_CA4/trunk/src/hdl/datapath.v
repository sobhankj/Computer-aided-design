module datapath#(parameter IFMAP_NUM_OF_REG, parameter FILTER_NUM_OF_REG, parameter ADDR_WIDTH_IFMAP, parameter ADDR_WIDTH_FILTER, parameter ELEMENT_WIDTH)
                (clk, rst, elco, end_of_row, wfco, done, wfen, dsen, feen, ldreg, lddc, ferst, woen, stall, stride,
                write_en_IFMAP, IFMAP_din, wfrst, 
                write_en_filter, filter_din,
                final_output, filter_size, rst_cnt, sel_next);
                
    input clk, rst, wfen, dsen, feen, lddc, ferst, woen, ldreg, done, wfrst, sel_next;
    input [IFMAP_NUM_OF_REG-1:0] stride;
    input [ADDR_WIDTH_FILTER-1:0] filter_size;
    output elco, end_of_row, wfco, stall;
    input rst_cnt;

    input write_en_IFMAP;
    input [ELEMENT_WIDTH+1:0] IFMAP_din;

    input write_en_filter;
    input [ELEMENT_WIDTH-1:0] filter_din;

    output [ELEMENT_WIDTH-1:0] final_output;

    wire rst_dp;
    assign rst_dp = rst || rst_cnt;

    wire valid_IFmap, valid_SRAM, ifmap_can_write, ifmap_wen, ifmap_wcnten, ifmap_buffen, wen_register_type, 
        wen_SRAM, filter_ren, chip_en, filter_wen, filter_wcnten, filter_buffen, filter_can_write, num;

    // for Scratchpad_register_type
    wire [ELEMENT_WIDTH+1:0] din_register_type;
    wire [ELEMENT_WIDTH-1:0] dout_register_type;

    // for Scratchpad_SRAM
    wire [ELEMENT_WIDTH-1:0] din_SRAM, dout_SRAM;

    // for read_address_generator_IF
    wire [ADDR_WIDTH_IFMAP-1:0] start1, start2, read_address_IFMAP;

    // for read_address_generator_SRAM
    wire [ADDR_WIDTH_FILTER-1:0] read_address_SRAM, filter_element_counter;

    wire [ADDR_WIDTH_IFMAP-1:0] start1_reg, start2_reg, end1_reg, end2_reg;

    // IFMAP write counter
    wire [ADDR_WIDTH_IFMAP - 1:0] counter_IFMAP_write;
    write_counter #(.CONFIG_BIT(ADDR_WIDTH_IFMAP), .NUM_OF_COUNT(IFMAP_NUM_OF_REG)) IFMAP_write_counter(
        .clk(clk), 
        .rst(rst_dp), 
        .wcnten(ifmap_wcnten), 
        .counter(counter_IFMAP_write), 
        .cout()
    );

    // filter write counter
    wire [ADDR_WIDTH_FILTER - 1:0] counter_filter_write;
    write_counter #(.CONFIG_BIT(ADDR_WIDTH_FILTER), .NUM_OF_COUNT(FILTER_NUM_OF_REG)) Filter_write_counter(
        .clk(clk), 
        .rst(rst_dp), 
        .wcnten(filter_wcnten), 
        .counter(counter_filter_write), 
        .cout()
    );

    // IFMAP buffer
    Buffer #(.WIDTH(ELEMENT_WIDTH+2)) IFMAP_buffer(
        .clk(clk), 
        .rst(rst), 
        .write_en(write_en_IFMAP), 
        .read_en(ifmap_buffen), 
        .din(IFMAP_din), 
        .dout(din_register_type), 
        .valid(valid_IFmap), 
        .ready()
    );

    // filter buffer
    Buffer #(.WIDTH(ELEMENT_WIDTH)) Filter_buffer(
        .clk(clk), 
        .rst(rst), 
        .read_en(filter_buffen),
        .write_en(write_en_filter), 
        .din(filter_din), 
        .ready(), 
        .valid(valid_SRAM), 
        .dout(din_SRAM)
    );
    
    // which one module
    wire read_controller_woen;
    counter_type_1 counter1(
        .clk(clk), 
        .rst(rst_dp), 
        .cout(), 
        .woen(read_controller_woen), 
        .counter(num)
    );

    // new one bit counter
    wire new_num_select;
    counter_type_1 counter2(
        .clk(clk), 
        .rst(rst_dp), 
        .cout(), 
        .woen(woen), 
        .counter(new_num_select)
    );

    // ifmap can write 
    wire [ADDR_WIDTH_IFMAP-1:0] start_select;
    mux_2_to_1 #(.CONFIG_BIT(ADDR_WIDTH_IFMAP)) ifmap_can_write_mux(
        .num(new_num_select), 
        .inp1(start1_reg), 
        .inp2(start2_reg), 
        .out(start_select)
    );
    ifmap_canwrite #(.CONFIG_BIT(ADDR_WIDTH_IFMAP), .IFMAP_NUM_OF_REG(IFMAP_NUM_OF_REG)) ifmap_can_write_module(
        .IFmapwriteaddr(counter_IFMAP_write), 
        .start(start_select), 
        .IFmapcanwrite(ifmap_can_write)
    );


    Scratchpad_register_type #(.DATA_WIDTH(ELEMENT_WIDTH), .NUM_OF_REG(IFMAP_NUM_OF_REG), .ADDR_WIDTH(ADDR_WIDTH_IFMAP))
                SPD_register(.clk(clk), .wen(ifmap_wen), .raddr((read_address_IFMAP % IFMAP_NUM_OF_REG)), 
                .waddr(counter_IFMAP_write), .din(din_register_type[ELEMENT_WIDTH-1:0]), .dout(dout_register_type));
    
    Scratchpad_SRAM_type #(.DATA_WIDTH(ELEMENT_WIDTH), .SRAM_SIZE(FILTER_NUM_OF_REG), .ADDR_WIDTH(ADDR_WIDTH_FILTER))
                SPD_SRAM(.clk(clk), .wen(filter_wen), .filterren(1'b1), .chipen(1'b1), 
                .raddr(read_address_SRAM), .waddr(counter_filter_write), .din(din_SRAM), .dout(dout_SRAM));

    read_controller IFMAP_read_controller(.clk(clk), .rst(rst_dp), .valid(valid_IFmap), 
                .ifmap_can_write(ifmap_can_write), .ifmap_wen(ifmap_wen), .ifmap_wcnten(ifmap_wcnten), .ifmap_buffen(ifmap_buffen), .start_bit(din_register_type[ELEMENT_WIDTH+1]), 
                .wo_en(read_controller_woen));


    read_controller Filter_read_controller(.clk(clk), .rst(rst_dp), .valid(valid_SRAM), 
                .ifmap_can_write(1'b1), .ifmap_wen(filter_wen), .ifmap_wcnten(filter_wcnten), .ifmap_buffen(filter_buffen), .start_bit(), .wo_en());


    read_address_generator_IF #(.CONFIG_BIT(ADDR_WIDTH_IFMAP)) read_addr_gen_IF(
        .clk(clk), 
        .stride(stride), 
        .start1(start1_reg), 
        .start2(start2_reg),
        .end1_reg(end2_reg+1),
        .end2_reg(end1_reg+1),
        .num(new_num_select), 
        .ldds(lddc), 
        .dsen(dsen), 
        .dsco(dsco), 
        .filter_element_addr(filter_element_counter), 
        .address(read_address_IFMAP),
        .rst(rst),
        .sel_next(sel_next)
    );

    read_address_generator_Filter #(.CONFIG_BIT(ADDR_WIDTH_FILTER), .SRAM_SIZE(FILTER_NUM_OF_REG)) read_addr_gen_Filter(
        .clk(clk), 
        .ferst(ferst), 
        .feen(feen), 
        .wfrst(wfrst), 
        .wfen(wfen), 
        .filter_size(filter_size), 
        .elco(elco), 
        .wfco(wfco), 
        .address(read_address_SRAM), 
        .filter_element_counter(filter_element_counter),
        .rst(rst)
    );

    // load start and end registers
    
    load_start_end #(.CONFIG_BIT(ADDR_WIDTH_IFMAP)) load_start_end_module(
        .clk(clk),
        .num(num), 
        .target_address(counter_IFMAP_write), 
        .start_bit(din_register_type[ELEMENT_WIDTH+1]), 
        .end_bit(din_register_type[ELEMENT_WIDTH]), 
        .start1_out(start1_reg), 
        .start2_out(start2_reg), 
        .end1_out(end1_reg), 
        .end2_out(end2_reg),
        .rst(rst_dp),
        .wen(ifmap_wen)
    );

    // IFMAP comparator
    wire IFMAP_comp_out;
    comparetor #(.CONFIG_BIT(ADDR_WIDTH_IFMAP)) IFcomp(
        .inp1(counter_IFMAP_write), 
        .inp2(read_address_IFMAP % IFMAP_NUM_OF_REG), 
        .out_comp(IFMAP_comp_out)
    );

    // filter comparator
    wire filter_comp_out;
    comparetor #(.CONFIG_BIT(ADDR_WIDTH_FILTER)) Filtercomp(
        .inp1(counter_filter_write), 
        .inp2(read_address_SRAM), 
        .out_comp(filter_comp_out)
    );

    // register IFMAP
    wire [ELEMENT_WIDTH-1:0] reg_out_IFREG;
    register #(.REG_WIDTH(ELEMENT_WIDTH)) IF_register(
        .clk(clk), 
        .rst(rst_dp),
        .ld_reg(1'b1),
        .reg_in(dout_register_type), 
        .reg_out(reg_out_IFREG)
    );

    // multiplier
    wire [ELEMENT_WIDTH-1:0] mult_out;
    multiplier #(.CONFIG_BIT(ELEMENT_WIDTH)) mult_module(
        .inp1(reg_out_IFREG), 
        .inp2(dout_SRAM), 
        .out(mult_out)
    );

    // mult result register and sum module and sum res module
    wire [ELEMENT_WIDTH-1:0] mult_reg_output;
    wire [ELEMENT_WIDTH-1:0] sum_res_register_out, sum_res;
    wire init_sum_res;
    wire ldreg_stall;

    register #(.REG_WIDTH(ELEMENT_WIDTH)) mult_result(
        .clk(clk), 
        .rst(rst_dp || init_sum_res),
        .ld_reg(ldreg_stall), 
        .reg_in(mult_out), 
        .reg_out(mult_reg_output)
    );

    adder_conv #(.CONFIG_BIT(ELEMENT_WIDTH)) adder_conv_module(
        .inp1(mult_reg_output), 
        .inp2(sum_res_register_out), 
        .out(sum_res)
    );

    register #(.REG_WIDTH(ELEMENT_WIDTH)) adder_res_register(
        .clk(clk), 
        .rst(rst_dp || init_sum_res),
        .ld_reg(ldreg_stall), 
        .reg_in(sum_res), 
        .reg_out(sum_res_register_out)
    );


    wire stall_write_controller, wen_write_controller;
    assign ldreg_stall = ldreg && !stall_write_controller;
    wire output_buf_ready;

    // output buffer
    Buffer #(.WIDTH(ELEMENT_WIDTH)) output_buffer(
        .clk(clk), 
        .rst(rst), 
        .read_en(),
        .write_en(wen_write_controller), 
        .din(sum_res_register_out), 
        .ready(output_buf_ready), 
        .valid(), 
        .dout(final_output)
    );

    // write controller
    write_controller write_controller_module(
        .clk(clk), 
        .rst(rst_dp), 
        .done(done), 
        .ready(output_buf_ready), 
        .stall(stall_write_controller), 
        .wen(wen_write_controller),
        .init_sum_res(init_sum_res)
    );


    // stall check
    wire check_for_stall_out;
    check_for_stall check_for_stall_module(
        .Ifmap_comp(IFMAP_comp_out),
        .Filter_comp(filter_comp_out), 
        .out_stall(check_for_stall_out)
    );

    // OR All
    assign stall = (check_for_stall_out || stall_write_controller) ? 1'b1 : 1'b0;

    // check_for_end
    wire [ADDR_WIDTH_IFMAP-1:0] end_row_wire;
    mux_2_to_1 #(.CONFIG_BIT(ADDR_WIDTH_IFMAP)) mux_2_to_1_for_checking_the_end(
        .num(new_num_select), 
        .inp1(end1_reg), 
        .inp2(end2_reg), 
        .out(end_row_wire)
    );
    check_for_end #(.CONFIG_BIT(ADDR_WIDTH_IFMAP)) check_for_end_module(
        .endrow(end_row_wire), 
        .Ifmapreadaddr(read_address_IFMAP % IFMAP_NUM_OF_REG), 
        .end_of_row(end_of_row)
    );
endmodule