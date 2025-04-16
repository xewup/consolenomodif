package consolebbl.application
{
   import bbl.GlobalProperties;
   import consolebbl.GlobalConsoleProperties;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.text.TextField;
   import net.SocketMessage;
   
   [Embed(source="/_assets/assets.swf", symbol="consolebbl.application.DynFx")]
   public class DynFx extends MovieClip
   {
       
      
      public var bt_exec:SimpleButton;
      
      public var txt_data:TextField;
      
      public function DynFx()
      {
         super();
         this.addEventListener(Event.ADDED,this.init,false,0,true);
      }
      
      public function init(param1:Event) : *
      {
         if(stage)
         {
            this.removeEventListener(Event.ADDED,this.init,false);
            parent.addEventListener("onKill",this.onKill,false,0,true);
            parent.width = 250;
            parent.height = 215;
            Object(parent).redraw();
            this.bt_exec.addEventListener("click",this.execEvt,false,0,true);
         }
      }
      
      public function execEvt(param1:Event) : *
      {
         var _loc2_:* = new SocketMessage();
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,4);
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,27);
         _loc2_.bitWriteString(this.txt_data.text);
         GlobalConsoleProperties.console.blablaland.send(_loc2_);
      }
      
      public function onKill(param1:Event) : *
      {
      }
   }
}
