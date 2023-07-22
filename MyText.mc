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
                dc.setColor(color, Graphics.COLOR_TRANSPARENT);
                dc.drawText(locX + width/2, locY + height/2, font, text, Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
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

        function updateDimensions(dc as Dc) as Void{
            var dimensions = dc.getTextDimensions(text, font);
            var w = dimensions[0];
            var h = dimensions[1];
            locX += (width - w)/2;
            locY += (height - h)/2;
            width = w;
            height = h;
        }
    }
}