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
  val TypeIsEnGear    = (inSymbolWidth > outSymbolWidth)
}

case class GearBoxBus(cfg: GearBoxGenerics) extends Bundle {
     import cfg._
     val bus        = Vec(Bits(symbolBitWidth bits),buffSymbolWidth)
     val ptr        = UInt(log2Up(buffSymbolWidth)    bits)
     val occupyNum  = UInt(log2Up(buffSymbolWidth) +1 bits)
     val alignSyn   = Bool()

    def push(data:Vec[Bits],alignSyn:Bool) : GearBoxBus ={
      val that     = GearBoxBus(cfg)
      // Calc the possible position of ptr
      val ptrList :List[Int]= (1 to  outSymbolWidth ).map{
        x => (x * inSymbolWidth) % outSymbolWidth
      }.toList.distinct
      println(ptrList)

      for(i <- 0 until buffSymbolWidth){
        switch(ptr){
          for(index <- ptrList){
            is(index){
              if( (i>= index) &&  (i < index + inSymbolWidth)){
                that.bus(i) := data(i-index)
              }
              else {
                that.bus(i) := this.bus(i)
              }
            }
          }
          default{that.bus(i) := this.bus(i) }
        }
      }

      that.alignSyn := alignSyn
      that.ptr      := this.ptr       +| inSymbolWidth
      that.occupyNum:= this.occupyNum +| inSymbolWidth
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
      that.alignSyn := this.alignSyn
      if(TypeIsEnGear) {
        that.ptr := this.ptr -| outSymbolWidth
        that.occupyNum := this.occupyNum -| outSymbolWidth
        that
      }
      else {
        when(this.alignSyn){
          that.ptr := 0
          that.occupyNum := 0
        }.otherwise {
          that.ptr := this.ptr -| outSymbolWidth
          that.occupyNum := this.occupyNum -| outSymbolWidth
        }
        that
      }
    }
}

case class GearBox(cfg:GearBoxGenerics) extends Component{
   import cfg._
   val io = new Bundle{
      val streamDataIn           = slave  Stream(Bits(symbolBitWidth*inSymbolWidth bits))
      val streamDataInAligSync   = in Bool()
      val streamDataOut          = master Stream(Bits(symbolBitWidth*outSymbolWidth bits))
      val streamDataOutAlignSync = out Bool()
   }
  noIoPrefix()
  //ClockDomain.current.reset.setName("rstn")
  val vecIn     = io.streamDataIn.payload.subdivideIn(symbolBitWidth bits)
  val regVecBus = Reg(GearBoxBus(cfg))
  val regVecBusOccupyNum = regVecBus.occupyNum
  val regVecBusFreeNum   = regVecBus.bus.length - regVecBus.occupyNum
  val regVecBusAlignSyn  = {
    if(TypeIsEnGear) {
      (regVecBus.alignSyn & (regVecBus.occupyNum <= outSymbolWidth)) |
        (regVecBus.occupyNum < outSymbolWidth)
    } else {
      regVecBus.alignSyn
    }
  }
  io.streamDataOutAlignSync :=  regVecBusAlignSyn


  regVecBus.bus.foreach(_.init(0))
  regVecBus.ptr.init(0)
  regVecBus.occupyNum.init(0)
  regVecBus.alignSyn.init(False)

  when(io.streamDataIn.fire & io.streamDataOut.fire){
    regVecBus := regVecBus.pop().push(vecIn,io.streamDataInAligSync)
  }.elsewhen(io.streamDataIn.fire){
    regVecBus := regVecBus.push(vecIn,io.streamDataInAligSync)
  }.elsewhen(io.streamDataOut.fire){
    regVecBus := regVecBus.pop()
  }.otherwise{
    regVecBus := regVecBus
  }

  io.streamDataIn.ready    := False
  if(TypeIsEnGear) {
    when(regVecBus.alignSyn) {
      when(io.streamDataOut.ready) {
        io.streamDataIn.ready := (regVecBusOccupyNum <= outSymbolWidth) ? True | False;
      } otherwise {
        io.streamDataIn.ready := (regVecBusOccupyNum === 0) ? True | False;
      }
    }.otherwise{
      when(io.streamDataOut.ready) {
        io.streamDataIn.ready := (regVecBusFreeNum +| outSymbolWidth >= inSymbolWidth) ? True | False;
      } otherwise {
        io.streamDataIn.ready := (regVecBusFreeNum >= inSymbolWidth) ? True | False;
      }
    }

     io.streamDataOut.valid  := (regVecBusOccupyNum  =/= 0            )? True | False;
  // when(regVecBus.alignSyn){
  //   io.streamDataOut.valid  := (regVecBusOccupyNum  =/= 0            )? True | False;
  // }.otherwise{
  //   io.streamDataOut.valid  := (regVecBusOccupyNum  >= outSymbolWidth)? True | False;
  // }

  } else {
    when(regVecBus.alignSyn) {
      when(io.streamDataOut.ready) {
        io.streamDataIn.ready := True | False;
      }
    }.otherwise{
      when(io.streamDataOut.ready) {
        io.streamDataIn.ready := (regVecBusFreeNum +| outSymbolWidth >= inSymbolWidth) ? True | False;
      } otherwise {
        io.streamDataIn.ready := (regVecBusFreeNum >= inSymbolWidth) ? True | False;
      }
    }

    when(regVecBus.alignSyn){
      io.streamDataOut.valid  := (regVecBusOccupyNum  =/= 0            )? True | False;
    }.otherwise{
      io.streamDataOut.valid  := (regVecBusOccupyNum  >= outSymbolWidth)? True | False;
    }
  }

  io.streamDataOut.payload:= regVecBus.bus.take(outSymbolWidth).asBits()
}

object Test extends App{
  //SpinalVerilog(GearBox(GearBoxGenerics(8,6,5)))
  SpinalConfig(anonymSignalPrefix = "tempz").generateVerilog(GearBox(GearBoxGenerics(8,5,3)))
}
