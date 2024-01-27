// Generator : SpinalHDL v1.10.0    git head : 270018552577f3bb8e5339ee2583c9c22d324215
// Component : EccSecDedDecode
// Git hash  : 13b19e6dddb1a36b08909f856a1b53ea696b0045

`timescale 1ns/1ps

module EccSecDedDecode (
  input  wire [10:0]   dataIn,
  input  wire [4:0]    parityIn,
  output reg  [10:0]   dataOut,
  output reg           oneErrCorrect,
  output reg           twoErrDetect
);

  wire       [10:0]   eccEncode_dataOut;
  wire       [4:0]    eccEncode_parityOut;
  wire                overallCheck;
  wire       [3:0]    parityCkeck;
  wire                when_EccSECDED_l67;
  wire       [3:0]    switch_EccSECDED_l70;

  EccSecDedEncode eccEncode (
    .dataIn    (dataIn[10:0]            ), //i
    .dataOut   (eccEncode_dataOut[10:0] ), //o
    .parityOut (eccEncode_parityOut[4:0])  //o
  );
  always @(*) begin
    oneErrCorrect = 1'b0;
    if(overallCheck) begin
      oneErrCorrect = 1'b1;
    end
  end

  always @(*) begin
    twoErrDetect = 1'b0;
    if(when_EccSECDED_l67) begin
      twoErrDetect = 1'b1;
    end
  end

  always @(*) begin
    dataOut = dataIn;
    if(oneErrCorrect) begin
      case(switch_EccSECDED_l70)
        4'b0011 : begin
          dataOut[0] = (! dataIn[0]);
        end
        4'b0101 : begin
          dataOut[1] = (! dataIn[1]);
        end
        4'b0110 : begin
          dataOut[2] = (! dataIn[2]);
        end
        4'b0111 : begin
          dataOut[3] = (! dataIn[3]);
        end
        4'b1001 : begin
          dataOut[4] = (! dataIn[4]);
        end
        4'b1010 : begin
          dataOut[5] = (! dataIn[5]);
        end
        4'b1011 : begin
          dataOut[6] = (! dataIn[6]);
        end
        4'b1100 : begin
          dataOut[7] = (! dataIn[7]);
        end
        4'b1101 : begin
          dataOut[8] = (! dataIn[8]);
        end
        4'b1110 : begin
          dataOut[9] = (! dataIn[9]);
        end
        4'b1111 : begin
          dataOut[10] = (! dataIn[10]);
        end
        default : begin
        end
      endcase
    end
  end

  assign overallCheck = ((^dataIn) ^ (^parityIn));
  assign parityCkeck = (eccEncode_parityOut[3 : 0] ^ parityIn[3 : 0]);
  assign when_EccSECDED_l67 = ((! overallCheck) && (|parityCkeck));
  assign switch_EccSECDED_l70 = parityCkeck;

endmodule

module EccSecDedEncode (
  input  wire [10:0]   dataIn,
  output wire [10:0]   dataOut,
  output reg  [4:0]    parityOut
);

  wire       [0:0]    tempz_parityOut;
  wire       [4:0]    tempz_parityOut_1;
  wire                parity_0;
  wire                parity_1;
  wire                parity_2;
  wire                parity_3;
  wire                data_0;
  wire                data_1;
  wire                data_2;
  wire                data_3;
  wire                data_4;
  wire                data_5;
  wire                data_6;
  wire                data_7;
  wire                data_8;
  wire                data_9;
  wire                data_10;

  assign tempz_parityOut = data_5;
  assign tempz_parityOut_1 = {data_4,{data_3,{data_2,{data_1,data_0}}}};
  assign dataOut = dataIn;
  assign data_0 = dataIn[0];
  assign data_1 = dataIn[1];
  assign data_2 = dataIn[2];
  assign data_3 = dataIn[3];
  assign data_4 = dataIn[4];
  assign data_5 = dataIn[5];
  assign data_6 = dataIn[6];
  assign data_7 = dataIn[7];
  assign data_8 = dataIn[8];
  assign data_9 = dataIn[9];
  assign data_10 = dataIn[10];
  assign parity_0 = (^{data_10,{data_8,{data_6,{data_4,{data_3,{data_1,data_0}}}}}});
  assign parity_1 = (^{data_10,{data_9,{data_6,{data_5,{data_3,{data_2,data_0}}}}}});
  assign parity_2 = (^{data_10,{data_9,{data_8,{data_7,{data_3,{data_2,data_1}}}}}});
  assign parity_3 = (^{data_10,{data_9,{data_8,{data_7,{data_6,{data_5,data_4}}}}}});
  always @(*) begin
    parityOut[4] = ((^{data_10,{data_9,{data_8,{data_7,{data_6,{tempz_parityOut,tempz_parityOut_1}}}}}}) ^ (^{parity_3,{parity_2,{parity_1,parity_0}}}));
    parityOut[3 : 0] = {parity_3,{parity_2,{parity_1,parity_0}}};
  end


endmodule
