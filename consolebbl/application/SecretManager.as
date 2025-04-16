package consolebbl.application
{
   import bbl.GlobalProperties;
   import consolebbl.GlobalConsoleProperties;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import net.ParsedMessageEvent;
   import net.SocketMessage;
   import ui.ValueSelector;
   
   public class SecretManager extends MovieClip
   {
       
      
      public var vs_modoChat:ValueSelector;
      
      public var vs_poursuite:ValueSelector;
      
      public var bt_save:SimpleButton;
      
      public function SecretManager()
      {
         super();
         this.addEventListener(Event.ADDED,this.init,false,0,true);
      }
      
      public function init(param1:Event) : *
      {
         if(stage)
         {
            this.removeEventListener(Event.ADDED,this.init,false);
            parent.width = 260;
            parent.height = 100;
            Object(parent).redraw();
            this.vs_modoChat.minValue = 0;
            this.vs_modoChat.maxValue = GlobalConsoleProperties.console.blablaland.grade - 1;
            this.vs_poursuite.minValue = 0;
            this.vs_poursuite.maxValue = GlobalConsoleProperties.console.blablaland.grade - 1;
            this.bt_save.addEventListener("click",this.onApply,false,0,true);
            parent.addEventListener("onKill",this.onKill,false,0,true);
            this.loadParams();
         }
      }
      
      public function loadParams(param1:Event = null) : *
      {
         mouseChildren = false;
         alpha = 0.5;
         GlobalConsoleProperties.console.blablaland.addEventListener("onParsedMessage",this.onMessage,false,0,true);
         var _loc2_:SocketMessage = new SocketMessage();
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,4);
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,22);
         _loc2_.bitWriteUnsignedInt(16,Object(parent).pid);
         GlobalConsoleProperties.console.blablaland.send(_loc2_);
      }
      
      public function onMessage(param1:ParsedMessageEvent) : *
      {
         var _loc2_:SocketMessage = null;
         var _loc3_:uint = 0;
         if(param1.evtType == 6)
         {
            if(param1.evtStype == 12)
            {
               _loc2_ = param1.getMessage();
               _loc3_ = _loc2_.bitReadUnsignedInt(16);
               if(_loc3_ == Object(parent).pid)
               {
                  param1.stopImmediatePropagation();
                  GlobalConsoleProperties.console.blablaland.removeEventListener("onParsedMessage",this.onMessage,false);
                  this.vs_modoChat.value = _loc2_.bitReadUnsignedInt(GlobalProperties.BIT_GRADE);
                  this.vs_poursuite.value = _loc2_.bitReadUnsignedInt(GlobalProperties.BIT_GRADE);
                  mouseChildren = true;
                  alpha = 1;
               }
            }
         }
      }
      
      public function onApply(param1:Event = null) : *
      {
         GlobalProperties.sharedObject.data.POPUP.SECRETCHAT = this.vs_modoChat.value;
         GlobalProperties.sharedObject.data.POPUP.SECRETPOURSUITE = this.vs_poursuite.value;
         var _loc2_:SocketMessage = new SocketMessage();
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,4);
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,23);
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_GRADE,this.vs_modoChat.value);
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_GRADE,this.vs_poursuite.value);
         GlobalConsoleProperties.console.blablaland.send(_loc2_);
         Object(parent).close();
      }
      
      public function onKill(param1:Event) : *
      {
         GlobalConsoleProperties.console.blablaland.removeEventListener("onParsedMessage",this.onMessage,false);
      }
   }
}
