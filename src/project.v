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
    wire reset = !rst_n; //use a positive logic reset
    reg [7:0] counter;
    reg [6:0] second_counter;
    wire [7:0] comp;
    wire signal;
    wire counter_reset;
    wire second_counter_clk;
    assign uio_oe[7:0] = 8'b11111111; //all bidirectional path used as outputs
    assign uo_out[7:0] = 8'd0; //no 7-segment used

    //Project
    assign comp = ui_in - 1;
    assign signal = counter >= comp; //compare the counter

    //Principal signal used as rst and clk
    assign counter_reset = signal;
    assign second_counter_clk = signal;
    
    always @(posedge clk or posedge reset) begin
        // if reset, set principal path & counter to 0
        if (reset) begin
            counter <= 8'd0;
        end 
        else begin
            if (counter_reset) 
                counter <= 8'd0;
            else 
                counter <= counter + 1;
        end
    end
    
    always @(posedge second_counter_clk or posedge reset) begin
        if (reset) begin
            second_counter <= 7'd0;
        end 
        else begin
            if (second_counter == ((2**7)-1)) 
                second_counter <= 7'd0;
            else 
                second_counter <= second_counter + 1;
        end
    end

    //outputs
    assign uio_out[7] = signal;
    assign uio_out[6:0] = second_counter;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, 1'b0};

endmodule
