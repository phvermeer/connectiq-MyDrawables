import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;

module MyBarrel{
    (:drawables)
    module Drawables{
        class Edge extends WatchUi.Drawable {
            enum EdgePos{
                EDGE_RIGHT = 0,
                EDGE_TOP = 90,
                EDGE_LEFT = 180,
                EDGE_BOTTOM = 270,
                EDGE_ALL = 360,
            }

            // THESE PROPERTIES COULD BE MODIFIED
            public var color as ColorType;
            public var position as EdgePos;
            hidden var screenShape as ScreenShape;

            function  initialize(settings as {
                :visible as Boolean,
                :position as EdgePos, 
                :color as Graphics.ColorType 
            }) {
                Drawable.initialize(settings);
                var deviceSettings = System.getDeviceSettings();
                width = deviceSettings.screenWidth;
                height = deviceSettings.screenHeight;
                screenShape = deviceSettings.screenShape;

                position = settings.hasKey(:position) ? settings.get(:position) as EdgePos : EDGE_TOP;
                color = settings.hasKey(:color) ? settings.get(:color) as ColorType : Graphics.COLOR_LT_GRAY;
            }
            
            function draw(dc) {
                // Draw a red edge on top of the screen
                var penWidth = width > 30 ? width / 30 : 1;
                dc.setPenWidth(penWidth);
                dc.setColor(color, Graphics.COLOR_TRANSPARENT);
                dc.clear();

                switch(screenShape){
                case System.SCREEN_SHAPE_ROUND:
                    {
                        var radius = width/2 - penWidth/2 + 1;
                        if(position == EDGE_ALL){
                            dc.drawCircle(width/2, height/2, radius);
                        }else{
                            var angle =
                                (position == EDGE_RIGHT) ? 0 :
                                (position == EDGE_TOP) ? 90 :
                                (position == EDGE_LEFT) ? 180 :
                                (position == EDGE_BOTTOM) ? 270 : null;
                
                            // Quarter circle
                            if(angle != null){
                                dc.drawArc(width/2, height/2, radius, Graphics.ARC_COUNTER_CLOCKWISE, angle-45, angle+45);
                            }
                        }
                        break;
                    }		
                case System.SCREEN_SHAPE_RECTANGLE:
                    {
                        // Straight line with small hooks
                        switch(position){
                            case EDGE_TOP:
                            {
                                dc.drawLine(0, 0, width, 0);
                                dc.drawLine(0, 0, 0, height/4);
                                dc.drawLine(width, 0, width, height/4);
                                break;
                            }
                            case EDGE_BOTTOM:
                            {
                                dc.drawLine(0, height, width, height);
                                dc.drawLine(0, height, 0, height*3/4);
                                dc.drawLine(width, height, width, height*3/4);
                                break;
                            }
                            case EDGE_LEFT:
                            {
                                dc.drawLine(0, 0, 0, height);
                                dc.drawLine(0, 0, width/4, 0);
                                dc.drawLine(0, height, width/4, height);
                                break;
                            }
                            case EDGE_RIGHT:
                            {
                                dc.drawLine(width, 0, width, height);
                                dc.drawLine(width, 0, width*3/4, 0);
                                dc.drawLine(width, height, width*3/4, height);
                                break;
                            }
                            case EDGE_ALL:
                            {
                                dc.drawRectangle(0, 0, width, height);
                                break;
                            }
                        }
                        break;
                    }
                default:
                    throw new Lang.InvalidOptionsException(format("Unsupported screen shape: $1$", [screenShape]));
                }
            }
        }
    }
}