package consolebbl
{
   import bbl.GlobalProperties;
   import flash.events.Event;
   import flash.media.SoundTransform;
   import net.ParsedMessageEvent;
   import net.SocketMessage;
   
   public class ConsoleChat extends ConsoleInit
   {
       
      
      public var consoleChatUserList:Array;
      
      public var consoleChatMsgList:Array;
      
      public var lastAmount:uint;
      
      public function ConsoleChat()
      {
         super();
         this.lastAmount = 0;
         blablaland.addEventListener("onParsedMessage",this.onChatMessage,false,0,true);
         this.consoleChatUserList = new Array();
         this.consoleChatMsgList = new Array();
      }
      
      public function onChatMessage(param1:ParsedMessageEvent) : *
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc5_:ConsoleChatUser = null;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:uint = 0;
         var _loc4_:SocketMessage = param1.getMessage();
         if(param1.evtType == 6 && param1.evtStype == 2)
         {
            while(_loc4_.bitReadBoolean())
            {
               _loc5_ = new ConsoleChatUser();
               this.consoleChatUserList.push(_loc5_);
               _loc5_.pid = _loc4_.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID);
               _loc5_.grade = _loc4_.bitReadUnsignedInt(GlobalProperties.BIT_GRADE);
               _loc5_.pseudo = _loc4_.bitReadString();
               _loc5_.login = _loc4_.bitReadString();
               _loc5_.secretChat = _loc4_.bitReadUnsignedInt(GlobalProperties.BIT_GRADE);
            }
            this.dispatchEvent(new Event("chatChangeUser"));
            param1.stopImmediatePropagation();
         }
         else if(param1.evtType == 6 && param1.evtStype == 3)
         {
            _loc2_ = _loc4_.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID);
            _loc5_ = null;
            _loc3_ = 0;
            while(_loc3_ < this.consoleChatUserList.length)
            {
               if(this.consoleChatUserList[_loc3_].pid == _loc2_)
               {
                  _loc5_ = this.consoleChatUserList[_loc3_];
                  this.consoleChatUserList.splice(_loc3_,1);
                  _loc3_--;
               }
               _loc3_++;
            }
            this.dispatchEvent(new Event("chatChangeUser"));
            if(_loc5_)
            {
               this.addLocalMessage("<span class=\'info\'>*** bye bye " + _loc5_.pseudo + " ***</span>");
            }
            param1.stopImmediatePropagation();
         }
         else if(param1.evtType == 6 && param1.evtStype == 4)
         {
            _loc5_ = new ConsoleChatUser();
            this.consoleChatUserList.push(_loc5_);
            _loc5_.pid = _loc4_.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID);
            _loc5_.grade = _loc4_.bitReadUnsignedInt(GlobalProperties.BIT_GRADE);
            _loc5_.pseudo = _loc4_.bitReadString();
            _loc5_.login = _loc4_.bitReadString();
            _loc5_.secretChat = _loc4_.bitReadUnsignedInt(GlobalProperties.BIT_GRADE);
            this.dispatchEvent(new Event("chatChangeUser"));
            this.addLocalMessage("<span class=\'info\'>*** Connection de " + _loc5_.pseudo + " ***</span>");
            param1.stopImmediatePropagation();
         }
         else if(param1.evtType == 6 && param1.evtStype == 5)
         {
            _loc2_ = _loc4_.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID);
            _loc6_ = _loc4_.bitReadBoolean();
            _loc7_ = _loc4_.bitReadBoolean();
            _loc8_ = this.unHTML(_loc4_.bitReadString());
            _loc9_ = "{unknown}";
            _loc3_ = 0;
            while(_loc3_ < this.consoleChatUserList.length)
            {
               if(this.consoleChatUserList[_loc3_].pid == _loc2_)
               {
                  _loc9_ = String(this.consoleChatUserList[_loc3_].pseudo);
                  break;
               }
               _loc3_++;
            }
            if(_loc6_)
            {
               this.addLocalMessage("<span class=\'user_mp\'>mp de " + _loc9_ + " :</span> <span class=\'message_mp\'>" + _loc8_ + "</span>");
            }
            else
            {
               this.addLocalMessage("<span class=\'user\'>" + _loc9_ + " :</span> <span class=\'message\'>" + _loc8_ + "</span>");
            }
            param1.stopImmediatePropagation();
         }
         else if(param1.evtType == 6 && param1.evtStype == 14)
         {
            this.lastAmount = _loc4_.bitReadUnsignedInt(32);
            this.dispatchEvent(new Event("onNewAmount"));
            param1.stopImmediatePropagation();
         }
         else if(param1.evtType == 6 && param1.evtStype == 15)
         {
            _loc10_ = _loc4_.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID);
            if(GlobalProperties.data["CONSOLEUSERCHAT_" + _loc10_])
            {
               GlobalProperties.data["CONSOLEUSERCHAT_" + _loc10_].addMessage("<span class=\'user_mp\'>mp A " + GlobalProperties.mainApplication.blablaland.pseudo + "</span> : </span><span class=\'message_mp\'>" + _loc4_.bitReadString() + "</span>");
            }
         }
      }
      
      public function addLocalMessage(param1:String) : *
      {
         new BipChat().play(0,0,new SoundTransform(0.5));
         this.consoleChatMsgList.push(param1);
         this.consoleChatMsgList.splice(0,this.consoleChatMsgList.length - 80);
         this.dispatchEvent(new Event("chatChangeText"));
      }
      
      public function getUserByPid(param1:uint = 0) : ConsoleChatUser
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this.consoleChatUserList.length)
         {
            if(this.consoleChatUserList[_loc2_].pid == param1)
            {
               return this.consoleChatUserList[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function unHTML(param1:String) : *
      {
         param1 = param1.replace(/\&/g,"&amp;");
         param1 = param1.replace(/>/g,"&gt;");
         return param1.replace(/</g,"&lt;");
      }
      
      public function modoChatSendMessage(param1:String, param2:uint = 0, param3:uint = 0) : *
      {
         var _loc5_:ConsoleChatUser = null;
         var _loc4_:*;
         (_loc4_ = new SocketMessage()).bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,4);
         _loc4_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,3);
         _loc4_.bitWriteUnsignedInt(GlobalProperties.BIT_USER_PID,param2);
         _loc4_.bitWriteBoolean(false);
         _loc4_.bitWriteUnsignedInt(GlobalProperties.BIT_GRADE,param3);
         _loc4_.bitWriteString(param3 > 0 ? "(+" + param3 + ") " + param1 : param1);
         blablaland.send(_loc4_);
         if(param2)
         {
            _loc5_ = this.getUserByPid(param2);
            this.addLocalMessage("<span class=\'info\'>mp envoyé à " + (!!_loc5_ ? _loc5_.pseudo : "{unknown}") + "</span> : <span class=\'mesage_info\'>" + this.unHTML(param1) + "</span>");
         }
      }
      
      public function modoChatKick(param1:String, param2:uint = 0) : *
      {
         var _loc3_:* = new SocketMessage();
         _loc3_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,4);
         _loc3_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,24);
         _loc3_.bitWriteUnsignedInt(GlobalProperties.BIT_USER_PID,param2);
         _loc3_.bitWriteString(param1);
         blablaland.send(_loc3_);
      }
   }
}
