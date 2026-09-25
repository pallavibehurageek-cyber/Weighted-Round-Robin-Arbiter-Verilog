`timescale 1ns / 1ps

module roundRobinArbiter
    #(parameter n=4,
      parameter w=3, //bits for storing weight of each requester
      parameter [n*w-1:0]weights={3'd4,3'd2,3'd1,3'd1}
    )
    (
    input clk, rst, 
    input [n-1:0]request,
    output reg [n-1:0]grant,
    input ready
    );
    
    integer k;
    
    
    reg [n-1:0]maskReg;
    wire [n-1:0]allowed;
    reg found;
    reg [n*w-1:0] credit;
    
    
    wire [n-1:0] credit_nonzero;
    wire creditsExhausted;
    assign creditsExhausted= &(~credit_nonzero);

    genvar i;
    generate
        for (i = 0; i < n; i = i + 1) begin
            assign credit_nonzero[i] = (credit[i*w +: w] != 0);
        end
    endgenerate
    
    assign allowed= maskReg & request & credit_nonzero;
    
    always @(*)
    begin
        grant='d0;
        found=1'b0;
        for(k=0;k<n;k=k+1)begin
            if(!found && allowed[k] ) begin
                grant[k]=1'b1;
                found=1'b1;
            end
        end
        if (!found) begin
            for (k = 0; k < n; k=k+1) begin
                if (!found && request[k] && credit_nonzero[k]) begin
                    grant[k] = 1'b1;
                    found = 1'b1;
                end
            end
        end
    end
    
    always @(posedge clk or posedge rst)
    begin
        if(rst) begin
            maskReg<={n{1'b1}};
            credit  <= weights;

        end else begin
            if(ready) begin
                for (k = 0; k < n; k= k+1) begin
                    if (grant[k] && credit[k*w +: w] != 0)
                        credit[k*w +: w] <= credit[k*w +: w] - 1'b1;
                end 
                for(k=0;k<n;k=k+1)begin
                    if(grant[k])begin
                        maskReg<=({n{1'b1}}<<(k+1));
                    end
                end
                
                if(creditsExhausted)
                    credit<=weights;
            end
        end
    end
endmodule