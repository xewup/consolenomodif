package consolebbl.application
{
   import bbl.GlobalProperties;
   import consolebbl.GlobalConsoleProperties;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.text.TextField;
   import net.SocketMessage;
   import ui.List;
   import ui.ListGraphicEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="consolebbl.application.MassBan")]
   public class MassBan extends MovieClip
   {
       
      
      public var bt_add:SimpleButton;
      
      public var bt_ban:SimpleButton;
      
      public var bt_clear:SimpleButton;
      
      public var txt_uid:TextField;
      
      public var txt_motif:TextField;
      
      public var liste:List;
      
      public function MassBan()
      {
         super();
         this.txt_uid.restrict = "0-9";
         this.addEventListener(Event.ADDED,this.init,false,0,true);
      }
      
      public function init(param1:Event) : *
      {
         if(stage)
         {
            this.removeEventListener(Event.ADDED,this.init,false);
            this.liste.size = 9;
            this.liste.graphicWidth = 200;
            this.liste.redraw();
            this.liste.addEventListener("onClick",this.clickevt,false,0,true);
            GlobalProperties.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownEvt,false);
            this.removeEventListener(Event.ADDED,this.init,false);
            parent.addEventListener("onKill",this.onKill,false,0,true);
            parent.width = 215;
            parent.height = 300;
            Object(parent).redraw();
            this.bt_add.addEventListener("click",this.addEvt,false,0,true);
            this.bt_ban.addEventListener("click",this.banEvt,false,0,true);
            this.bt_clear.addEventListener("click",this.clearEvt,false,0,true);
         }
      }
      
      public function clickevt(param1:ListGraphicEvent) : *
      {
         this.liste.node.removeChild(param1.graphic.node);
         this.liste.redraw();
      }
      
      public function onKeyDownEvt(param1:KeyboardEvent) : *
      {
         if(GlobalProperties.stage.focus == this.txt_uid && param1.keyCode == 13 && Boolean(Object(parent).focus))
         {
            this.addEvt(null);
         }
      }
      
      public function clearEvt(param1:Event) : *
      {
         this.liste.node.removeAllChild();
         this.liste.redraw();
         this.txt_motif.text = "";
      }
      
      public function banEvt(param1:Event) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:uint = 0;
         if(this.txt_motif.text.length <= 3)
         {
            GlobalConsoleProperties.console.msgPopup.open({
               "APP":PopupMessage,
               "TITLE":"Erreur",
               "DEPEND":this
            },{
               "MSG":"Nécessite un motif :",
               "ACTION":"OK"
            });
         }
         else if(this.liste.node.childNode.length == 0)
         {
            GlobalConsoleProperties.console.msgPopup.open({
               "APP":PopupMessage,
               "TITLE":"Erreur",
               "DEPEND":this
            },{
               "MSG":"Pas de blabla !",
               "ACTION":"OK"
            });
         }
         else
         {
            _loc2_ = new SocketMessage();
            _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,4);
            _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,28);
            _loc2_.bitWriteString(this.txt_motif.text);
            _loc3_ = 0;
            while(_loc3_ < this.liste.node.childNode.length)
            {
               _loc2_.bitWriteBoolean(true);
               _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_USER_ID,this.liste.node.childNode[_loc3_].data.UID);
               _loc3_++;
            }
            _loc2_.bitWriteBoolean(false);
            GlobalConsoleProperties.console.blablaland.send(_loc2_);
            GlobalConsoleProperties.console.msgPopup.open({
               "APP":PopupMessage,
               "TITLE":"Ok",
               "DEPEND":this
            },{
               "MSG":"Ordre envoyé au serveur.",
               "ACTION":"OK"
            });
         }
      }
      
      public function addEvt(param1:Event) : *
      {
         var _loc2_:URLVariables = null;
         var _loc3_:URLRequest = null;
         var _loc4_:URLLoader = null;
         if(this.txt_uid.text.length > 0 && !isNaN(Number(this.txt_uid.text)))
         {
            _loc2_ = new URLVariables();
            _loc2_.SESSION = GlobalConsoleProperties.console.session;
            _loc2_.UID = this.txt_uid.text;
            _loc2_.CACHE = new Date().getTime();
            _loc3_ = new URLRequest(GlobalProperties.scriptAdr + "console/searchUser.php");
            _loc3_.method = "POST";
            _loc3_.data = _loc2_;
            (_loc4_ = new URLLoader()).dataFormat = "variables";
            _loc4_.load(_loc3_);
            _loc4_.addEventListener("complete",this.onSearchUser,false,0,true);
            this.txt_uid.text = "";
         }
      }
      
      public function onSearchUser(param1:Event) : *
      {
         var _loc2_:Boolean = false;
         var _loc3_:uint = 0;
         var _loc4_:* = undefined;
         param1.currentTarget.removeEventListener("complete",this.onSearchUser,false);
         if(param1.currentTarget.data.RESULT == 1)
         {
            _loc2_ = true;
            if(param1.currentTarget.data.grade >= GlobalConsoleProperties.console.rulesMassBan)
            {
               GlobalConsoleProperties.console.msgPopup.open({
                  "APP":PopupMessage,
                  "TITLE":"Erreur",
                  "DEPEND":this
               },{
                  "MSG":"Blabla uid " + param1.currentTarget.data.UID + " [" + param1.currentTarget.data.login + "] dispose d\'un grade trop élevé !",
                  "ACTION":"OK"
               });
               _loc2_ = false;
            }
            _loc3_ = 0;
            while(_loc2_ && _loc3_ < this.liste.node.childNode.length)
            {
               if(this.liste.node.childNode[_loc3_].data.UID == param1.currentTarget.data.UID)
               {
                  GlobalConsoleProperties.console.msgPopup.open({
                     "APP":PopupMessage,
                     "TITLE":"Erreur",
                     "DEPEND":this
                  },{
                     "MSG":"Blabla uid " + param1.currentTarget.data.UID + " déja dans la liste !",
                     "ACTION":"OK"
                  });
                  _loc2_ = false;
               }
               _loc3_++;
            }
            if(_loc2_)
            {
               (_loc4_ = this.liste.node.addChild()).data.LOGIN = param1.currentTarget.data.login;
               _loc4_.data.UID = param1.currentTarget.data.UID;
               _loc4_.data.node = _loc4_;
               _loc4_.text = "[" + _loc4_.data.UID + "] " + _loc4_.data.LOGIN;
               this.liste.redraw();
            }
         }
         else
         {
            GlobalConsoleProperties.console.msgPopup.open({
               "APP":PopupMessage,
               "TITLE":"Erreur",
               "DEPEND":this
            },{
               "MSG":"Blabla uid " + param1.currentTarget.data.UID + " non trouvé !",
               "ACTION":"OK"
            });
         }
      }
      
      public function onKill(param1:Event) : *
      {
         GlobalProperties.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownEvt,false);
      }
   }
}
