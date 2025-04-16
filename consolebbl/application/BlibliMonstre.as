package consolebbl.application
{
   import bbl.GlobalProperties;
   import consolebbl.GlobalConsoleProperties;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.text.TextField;
   import net.Channel;
   import net.SocketMessage;
   import ui.List;
   import ui.ListGraphicEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="consolebbl.application.BlibliMonstre")]
   public class BlibliMonstre extends MovieClip
   {
       
      
      public var bt_search:SimpleButton;
      
      public var bt_reset:SimpleButton;
      
      public var txt_pseudo:TextField;
      
      public var liste:List;
      
      public var channel:Channel;
      
      public var confirmPopup:Object;
      
      public function BlibliMonstre()
      {
         super();
         this.addEventListener(Event.ADDED,this.init,false,0,true);
      }
      
      public function init(param1:Event) : *
      {
         if(stage)
         {
            this.confirmPopup = null;
            this.removeEventListener(Event.ADDED,this.init,false);
            this.liste.size = 9;
            this.liste.graphicWidth = 200;
            this.liste.redraw();
            this.liste.addEventListener("onClick",this.listeEvt,false,0,true);
            GlobalProperties.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownEvt,false);
            this.channel = new Channel();
            this.channel.addEventListener("onMessage",this.onChannelMessage);
            this.removeEventListener(Event.ADDED,this.init,false);
            parent.width = 215;
            parent.height = 200;
            Object(parent).redraw();
            this.bt_search.addEventListener("click",this.searchEvt,false,0,true);
            this.bt_reset.addEventListener("click",this.resetEvt,false,0,true);
         }
      }
      
      public function onChannelMessage(param1:Event) : *
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:* = undefined;
         var _loc6_:Number = NaN;
         var _loc7_:Date = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc2_:Object = this.channel.message;
         _loc3_ = int(_loc2_.bitReadUnsignedInt(8));
         this.alpha = 1;
         this.mouseEnabled = this.mouseChildren = true;
         if(_loc3_ == 1)
         {
            this.liste.node.removeAllChild();
            this.liste.redraw();
            if((_loc4_ = int(_loc2_.bitReadUnsignedInt(8))) == 0)
            {
               while(_loc2_.bitReadBoolean())
               {
                  (_loc5_ = this.liste.node.addChild()).data.UID = _loc2_.bitReadUnsignedInt(32);
                  _loc5_.data.BDDID = _loc2_.bitReadUnsignedInt(32);
                  _loc5_.data.NAME = _loc2_.bitReadString();
                  if(_loc6_ = Number(_loc2_.bitReadUnsignedInt(32)))
                  {
                     (_loc7_ = new Date()).time = _loc6_ * 1000;
                     _loc5_.text = _loc5_.data.NAME + " [" + _loc7_.date + "/" + (_loc7_.month + 1) + "/" + _loc7_.fullYear + " " + _loc7_.hours + ":" + _loc7_.minutes + "]";
                  }
                  else
                  {
                     _loc5_.text = _loc5_.data.NAME + " [ -- ]";
                  }
               }
               this.liste.redraw();
            }
         }
         else if(_loc3_ == 2)
         {
            if((_loc4_ = int(_loc2_.bitReadUnsignedInt(8))) == 0)
            {
               _loc8_ = int(_loc2_.bitReadUnsignedInt(32));
               _loc9_ = 0;
               while(_loc9_ < this.liste.node.childNode.length)
               {
                  if(this.liste.node.childNode[_loc9_].data.BDDID == _loc8_)
                  {
                     this.liste.node.removeChild(this.liste.node.childNode[_loc9_]);
                     break;
                  }
                  _loc9_++;
               }
               if(_loc2_.bitReadBoolean())
               {
                  GlobalConsoleProperties.console.msgPopup.open({
                     "APP":PopupMessage,
                     "TITLE":"Resultat..",
                     "DEPEND":this
                  },{
                     "MSG":"Le nom du blibli à bien été réinitialisé. Le blibli était actif et à donc été coupé.",
                     "ACTION":"OK"
                  });
               }
               else
               {
                  GlobalConsoleProperties.console.msgPopup.open({
                     "APP":PopupMessage,
                     "TITLE":"Resultat..",
                     "DEPEND":this
                  },{
                     "MSG":"Le nom du blibli à bien été réinitialisé. Attention, le blabla n\'etait pas connecté, sur un autre univers ou son blibli n\'etait pas actif.. Penser à le kicker si necessaire.",
                     "ACTION":"OK"
                  });
               }
               this.liste.redraw();
            }
         }
      }
      
      public function listeEvt(param1:ListGraphicEvent) : *
      {
         this.liste.node.unSelectAllItem();
         param1.graphic.node.selected = !param1.graphic.node.selected;
         this.liste.redraw();
      }
      
      public function onKeyDownEvt(param1:KeyboardEvent) : *
      {
         if(GlobalProperties.stage.focus == this.txt_pseudo && param1.keyCode == 13 && Boolean(Object(parent).focus))
         {
            this.searchEvt(null);
         }
      }
      
      public function resetEvt(param1:Event) : *
      {
         var _loc2_:Array = this.liste.node.getSelectedList();
         if(Boolean(_loc2_) && _loc2_.length == 1)
         {
            if(this.confirmPopup)
            {
               this.confirmPopup.kill();
            }
            this.confirmPopup = GlobalConsoleProperties.console.msgPopup.open({
               "APP":PopupMessage,
               "TITLE":"Confirmer",
               "DEPEND":this
            },{
               "MSG":"Sur de vouloir réinitialiser le nom de ce blibli (" + _loc2_[0].data.NAME + ")",
               "ACTION":"YESNO"
            });
            this.confirmPopup.addEventListener("onEvent",this.onConfirmEvt);
            this.confirmPopup.addEventListener("onKill",this.onConfirmKill);
            this.confirmPopup.data.UID = _loc2_[0].data.UID;
            this.confirmPopup.data.BDDID = _loc2_[0].data.BDDID;
         }
      }
      
      public function onConfirmKill(param1:Event) : *
      {
         this.confirmPopup = null;
      }
      
      public function onConfirmEvt(param1:Event) : *
      {
         var _loc2_:* = undefined;
         if(param1.currentTarget.data.RES)
         {
            _loc2_ = new SocketMessage();
            _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,12);
            _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,2);
            _loc2_.bitWriteUnsignedInt(8,2);
            _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_CHANNEL_ID,this.channel.id);
            _loc2_.bitWriteUnsignedInt(32,param1.currentTarget.data.UID);
            _loc2_.bitWriteUnsignedInt(32,param1.currentTarget.data.BDDID);
            GlobalConsoleProperties.console.blablaland.send(_loc2_);
            this.alpha = 0.5;
            this.mouseEnabled = this.mouseChildren = false;
         }
      }
      
      public function searchEvt(param1:Event) : *
      {
         var _loc2_:* = undefined;
         if(this.txt_pseudo.text.length > 0)
         {
            _loc2_ = new SocketMessage();
            _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,12);
            _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,2);
            _loc2_.bitWriteUnsignedInt(8,1);
            _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_CHANNEL_ID,this.channel.id);
            _loc2_.bitWriteString(this.txt_pseudo.text);
            GlobalConsoleProperties.console.blablaland.send(_loc2_);
            this.liste.node.removeAllChild();
            this.liste.redraw();
            this.alpha = 0.5;
            this.mouseEnabled = this.mouseChildren = false;
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
