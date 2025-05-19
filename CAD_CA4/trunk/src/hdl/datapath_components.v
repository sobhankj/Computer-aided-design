`timescale 1ns/1ns

module register #(parameter REG_WIDTH = 4)
                (clk, rst, ld_reg, reg_in, reg_out);
    input clk, ld_reg, rst;
    input[REG_WIDTH-1:0] reg_in;
    output reg[REG_WIDTH-1:0] reg_out;

    always @(posedge clk) begin
        if (rst)
            reg_out <= 0;
        else if(ld_reg)
            reg_out <= reg_in;
    end
endmodule

module multiplier #(parameter CONFIG_BIT)
                  (inp1, inp2, out);
    input [CONFIG_BIT-1:0] inp1, inp2;
    output [CONFIG_BIT-1:0] out;
    wire [(2*CONFIG_BIT)-1:0] temp_res;

    assign temp_res = inp1 * inp2;
    assign out = temp_res[(2*CONFIG_BIT)-1:CONFIG_BIT];
endmodule

module adder_conv #(parameter CONFIG_BIT)
                    (inp1, inp2, out);
    input [CONFIG_BIT-1:0] inp1, inp2;
    output [CONFIG_BIT-1:0] out;
    
    assign out = inp1 + inp2;
endmodule

module write_counter #(parameter CONFIG_BIT = 4, parameter NUM_OF_COUNT = 12) 
                     (clk, rst, wcnten, counter, cout);
    input clk, rst, wcnten;
    output reg [CONFIG_BIT - 1:0] counter;
    output reg cout;

    always @(posedge clk) begin
        if (rst) begin
            counter <= 0;      
            cout <= 0;
        end
        else if (wcnten) begin
            if (counter == NUM_OF_COUNT - 1) begin
                counter <= 0;   
                cout <= 1;   
            end 
            else begin
                counter <= counter + 1;
                cout <= 0;
            end
        end
    end
endmodule


module counter_type_1(clk, rst, cout, woen, counter);
    input woen, clk, rst;
    output reg cout;

    output reg counter;

    always @(posedge clk) begin
        if (rst) begin
            counter <= 0;
        end
        else if (woen) begin
            if (counter == 1'b1) begin
                counter <= 0;
                cout <= 1;
            end
            else begin
                counter <= counter + 1;
                cout <= 0;
            end
        end
    end
endmodule

module mux_2_to_1 #(parameter CONFIG_BIT)
                   (num, inp1, inp2, out);
    input num;
    input [CONFIG_BIT-1:0] inp1, inp2;
    output [CONFIG_BIT-1:0] out;
    assign out = (num) ? inp2 : inp1;
endmodule

module mux_4_to_1 #(parameter CONFIG_BIT)
                   (num, sel_next, inp1, inp2, inp3, inp4, out);
    input num, sel_next;
    input [CONFIG_BIT-1:0] inp1, inp2, inp3, inp4;
    output reg [CONFIG_BIT-1:0] out;

    always @(*) begin
        case({sel_next, num})
            2'b00: out = inp1;
            2'b01: out = inp2;
            2'b10: out = inp3;
            2'b11: out = inp4;
        endcase
    end
endmodule

module ifmap_canwrite #(parameter CONFIG_BIT, parameter IFMAP_NUM_OF_REG)
                       (IFmapwriteaddr, start, IFmapcanwrite);
    input [CONFIG_BIT-1:0] IFmapwriteaddr, start;
    output IFmapcanwrite;
    wire [CONFIG_BIT-1:0] temp;

    assign temp = (start == 0) ? IFMAP_NUM_OF_REG - 1 : start - 1;
    assign IFmapcanwrite = (IFmapwriteaddr == temp) ? 1'b0 : 1'b1;
endmodule


module Scratchpad_register_type #(parameter DATA_WIDTH = 8, parameter ADDR_WIDTH = 4, parameter NUM_OF_REG = 16)
                                 (clk, wen, raddr, waddr, din, dout);
    input clk, wen;
    input [DATA_WIDTH-1:0] din;
    input [ADDR_WIDTH-1:0] raddr, waddr;
    output [DATA_WIDTH-1:0] dout;

    reg [DATA_WIDTH-1:0] memory [0:NUM_OF_REG-1];

    assign dout = memory[raddr];
    always @(posedge clk) begin
        if (wen) begin
            memory[waddr] <= din;
        end
    end

endmodule

module Scratchpad_SRAM_type #(parameter DATA_WIDTH = 8, parameter ADDR_WIDTH = 4, parameter SRAM_SIZE = 16)
                             (clk, wen, filterren, chipen, raddr, waddr, din, dout);
    input clk, wen, filterren, chipen;
    input [ADDR_WIDTH-1:0] raddr, waddr;
    input [DATA_WIDTH-1:0] din;
    output reg [DATA_WIDTH-1:0] dout;

    reg [DATA_WIDTH-1:0] memory [0:SRAM_SIZE-1];

    always @(posedge clk) begin
        if (chipen) begin
            if (wen) begin
                memory[waddr] <= din;
            end
            if (filterren) begin
                dout <= memory[raddr];
            end
        end
    end
endmodule

module read_controller(clk, rst, valid, ifmap_can_write, ifmap_wen , ifmap_wcnten , ifmap_buffen, start_bit, wo_en);
    input clk, rst, valid, ifmap_can_write, start_bit;
    output reg ifmap_wen , ifmap_wcnten , ifmap_buffen, wo_en;
    reg [1:0] ps, ns;
    parameter [1:0] Idle = 0, write = 1, update_cnt = 2, update_buff = 3;

    always @(*) begin
        ns = Idle;
        case (ps)
            Idle: ns = (valid && ifmap_can_write) ? write : Idle;

            write: ns = update_cnt;

            update_cnt: ns = update_buff;

            update_buff: ns = Idle;

        endcase
    end

    always @(*) begin
        {ifmap_wen , ifmap_wcnten , ifmap_buffen, wo_en} = 4'b0000;
        case (ps)
            Idle: begin
            end

            write: begin
                ifmap_wen = 1'b1;
            end
            
            update_cnt: begin
                ifmap_buffen = 1'b1;
                if (start_bit) begin
                    wo_en = 1'b1;
                end

            end
            
            update_buff: begin
                ifmap_wcnten = 1'b1;
            end

        endcase
    end

    always @(posedge clk or posedge rst) begin
        if (rst)
            ps <= Idle;
        else
            ps <= ns;
    end
endmodule

module data_start #(parameter CONFIG_BIT = 4) 
                  (clk, ldds, dsen, load_data, stride, counter, cout, rst);
    
    input clk, dsen, ldds, rst;
    input[CONFIG_BIT-1:0] load_data, stride;
    output reg [CONFIG_BIT-1:0] counter;
    output reg cout;

    always @(posedge clk) begin
        if (rst)
            counter <= 0;
        else begin
            if (ldds) begin
                counter <= load_data;
            end
            else if (dsen) begin
                counter <= counter + stride;
            end 
        end
    end
endmodule

module read_address_generator_IF #(parameter CONFIG_BIT)
                                 (clk, stride, start1, start2, end1_reg, end2_reg, num, ldds, dsen, dsco, filter_element_addr, address, rst, sel_next);
    input clk, num, ldds, dsen, rst, sel_next;
    input [CONFIG_BIT-1:0] stride, start1, start2, filter_element_addr, end1_reg, end2_reg;
    output [CONFIG_BIT-1:0] address;
    output dsco;
    wire [CONFIG_BIT-1:0] mux_out_start;
    wire [CONFIG_BIT-1:0] counter;

    mux_4_to_1 #(.CONFIG_BIT(CONFIG_BIT)) mux_module(.num(num), .inp1(start1), .inp2(start2), .out(mux_out_start), .inp3(end1_reg), .inp4(end2_reg), .sel_next(sel_next));
    data_start #(.CONFIG_BIT(CONFIG_BIT)) data_start_module(.clk(clk), .ldds(ldds), .dsen(dsen), .load_data(mux_out_start), .stride(stride), .counter(counter), .cout(dsco), .rst(rst));
    adder_conv #(.CONFIG_BIT(CONFIG_BIT)) sum_module(.inp1(counter), .inp2(filter_element_addr), .out(address));
endmodule

module filter_element #(parameter CONFIG_BIT = 4)
                       (clk, ferst, feen, filter_size, counter, elco, rst);
    input clk, ferst, feen, rst;
    input [CONFIG_BIT-1:0] filter_size;
    output reg [CONFIG_BIT-1:0] counter;
    output reg elco;

    always @(posedge clk) begin
        if (ferst || rst) begin
            counter <= 0;    
            elco <= 0;      
        end
        else if (feen) begin
            counter <= counter + 1;
        end
    end
    assign elco = (counter == filter_size - 1) ? 1'b1 : 1'b0;
    assign counter = (counter % filter_size);
endmodule

module which_filter #(parameter CONFIG_BIT = 4, parameter SRAM_SIZE = 16)
                     (clk, wfrst, wfen, filter_size, counter, wfco, rst);
    input clk, wfrst, wfen, rst;
    input[CONFIG_BIT-1:0] filter_size;
    output reg [CONFIG_BIT-1:0] counter;
    output reg wfco;

    reg [CONFIG_BIT-1:0] num_of_filters;

    always @(*) begin
        num_of_filters = SRAM_SIZE / filter_size;
    end

    reg [CONFIG_BIT-1:0] inc_counter;

    always @(posedge clk) begin
        if (wfrst || rst) begin
            counter <= 0;         
            inc_counter <= 0;
            wfco <= 0;
        end
        else if (wfen) begin
            counter <= counter + filter_size;
            inc_counter <= inc_counter + 1;
        end
    end
    assign wfco = (inc_counter == num_of_filters - 1) ? 1'b1 : 1'b0;
endmodule

module read_address_generator_Filter #(parameter CONFIG_BIT, parameter SRAM_SIZE)
                                      (clk, ferst, feen, wfrst, wfen, filter_size, elco, wfco, address, filter_element_counter, rst);
    input clk, ferst, feen, wfrst, wfen, rst;
    output elco, wfco;
    input [CONFIG_BIT-1:0] filter_size;
    output [CONFIG_BIT-1:0] address;
    output [CONFIG_BIT-1:0] filter_element_counter;
    wire [CONFIG_BIT-1:0] which_filter_counter;

    filter_element #(.CONFIG_BIT(CONFIG_BIT)) filter_element_module(.clk(clk), .ferst(ferst), .feen(feen), .filter_size(filter_size), .counter(filter_element_counter), .elco(elco), .rst(rst));
    which_filter #(.CONFIG_BIT(CONFIG_BIT), .SRAM_SIZE(SRAM_SIZE)) which_filter_module(.clk(clk), .wfrst(wfrst), .wfen(wfen), .filter_size(filter_size), .counter(which_filter_counter), .wfco(wfco), .rst(rst));
    adder_conv #(.CONFIG_BIT(CONFIG_BIT)) sum_module(.inp1(filter_element_counter), .inp2(which_filter_counter), .out(address));
endmodule

module load_start_end #(parameter CONFIG_BIT)
                       (num, target_address, start_bit, end_bit, start1_out, start2_out, end1_out, end2_out, rst, clk, wen);
    input num, start_bit, end_bit, rst, clk, wen;
    input [CONFIG_BIT-1:0] target_address;
    output [CONFIG_BIT-1:0] start1_out, start2_out, end1_out, end2_out;
    wire start1_load;

    assign start1_load = (start_bit && !num) ? 1'b1 : 1'b0;
    register #(.REG_WIDTH(CONFIG_BIT)) start1(
        .clk(clk), 
        .rst(1'b0),
        .ld_reg(start1_load), 
        .reg_in(target_address), 
        .reg_out(start1_out)
    );

    wire start2_load;
    assign start2_load = (start_bit && num) ? 1'b1 : 1'b0;
    register #(.REG_WIDTH(CONFIG_BIT)) start2(
        .clk(clk), 
        .rst(1'b0),
        .ld_reg(start2_load), 
        .reg_in(target_address), 
        .reg_out(start2_out)
    );

    wire end1_load;
    assign end1_load = (end_bit && num && wen) ? 1'b1 : 1'b0;
    register #(.REG_WIDTH(CONFIG_BIT)) end1(
        .clk(clk), 
        .rst(1'b0),
        .ld_reg(end1_load), 
        .reg_in(target_address), 
        .reg_out(end1_out)
    );

    wire end2_load;
    assign end2_load = (end_bit && !num && wen) ? 1'b1 : 1'b0;
    register #(.REG_WIDTH(CONFIG_BIT)) end2(
        .clk(clk), 
        .rst(1'b0),
        .ld_reg(end2_load), 
        .reg_in(target_address), 
        .reg_out(end2_out)
    );
endmodule

module comparetor #(parameter CONFIG_BIT) 
                   (inp1, inp2, out_comp);
    input [CONFIG_BIT-1:0] inp1, inp2;
    output out_comp;

    assign out_comp = (inp2 == inp1) ? 1'b1 : 1'b0;
endmodule

module write_controller(clk, rst, done, ready, stall, wen, init_sum_res);
    input clk, rst, done, ready;
    output reg stall, wen, init_sum_res;
    reg [1:0] ps, ns;
    parameter [1:0] Idle = 0, wait_ready = 1, write = 2;

    always @(*) begin
        ns = Idle;
        case(ps) 
            Idle: begin
                ns = (done) ? wait_ready : Idle;
            end

            wait_ready: begin
                ns = (ready) ? write : wait_ready;
            end

            write: begin
                ns = Idle;
            end
        endcase
    end

    always @(ps) begin
        {stall, wen, init_sum_res} = 3'b000;

        case(ps)
            Idle: begin

            end

            wait_ready: begin
                stall = 1'b1;
            end

            write: begin
                wen = 1'b1;
                init_sum_res = 1'b1;
            end
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if (rst)
            ps <= Idle;
        else
            ps <= ns;
    end
endmodule

module check_for_stall (Ifmap_comp, Filter_comp, out_stall);
    input Ifmap_comp, Filter_comp;
    output out_stall;

    assign out_stall = (Ifmap_comp || Filter_comp) ? 1'b1 : 1'b0;
endmodule

module check_for_end #(parameter CONFIG_BIT)
                      (endrow, Ifmapreadaddr, end_of_row);
    input [CONFIG_BIT-1:0] Ifmapreadaddr, endrow;
    output end_of_row;

    assign end_of_row = (Ifmapreadaddr == endrow) ? 1'b1 : 1'b0;
endmodule