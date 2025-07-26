module dual_port_ram(dout_a,dout_b,clk,addr_a,addr_b,dbus_a,dbus_b,we_a,we_b);
parameter ADDR_SIZE=6, DATA_BITS=8, NO_OF_ADDR=64;
input clk,we_a,we_b;                //we_x: write_enable_x, cs:chip select
input [ADDR_SIZE-1:0]addr_a,addr_b;
inout tri [DATA_BITS-1:0]dbus_a,dbus_b;          //the tristate data bus
output reg [DATA_BITS-1:0]dout_a,dout_b;

wire [DATA_BITS-1:0]din_a,din_b; 

reg [DATA_BITS-1:0] ram [NO_OF_ADDR-1:0]; //8*64 bit ram

assign dbus_a=!we_a?dout_a:8'hzz;
assign dbus_b=!we_b?dout_b:8'hzz;
assign din_a=we_a?dbus_a:8'hzz;
assign din_b=we_b?dbus_b:8'hzz;


always @(posedge clk)
begin 
    if(we_a) 
        ram[addr_a]<=din_a;
    else 
        dout_a<=ram[addr_a];
end

always @(posedge clk)
begin 
    if(we_a) 
        ram[addr_b]<=din_b;
    else 
        dout_b<=ram[addr_b];
end

endmodule