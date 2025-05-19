module ConvolutionCalculator #(parameter IFMAP_NUM_OF_REG, parameter FILTER_NUM_OF_REG, parameter ADDR_WIDTH_IFMAP, parameter ADDR_WIDTH_FILTER, parameter ELEMENT_WIDTH) 
                    (clk, rst, start, IFMAP, FILTER, output_psum, stride, write_en_IFMAP, write_en_filter, filter_size);
    
    input clk, rst, start;
    input [ELEMENT_WIDTH-1:0] FILTER;
    input [IFMAP_NUM_OF_REG-1:0] stride;
    input [ELEMENT_WIDTH+1:0] IFMAP;
    input [ADDR_WIDTH_FILTER-1:0] filter_size;
    output [ELEMENT_WIDTH-1:0] output_psum;

    wire wfen, dsen, feen, lddc, ferst, woen, ldreg, done;
    wire stall, elco, end_of_row, wfco, wfrst;
    input write_en_IFMAP;
    input write_en_filter;
    wire rst_dp, sel_next;

    datapath #(.IFMAP_NUM_OF_REG(IFMAP_NUM_OF_REG), .FILTER_NUM_OF_REG(FILTER_NUM_OF_REG), .ADDR_WIDTH_IFMAP(ADDR_WIDTH_IFMAP), .ADDR_WIDTH_FILTER(ADDR_WIDTH_FILTER), .ELEMENT_WIDTH(ELEMENT_WIDTH)) 
        Datapath(
        .clk(clk), 
        .rst(rst), 
        .elco(elco), 
        .end_of_row(end_of_row), 
        .wfco(wfco), 
        .done(done), 
        .wfen(wfen), 
        .dsen(dsen), 
        .feen(feen), 
        .ldreg(ldreg), 
        .lddc(lddc), 
        .ferst(ferst), 
        .woen(woen), 
        .stall(stall), 
        .stride(stride),
        .write_en_IFMAP(write_en_IFMAP), 
        .IFMAP_din(IFMAP),
        .write_en_filter(write_en_filter), 
        .filter_din(FILTER),
        .final_output(output_psum),
        .wfrst(wfrst),
        .filter_size(filter_size),
        .rst_cnt(rst_dp),
        .sel_next(sel_next)
    );

    controller Controller(
        .clk(clk), 
        .rst(rst), 
        .stall(stall), 
        .start(start), 
        .elco(elco), 
        .end_of_row(end_of_row), 
        .wfco(wfco), 
        .done(done), 
        .wfen(wfen), 
        .dsen(dsen), 
        .feen(feen), 
        .ldreg(ldreg), 
        .lddc(lddc), 
        .ferst(ferst), 
        .woen(woen), 
        .wfrst(wfrst),
        .rst_dp(rst_dp),
        .sel_next(sel_next)
    );
endmodule