
module memory_cpu_tb;
 reg clk, reset;
 reg [15:0] data_in;
 wire read_write; 
 wire [9:0] memory_address;
 wire [15:0] data_out;
 wire [9:0] PC;
 wire[15:0] IR;
 wire[15:0] AC;
 wire start_end;
 
CPU (.clk(clk), .reset(reset), .data_in(data_in), .read_write(read_write), .memory_address(memory_address), .data_out(data_out), .PC(PC), .IR(IR), .AC(AC), .start_end(start_end));

reg [15:0] memory[0:1023];

always@(posedge clk or negedge clk) begin 
   if(clk==0 && read_write==1'd0)
     data_in = memory[memory_address];
   else if(clk==1 && read_write==1'd1)
     memory[memory_address] = data_out;
end

always begin 
# 0.5 clk = ~clk;
end            

initial begin
  clk = 1'd0;
  $readmemh("C:\Users\pc\Desktop\project_mahima_calC\Program.txt", memory, 0, 400);
  $readmemh("C:\Users\pc\Desktop\project_mahima_calC\Data.txt", memory, 401, 1023);
  reset=1'd0;
  reset=1'd1;
end

integer count=0;
always@(posedge clk) begin
  count = count + 1;
  if(start_end==1'd0) begin
    $display("count=%d", count);
    $writememh("C:\Users\pc\Desktop\project_mahima_calC\Output_CPU.txt", memory,401,1023);
    $finish;
  end  
end

endmodule
