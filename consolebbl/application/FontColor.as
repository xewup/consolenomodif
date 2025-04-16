package consolebbl.application
{
   import bbl.GlobalProperties;
   import flash.display.MovieClip;
   import flash.events.Event;
   import ui.ColorPanel;
   
   [Embed(source="/_assets/assets.swf", symbol="consolebbl.application.FontColor")]
   public class FontColor extends MovieClip
   {
       
      
      public var palette:ColorPanel;
      
      public function FontColor()
      {
         super();
         this.addEventListener(Event.ADDED,this.init,false,0,true);
         this.palette.addEventListener("onChanged",this.updateDemo,false,0,true);
      }
      
      public function updateDemo(param1:Event) : *
      {
         stage.color = this.palette.DEC;
         GlobalProperties.sharedObject.data.POPUP.FONT_COLOR = this.palette.DEC;
      }
      
      public function init(param1:Event) : *
      {
         if(stage)
         {
            this.removeEventListener(Event.ADDED,this.init,false);
            parent.width = 160;
            parent.height = 200;
            Object(parent).redraw();
            this.palette.DEC = 5263488;
            if(GlobalProperties.sharedObject.data.POPUP.FONT_COLOR !== undefined)
            {
               this.palette.DEC = GlobalProperties.sharedObject.data.POPUP.FONT_COLOR;
            }
         }
      }
   }
}
