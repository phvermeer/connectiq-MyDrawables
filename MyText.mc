import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Graphics;
import MyTools;

module MyDrawables{
	class MyText extends WatchUi.Text{
		static private var dummyDc as Dc;
		function initialize(options as {
			:text as String or Symbol, 
			:color as Graphics.ColorType, 
			:backgroundColor as Graphics.ColorType, 
			:font as Graphics.FontType, 
			:justification as Graphics.TextJustification or Number, 
			:locX as Numeric, 
			:locY as Numeric,
			:width as Numeric,
			:height as Numeric,
		}){
			dummyDc = initDummyDc();
			Text.initialize(options);
		}
		
		function getFont() as Graphics.FontReference{
			return self.mFont;
		}
		
		function getText() as String{
			return self.mText;
		}
		
		function getColor() as Graphics.ColorType{
			return self.mColor;
		}

		public static function getOptimizedFont(w as Numeric, h as Numeric, text as String, useNumberFonts as Boolean) as FontType{
			// search for the font that fits within the given dimensions
			var fontMin = Graphics.FONT_XTINY;
			var fontMax = useNumberFonts ? Graphics.FONT_NUMBER_THAI_HOT : Graphics.FONT_LARGE;

			//loop through the fonts until the font is too large
			var font = fontMin;
			while(font < fontMax){
				var fontTest = (font + 1) as FontDefinition;
				var margins = getFontMargins(fontTest);
				var dh = margins[0] + margins[1];
				var dimensions = dummyDc.getTextDimensions(text, fontTest);
				if(dimensions == null || dimensions[0] > w || dimensions[1] - dh > h){
					break;
				}
				font = fontTest;
			}
			return font;
		}
		public function optimizeFont(useNumberFonts as Boolean) as Void{
			var text = (mText == null) ? "..." : mText.toString();
			var newFont = getOptimizedFont(width, height, text, useNumberFonts);
			setFont(newFont);
		}

		public static function getOptimizedDimensions(text as String, font as FontType) as Array<Number> | Null{
			// modify size for font and text
			var dimensions = dummyDc.getTextDimensions(text, font);
			if(dimensions != null){
				var w = dimensions[0];
				var h = dimensions[1];'
				var margins = getFontMargins(font);

				h -= margins[0] + margins[1];
				return [w, h] as Array<Number>;
			}
			return null;
		}

		public static function getTextDimensions(text as String, font as FontType) as Array<Number> | Null {
			// Use a dummy dc just for retrieving text sizes
			return dummyDc.getTextDimensions(text, font);
		}

		private function initDummyDc() as Dc{
			if(dummyDc != null){
				return dummyDc;
			}else{
				var layer = new WatchUi.Layer({});
				dummyDc = layer.getDc() as Dc;
				return dummyDc;
			}
		}

		public function draw(dc as Dc){
			var text = mText == null ? "..." : mText.toString();

			// calculate x,y offset occording text justication
			var xOffset;
			var yOffset;

			// vertical alignment
			var margins = getFontMargins(mFont);
			var marginTop = margins[0];
			var marginBottom = margins[1];
			var textHeight = Graphics.getFontHeight(mFont) - (marginTop + marginBottom);
			if(mJustification & Graphics.TEXT_JUSTIFY_VCENTER > 0){
				// middle
				yOffset = (height - textHeight) / 2 - marginTop;
			}else{
				// top
				yOffset = 0 - marginTop;
			}

			// horizontal alignment
			var textWidth = dummyDc.getTextWidthInPixels(text, mFont);
			if(mJustification & Graphics.TEXT_JUSTIFY_CENTER > 0){
				// center
				xOffset = (width - textWidth) / 2;
			}else if(mJustification & Graphics.TEXT_JUSTIFY_RIGHT > 0){
				// right
				xOffset = (width - textWidth);
			}else{
				// left
				xOffset = 0;
			}

			dc.setColor(mColor, mBackgroundColor);
			dc.drawText(locX + xOffset, locY + yOffset, mFont, text, Graphics.TEXT_JUSTIFY_LEFT);
		}

		private static function getFontMargins(font as FontType) as Array<Number>{
			// retrieves the top and bottom margin of current font
			var marginBottom = Graphics.getFontDescent(mFont) * 4/5 - 1;
			var marginTop = Graphics.getFontAscent(mFont) * 1/4 - 1;
			return [marginTop, marginBottom] as Array<Number>;
		}
	}
}