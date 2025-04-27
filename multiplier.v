// creating a multipler by repeated addition and 
// specifiying the data path , control signals and control path.

// Data path 
// I am using variuos sequential and combinational circuits for the operation 
// so defining them before using 
// PIPO register to load the A input 

module PIPO1 ( dout , din, ld,clk);

    input [15: 0 ] din;
    input ld,clk;
    output reg [15:0] dout;

    always @(posedge clk)
        if (ld) 
            dout <= din;
endmodule

// PIPO  register for output of product P  

module PIPO2( dout , din, ld, clr,clk );
     input [15: 0 ] din;
    input ld,clk, clr;
    output reg [15:0] dout;
    always @(posedge clk)
        if (clr) 
            dout <= 16'b0;
        else if (ld) 
                dout <= din;
endmodule

// defining an adder for repeated addition 

module add(out , a , b );
    input [15: 0 ] a,b;
    output reg [15:0] out;
    always @(*)
        out = a + b;
endmodule

// defining a comparator , to check whether to continue or not 

module comp( eqz , data);
    input[15:0] data;
    output eqz;
    assign eqz = (data==0);
endmodule

// down counter for B 

module cntr( dout, din, ld, dec, clk);
    input [15:0]din;
    input ld, dec,clk;
    output reg [ 15:0] dout;
    always @(posedge clk)
        if (ld) dout <= din;
        else if (dec) dout <= dout-1;
endmodule

// end of data path 
//....................................................................
// CONTROL PATH or the FSM modelling 

module controller( lda, ldb, ldp, clrp, decb,done, clk, eqz, start);
    input clk , eqz, start;
    output reg lda,ldb,ldp, clrp,decb,done;
    reg [2:0] state;
    parameter s0=3'b000;
    parameter s1=3'b001;
    parameter s2=3'b010;
    parameter s3=3'b011;
    parameter s4=3'b100;

    always @ ( posedge clk)
        begin 
        case (state)
            s0: if ( start) state <= s1;
            s1: state <= s2;
            s2: state <= s3;
            s3: #2 if (eqz) state <= s4;
                    else state <=s3;
            s4: state <= s4;
        default : state <= s0;
        endcase 
    end

// Control Signals 

    always @ ( state)
        begin 
        case (state)
            s0: begin #1 lda=0 ;ldb=0 ;ldp=0 ;clrp= 0;decb=0 ;done = 0 ;end
            s1: begin #1 lda=1 ;done = 0 ;end
            s2: begin #1 lda= 0;ldb=1;clrp=1 ;done = 0 ;end
            //s3: begin #1 ldb=0 ;ldb=0; ldp= 1 ;clrp= 0;decb=1 ;end
            s3: begin #1 ldb=0; ldp= 1 ;clrp= 0;decb=1 ;done = 0 ;end
            s4: begin #1 done= 1  ;ldb=0 ;ldp= 0 ;decb=0 ;end
            default begin #1 lda = 0 ; ldb = 0; ldp = 0; clrp= 0 ; decb=0;done = 0 ; end
        endcase
        end
endmodule
// end of Control Signal and Control Path 

// Calling final multiplier 

module mul(eqz, lda,ldb,ldp,clrp,decb,data_in,clk, product);
    input lda,ldb,ldp,clrp,decb,clk; // lda = load A , ldb = load B , P= product , decb = To decrese B , clrp = Clear P 
    input [15:0] data_in;
    output eqz; // to compare the left value with B 
    wire [15:0] x,y,z,bout,bus;
    output [15:0] product;
    assign bus = data_in; 
    assign product = y;


// calling the blocks designed earlier 
    PIPO1 A (x, bus, lda, clk);
    PIPO2 P ( y,z,ldp,clrp,clk);
    cntr B ( bout, bus, ldb, decb, clk);
    add d ( z,x,y);
    comp e ( eqz, bout);
    


endmodule



