`timescale 1ns/1ns
// parameter num_of_words = 8;
// parameter bits_of_words = 32;
// parameter address_bits = 3;

module Output_memory #(parameter num_of_words = 8, parameter bits_of_words = 32, parameter address_bits = 3)(clk, address, write_enable, word);
    input [address_bits - 1:0] address;
    input [bits_of_words - 1:0] word;
    input clk, write_enable;

    reg [bits_of_words - 1:0] output_memory [0:num_of_words - 1];

    always @(posedge clk , write_enable) begin
        if(write_enable)
            output_memory[address] <= word;
            $writememh("data_output.txt", output_memory);
    end
endmodule