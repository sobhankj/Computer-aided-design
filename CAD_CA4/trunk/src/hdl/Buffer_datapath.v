module BufferDatapath #(parameter WIDTH, parameter DEPTH, parameter PAR_READ, parameter PAR_WRITE) 
                (clk, rst, wen, din, dout, valid, ready, wcnten, rcnten, empty, full, read_en);
    input clk, rst, wcnten, rcnten, wen, read_en;
    output empty, full;
    output ready, valid;
    input [0:(WIDTH * PAR_WRITE) - 1] din;
    output [0:(WIDTH * PAR_READ) - 1] dout;
    wire [3:0] waddr, raddr;
    wire comp_out_1, comp_out_2;
    wire [4:0] a, ap;
    wire [4:0] b, bp;
    wire [4:0] c, cp;

    fifo_buffer #(.WIDTH(WIDTH), .DEPTH(DEPTH), .PAR_READ(PAR_READ), .PAR_WRITE(PAR_WRITE)) 
                    buffer(.clk(clk), .rst(rst), .din(din), .dout(dout), .wen(wen), .waddr(waddr), .raddr(raddr), .read_en(read_en));
    write_cnt #(.PAR_WRITE(PAR_WRITE), .DEPTH(DEPTH))
                    write_cnt_module(.clk(clk), .rst(rst), .wcenten(wcnten), .waddr(waddr));
    read_cnt #(.PAR_READ(PAR_READ), .DEPTH(DEPTH))
                    read_cnt_module(.clk(clk), .rst(rst), .rcenten(rcnten), .raddr(raddr));

    checkout checkout_module(.waddr(waddr), .raddr(raddr), .full(full), .empty(empty));

    // left-ready=full
    comparator_full #(.size(4))
                    read_write_left_comp(.inp1(waddr), .inp2(raddr), .comparator_output(comp_out_1));
    adder #(.THERESHOLD(PAR_WRITE))
                    PAR_WRITE_adder_left(.inp(waddr), .out(a));
    adder #(.THERESHOLD(DEPTH + 1))
                    DEPTH_adder_left(.inp(raddr), .out(c));
    mux_ready mux_ready_module(.inp1(c), .inp2(raddr), .sel(comp_out_1), .mux_output(b));
    comparator_ready #(.size(5))
                    comparator_module_a_b(.inp1(a), .inp2(b), .comparator_output(ready));

    // right-valid=empty
    comparator_empty #(.size(4))
                    read_write_right_comp(.inp1(raddr), .inp2(waddr), .comparator_output(comp_out_2));
    adder #(.THERESHOLD(PAR_READ))
                    PAR_READ_adder_right(.inp(raddr), .out(ap));
    adder #(.THERESHOLD(DEPTH + 1))
                    DEPTH_adder_right(.inp(waddr), .out(cp));
    mux_valid mux_valid_module(.inp1(waddr), .inp2(cp), .sel(comp_out_2),.mux_output(bp));
    comparator_valid #(.size(5))
                    comparator_module_ap_bp(.inp1(ap), .inp2(bp), .comparator_output(valid));
endmodule