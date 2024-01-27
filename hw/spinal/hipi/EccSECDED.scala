package hipi
import spinal.core._
import spinal.core.sim._
import spinal.sim._
import spinal.lib._


case class EccGenerics(dataWith:Int,parityWidth:Int){
   //2**k >= n+k+1
   println(s"DataWidht= ${dataWith}",s"PataWidht= ${parityWidth}")
   require(scala.math.pow(2,parityWidth-1) >= dataWith + parityWidth )

  var PositionList =(1 to dataWith).toList

  // calc position
  for(n <- 0 until parityWidth-1){
    PositionList = PositionList.map(x=>{
      if( x>= scala.math.pow(2,n).toInt){ x+1 } else { x } })
  }

  // (position -- index)
  val PositionAndData = PositionList.zipWithIndex
}
case class  EccSecDedEncode(cfg:EccGenerics)extends Component{
  import cfg._
  val io = new Bundle {
    val dataIn       = in  Bits(cfg.dataWith bits)
    val dataOut      = out Bits(cfg.dataWith bits)
    val parityOut    = out Bits(cfg.parityWidth bits)
  }
  noIoPrefix()
  io.dataOut := io.dataIn
  val parity = Vec(Bool(),cfg.parityWidth-1)
  val data   =  io.dataIn.asBools

  for(n <- 0 until cfg.parityWidth-1){
    parity(n):= {
      for{(position,bitIndex) <- PositionAndData
          if ((position & 1<<n)!=0)}
      yield data(bitIndex)
    }.xorR
  }
  io.parityOut.msb := data.xorR ^ parity.xorR
  io.parityOut(cfg.parityWidth-2 downto 0) := parity.asBits
}


case class  EccSecDedDecode(cfg:EccGenerics)extends Component {
  import cfg._
  val io = new Bundle {
    val dataIn          = in Bits (cfg.dataWith bits)
    val parityIn        = in Bits (cfg.parityWidth bits)
    val dataOut         = out Bits (cfg.dataWith bits)
    val oneErrCorrect   = out Bool()
    val twoErrDetect    = out Bool()
  }
  noIoPrefix()
  io.oneErrCorrect:=False
  io.twoErrDetect:=False
  io.dataOut := io.dataIn
  val eccEncode =  EccSecDedEncode(cfg)
  eccEncode.io.dataIn    <> io.dataIn
  val overallCheck = io.dataIn.xorR ^ io.parityIn.xorR
  val parityCkeck = eccEncode.io.parityOut(cfg.parityWidth-2 downto 0) ^ io.parityIn(cfg.parityWidth-2 downto 0)

  io.oneErrCorrect.setWhen(overallCheck )
  io.twoErrDetect.setWhen (!overallCheck && parityCkeck.orR)

  when(io.oneErrCorrect) {
    switch(parityCkeck.resize(cfg.parityWidth - 1).asUInt) {
      for ((position, bitIndex) <- PositionAndData) {
        is(position) {
          io.dataOut(bitIndex) := ~io.dataIn(bitIndex)
        }
      }
    }
  }
}
object EccTest extends App{
  //SpinalVerilog(GearBox(GearBoxGenerics(8,6,5)))
  SpinalConfig(anonymSignalPrefix = "tempz").generateVerilog(EccSecDedEncode(EccGenerics(11,5)))
  SpinalConfig(anonymSignalPrefix = "tempz").generateVerilog(EccSecDedDecode(EccGenerics(11,5)))
}
