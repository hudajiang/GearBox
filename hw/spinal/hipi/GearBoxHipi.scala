package hipi
import spinal.core._
import spinal.core.sim._
import spinal.sim._
import spinal.lib._
import scala.collection.mutable._
case class GearBoxGenerics(symbolBitWidth:Int,inSymbolWidth:Int,outSymbolWidth:Int) {
   require(inSymbolWidth  < 2*outSymbolWidth)
   require(outSymbolWidth < 2*inSymbolWidth)
  val buffSymbolWidth = inSymbolWidth + outSymbolWidth -1
}

case class GearBoxBus(cfg: GearBoxGenerics) extends Bundle {
     import cfg._
     val bus        = Vec(Bits(symbolBitWidth bits),buffSymbolWidth)
     val ptr        = UInt(log2Up(buffSymbolWidth)    bits)
     val occupyNum  = UInt(log2Up(buffSymbolWidth) +1 bits)
     def alignSyn   = (ptr === inSymbolWidth)

    def push(data:Vec[Bits]) : GearBoxBus ={
      val that     = GearBoxBus(cfg)
      val ptrList = ListBuffer[Int]()
      var inwidth = inSymbolWidth
      val outwidth = outSymbolWidth
      var delta = 0
      println(delta)
      while(!ptrList.contains(delta)){
        ptrList.append(delta)
        delta = inwidth % outwidth
        println(inwidth,outwidth,delta)
        inwidth = inwidth + inSymbolWidth
      }
      println(ptrList)
      that.bus := this.bus
      switch(ptr){
        for(index <- ptrList){
          is(index){
            for( i<- 0 until inSymbolWidth){
                 that.bus(index + i) := data(i)
            }
          }
        }
      }
      that.ptr      := this.ptr       + inSymbolWidth
      that.occupyNum:= this.occupyNum + inSymbolWidth
      that
    }

    def pop() : GearBoxBus ={
      val that = GearBoxBus(cfg)
      for(index <- 0 until buffSymbolWidth){
        if(index + outSymbolWidth < buffSymbolWidth) {
            that.bus(index ) := this.bus(index + outSymbolWidth)
        }
        else {
          that.bus(index ).clearAll()
        }
      }
      that.ptr      := this.ptr        - outSymbolWidth
      that.occupyNum:= this.occupyNum  - outSymbolWidth
      that
    }
}

case class GearBox(cfg:GearBoxGenerics) extends Component{
   import cfg._
   val io = new Bundle{
      val streamDataIn  = slave  Stream(Bits(symbolBitWidth*inSymbolWidth bits))
      val streamDataOut = master Stream(Bits(symbolBitWidth*outSymbolWidth bits))
      val streamDataOutAlignSync = out Bool()
   }
  noIoPrefix()
  //ClockDomain.current.reset.setName("rstn")
  val vecIn     = io.streamDataIn.payload.subdivideIn(symbolBitWidth bits)
  val regVecBus = Reg(GearBoxBus(cfg))
  val regVecBusOccupyNum = regVecBus.occupyNum
  val regVecBusFreeNum   = regVecBus.bus.length - regVecBus.occupyNum
  val regVecBusAlignSyn  = regVecBus.alignSyn
  io.streamDataOutAlignSync :=  regVecBusAlignSyn


  regVecBus.bus.foreach(_.init(0))
  regVecBus.ptr.init(0)
  regVecBus.occupyNum.init(0)

  when(io.streamDataIn.fire & io.streamDataOut.fire){
    regVecBus := regVecBus.pop().push(vecIn)
  }.elsewhen(io.streamDataIn.fire){
    regVecBus := regVecBus.push(vecIn)
  }.elsewhen(io.streamDataOut.fire){
    regVecBus := regVecBus.pop()
  }.otherwise{
    regVecBus := regVecBus
  }

  io.streamDataIn.ready    := False
  when(io.streamDataOut.ready){
    io.streamDataIn.ready := (regVecBusFreeNum +| outSymbolWidth >= inSymbolWidth)? True | False;
  }otherwise {
    io.streamDataIn.ready := (regVecBusFreeNum                   >= inSymbolWidth)? True | False;
  }

  io.streamDataOut.valid  := (regVecBusOccupyNum                 >= outSymbolWidth)? True | False;

  io.streamDataOut.payload:= regVecBus.bus.take(outSymbolWidth).asBits()

}

object Test extends App{
  //SpinalVerilog(GearBox(GearBoxGenerics(8,6,5)))
  SpinalConfig(anonymSignalPrefix = "tempz").generateVerilog(GearBox(GearBoxGenerics(8,5,3)))
}
object TestSim extends App {
   SimConfig.withConfig(SpinalConfig(anonymSignalPrefix = "tempz"))
     .withWave.compile(GearBox(GearBoxGenerics(8,5,3))).doSim { dut =>
     dut.clockDomain.forkStimulus(period = 10)
     for (a <- 0 to 7) {
       // Apply input
       dut.clockDomain.waitRisingEdge()
       dut.io.streamDataIn.payload.randomize()
       dut.io.streamDataIn.valid   #= true
       dut.io.streamDataOut.ready   #= true
       // Wait for a simulation time unit
     }
   }

}