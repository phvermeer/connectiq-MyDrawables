import Toybox.Lang;
using Toybox.WatchUi;
using Toybox.Graphics;

module Common {
	class HintSwipeUp extends WatchUi.Drawable {
	
		function  initialize(settings as {
			:identifier as String, 
			:locX as Lang.Numeric, 
			:locY as Lang.Numeric, 
			:width as Lang.Numeric, 
			:height as Lang.Numeric, 
			:visible as Lang.Boolean,
		}) {
			Drawable.initialize(settings);
		}
		
		function draw(dc) {
			var angle = 2.0*Math.PI/360 * 57;
			var w = dc.getWidth();
			var h = dc.getHeight();
			var r_watch = w/2;			// radial of the watchface
			var r_shape = r_watch/2;   	// radial of circle to draw
			var size = r_watch/5; 		// part of the circle that is visible on the edge
			var r_xy = r_watch + r_shape - size;
	
			var x = Math.sin(angle)*r_xy + w/2;
			var y = Math.cos(angle)*-r_xy + w/2;
			
			dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
			dc.fillCircle(locX, locY, r_shape);
		}
	}
}