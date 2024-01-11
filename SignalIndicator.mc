import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;

module MyBarrel{

	class SignalIndicator extends WatchUi.Drawable {
        enum SignalLevel{
            SIGNAL_NONE = 0,
            SIGNAL_POOR = 1,
            SIGNAL_FAIR = 2,
            SIGNAL_GOOD = 3,
        }

		// THESE PROPERTIES COULD BE MODIFIED
		public var darkMode as Boolean;
        public var level as SignalLevel;
        public var size as Numeric;

		function  initialize(settings as {
			:visible as Boolean,
			:darkMode as Boolean,
            :level as SignalLevel,
		}) {

			Drawable.initialize(settings);
            darkMode = settings.hasKey(:darkMode) ? settings.get(:darkMode) as Boolean : false;
            level = settings.hasKey(:level) ? settings.get(:level) as SignalLevel : SIGNAL_NONE;

            var deviceSettings = System.getDeviceSettings();
            var w = deviceSettings.screenWidth;
            var h = deviceSettings.screenHeight;
            size = (w>h ? h : w)/3;
            if(!settings.hasKey(:width)){ width = size; }
            if(!settings.hasKey(:height)){ height = size; }
		}
		
		function draw(dc) {
			// Draw a red edge on top of the screen
			if(isVisible){
                var colorOff = darkMode ? Graphics.COLOR_DK_GRAY : Graphics.COLOR_LT_GRAY;
                var colorOn  = darkMode ? Graphics.COLOR_WHITE : Graphics.COLOR_BLACK;

                var radius = height;
                var margin = 0.05 * radius;
                var h = (radius - 2 * margin)/(SIGNAL_GOOD+1);
                var x = locX + width/2;
                var y = locY + height;

                var angle = Math.asin((width/2f)/radius)*180/(Math.PI);
                //var angle = 30; //Math.asin((width/2f)/radius);

                // test
                dc.setPenWidth(h);
                dc.setColor(colorOn, Graphics.COLOR_TRANSPARENT);
                var r = h/2;
                for(var l=SIGNAL_NONE; l<=SIGNAL_GOOD; l++){
                    if(level<l){
                        dc.setColor(colorOff, Graphics.COLOR_TRANSPARENT);
                    }
                    dc.drawArc(x, y, r, Graphics.ARC_CLOCKWISE, 90+angle, 90-angle);
                    r += margin + h;
                }
			}
		}
	}
}