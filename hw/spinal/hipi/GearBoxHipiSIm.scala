package hipi
package hipi
import spinal.core._
import spinal.core.sim._
import spinal.sim._
import spinal.lib._
import scala.collection.mutable._
case class GearBoxPair (cfg:GearBoxGenerics) extends Component {
  import cfg._
  val io = new Bundle{
    val streamDataIn           = slave  Stream(Bits(symbolBitWidth*inSymbolWidth bits))
    val streamDataInAligSync   = in Bool()
    val streamDataOut          = master Stream(Bits(symbolBitWidth*inSymbolWidth bits))
    val streamDataOutAlignSync = out Bool()
  }
  val enGearbox = GearBox(GearBoxGenerics(cfg.symbolBitWidth,cfg.inSymbolWidth,cfg.outSymbolWidth)).setDefinitionName("enGearBox")
  val deGearbox = GearBox(GearBoxGenerics(cfg.symbolBitWidth,cfg.outSymbolWidth,cfg.inSymbolWidth)).setDefinitionName("deGearBox")

  io.streamDataIn                     <> enGearbox.io.streamDataIn
  io.streamDataInAligSync             <> enGearbox.io.streamDataInAligSync

  enGearbox.io.streamDataOut          <>deGearbox.io.streamDataIn
  enGearbox.io.streamDataOutAlignSync <>deGearbox.io.streamDataInAligSync

  io.streamDataOut                    <> deGearbox.io.streamDataOut
  io.streamDataOutAlignSync           <> deGearbox.io.streamDataOutAlignSync

}
object TestSim extends App {
  SimConfig.withConfig(SpinalConfig(anonymSignalPrefix = "tempz"))
    .withWave.compile(GearBoxPair(GearBoxGenerics(8,64,60))).doSim { dut =>
      dut.clockDomain.forkStimulus(period = 10)
      for (a <- 0 to 100) {
        // Apply input
        dut.clockDomain.waitRisingEdge()
        dut.io.streamDataIn.payload.randomize()
        dut.io.streamDataIn.valid   #= true
        dut.io.streamDataInAligSync   #= false
        dut.io.streamDataOut.ready   #= true
        // Wait for a simulation time unit
      }
    }

}