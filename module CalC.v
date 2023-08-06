
module CalC(
input [15:0]x,
input [15:0]y,
input zx, nx, zy, ny, f, no,
output [15:0]o,
output zr, ng
    );
    
    wire [7:0] mid_zx, mid_nx;
    assign mid_zx = x&~({16{zx}});
    assign mid_nx = nx^~({16{mid_zx}});
    
    wire [15:0] mid_zy, mid_ny;
    assign mid_zy = y&~({16{zy}});
    assign mid_ny = ny^~({16{mid_zy}});
    
    wire [15:0] f_o;
    assign f_o = f?(mid_nx + mid_ny):(mid_nx & mid_ny);
    
    assign o = ({16{no}})^~(f_o);
    
    assign zr = ~(o == 16'd0);
    assign ng = o[15];
     
endmodule
