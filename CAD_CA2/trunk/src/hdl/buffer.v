`timescale 1ns/1ns
// `include "shared_params.vh"

module Buffer #(parameter NUM_BIT = 4, NUM_REG = 4, ADDR_REG = 2, PAR_WRITE = 2, PAR_READ = 1 , NUMP1 = 5)
(clk, rst, wen, waddr, raddr, din, dout);

    input clk , rst , wen;
    input [ADDR_REG : 0] waddr , raddr;
    input [(PAR_WRITE * NUM_BIT) - 1 : 0] din;
    output [(PAR_READ * NUM_BIT) - 1 : 0] dout;

    // one register more than usual
    // a 256-word, 32-bit memory
    //reg [31:0] Imem[0:255];
    reg [NUM_BIT - 1 : 0] buffer [0 : NUM_REG];

    //here is for reading from the buffer
    genvar i;
    generate
        for (i = 0; i < PAR_READ; i = i + 1) begin
            assign dout[(NUM_BIT * (i + 1)) - 1 : NUM_BIT * i] = buffer[(raddr + i) % NUMP1];
        end
    endgenerate
    //here is for writing into the buffer
    integer k, o;
    always @(posedge clk) begin
        if (rst) begin
            // Initialize buffer entries to zero
            for (k = 0; k < NUM_REG; k = k + 1) begin
                buffer[k] <= {NUM_BIT{1'b0}};
            end
        end 
        else if (wen) begin
            for (o = 0; o < PAR_WRITE; o = o + 1) begin
                buffer[(waddr + o) % NUMP1] <= din[(NUM_BIT * (o + 1)) - 1 -: NUM_BIT];
            end
        end
    end
endmodule
