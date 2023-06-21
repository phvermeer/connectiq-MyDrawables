using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
import Toybox.Lang;

class HintStart extends WatchUi.Drawable {
	var x_area as Numeric;
	var y_area as Numeric;
	var r_area as Numeric;
	var pts_arrow as Array< Array< Numeric > >;

	function  initialize(settings as {
		:identifier as String,
		:locX as Number,
		:locY as Number,
		:width as Number,
		:height as Number,
	}) {
		Drawable.initialize(settings);
		
		var deviceSettings = System.getDeviceSettings();
		var w = deviceSettings.screenWidth;
		var h = deviceSettings.screenHeight;
		
		// calculate drawing with relative watch size
		var angle = (2.0f * Math.PI/360 * 57);
		var r_watch = w/2;			// radial of the watchface
		r_area = r_watch/3;   	// radial of circle to draw
		var size = r_area; 		// part of the circle that is visible on the edge

		var r_xy = r_watch + r_area - size;
		x_area = Math.sin(angle)*r_xy + w/2;
		y_area = Math.cos(angle)*-r_xy + h/2;

		// Now the inner arrow (triangle)
		r_xy = r_watch - size/2;
		var x_arrow = Math.sin(angle)*r_xy + w/2;
		var y_arrow = Math.cos(angle)*-r_xy + w/2;
		
		var angle_start = 0.5f*Math.PI; 
		var angle_step = 2.0f*Math.PI/3.0f; 
		var angle_stop = 2.0f*Math.PI;
		var r_arrow = size/4;
		
		pts_arrow = [] as Array< Array< Numeric > >; 
		for(angle = angle_start; angle<angle_stop; angle += angle_step){
			var x = x_arrow + Math.sin(angle) * r_arrow;
			var y = y_arrow + -1.0* Math.cos(angle) * r_arrow;
			pts_arrow.add([x,y] as Array< Numeric >);
		}
	}
	
	
	function draw(dc) {
		// Draw the indicator area
		dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
		dc.fillCircle(x_area, y_area, r_area);
		
		// Now draw the inner trangle
		dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
		dc.fillPolygon(pts_arrow);
	}
}