import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

module MyBarrel{
    (:drawables)
    module Drawables{
        class Compass extends Drawable{
            var bearing as Float|Null;
            var darkMode as Boolean;

            function initialize(options as {
                :locX as Number,
                :locY as Number,
                :width as Number,
                :height as Number,
                :visible as Boolean,
                :bearing as Float|Null, // [radians] 0 == 
                :darkMode as Boolean,
            }){
                Drawable.initialize(options);
                bearing = options.get(:bearing) as Float|Null;
                darkMode = options.hasKey(:darkMode) ? options.get(:darkMode) as Boolean : false;
            }

            function draw(dc as Dc) as Void{
                var x = locX + width/2f;
                var y = locY + height/2f;
                var size = width <= height ? width : height;

                if(self.bearing != null){
                    var bearing = self.bearing as Float;

                    var colorNW = Graphics.COLOR_RED;
                    var colorNE = Graphics.COLOR_DK_RED;
                    var colorSW = darkMode ? Graphics.COLOR_WHITE : Graphics.COLOR_LT_GRAY;
                    var colorSE = darkMode ? Graphics.COLOR_LT_GRAY : Graphics.COLOR_DK_GRAY;

                    var sin = 0.5f * size * Math.sin(bearing);
                    var cos = 0.5f * size * Math.cos(bearing);
                    var dxN = -sin;
                    var dyN = -cos;
                    var dxE = cos/5f;
                    var dyE = -sin/5f;

                    dc.setColor(colorNE, Graphics.COLOR_TRANSPARENT);
                    dc.fillPolygon([[x, y], [x+dxN, y+dyN],[x+dxE, y+dyE]] as Array< Array<Numeric> >);
                    dc.setColor(colorNW, Graphics.COLOR_TRANSPARENT);
                    dc.fillPolygon([[x, y], [x+dxN, y+dyN],[x-dxE, y-dyE]] as Array< Array<Numeric> >);
                    dc.setColor(colorSW, Graphics.COLOR_TRANSPARENT);
                    dc.fillPolygon([[x, y], [x-dxN, y-dyN], [x-dxE, y-dyE]] as Array< Array<Numeric> >);
                    dc.setColor(colorSE, Graphics.COLOR_TRANSPARENT);
                    dc.fillPolygon([[x, y], [x-dxN, y-dyN], [x+dxE, y+dyE]] as Array< Array<Numeric> >);
                }else{
                    var dy = size/2f;
                    var dx = dy/5;

                    var color1 = darkMode ? Graphics.COLOR_LT_GRAY : Graphics.COLOR_DK_GRAY;
                    var color2 = darkMode ? Graphics.COLOR_DK_GRAY : Graphics.COLOR_LT_GRAY;
                    dc.setColor(color2, Graphics.COLOR_TRANSPARENT);
                    dc.fillPolygon([[x, y-dy], [x+dx, y], [x-dx, y]] as Array< Array<Numeric> >);
                    dc.setColor(color1, Graphics.COLOR_TRANSPARENT);
                    dc.setPenWidth(1);
                    dc.drawLine(x, y-dy, x+dx, y);
                    dc.drawLine(x+dx, y, x, y+dy);
                    dc.drawLine(x, y+dy, x-dx, y);
                    dc.drawLine(x-dx, y, x, y-dy);
                    dc.drawLine(x-dx, y, x+dx, y);
    //                dc.fillPolygon([[x, y-dy],[x+dx, y], [x, y+dy],[x-dx, y]] as Array< Array<Numeric> >);
                }
            }
        }
    }
}
