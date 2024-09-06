// Custom Module

module PWM_RegInterface (
  input                  i_clk,
  input                  i_rst,
  input   [31:0]         i_SPI_data_in,   // SPI data in
  input                  i_SPI_data_we,   // SPI data write enbale in
  output  [31:0]         o_SPI_data_out,
  output                 o_SPI_data_we,   // SPI data write enbale out
  output  [7:0]          o_Duty0,         // Ouput Duty Cycles for 0th PWM Channels 
  output  reg            o_Duty0_Valid,
  
  output  [14:0]         o_Final_Value0,   // Ouput Final Value for 0th PWM Channels 
  output  reg            o_Final_Value0_Valid,
  
  output  [7:0]          o_Duty1,         // Ouput Duty Cycles for 1th PWM Channels 
  output  reg            o_Duty1_Valid,
  
  output  [14:0]         o_Final_Value1,   // Ouput Final Value for 1th PWM Channels 
  output  reg            o_Final_Value1_Valid,
  
  output  [7:0]          o_Duty2,         // Ouput Duty Cycles for 2th PWM Channels 
  output  reg            o_Duty2_Valid,
  
  output  [14:0]         o_Final_Value2,   // Ouput Final Value for 2th PWM Channels 
  output  reg            o_Final_Value2_Valid,
  
  output  [7:0]          o_Duty3,         // Ouput Duty Cycles for 3th PWM Channels 
  output  reg            o_Duty3_Valid,
  
  output  [14:0]         o_Final_Value3,   // Ouput Final Value for 3th PWM Channels 
  output  reg            o_Final_Value3_Valid,
  
  input                  i_done0,
  input                  i_done1,
  input                  i_done2,
  input                  i_done3
);
parameter s_Wait = 3'b001,
          s_Register_Read = 3'b010,
          s_Register_Assign = 3'b011;
integer i;
reg [2:0] s_state;

// Instantiating Registers to be used in the design
reg [31:0] SPI_data_reg;
reg reg_SPI_data_we; 
wire edge_SPI_data_we;
reg [7:0] reg_Duty0, reg_Duty1, reg_Duty2, reg_Duty3;
reg [14:0] reg_Final_Value0, reg_Final_Value1, reg_Final_Value2, reg_Final_Value3;

assign o_Duty0 = reg_Duty0;
assign o_Duty1 = reg_Duty1;
assign o_Duty2 = reg_Duty2;
assign o_Duty3 = reg_Duty3;
assign o_Final_Value0 = reg_Final_Value0;
assign o_Final_Value1 = reg_Final_Value1;
assign o_Final_Value2 = reg_Final_Value2;
assign o_Final_Value3 = reg_Final_Value3;
assign edge_SPI_data_we = i_SPI_data_we & (~reg_SPI_data_we);  // Detecting the rising edge of input valid from SPI Slave 
  // Registers to hold current values
 always @(posedge i_clk or posedge i_rst) begin
      if (i_rst) begin 
        reg_SPI_data_we <= 0;
      end
      else begin 
        reg_SPI_data_we <= i_SPI_data_we; // Registering input SPI Data Write Enable
      end
  end
  always @(posedge i_clk or posedge i_rst) begin
    if (i_rst) begin // Initializing ther Signals 
        reg_Duty0  <= 'h0;
        reg_Final_Value0 <= 'h0;
        reg_Duty1  <= 'h0;
        reg_Final_Value1 <= 'h0;
        reg_Duty2  <= 'h0;
        reg_Final_Value2 <= 'h0;
        reg_Duty3  <= 'h0;
        reg_Final_Value3 <= 'h0;
        SPI_data_reg <= 0;
        s_state <= s_Wait;
        
        o_Duty0_Valid <= 1'b0;
        o_Duty1_Valid <= 1'b0;
        o_Duty2_Valid <= 1'b0;
        o_Duty3_Valid <= 1'b0;
        o_Final_Value0_Valid <= 1'b0;
        o_Final_Value1_Valid <= 1'b0;
        o_Final_Value2_Valid <= 1'b0;
        o_Final_Value3_Valid <= 1'b0;
    end 
    else begin
        case (s_state)
            s_Wait: begin // Wiat until we get data on SPI
                if ( (edge_SPI_data_we == 1'b1) & (i_SPI_data_in[27] == 1'b1) ) begin //If user wants to configure a register
                    s_state <= s_Register_Assign;
                    SPI_data_reg <= i_SPI_data_in;
                end
                else begin 
                    s_state <= s_Wait; // Wait until user inputs the data 
                    SPI_data_reg <= 0;
                end
        
                // If the values is Updated in PWM_In module apply logic 0 to the valid output for Duty Cycle and Final Values
                if (i_done0) begin 
                    o_Duty0_Valid <= 1'b0;
                    o_Final_Value0_Valid <= 1'b0;
                end
                if (i_done1) begin 
                    o_Duty1_Valid <= 1'b0;
                    o_Final_Value1_Valid <= 1'b0;
                end
                if (i_done2) begin 
                    o_Duty2_Valid <= 1'b0;
                    o_Final_Value2_Valid <= 1'b0;
                end
                if (i_done3) begin 
                    o_Duty3_Valid <= 1'b0;
                    o_Final_Value3_Valid <= 1'b0;
                end
            end
            
            s_Register_Assign : begin  // Detect at which device user wants to configure Duty Cycle/ Final Value 
                case (SPI_data_reg [31:28])
                    4'b0000 : begin // If use want to configure Duty_Cyle of PWM device 1 
                        reg_Duty0 <= SPI_data_reg [23:16];
                        o_Duty0_Valid <= 1'b1;
                        reg_Final_Value0 <= SPI_data_reg [14:0]; // Configuring Final_Value of PWM device 1 
                        o_Final_Value0_Valid <= 1'b1;
                    end
                    4'b0001 : begin // If use want to configure Duty_Cyle of PWM device 2
                        reg_Duty1 <= SPI_data_reg [23:16];
                        o_Duty1_Valid <= 1'b1;
                        reg_Final_Value1 <= SPI_data_reg [14:0]; // Configuring Final_Value of PWM device 2 
                        o_Final_Value1_Valid <= 1'b1;
                    end
                    4'b0010 : begin // If use want to configure Duty_Cyle of PWM device 3
                        reg_Duty2 <= SPI_data_reg [23:16];
                        o_Duty2_Valid <= 1'b1;
                        reg_Final_Value2 <= SPI_data_reg [14:0]; // Configuring Final_Value of PWM device 3
                        o_Final_Value2_Valid <= 1'b1;
                    end
                    4'b0011 : begin // If use want to configure Duty_Cyle of PWM device 4
                        reg_Duty3 <= SPI_data_reg [23:16];
                        o_Duty3_Valid <= 1'b1;
                        reg_Final_Value3 <= SPI_data_reg [14:0]; // Configuring Final_Value of PWM device 4 
                        o_Final_Value3_Valid <= 1'b1;
                    end
                    default : begin 
                    
                    end
                endcase
                s_state <= s_Wait; // Move back to s_Wait state until use provides another command to input
            end

        endcase
    end
  end

endmodule