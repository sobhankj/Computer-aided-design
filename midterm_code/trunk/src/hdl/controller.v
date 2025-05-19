`timescale 1ns/1ns
module controller(clk, rst, start, Reset, init , sel , ready);
    input clk, rst, start, Reset , ready;
    output reg init , sel;

    reg [4:0] ps, ns; 

    parameter [4:0] Idle = 0, pre = 1, getN = 2, fetch = 3;

    always @(*) begin
        ns = Idle;
        case (ps)
            Idle: ns = (start) ? pre : Idle;

            pre: ns = (start) ? pre : getN;

            getN: ns = fetch;

            fetch: ns = (Reset) ? Idle : fetch;
        endcase
    end

    always @(*) begin
        {init , sel} = 2'b00;   
        case (ps)
            Idle: begin
            end

            pre: begin
                init = 1'b1;
            end
            
            getN: begin

            end
            
            fetch: begin
                if (ready)
                    sel = 1'b1;
                else
                    sel = 1'b0;
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
