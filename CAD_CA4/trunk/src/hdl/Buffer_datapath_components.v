`timescale 1ns/1ns

module fifo_buffer #(parameter WIDTH, parameter DEPTH, parameter PAR_READ , parameter PAR_WRITE) 
                    (clk, rst, din, dout, wen, waddr, raddr, read_en);
    input clk, rst, wen, read_en;
    input [0:(WIDTH * PAR_WRITE) - 1] din;
    output reg [0:(WIDTH * PAR_READ) - 1] dout;
    
    input [3:0] waddr, raddr;
    reg [WIDTH-1:0] buffer [DEPTH:0];

    integer i, j, k;
    reg [WIDTH-1:0] din_chunk, dout_chunk;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // for (i = 0; i <= DEPTH; i = i + 1)
            //     buffer[i] <= 0;
        end
        else if (wen) begin
            for (j = 0; j < PAR_WRITE; j = j + 1) begin
                din_chunk = din[(j * WIDTH) +: WIDTH];
                buffer[(j + waddr) % (DEPTH + 1)] <= din_chunk;
            end
        end
    end

    always @(posedge clk) begin
        // dout = 0;
        // if (read_en) begin
            for (k = 0; k < PAR_READ; k = k + 1) begin
                dout_chunk = buffer[(((k + raddr) % (DEPTH + 1))) % (DEPTH + 1)];
                dout[(k * WIDTH) +: WIDTH] = dout_chunk;
            end
        // end
    end
endmodule

module write_cnt #(parameter PAR_WRITE, parameter DEPTH)
                    (clk, rst, wcenten, waddr);
    parameter size = 4;
    localparam ZERO = 4'b0000;
    input clk, rst, wcenten;
    output reg [size-1:0] waddr;
    always @(posedge clk or posedge rst) begin
        if (rst)
            waddr <= ZERO;
        else begin
            if (wcenten) begin
                waddr <= waddr + PAR_WRITE;
            end
        end
    end
    assign waddr = (waddr >= DEPTH + 1) ? waddr - (DEPTH + 1) : waddr;
endmodule

module read_cnt #(parameter PAR_READ, parameter DEPTH)
                (clk, rst, rcenten, raddr);
    parameter size = 4;
    localparam ZERO = 4'b0000;
    input clk, rst, rcenten;
    output reg [size-1:0] raddr;
    always @(negedge clk or posedge rst) begin
        if (rst)
            raddr <= ZERO;
        else begin
            if (rcenten)
                raddr <= raddr + PAR_READ;
        end
    end
    assign raddr = (raddr >= DEPTH + 1) ? raddr - (DEPTH + 1) : raddr;
endmodule

module checkout(waddr, raddr, full, empty);
    input [3:0] waddr, raddr;
    output reg full, empty;
    assign empty = (waddr == raddr) ? 1'b1 : 1'b0;
    assign full = (raddr - waddr == 4'b001) ? 1'b1 : 1'b0;
endmodule

module comparator_full #(parameter size) (inp1, inp2, comparator_output);
    input [size - 1:0] inp1, inp2;
    output comparator_output;
    assign comparator_output = (inp1 < inp2) ? 1'b1 : 1'b0;
endmodule

module adder #(parameter THERESHOLD) (inp, out);
    input [3:0] inp;
    output [4:0] out;
    assign out = inp + THERESHOLD;
endmodule

module mux_ready(inp1, inp2, sel, mux_output);
    input [4:0] inp1;
    input [3:0] inp2;
    input sel;
    output [4:0] mux_output;
    assign mux_output = (sel == 1'b1) ? {1'b0,inp2} : inp1;
endmodule

module comparator_ready #(parameter size) (inp1, inp2, comparator_output);
    input [size - 1:0] inp1, inp2;
    output comparator_output;
    assign comparator_output = (inp1 < inp2) ? 1'b1 : 1'b0;
endmodule

module comparator_empty #(parameter size) (inp1, inp2, comparator_output);
    input [size - 1:0] inp1, inp2;
    output comparator_output;
    assign comparator_output = (inp1 <= inp2) ? 1'b1 : 1'b0;
endmodule

module mux_valid(inp1, inp2, sel, mux_output);
    input [3:0] inp1;
    input [4:0] inp2;
    input sel;
    output [4:0] mux_output;
    assign mux_output = (sel == 1'b1) ? {1'b0,inp1} : inp2;
endmodule

module comparator_valid #(parameter size) (inp1, inp2, comparator_output);
    input [size - 1:0] inp1, inp2;
    output comparator_output;
    assign comparator_output = (inp1 <= inp2) ? 1'b1 : 1'b0;
endmodule


