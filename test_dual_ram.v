module test_dual_ram;
parameter ADDR_SIZE=6, DATA_BITS=8, NO_OF_ADDR=64;
reg clk,we_a,we_b;
reg [ADDR_SIZE-1:0]addr_a,addr_b;

// For driving inout dbus
reg [7:0] drive_a, drive_b;
reg drive_en_a, drive_en_b;
wire [7:0] dbus_a, dbus_b;

wire [DATA_BITS-1:0]dout_a,dout_b;

// Connect drive reg and databus
assign dbus_a = drive_en_a ? drive_a : 8'hzz;
assign dbus_b = drive_en_b ? drive_b : 8'hzz;

dual_port_ram DUT(dout_a,dout_b,clk,addr_a,addr_b,dbus_a,dbus_b,we_a,we_b);

initial begin
    $dumpfile("dp_ram.vcd");
    $dumpvars(0,test_dual_ram);

    clk=1'b0;
end

always #5 clk=!clk;

initial begin  
    #2;
    drive_en_a = 1;
    drive_en_b = 1;

    drive_a = 8'h33;
    addr_a = 6'h01;

    drive_b = 8'h44;
    addr_b = 6'h02;

    we_a = 1;
    we_b = 1;

    #10;

    drive_a = 8'h55;
    addr_a = 6'h03;

    addr_b = 6'h01;
    we_b = 0;    // read from addr_b

    #10;

    addr_a = 6'h02;
    addr_b = 6'h03;
    we_a = 0;    // read from addr_a

    #10;

    addr_a = 6'h01;
    drive_b = 8'h77;
    addr_b = 6'h02;
    we_b = 1;

    #10;
    $finish;

end

endmodule