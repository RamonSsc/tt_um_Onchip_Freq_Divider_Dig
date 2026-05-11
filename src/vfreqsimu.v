`timescale 1ns / 100ps // `timescale <time_unit> / <time_precision>

`include "tt_um_Onchip_Freq_Divider_Dig.v"
//////////////////////////////////////////////////////////////////////////////////


module vfreqsimu();

    reg clk, rst;
    reg [7:0] cnt;
    wire [7:0] uo_out;
    //wire [7:0] uio_in;
    wire [7:0] uio_oe,uio_out;

    
    tt_um_Onchip_Freq_Divider_Dig vfreq (
        .clk(clk),
        .ui_in(cnt),
        .rst_n(rst),
        .uo_out(uo_out),
        //.uio_in(uio_in),
        .uio_out(uio_out),
        //.ena(1'd1),
        .uio_oe(uio_oe)
    );

    always begin
        #5;
        clk = ~clk;
    end
    
    initial begin
        $dumpfile("vfreqsimu.vcd");  // Crea el archivo VCD
        $dumpvars;                   // Registra todas las señales

        clk = 1'b0;
        rst = 1'b0;
        #10;
        rst = 1'b1;
        #10;
        $display($time);
        cnt = 8'd3;
        #500;
        $display($time);
        cnt = 8'd10;
        #1000;
        $display($time);
        cnt = 8'd32;
        #10000;
        $finish;
    end
endmodule
