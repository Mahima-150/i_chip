
module CPU(
input wire clk, reset,
input wire [15:0] data_in,
output reg read_write, 
output reg [9:0] memory_address,
output reg [15:0] data_out,
output reg [9:0] PC, reg[15:0] IR, reg[15:0] AC,
output reg start_end
);

reg [15:0]x;
reg [15:0]y;
reg zx, nx, zy, ny, f, no;
wire [15:0]o;
wire zr, ng;

CalC ALU(.x(x), .y(y), .zx(zx), .nx(nx), .zy(zy), .ny(ny), .f(f), .no(no), .o(o), .zr(zr), .ng(ng));

reg [1:0]state;
reg  inst_complete;
reg  mode; 
reg  [4:0]opcode;
reg  [9:0] address;
parameter a=0,b=1,c=2,d=3;

 always @(posedge reset) begin
  PC=0;
  IR=0;
  AC=0;
  start_end=1;
  state = a;
  inst_complete=0;
  end

always@( posedge clk or negedge clk) begin
       if(clk==1 && state==a && start_end==1)begin
         read_write = 1'd0;
         memory_address = PC;
         state = b;
       end 
       else if( clk==1 && state==b ) begin
         IR = data_in;
         mode= data_in[15];
         opcode= data_in[14:10];
         address = data_in[9:0];
         read_write = 0;
         memory_address = data_in[9:0];
         state = c;
       end 
       else if(clk==1 && state==c) begin
         if(mode)begin
         address = data_in;
         memory_address= data_in;
         read_write= 0;
         end
         state=d; 
       end 
       else if(clk==1 && state==d) begin
         case(opcode)
            5'd00 : begin x=AC; y=data_in; zx=1; nx=0; zy=1; ny=0; f=1; no=0; end
            5'd01 : begin x=AC; y=data_in; zx=1; nx=1; zy=1; ny=1; f=1; no=1; end
            5'd02 : begin x=AC; y=data_in; zx=1; nx=1; zy=1; ny=0; f=1; no=0; end
            5'd03 : begin x=AC; y=data_in; zx=0; nx=0; zy=1; ny=1; f=0; no=0; end
            5'd04 : begin x=AC; y=data_in; zx=1; nx=1; zy=0; ny=0; f=0; no=0; end
            5'd05 : begin x=AC; y=data_in; zx=0; nx=0; zy=1; ny=1; f=0; no=1; end
            5'd06 : begin x=AC; y=data_in; zx=1; nx=1; zy=0; ny=0; f=0; no=1; end
            5'd07 : begin x=AC; y=data_in; zx=0; nx=0; zy=1; ny=1; f=1; no=1; end
            5'd08 : begin x=AC; y=data_in; zx=1; nx=1; zy=0; ny=0; f=1; no=1; end
            5'd09 : begin x=AC; y=data_in; zx=0; nx=1; zy=1; ny=1; f=1; no=1; end
            5'd10 : begin x=AC; y=data_in; zx=1; nx=1; zy=0; ny=1; f=1; no=1; end
            5'd11 : begin x=AC; y=data_in; zx=0; nx=0; zy=1; ny=1; f=1; no=0; end
            5'd12 : begin x=AC; y=data_in; zx=1; nx=1; zy=0; ny=0; f=1; no=0; end
            5'd13 : begin x=AC; y=data_in; zx=0; nx=0; zy=0; ny=0; f=1; no=0; end
            5'd14 : begin x=AC; y=data_in; zx=0; nx=1; zy=0; ny=0; f=1; no=1; end
            5'd15 : begin x=AC; y=data_in; zx=0; nx=0; zy=0; ny=1; f=1; no=1; end
            5'd16 : begin x=AC; y=data_in; zx=0; nx=0; zy=0; ny=0; f=0; no=0; end
            5'd17 : begin x=AC; y=data_in; zx=0; nx=1; zy=0; ny=1; f=0; no=1; end
            5'd18 : begin x=AC; y=data_in; zx=1; nx=1; zy=0; ny=0; f=0; no=0; end
            5'd19 : begin x=AC; y=data_in; zx=0; nx=0; zy=1; ny=1; f=0; no=0; read_write=1'd1; data_out=AC; end
            5'd20 : begin x=AC; y=data_in; zx=0; nx=0; zy=1; ny=1; f=0; no=0; PC=address-10'd1; end
            5'd21 : begin x=AC; y=data_in; zx=0; nx=0; zy=1; ny=1; f=0; no=0; if(AC==16'd0) PC=address-10'd1; end
            5'd22 : begin x=AC; y=data_in; zx=0; nx=0; zy=1; ny=1; f=0; no=0; if(AC[15]==1'd1) PC=address-10'd1; end
            5'd23 : begin start_end=1'd0; end
        endcase 
        state=a; 
        inst_complete = 1'd1;
      end 
      else if(clk==0 && inst_complete==1'd1) begin
        AC=o;
        PC=PC + 10'd1;
        inst_complete = 1'd0;
      end  
   end

endmodule
