`include "multiplier.v"

module fsmtest; 
    reg [15:0] data_in;
    reg start, clk;
    wire done;
    wire [15:0] product;

    mul DP( eqz, lda,ldb,ldp,clrp,decb,data_in,clk,product); 
    controller con( lda, ldb, ldp, clrp, decb,done, clk, eqz, start);

    initial 
        begin 
            clk = 1'b0;
            #3 start = 1'b1;
            #500 $finish;

        end
    always #5 clk = ~ clk ; 

    initial 
        begin
        #17 data_in= 5;
        #10 data_in = 5;
        end
    initial 
        begin
            $monitor( $time, "Product= %d,Done=%b",product, done);

        end
endmodule


