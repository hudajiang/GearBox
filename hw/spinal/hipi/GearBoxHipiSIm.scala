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
        dut.io.streamDataInAligSync   #= true
        dut.io.streamDataOut.ready   #= true
        // Wait for a simulation time unit
      }
    }
}

object GearBoxSim extends App {
  val txQuene         = scala.collection.mutable.Queue[BigInt]()
  val txAlignSynQuene = scala.collection.mutable.Queue[Boolean]()
  val rxQuene         = scala.collection.mutable.Queue[BigInt]()
  val rxAlignSynQuene = scala.collection.mutable.Queue[Boolean]()

  val compliled = SimConfig.withConfig(SpinalConfig(anonymSignalPrefix = "tempz"))
                  .withWave.compile(GearBoxPair(GearBoxGenerics(8, 64, 60)))
    compliled.doSim { dut =>
    dut.clockDomain.forkStimulus(10)
    val inputDriver = driver(dut.io.streamDataIn,dut.io.streamDataInAligSync ,dut.clockDomain)
    val outmonitor = monitor(dut.io.streamDataOut,dut.io.streamDataInAligSync,dut.clockDomain)
    var rx_fire_cnt = 0
    val txOnStreamFire = onStreamFire(dut.io.streamDataIn,dut.clockDomain) {
      val data     =  dut.io.streamDataIn.payload.toBigInt
      val alignSync = dut.io.streamDataInAligSync.toBoolean
      txQuene.enqueue(data)
      txAlignSynQuene.enqueue(alignSync)
      printf("txQuene is %d\n",txQuene.length)
    }
    val rxOnStreamFire = onStreamFire(dut.io.streamDataOut,dut.clockDomain) {
      val data      =  dut.io.streamDataOut.payload.toBigInt
      val alignSync = dut.io.streamDataOutAlignSync.toBoolean
      rxQuene.enqueue(data)
      rxAlignSynQuene.enqueue(alignSync)
      printf("rxQuene is %d\n",rxQuene.length)
      rx_fire_cnt += 1
    }
    val mycheck = check(dut.clockDomain)
    waitUntil(rx_fire_cnt==100000000)
  }

  def driver[T <: Data](stream: Stream[T],alignSync:Bool, clkdm: ClockDomain) = fork {
    var driver_cnt = 0
    println("driver is runing")
    while (true) {
      clkdm.waitSampling()
      sleep(0)
      stream.payload.randomize()
      stream.valid.randomize()
      alignSync.randomize()
      printf("drivercnt is %d\n", driver_cnt)
      driver_cnt = driver_cnt + 1
    }
  }

  def monitor[T <: Data](stream: Stream[T],alignSync:Bool, clkdm: ClockDomain) = fork {
    while (true) {
      println("monitor is runing")
      stream.ready.randomize()
      clkdm.waitSampling()
    }
  }
  def check(clkdm: ClockDomain) = fork {
    while (true) {
      clkdm.waitSampling()
      while(!rxQuene.isEmpty && !txQuene.isEmpty) {
        val txdata     = txQuene.dequeue()
        val txalignSyn = txAlignSynQuene.dequeue()
        val rxdata     = rxQuene.dequeue()
        val rxalignSyn = rxAlignSynQuene.dequeue()
        printf("left=%x   right=%x\n",txdata,rxdata)
        assert(txdata == rxdata)
        assert(txalignSyn == txalignSyn)
      }
    }
  }
  def onStreamFire[T <: Data](stream: Stream[T], clockDomain: ClockDomain)(body: => Unit): Unit = fork {
    while (true) {
      println("onStream is runing")
      clockDomain.waitSampling()
      var dummy = if (stream.valid.toBoolean && stream.ready.toBoolean) {
        body
      }
    }
  }
}