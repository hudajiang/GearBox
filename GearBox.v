// Generator : SpinalHDL v1.10.0    git head : 270018552577f3bb8e5339ee2583c9c22d324215
// Component : GearBox
// Git hash  : 809f39c32be9e713aa9aebb67f31087e4c0addbf

`timescale 1ns/1ps

module GearBox (
  input  wire          streamDataIn_valid,
  output reg           streamDataIn_ready,
  input  wire [39:0]   streamDataIn_payload,
  input  wire          streamDataInAligSync,
  output reg           streamDataOut_valid,
  input  wire          streamDataOut_ready,
  output wire [23:0]   streamDataOut_payload,
  output wire          streamDataOutAlignSync,
  input  wire          clk,
  input  wire          reset
);

  wire       [3:0]    tempz_tempz_when_UInt_l129;
  wire       [2:0]    tempz_tempz_when_UInt_l129_1;
  wire       [4:0]    tempz_tempz_when_UInt_l129_1_1;
  wire       [2:0]    tempz_tempz_when_UInt_l129_1_2;
  wire       [4:0]    tempz_tempz_when_UInt_l120_4;
  wire       [3:0]    tempz_tempz_when_UInt_l120_4_1;
  wire       [4:0]    tempz_tempz_when_UInt_l120_6;
  wire       [3:0]    tempz_tempz_when_UInt_l120_6_1;
  wire       [3:0]    tempz_tempz_when_UInt_l129_2;
  wire       [2:0]    tempz_tempz_when_UInt_l129_2_1;
  wire       [4:0]    tempz_tempz_when_UInt_l129_3;
  wire       [2:0]    tempz_tempz_when_UInt_l129_3_1;
  wire       [4:0]    tempz_tempz_when_UInt_l120_7;
  wire       [2:0]    tempz_tempz_when_UInt_l120_7_1;
  wire       [7:0]    vecIn_0;
  wire       [7:0]    vecIn_1;
  wire       [7:0]    vecIn_2;
  wire       [7:0]    vecIn_3;
  wire       [7:0]    vecIn_4;
  reg        [7:0]    regVecBus_bus_0;
  reg        [7:0]    regVecBus_bus_1;
  reg        [7:0]    regVecBus_bus_2;
  reg        [7:0]    regVecBus_bus_3;
  reg        [7:0]    regVecBus_bus_4;
  reg        [7:0]    regVecBus_bus_5;
  reg        [7:0]    regVecBus_bus_6;
  reg        [2:0]    regVecBus_ptr;
  reg        [3:0]    regVecBus_occupyNum;
  wire       [3:0]    regVecBusFreeNum;
  wire                regVecBusAlignSyn;
  wire                streamDataIn_fire;
  wire                streamDataOut_fire;
  wire                when_GearBoxHipi_l86;
  wire       [2:0]    tempz_when_UInt_l120;
  wire       [3:0]    tempz_when_UInt_l129;
  reg        [2:0]    tempz_when_UInt_l120_1;
  wire                when_UInt_l129;
  wire       [4:0]    tempz_when_UInt_l129_1;
  reg        [3:0]    tempz_when_UInt_l120_2;
  wire                when_UInt_l129_1;
  reg        [7:0]    tempz_regVecBus_bus_0;
  reg        [7:0]    tempz_regVecBus_bus_1;
  reg        [7:0]    tempz_regVecBus_bus_2;
  reg        [7:0]    tempz_regVecBus_bus_3;
  reg        [7:0]    tempz_regVecBus_bus_4;
  reg        [7:0]    tempz_regVecBus_bus_5;
  reg        [7:0]    tempz_regVecBus_bus_6;
  wire       [3:0]    tempz_when_UInt_l120_3;
  reg        [2:0]    tempz_regVecBus_ptr;
  wire                when_UInt_l120;
  wire       [4:0]    tempz_when_UInt_l120_4;
  reg        [3:0]    tempz_regVecBus_occupyNum;
  wire                when_UInt_l120_1;
  reg        [7:0]    tempz_regVecBus_bus_0_1;
  reg        [7:0]    tempz_regVecBus_bus_1_1;
  reg        [7:0]    tempz_regVecBus_bus_2_1;
  reg        [7:0]    tempz_regVecBus_bus_3_1;
  reg        [7:0]    tempz_regVecBus_bus_4_1;
  reg        [7:0]    tempz_regVecBus_bus_5_1;
  reg        [7:0]    tempz_regVecBus_bus_6_1;
  wire       [3:0]    tempz_when_UInt_l120_5;
  reg        [2:0]    tempz_regVecBus_ptr_1;
  wire                when_UInt_l120_2;
  wire       [4:0]    tempz_when_UInt_l120_6;
  reg        [3:0]    tempz_regVecBus_occupyNum_1;
  wire                when_UInt_l120_3;
  wire       [3:0]    tempz_when_UInt_l129_2;
  reg        [2:0]    tempz_regVecBus_ptr_2;
  wire                when_UInt_l129_2;
  wire       [4:0]    tempz_when_UInt_l129_3;
  reg        [3:0]    tempz_regVecBus_occupyNum_2;
  wire                when_UInt_l129_3;
  wire       [4:0]    tempz_when_UInt_l120_7;
  reg        [3:0]    tempz_streamDataIn_ready;
  wire                when_UInt_l120_4;

  assign tempz_tempz_when_UInt_l129_1 = {1'b0,2'b11};
  assign tempz_tempz_when_UInt_l129 = {1'd0, tempz_tempz_when_UInt_l129_1};
  assign tempz_tempz_when_UInt_l129_1_2 = {1'b0,2'b11};
  assign tempz_tempz_when_UInt_l129_1_1 = {2'd0, tempz_tempz_when_UInt_l129_1_2};
  assign tempz_tempz_when_UInt_l120_4_1 = {1'b0,3'b101};
  assign tempz_tempz_when_UInt_l120_4 = {1'd0, tempz_tempz_when_UInt_l120_4_1};
  assign tempz_tempz_when_UInt_l120_6_1 = {1'b0,3'b101};
  assign tempz_tempz_when_UInt_l120_6 = {1'd0, tempz_tempz_when_UInt_l120_6_1};
  assign tempz_tempz_when_UInt_l129_2_1 = {1'b0,2'b11};
  assign tempz_tempz_when_UInt_l129_2 = {1'd0, tempz_tempz_when_UInt_l129_2_1};
  assign tempz_tempz_when_UInt_l129_3_1 = {1'b0,2'b11};
  assign tempz_tempz_when_UInt_l129_3 = {2'd0, tempz_tempz_when_UInt_l129_3_1};
  assign tempz_tempz_when_UInt_l120_7_1 = {1'b0,2'b11};
  assign tempz_tempz_when_UInt_l120_7 = {2'd0, tempz_tempz_when_UInt_l120_7_1};
  assign vecIn_0 = streamDataIn_payload[7 : 0];
  assign vecIn_1 = streamDataIn_payload[15 : 8];
  assign vecIn_2 = streamDataIn_payload[23 : 16];
  assign vecIn_3 = streamDataIn_payload[31 : 24];
  assign vecIn_4 = streamDataIn_payload[39 : 32];
  assign regVecBusFreeNum = (4'b0111 - regVecBus_occupyNum);
  assign regVecBusAlignSyn = (regVecBus_ptr == 3'b101);
  assign streamDataOutAlignSync = regVecBusAlignSyn;
  assign streamDataIn_fire = (streamDataIn_valid && streamDataIn_ready);
  assign streamDataOut_fire = (streamDataOut_valid && streamDataOut_ready);
  assign when_GearBoxHipi_l86 = (streamDataIn_fire && streamDataOut_fire);
  assign tempz_when_UInt_l129 = ({1'b0,regVecBus_ptr} - tempz_tempz_when_UInt_l129);
  assign when_UInt_l129 = tempz_when_UInt_l129[3];
  always @(*) begin
    if(when_UInt_l129) begin
      tempz_when_UInt_l120_1 = 3'b000;
    end else begin
      tempz_when_UInt_l120_1 = tempz_when_UInt_l129[2 : 0];
    end
  end

  assign tempz_when_UInt_l120 = tempz_when_UInt_l120_1;
  assign tempz_when_UInt_l129_1 = ({1'b0,regVecBus_occupyNum} - tempz_tempz_when_UInt_l129_1_1);
  assign when_UInt_l129_1 = tempz_when_UInt_l129_1[4];
  always @(*) begin
    if(when_UInt_l129_1) begin
      tempz_when_UInt_l120_2 = 4'b0000;
    end else begin
      tempz_when_UInt_l120_2 = tempz_when_UInt_l129_1[3 : 0];
    end
  end

  always @(*) begin
    tempz_regVecBus_bus_0 = regVecBus_bus_3;
    case(tempz_when_UInt_l120)
      3'b000 : begin
        tempz_regVecBus_bus_0 = vecIn_0;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    tempz_regVecBus_bus_1 = regVecBus_bus_4;
    case(tempz_when_UInt_l120)
      3'b001 : begin
        tempz_regVecBus_bus_1 = vecIn_0;
      end
      3'b000 : begin
        tempz_regVecBus_bus_1 = vecIn_1;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    tempz_regVecBus_bus_2 = regVecBus_bus_5;
    case(tempz_when_UInt_l120)
      3'b010 : begin
        tempz_regVecBus_bus_2 = vecIn_0;
      end
      3'b001 : begin
        tempz_regVecBus_bus_2 = vecIn_1;
      end
      3'b000 : begin
        tempz_regVecBus_bus_2 = vecIn_2;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    tempz_regVecBus_bus_3 = regVecBus_bus_6;
    case(tempz_when_UInt_l120)
      3'b010 : begin
        tempz_regVecBus_bus_3 = vecIn_1;
      end
      3'b001 : begin
        tempz_regVecBus_bus_3 = vecIn_2;
      end
      3'b000 : begin
        tempz_regVecBus_bus_3 = vecIn_3;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    tempz_regVecBus_bus_4 = 8'h00;
    case(tempz_when_UInt_l120)
      3'b010 : begin
        tempz_regVecBus_bus_4 = vecIn_2;
      end
      3'b001 : begin
        tempz_regVecBus_bus_4 = vecIn_3;
      end
      3'b000 : begin
        tempz_regVecBus_bus_4 = vecIn_4;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    tempz_regVecBus_bus_5 = 8'h00;
    case(tempz_when_UInt_l120)
      3'b010 : begin
        tempz_regVecBus_bus_5 = vecIn_3;
      end
      3'b001 : begin
        tempz_regVecBus_bus_5 = vecIn_4;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    tempz_regVecBus_bus_6 = 8'h00;
    case(tempz_when_UInt_l120)
      3'b010 : begin
        tempz_regVecBus_bus_6 = vecIn_4;
      end
      default : begin
      end
    endcase
  end

  assign tempz_when_UInt_l120_3 = ({1'b0,tempz_when_UInt_l120} + {1'b0,3'b101});
  assign when_UInt_l120 = (|tempz_when_UInt_l120_3[3 : 3]);
  always @(*) begin
    if(when_UInt_l120) begin
      tempz_regVecBus_ptr = 3'b111;
    end else begin
      tempz_regVecBus_ptr = tempz_when_UInt_l120_3[2 : 0];
    end
  end

  assign tempz_when_UInt_l120_4 = ({1'b0,tempz_when_UInt_l120_2} + tempz_tempz_when_UInt_l120_4);
  assign when_UInt_l120_1 = (|tempz_when_UInt_l120_4[4 : 4]);
  always @(*) begin
    if(when_UInt_l120_1) begin
      tempz_regVecBus_occupyNum = 4'b1111;
    end else begin
      tempz_regVecBus_occupyNum = tempz_when_UInt_l120_4[3 : 0];
    end
  end

  always @(*) begin
    tempz_regVecBus_bus_0_1 = regVecBus_bus_0;
    case(regVecBus_ptr)
      3'b000 : begin
        tempz_regVecBus_bus_0_1 = vecIn_0;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    tempz_regVecBus_bus_1_1 = regVecBus_bus_1;
    case(regVecBus_ptr)
      3'b001 : begin
        tempz_regVecBus_bus_1_1 = vecIn_0;
      end
      3'b000 : begin
        tempz_regVecBus_bus_1_1 = vecIn_1;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    tempz_regVecBus_bus_2_1 = regVecBus_bus_2;
    case(regVecBus_ptr)
      3'b010 : begin
        tempz_regVecBus_bus_2_1 = vecIn_0;
      end
      3'b001 : begin
        tempz_regVecBus_bus_2_1 = vecIn_1;
      end
      3'b000 : begin
        tempz_regVecBus_bus_2_1 = vecIn_2;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    tempz_regVecBus_bus_3_1 = regVecBus_bus_3;
    case(regVecBus_ptr)
      3'b010 : begin
        tempz_regVecBus_bus_3_1 = vecIn_1;
      end
      3'b001 : begin
        tempz_regVecBus_bus_3_1 = vecIn_2;
      end
      3'b000 : begin
        tempz_regVecBus_bus_3_1 = vecIn_3;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    tempz_regVecBus_bus_4_1 = regVecBus_bus_4;
    case(regVecBus_ptr)
      3'b010 : begin
        tempz_regVecBus_bus_4_1 = vecIn_2;
      end
      3'b001 : begin
        tempz_regVecBus_bus_4_1 = vecIn_3;
      end
      3'b000 : begin
        tempz_regVecBus_bus_4_1 = vecIn_4;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    tempz_regVecBus_bus_5_1 = regVecBus_bus_5;
    case(regVecBus_ptr)
      3'b010 : begin
        tempz_regVecBus_bus_5_1 = vecIn_3;
      end
      3'b001 : begin
        tempz_regVecBus_bus_5_1 = vecIn_4;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    tempz_regVecBus_bus_6_1 = regVecBus_bus_6;
    case(regVecBus_ptr)
      3'b010 : begin
        tempz_regVecBus_bus_6_1 = vecIn_4;
      end
      default : begin
      end
    endcase
  end

  assign tempz_when_UInt_l120_5 = ({1'b0,regVecBus_ptr} + {1'b0,3'b101});
  assign when_UInt_l120_2 = (|tempz_when_UInt_l120_5[3 : 3]);
  always @(*) begin
    if(when_UInt_l120_2) begin
      tempz_regVecBus_ptr_1 = 3'b111;
    end else begin
      tempz_regVecBus_ptr_1 = tempz_when_UInt_l120_5[2 : 0];
    end
  end

  assign tempz_when_UInt_l120_6 = ({1'b0,regVecBus_occupyNum} + tempz_tempz_when_UInt_l120_6);
  assign when_UInt_l120_3 = (|tempz_when_UInt_l120_6[4 : 4]);
  always @(*) begin
    if(when_UInt_l120_3) begin
      tempz_regVecBus_occupyNum_1 = 4'b1111;
    end else begin
      tempz_regVecBus_occupyNum_1 = tempz_when_UInt_l120_6[3 : 0];
    end
  end

  assign tempz_when_UInt_l129_2 = ({1'b0,regVecBus_ptr} - tempz_tempz_when_UInt_l129_2);
  assign when_UInt_l129_2 = tempz_when_UInt_l129_2[3];
  always @(*) begin
    if(when_UInt_l129_2) begin
      tempz_regVecBus_ptr_2 = 3'b000;
    end else begin
      tempz_regVecBus_ptr_2 = tempz_when_UInt_l129_2[2 : 0];
    end
  end

  assign tempz_when_UInt_l129_3 = ({1'b0,regVecBus_occupyNum} - tempz_tempz_when_UInt_l129_3);
  assign when_UInt_l129_3 = tempz_when_UInt_l129_3[4];
  always @(*) begin
    if(when_UInt_l129_3) begin
      tempz_regVecBus_occupyNum_2 = 4'b0000;
    end else begin
      tempz_regVecBus_occupyNum_2 = tempz_when_UInt_l129_3[3 : 0];
    end
  end

  always @(*) begin
    streamDataIn_ready = 1'b0;
    if(streamDataInAligSync) begin
      if(streamDataOut_ready) begin
        streamDataIn_ready = ((regVecBus_occupyNum <= 4'b0011) ? 1'b1 : 1'b0);
      end else begin
        streamDataIn_ready = ((regVecBus_occupyNum == 4'b0000) ? 1'b1 : 1'b0);
      end
    end else begin
      if(streamDataOut_ready) begin
        streamDataIn_ready = ((4'b0101 <= tempz_streamDataIn_ready) ? 1'b1 : 1'b0);
      end else begin
        streamDataIn_ready = ((4'b0101 <= regVecBusFreeNum) ? 1'b1 : 1'b0);
      end
    end
  end

  assign tempz_when_UInt_l120_7 = ({1'b0,regVecBusFreeNum} + tempz_tempz_when_UInt_l120_7);
  assign when_UInt_l120_4 = (|tempz_when_UInt_l120_7[4 : 4]);
  always @(*) begin
    if(when_UInt_l120_4) begin
      tempz_streamDataIn_ready = 4'b1111;
    end else begin
      tempz_streamDataIn_ready = tempz_when_UInt_l120_7[3 : 0];
    end
  end

  always @(*) begin
    if(streamDataInAligSync) begin
      streamDataOut_valid = ((regVecBus_occupyNum != 4'b0000) ? 1'b1 : 1'b0);
    end else begin
      streamDataOut_valid = ((4'b0011 <= regVecBus_occupyNum) ? 1'b1 : 1'b0);
    end
  end

  assign streamDataOut_payload = {regVecBus_bus_2,{regVecBus_bus_1,regVecBus_bus_0}};
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      regVecBus_bus_0 <= 8'h00;
      regVecBus_bus_1 <= 8'h00;
      regVecBus_bus_2 <= 8'h00;
      regVecBus_bus_3 <= 8'h00;
      regVecBus_bus_4 <= 8'h00;
      regVecBus_bus_5 <= 8'h00;
      regVecBus_bus_6 <= 8'h00;
      regVecBus_ptr <= 3'b000;
      regVecBus_occupyNum <= 4'b0000;
    end else begin
      if(when_GearBoxHipi_l86) begin
        regVecBus_bus_0 <= tempz_regVecBus_bus_0;
        regVecBus_bus_1 <= tempz_regVecBus_bus_1;
        regVecBus_bus_2 <= tempz_regVecBus_bus_2;
        regVecBus_bus_3 <= tempz_regVecBus_bus_3;
        regVecBus_bus_4 <= tempz_regVecBus_bus_4;
        regVecBus_bus_5 <= tempz_regVecBus_bus_5;
        regVecBus_bus_6 <= tempz_regVecBus_bus_6;
        regVecBus_ptr <= tempz_regVecBus_ptr;
        regVecBus_occupyNum <= tempz_regVecBus_occupyNum;
      end else begin
        if(streamDataIn_fire) begin
          regVecBus_bus_0 <= tempz_regVecBus_bus_0_1;
          regVecBus_bus_1 <= tempz_regVecBus_bus_1_1;
          regVecBus_bus_2 <= tempz_regVecBus_bus_2_1;
          regVecBus_bus_3 <= tempz_regVecBus_bus_3_1;
          regVecBus_bus_4 <= tempz_regVecBus_bus_4_1;
          regVecBus_bus_5 <= tempz_regVecBus_bus_5_1;
          regVecBus_bus_6 <= tempz_regVecBus_bus_6_1;
          regVecBus_ptr <= tempz_regVecBus_ptr_1;
          regVecBus_occupyNum <= tempz_regVecBus_occupyNum_1;
        end else begin
          if(streamDataOut_fire) begin
            regVecBus_bus_0 <= regVecBus_bus_3;
            regVecBus_bus_1 <= regVecBus_bus_4;
            regVecBus_bus_2 <= regVecBus_bus_5;
            regVecBus_bus_3 <= regVecBus_bus_6;
            regVecBus_bus_4 <= 8'h00;
            regVecBus_bus_5 <= 8'h00;
            regVecBus_bus_6 <= 8'h00;
            regVecBus_ptr <= tempz_regVecBus_ptr_2;
            regVecBus_occupyNum <= tempz_regVecBus_occupyNum_2;
          end else begin
            regVecBus_bus_0 <= regVecBus_bus_0;
            regVecBus_bus_1 <= regVecBus_bus_1;
            regVecBus_bus_2 <= regVecBus_bus_2;
            regVecBus_bus_3 <= regVecBus_bus_3;
            regVecBus_bus_4 <= regVecBus_bus_4;
            regVecBus_bus_5 <= regVecBus_bus_5;
            regVecBus_bus_6 <= regVecBus_bus_6;
            regVecBus_ptr <= regVecBus_ptr;
            regVecBus_occupyNum <= regVecBus_occupyNum;
          end
        end
      end
    end
  end


endmodule
