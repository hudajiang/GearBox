package hipi
import spinal.core._
import spinal.core.sim._
import spinal.sim._
import spinal.lib._
import scala.collection.mutable._

case class EccPair (cfg:EccGenerics) extends Component {
  import cfg._
  val io = new Bundle {
    val dataIn          = in  Bits(cfg.dataWith bits)
    val dataOut         = out Bits (cfg.dataWith bits)
    val oneErrCorrect   = out Bool()
    val twoErrDetect    = out Bool()
    val bus             = in Bits(cfg.dataWith+cfg.parityWidth bits)
  }
  val eccEncode =  EccSecDedEncode(cfg)
  val eccDecode =  EccSecDedDecode(cfg)
  eccEncode.io.dataIn<>io.dataIn
  eccDecode.io.dataOut <> io.dataOut
  eccDecode.io.oneErrCorrect <> io.oneErrCorrect
  eccDecode.io.twoErrDetect  <> io.twoErrDetect
  eccDecode.io.dataIn   := eccEncode.io.dataOut   ^ io.bus(0,cfg.dataWith bits)
  eccDecode.io.parityIn := eccEncode.io.parityOut ^ io.bus(cfg.dataWith,cfg.parityWidth bits)
}

object EccSim extends App {
  val compliled = SimConfig.withConfig(SpinalConfig(anonymSignalPrefix = "tempz"))
    .withWave.compile(EccPair(EccGenerics(246, 9)))
  compliled.doSim { dut =>
    dut.clockDomain.forkStimulus(10)
    for (cnt <- 0 to 1000) {
      dut.io.dataIn.randomize()
      dut.io.bus#= 1.toBigInt<<cnt%(dut.cfg.dataWith + dut.cfg.parityWidth)
      sleep(1)
      assert(dut.io.dataIn.toBigInt == dut.io.dataOut.toBigInt)
    }
  }
}
