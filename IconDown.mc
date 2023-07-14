import Toybox.Lang;
using Toybox.Graphics as Gfx;
using Toybox.WatchUi as Ui;
import MyDrawables;

class IconDown extends CustomShape{
  public function initialize(settings as {
    :identifier as Object,
    :locX as Numeric,
    :locY as Numeric,
    :width as Numeric,
    :height as Numeric, 
    :visible as Boolean
  }, color as Gfx.ColorType){

    //  [ ][ ][ ]
    //  [X][X][X]
    //  [ ][X][ ]

    var pts = [
      [0, 1],
      [2, 1],
      [1, 2]
    ];

    CustomShape.initialize(settings, pts as Array< Array<Number> >, 2, color);
  }
}