package projectname
import spinal.core._
import spinal.lib._
import spinal.lib.graphic.Rgb
import spinal.lib.misc.pipeline._
case class MyTopLevelPipe() extends Component {
  val io = new Bundle{
    val up    = slave Stream(Rgb(8,8,8))
    val down  = master Stream(Rgb(8,8,8) )
  }
  noIoPrefix()
  val a,b,c = new Node
  val ab = StageLink(a,b)
  val bc = StageLink(b,c)
  a.arbitrateFrom(io.up)
  val RED = a.insert(io.up.payload.r)
  //val GREE = b.insert(b(RED)+b(RED)D
  val onC = new c.Area {
    c.arbitrateTo(io.down)
    io.down.r := RED
    io.down.g := RED
    io.down.b := RED
  }

  Builder(ab,bc)
}

object MyTopLevelVerilogPipe extends App {
  Config.spinal.generateVerilog(MyTopLevelPipe())
}