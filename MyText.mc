import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

module MyDrawables{
    class MyText extends WatchUi.Drawable{
        var text as String;
        hidden var font as FontType;
        var color as ColorType;
        hidden var yOffset as Number?;

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
                // update yOffset to correct removal of additional font margins
                if(yOffset == null){
                    var fontMargins = getFontMargins(dc, font);
                    yOffset = Math.round(0.5*(fontMargins[1] - fontMargins[0])).toNumber();
                }

                dc.setColor(color, Graphics.COLOR_TRANSPARENT);
                var x = locX + width/2;
                var y = locY + height/2 + yOffset as Number;
                dc.drawText(x, y, font, text, Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
            }
        }

        function setFont(font as FontType) as Void{
            self.font = font;
            yOffset = null;
        }
        function getFont() as FontType{
            return font;
        }

        hidden function getFontMargins(dc as Dc, font as FontType) as Array<Number>{
            // return [marginTop, marginBottom]

            //  ---------------------┬─ 15 (above baseline) ─┬─ 19 (height)
            //   •  ╭──╮  │   ╭──╮   │                       │
            //   │  │  │  │   │  │   │                       │
            //  -│--╰──╯--╰─--╰──╯-- ┼─  0 (baseline)        │
            //  ─╯------------------ ┴─ -4 (below baseline) ─┴─ 0

            // get addition margins within returned text height (depends text is number or text)
            var isNumber = (text.toFloat() != null);
            var marginBottom = isNumber ? Graphics.getFontDescent(font)*2/3 : 0;
            var marginTop = Graphics.getFontAscent(font)/4;
            return [marginTop, marginBottom] as Array<Number>;
        }
        
        function adaptSize(dc as Dc) as Void{
            // adapt the size to current text and font
            var fontMargins = getFontMargins(dc, font);
            var size = dc.getTextDimensions(text, font);
            var w = size[0];
            var h = size[1] - (fontMargins[0] + fontMargins[1]);

            //locX += Math.round(0.5 * (width - w)).toNumber();
            //locY += Math.round(0.5 * (height - h)).toNumber();
            locX += Math.round(0.5 * (width - w)).toNumber();
            locY += Math.round(0.5 * (height - h)).toNumber();

            width = w;
            height = h;
        }

        function adaptFont(dc as Dc, includeNumberFonts as Boolean) as Void{
            // determine the first(largest) and last(smallest) font to check a fit
            var largestFont = includeNumberFonts ? Graphics.FONT_NUMBER_THAI_HOT : Graphics.FONT_LARGE;
            var smallestFont = Graphics.FONT_XTINY;

            for(var i=largestFont; i>=smallestFont; i--){
                var f = i as Graphics.FontDefinition;
                var size = dc.getTextDimensions(text, f);
                var margins = getFontMargins(dc, f);
                var w = size[0];
                var h = size[1] - (margins[0]+margins[1]);
                var ok = (w <= width) && (h <= height);
                if(ok){
                    font = f;
                    return;
                }
            }
            font = smallestFont;
        }
    }
}