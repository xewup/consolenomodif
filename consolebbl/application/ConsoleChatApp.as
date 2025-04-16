package consolebbl.application
{
   import bbl.GlobalProperties;
   import consolebbl.GlobalConsoleProperties;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.TextEvent;
   import flash.text.StyleSheet;
   import flash.text.TextField;
   import ui.ValueSelector;
   
   [Embed(source="/_assets/assets.swf", symbol="consolebbl.application.ConsoleChatApp")]
   public class ConsoleChatApp extends MovieClip
   {
       
      
      public var userList:TextField;
      
      public var textList:TextField;
      
      public var inputText:TextField;
      
      public var txt_send:DisplayObjectContainer;
      
      public var bt_send:SimpleButton;
      
      public var vs_selgrade:ValueSelector;
      
      private var lastModoLine:int;
      
      public function ConsoleChatApp()
      {
         super();
         this.lastModoLine = -1;
         this.addEventListener(Event.ADDED,this.init,false,0,true);
         this.userList.addEventListener(TextEvent.LINK,this.userLinkEvent,false,0,true);
         this.userList.addEventListener("mouseMove",this.userLinkMoveEvent,false,0,true);
         this.userList.addEventListener("mouseOut",this.userLinkOutEvent,false,0,true);
         this.bt_send.addEventListener("click",this.sendMessage,false,0,true);
         this.userList.text = "";
         this.textList.text = "";
         this.inputText.text = "";
         this.txt_send.mouseEnabled = false;
         this.txt_send.mouseChildren = false;
         var _loc1_:* = new StyleSheet();
         _loc1_.setStyle(".user",{"color":"#0000FF"});
         _loc1_.setStyle(".user_mp",{"color":"#FFA000"});
         _loc1_.setStyle(".info",{"color":"#FF0000"});
         _loc1_.setStyle(".message_info",{"color":"#FF0000"});
         this.textList.styleSheet = _loc1_;
      }
      
      public function init(param1:Event) : *
      {
         if(stage)
         {
            Object(parent).resizer.visible = true;
            this.removeEventListener(Event.ADDED,this.init,false);
            GlobalProperties.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownEvt,false,0,true);
            parent.width = !!GlobalProperties.sharedObject.data.POPUP.CONSOLECHAT_W ? Number(GlobalProperties.sharedObject.data.POPUP.CONSOLECHAT_W) : 230;
            parent.height = !!GlobalProperties.sharedObject.data.POPUP.CONSOLECHAT_H ? Number(GlobalProperties.sharedObject.data.POPUP.CONSOLECHAT_H) : 180;
            Object(parent).redraw();
            parent.addEventListener("onKill",this.onKill,false,0,true);
            parent.addEventListener("onResized",this.onResized,false,0,true);
            this.onResized();
            GlobalConsoleProperties.console.addEventListener("chatChangeUser",this.chatChangeUser,false,0,true);
            GlobalConsoleProperties.console.addEventListener("chatChangeText",this.chatChangeText,false,0,true);
            this.chatChangeUser();
            this.chatChangeText();
            this.vs_selgrade.addEventListener("mouseOver",this.selGradeOverEvt,false,0,true);
            this.vs_selgrade.addEventListener("onChanged",this.chatChangeUser,false,0,true);
            this.vs_selgrade.maxValue = Math.pow(2,GlobalProperties.BIT_GRADE) - 1;
            this.vs_selgrade.value = 0;
         }
      }
      
      public function onResized(param1:Event = null) : *
      {
         parent.width = Math.max(parent.width,300);
         parent.height = Math.max(parent.height,150);
         parent.width = Math.min(parent.width,800);
         parent.height = Math.min(parent.height,600);
         this.redrawSize();
      }
      
      public function redrawSize() : *
      {
         GlobalProperties.sharedObject.data.POPUP.CONSOLECHAT_W = parent.width;
         GlobalProperties.sharedObject.data.POPUP.CONSOLECHAT_H = parent.height;
         this.vs_selgrade.x = parent.width - this.vs_selgrade.width;
         this.vs_selgrade.y = parent.height - this.vs_selgrade.height;
         this.bt_send.y = parent.height - this.bt_send.height / 2 - 2;
         this.bt_send.x = this.vs_selgrade.x - this.bt_send.width / 2 - 2;
         this.txt_send.x = this.bt_send.x;
         this.txt_send.y = this.bt_send.y;
         this.inputText.width = this.vs_selgrade.x - this.bt_send.width - 6;
         this.inputText.y = parent.height - this.inputText.height - 2;
         this.userList.height = this.inputText.y - 4;
         this.textList.height = this.userList.height;
         this.textList.width = parent.width - 2 - this.textList.x;
         this.textList.scrollV = this.textList.maxScrollV;
      }
      
      public function chatChangeUser(param1:Event = null) : *
      {
         var _loc6_:String = null;
         var _loc2_:Number = this.userList.scrollH;
         this.userList.text = "";
         var _loc3_:Array = GlobalConsoleProperties.console.consoleChatUserList;
         var _loc4_:String = "";
         var _loc5_:* = 0;
         while(_loc5_ < _loc3_.length)
         {
            _loc6_ = "0000FF";
            if(this.vs_selgrade.value > _loc3_[_loc5_].grade && _loc3_[_loc5_].secretChat == 0)
            {
               _loc6_ = "A0A0DD";
            }
            else if(this.vs_selgrade.value > _loc3_[_loc5_].grade && _loc3_[_loc5_].secretChat > 0)
            {
               _loc6_ = "D0A0A0";
            }
            else if(this.vs_selgrade.value <= _loc3_[_loc5_].grade && _loc3_[_loc5_].secretChat > 0)
            {
               _loc6_ = "EE5000";
            }
            _loc4_ += "<A HREF=\'event:0_" + _loc3_[_loc5_].pid + "\'><U><FONT COLOR=\'#" + _loc6_ + "\'>" + _loc3_[_loc5_].pseudo + "</FONT></U></A><BR>";
            _loc5_++;
         }
         this.userList.htmlText = _loc4_;
         this.userList.scrollH = _loc2_;
      }
      
      public function selGradeOverEvt(param1:Event) : *
      {
         GlobalProperties.mainApplication.infoBulle("Grade minimum requis pour recevoir ce message.");
      }
      
      public function userLinkOutEvent(param1:Event) : *
      {
         this.lastModoLine = -1;
         GlobalProperties.mainApplication.infoBulle(null);
      }
      
      public function userLinkMoveEvent(param1:Event) : *
      {
         var _loc3_:uint = 0;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc2_:Boolean = false;
         if(this.userList.getCharIndexAtPoint(mouseX,mouseY) > 0)
         {
            _loc3_ = uint(this.userList.getLineIndexAtPoint(mouseX,mouseY));
            _loc2_ = true;
            if(_loc3_ != this.lastModoLine)
            {
               this.lastModoLine = _loc3_;
               if((_loc4_ = GlobalConsoleProperties.console.consoleChatUserList).length > _loc3_)
               {
                  _loc5_ = _loc4_[_loc3_].login + " / " + _loc4_[_loc3_].pseudo;
                  if(_loc4_[_loc3_].secretChat > 0)
                  {
                     _loc5_ += " (secret chat " + _loc4_[_loc3_].secretChat + ")";
                  }
                  GlobalProperties.mainApplication.infoBulle(_loc5_);
               }
            }
         }
         if(!_loc2_)
         {
            GlobalProperties.mainApplication.infoBulle(null);
            this.lastModoLine = -1;
         }
      }
      
      public function userLinkEvent(param1:TextEvent) : *
      {
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:* = undefined;
         var _loc2_:Array = param1.text.split("_");
         if(_loc2_[0] == 0)
         {
            _loc3_ = this.inputText.text;
            this.inputText.text = _loc3_.replace(/^\/mp *[^ ]* ?/,"");
            _loc4_ = GlobalConsoleProperties.console.consoleChatUserList;
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               if(_loc4_[_loc5_].pid == _loc2_[1])
               {
                  this.inputText.text = "/mp " + _loc4_[_loc5_].pseudo + " " + this.inputText.text;
               }
               _loc5_++;
            }
            stage.focus = this.inputText;
            this.inputText.setSelection(this.inputText.length,this.inputText.length);
         }
      }
      
      public function chatChangeText(param1:Event = null) : *
      {
         var _loc2_:* = GlobalConsoleProperties.console.consoleChatMsgList;
         this.textList.htmlText = _loc2_.join("\n");
         this.textList.scrollV = this.textList.maxScrollV;
      }
      
      public function onKeyDownEvt(param1:KeyboardEvent) : *
      {
         if(GlobalProperties.stage.focus == this.inputText && param1.keyCode == 13 && Boolean(Object(parent).focus))
         {
            this.sendMessage();
         }
      }
      
      public function sendMessage(param1:Event = null) : *
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         if(this.inputText.text.length)
         {
            _loc2_ = this.inputText.text;
            _loc3_ = _loc2_.split(" ");
            _loc5_ = 0;
            if(_loc3_[0] == "/mp" && _loc3_.length > 2)
            {
               _loc7_ = String(_loc3_[1]);
               _loc6_ = GlobalConsoleProperties.console.consoleChatUserList;
               _loc4_ = 0;
               while(_loc4_ < _loc6_.length)
               {
                  if(_loc6_[_loc4_].pseudo.toLowerCase() == _loc7_.toLowerCase())
                  {
                     _loc5_ = uint(_loc6_[_loc4_].pid);
                     break;
                  }
                  _loc4_++;
               }
               _loc3_.shift();
               _loc3_.shift();
               _loc2_ = _loc3_.join(" ");
               if(_loc5_)
               {
                  GlobalConsoleProperties.console.modoChatSendMessage(_loc2_,_loc5_);
               }
               else
               {
                  GlobalConsoleProperties.console.addLocalMessage("<span class=\'info\'>Impossible de trouver le modo " + _loc7_ + "</span>");
               }
            }
            else if(_loc3_[0] == "/kick" && _loc3_.length > 1)
            {
               _loc7_ = String(_loc3_[1]);
               _loc6_ = GlobalConsoleProperties.console.consoleChatUserList;
               _loc4_ = 0;
               while(_loc4_ < _loc6_.length)
               {
                  if(_loc6_[_loc4_].pseudo.toLowerCase() == _loc7_.toLowerCase())
                  {
                     _loc5_ = uint(_loc6_[_loc4_].pid);
                     break;
                  }
                  _loc4_++;
               }
               _loc3_.shift();
               _loc3_.shift();
               _loc2_ = _loc3_.join(" ");
               if(_loc5_)
               {
                  GlobalConsoleProperties.console.modoChatKick(_loc2_,_loc5_);
               }
               else
               {
                  GlobalConsoleProperties.console.addLocalMessage("<span class=\'info\'>Impossible de trouver le modo " + _loc7_ + "</span>");
               }
            }
            else
            {
               GlobalConsoleProperties.console.modoChatSendMessage(_loc2_,_loc5_,this.vs_selgrade.value);
            }
            this.inputText.text = "";
         }
      }
      
      public function onKill(param1:Event) : *
      {
         GlobalProperties.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownEvt,false);
         GlobalConsoleProperties.console.removeEventListener("chatChangeUser",this.chatChangeUser,false);
         GlobalConsoleProperties.console.removeEventListener("chatChangeText",this.chatChangeText,false);
      }
   }
}
