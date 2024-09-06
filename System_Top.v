//Custom Testbench

module System_Top(
input i_rst,
input i_clk,
input i_sck,
input i_mosi,
input i_ss_n,
output o_miso
);

wire [31:0] o_rx_data;
wire o_rx_int;
wire [7:0] w_Duty0, w_Duty1, w_Duty2, w_Duty3;
wire [14:0] w_Final_Value0, w_Final_Value1, w_Final_Value2, w_Final_Value3;
wire w_Duty0_Valid, w_Duty1_Valid, w_Duty2_Valid, w_Duty3_Valid, w_Final_Value0_Valid, w_Final_Value1_Valid, w_Final_Value2_Valid, w_Final_Value3_Valid;
wire w_done0, w_done1, w_done2, w_done3;
spi_slave #(.CPOL (1'b0), .CPHA (1'b0), .WIDTH (32), .LSB (1'b0))  
dut_SPI (
.i_clk (i_clk),      
.i_rst (i_rst),          

.i_sck (i_sck),           
.i_mosi (i_mosi),         
.i_ss_n (i_ss_n),          
.o_miso (o_miso),          
.o_miso_oe (),      

.i_reset (i_rst),         
.i_tx_data (),      
.o_tx_int (),        
.o_rx_int (o_rx_int),        
.o_rx_data (o_rx_data)            
);

PWM_RegInterface dut_PWM_RegInterface (
.i_clk (i_clk), 
.i_rst (i_rst), 
.i_SPI_data_in (o_rx_data), 
.i_SPI_data_we (o_rx_int), 
.o_SPI_data_out (), 
.o_SPI_data_we (), 
.o_Duty0 (w_Duty0), 
.o_Duty0_Valid (w_Duty0_Valid),
.o_Final_Value0 (w_Final_Value0),
.o_Final_Value0_Valid (w_Final_Value0_Valid), 
.o_Duty1 (w_Duty1), 
.o_Duty1_Valid (w_Duty1_Valid),
.o_Final_Value1 (w_Final_Value1), 
.o_Final_Value1_Valid (w_Final_Value1_Valid),
.o_Duty2 (w_Duty2), 
.o_Duty2_Valid (w_Duty2_Valid),
.o_Final_Value2 (w_Final_Value2),
.o_Final_Value2_Valid (w_Final_Value2_Valid), 
.o_Duty3 (w_Duty3), 
.o_Duty3_Valid (w_Duty3_Valid),
.o_Final_Value3 (w_Final_Value3),
.o_Final_Value3_Valid (w_Final_Value3_Valid),

.i_done0 (w_done0),
.i_done1 (w_done1),
.i_done2 (w_done2),
.i_done3 (w_done3)
);

Pwm_In #( .R(7), .TimerBits(15) )
dut_PWM_0(
.clk (i_clk),
.reset_n (~i_rst),
.duty (w_Duty0),
.Final_Value (w_Final_Value0),
.ready (w_Duty0_Valid),
.done (w_done0),
.pwm_out ()
);

Pwm_In #( .R(7), .TimerBits(15) )
dut_PWM_1(
.clk (i_clk),
.reset_n (~i_rst),
.duty (w_Duty1),
.Final_Value (w_Final_Value1),
.ready (w_Duty1_Valid),
.done (w_done1),
.pwm_out ()
);

Pwm_In #( .R(7), .TimerBits(15) )
dut_PWM_2(
.clk (i_clk),
.reset_n (~i_rst),
.duty (w_Duty2),
.Final_Value (w_Final_Value2),
.ready (w_Duty2_Valid),
.done (w_done2),
.pwm_out ()
);

Pwm_In #( .R(7), .TimerBits(15) )
dut_PWM_3(
.clk (i_clk),
.reset_n (~i_rst),
.duty (w_Duty3),
.Final_Value (w_Final_Value3),
.ready (w_Duty3_Valid),
.done (w_done3),
.pwm_out ()
);
endmodule