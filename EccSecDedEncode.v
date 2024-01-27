// Generator : SpinalHDL v1.10.0    git head : 270018552577f3bb8e5339ee2583c9c22d324215
// Component : EccSecDedEncode
// Git hash  : 13b19e6dddb1a36b08909f856a1b53ea696b0045

`timescale 1ns/1ps

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
