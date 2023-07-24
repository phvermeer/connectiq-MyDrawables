import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

module MyDrawables{
    class MyText extends WatchUi.Drawable{
        hidden var text as String;
        hidden var font as FontType;
        hidden var color as ColorType;

        function initialize(options as {
            :text as String,
            :font as FontType,
            :color as ColorType,
        }){
            Drawable.initialize(options);
            var value = options.get(:text);
            text = (value != null) ? value as String : "";
            value = options.get(:font);
            font = (value != null) ? value as FontType : Graphics.FONT_SMALL;
            value = options.get(:color);
            color = (value != null) ? value as ColorType : Graphics.COLOR_DK_GRAY;
        }

        function draw(dc as Dc){
            if(isVisible){
                var margins = getMargins(dc, font);
                var y = locY - margins[2] + (margins[2]+margins[3])/2;
                var x = locX + margins[0];

                dc.setColor(color, Graphics.COLOR_TRANSPARENT);
                dc.drawText(x, y, font, text, Graphics.TEXT_JUSTIFY_LEFT);
            }
        }

        function setText(text as String) as Void{
            self.text = text;
        }
        function getText() as String{
            return text;
        }

        function setFont(font as FontType) as Void{
            self.font = font;
        }
        function getFont() as FontType{
            return font;
        }
        function setColor(color as ColorType) as Void{
            self.color = color;
        }
        function getColor() as ColorType{
            return color;
        }

        hidden function getMargins(dc as Dc, font as FontType) as Array<Number>{
            // return [marginLeft, marginRight, marginTop, marginBottom]

            //  ---------------------┬─ 15 (above baseline) ─┬─ 19 (height)
            //   •  ╭──╮  │   ╭──╮   │                       │
            //   │  │  │  │   │  │   │                       │
            //  -│--╰──╯--╰─--╰──╯-- ┼─  0 (baseline)        │
            //  ─╯------------------ ┴─ -4 (below baseline) ─┴─ 0

            var size = dc.getTextDimensions(text, font);
            var w = size[0];
            var h = size[1];

            var marginBottom = height - h;
            var marginLeftRight = (width - w)/2;

            // get addition margins within returned text height (depends text is number or text)
            var isNumber = (text.toFloat() != null);
            if(isNumber){
                marginBottom += Graphics.getFontDescent(font)*2/3;
            }
            var marginTop = Graphics.getFontAscent(font)/4;
            return [marginLeftRight, marginLeftRight, marginTop, marginBottom] as Array<Number>;
        }
        
        function adaptSize(dc as Dc) as Void{
            // adapt the size to current text and font

            var margins = getMargins(dc, font);
            width -= (margins[0] + margins[1]);
            height -= (margins[2] + margins[3]);
            locX += margins[0];
            locY += (margins[2]+margins[3])/2;
        }

        function adaptFont(dc as Dc, includeNumberFonts as Boolean) as Void{
            // adapt the font to current text and size


            // determine the first(largest) and last(smallest) font to check a fit
            var largestFont = includeNumberFonts ? Graphics.FONT_NUMBER_THAI_HOT : Graphics.FONT_LARGE;
            var smallestFont = Graphics.FONT_XTINY;
            for(var i=largestFont; i>=smallestFont; i--){
                var f = i as Graphics.FontDefinition;
                var margins = getMargins(dc, f);
                var ok = (margins[0] + margins[1] > 0) && ((margins[2] + margins[3] > 0));
                if(ok){
                    font = f;
                    return;
                }
            }
            font = smallestFont;
        }
    }
}