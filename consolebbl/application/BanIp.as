package consolebbl.application
{
   import bbl.GlobalProperties;
   import consolebbl.GlobalConsoleProperties;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.text.TextField;
   import net.Channel;
   import net.SocketMessage;
   
   [Embed(source="/_assets/assets.swf", symbol="consolebbl.application.BanIp")]
   public class BanIp extends MovieClip
   {
       
      
      public var bt_addnew:SimpleButton;
      
      public var txt_newdata:TextField;
      
      public var chback:Channel;
      
      public function BanIp()
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
            parent.height = 30;
            Object(parent).redraw();
            this.txt_newdata.restrict = "0-9.";
            this.bt_addnew.addEventListener("click",this.onAddIp,false,0,true);
            this.chback = new Channel();
            this.chback.addEventListener("onMessage",this.onMessage);
         }
      }
      
      public function onAddIp(param1:Event) : *
      {
         trace(this.txt_newdata.text);
         var _loc2_:SocketMessage = new SocketMessage();
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,4);
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,26);
         _loc2_.bitWriteUnsignedInt(10,1);
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_CHANNEL_ID,this.chback.id);
         _loc2_.bitWriteString(this.txt_newdata.text);
         GlobalConsoleProperties.console.blablaland.send(_loc2_);
         mouseChildren = false;
         alpha = 0.5;
      }
      
      public function onMessage(param1:Event) : *
      {
         mouseChildren = true;
         alpha = 1;
         var _loc2_:int = this.chback.message.bitReadUnsignedInt(8);
         if(_loc2_ == 0)
         {
            GlobalConsoleProperties.console.msgPopup.open({
               "APP":PopupMessage,
               "TITLE":"Reponse serveur : ",
               "DEPEND":this
            },{
               "MSG":"IP ajoutée",
               "ACTION":"OK"
            });
         }
         else if(_loc2_ == 1)
         {
            GlobalConsoleProperties.console.msgPopup.open({
               "APP":PopupMessage,
               "TITLE":"Reponse serveur : ",
               "DEPEND":this
            },{
               "MSG":"Mauvaise syntaxe d\'IP",
               "ACTION":"OK"
            });
         }
         else
         {
            GlobalConsoleProperties.console.msgPopup.open({
               "APP":PopupMessage,
               "TITLE":"Reponse serveur : ",
               "DEPEND":this
            },{
               "MSG":"Erreur inconnue : " + _loc2_,
               "ACTION":"OK"
            });
         }
      }
      
      public function onKill(param1:Event) : *
      {
         this.chback.dispose();
      }
   }
}
