import Toybox.Lang;
using Toybox.Graphics as Gfx;
using Toybox.WatchUi as Ui;

class IconUp extends CustomShape{
  public function initialize(settings as {
    :identifier as Object,
    :locX as Numeric,
    :locY as Numeric,
    :width as Numeric,
    :height as Numeric, 
    :visible as Boolean
  }, color as Gfx.ColorType){

    //  [ ][X][ ]
    //  [X][X][X]
    //  [ ][ ][ ]

    var pts = [
      [1, 0],
      [2, 1],
      [0, 1]
    ];

    CustomShape.initialize(settings, pts as Array< Array<Number> >, 2, color);
  }

/*
    // ToDo draw a icon that indicates elevation (based on a size of 4x4)
    //  [ ][X][X][X][X]
    //  [ ][ ][X][ ][X]
    //  [ ][X][ ][X][X]
    //  [X][ ][X][ ][X]
    //  [ ][X][ ][ ][ ]

    var _pts = [
      [1, 0],
      [4, 0],
      [4, 3],
      [3, 2],
      [1, 4],
      [0, 3],
      [2, 1]
    ];
*/
}