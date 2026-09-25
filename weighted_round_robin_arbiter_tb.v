`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/04/2026 10:29:30 AM
// Design Name: 
// Module Name: roundRobinArbiter_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module roundRobinArbiter_tb(
    );
    parameter  n=4;
    reg clk, rst;
    reg [n-1:0]request;
    reg ready;
    wire [n-1:0]grant;
    
    always #5 clk=~clk;
    
    roundRobinArbiter DUT(
        .clk(clk),
        .rst(rst),
        .request(request),
        .ready(ready),
        .grant(grant)
    );
    
    initial
    begin
        clk=1'b0;
        rst=1;
        #2
        rst=0;
        request={n{1'b1}};
        ready=1'b1;
        #100
        request =0101;
        #10
        ready=1'b0;
        #30
        ready=1'b1;
        #60
        request=1000;
        #100
        request=0;
        #100
        $finish;
        
        
    end
endmodule