/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_Onchip_Freq_Divider_Dig (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  //Initialize signals
    reg [7:0] counter;
    reg [6:0] second_counter;
    wire [7:0] comp;
    wire signal;
    wire counter_reset, counter_enable;
    assign uio_oe[7:0] = 8'b11111111; //all bidirectional path used as outputs

    //Project
    assign comp = (ui_in == 8'd0) ? 8'd0 : (ui_in - 8'd1);
    assign signal = counter >= comp; //compare the counter

    //Principal signal used as rst and clk
    assign counter_reset = signal;
    assign counter_enable = signal; // Enable the second counter when the signal is high

    always @(posedge clk) begin
        // if reset, set principal path & counter to 0
        if (!rst_n) begin
            counter <= 8'd0;
        end 
        else begin
            if (counter_reset) 
                counter <= 8'd0;
            else 
                counter <= counter + 1;
        end
    end
    
    always @(posedge clk) begin
        if (!rst_n) begin
            second_counter <= 7'd0;
        end 
        else if (counter_enable) begin
            if (second_counter == ((2**7)-1)) //127
                second_counter <= 7'd0;
            else 
                second_counter <= second_counter + 1;
        end
    end

    //outputs
    assign uo_out[0] = second_counter[5]; 
    assign uo_out[5:1] = second_counter[4:0]; //show the second counter in the 7-segment
    assign uo_out[6] = second_counter[6]; //show the second counter in the 7-segment
    assign uo_out[7] = 1'b1; //always 1 to show the 7-segment dot

    assign uio_out[7:0] = {second_counter[6:0], signal}; //no bidirectional path used as input, all as output

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, uio_in[7:0], 1'b0};

endmodule
