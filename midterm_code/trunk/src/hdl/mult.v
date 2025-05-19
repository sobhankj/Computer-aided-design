`timescale 1ns/1ns


module mult #(parameter size)(inp1, inp2, mult_output);
    input signed[size-1:0] inp1, inp2;
    output signed [size-1:0] mult_output;
    wire signed [(2*size - 1):0] temp;

    assign temp = inp1 * inp2;
    assign mult_output = temp[((2*size - 1)-1):(size-1)];
endmodule

// module booth_multiplier(input signed [31:0] A, B, output signed [63:0] z);
//   reg signed [31:0] multiplicand;
//   reg signed [63:0] product;
//   reg signed [32:0] booth;
//   integer i;

//   always @(A or B) begin
//     multiplicand = A;
//     product = 0;
//     booth = {B, 1'b0}; // Append 0 to the LSB for Booth's algorithm

//     // Booth's algorithm main loop
//     for (i = 0; i < 32; i = i + 1) begin
//       case (booth[1:0])
//         2'b01: product = product + (multiplicand << i);
//         2'b10: product = product - (multiplicand << i);
//         default: ; // No operation for 2'b00 or 2'b11
//       endcase
//       booth = {booth[32], booth[32:1]}; // Arithmetic shift right
//     end
//   end

//   assign z = product[63:32];

// endmodule
