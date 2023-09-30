import Toybox.Lang;
import Toybox.Graphics;
using Toybox.WatchUi;

module MyDrawables{
  class CustomShape extends WatchUi.Drawable{
    hidden var _pts as Array<Array<Numeric> > = [] as Array<Array <Numeric> >;
    hidden var _color as ColorType;

    public function initialize(options as {
      :identifier as Object,
      :locX as Numeric,
      :locY as Numeric,
      :width as Numeric,
      :height as Numeric, 
      :visible as Boolean
    }, pts as Array< Array<Numeric> >, size as Number, color as ColorType){
      Drawable.initialize(options);
      _color = color;

      //  [ ][X][ ]
      //  [X][X][X]
      //  [ ][ ][ ]
      //
      //  var pts = [[1,0],[2,1],[0,1]];
      //  maxWidth x maxHeight = 2x2 => size = 2;   

      var factor = width>height ? height/size : width/size;
      var xOffset = (width-factor*size)/2 + locX;
      var yOffset = (height-factor*size)/2 + locY;

      for(var i=0; i<pts.size(); i++){
        _pts.add([
          pts[i][0] * factor + xOffset,
          pts[i][1] * factor + yOffset
        ] as Array<Numeric>);
      }
    }
    
    public function draw(dc){
      dc.setColor(_color, Graphics.COLOR_TRANSPARENT);
      dc.fillPolygon(_pts);
    }
  }
}