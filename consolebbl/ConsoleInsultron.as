package consolebbl
{
   import bbl.BblTrackerUser;
   import bbl.GlobalProperties;
   import flash.events.Event;
   import flash.utils.Timer;
   import net.ParsedMessageEvent;
   import net.SocketMessage;
   
   public class ConsoleInsultron extends ConsoleDroits
   {
       
      
      public var insultronUserList:Array;
      
      private var insultronTimer:Timer;
      
      public function ConsoleInsultron()
      {
         super();
         this.insultronUserList = new Array();
         this.insultronTimer = new Timer(1000);
         this.insultronTimer.start();
         this.insultronTimer.addEventListener("timer",this.onInsultronTimerEvt,false,0,true);
         blablaland.addEventListener("onParsedMessage",this.onInsultronMessage,false,0,true);
      }
      
      public function removeInsultronUser(param1:uint) : *
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this.insultronUserList.length)
         {
            if(this.insultronUserList[_loc2_].uid == param1)
            {
               this.insultronUserList.splice(_loc2_,1);
               _loc2_--;
            }
            _loc2_++;
         }
      }
      
      public function getInsultronUserByUid(param1:uint) : BblTrackerUser
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this.insultronUserList.length)
         {
            if(this.insultronUserList[_loc2_].uid == param1)
            {
               return this.insultronUserList[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function onInsultronTimerEvt(param1:Event) : *
      {
         var _loc3_:BblTrackerUser = null;
         var _loc2_:uint = 0;
         while(_loc2_ < this.insultronUserList.length)
         {
            _loc3_ = this.insultronUserList[_loc2_];
            --_loc3_.ptsAlert;
            if(_loc3_.ptsAlert <= 0)
            {
               this.insultronUserList.splice(_loc2_,1);
               _loc2_--;
            }
            _loc2_++;
         }
         this.dispatchEvent(new Event("onInsultronChange"));
      }
      
      public function onInsultronMessage(param1:ParsedMessageEvent) : *
      {
         var _loc2_:SocketMessage = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         var _loc6_:uint = 0;
         var _loc7_:BblTrackerUser = null;
         if(param1.evtType == 6)
         {
            if(param1.evtStype == 9)
            {
               _loc2_ = param1.getMessage();
               _loc3_ = _loc2_.bitReadUnsignedInt(32);
               _loc4_ = _loc2_.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID);
               _loc5_ = _loc2_.bitReadString();
               _loc6_ = _loc2_.bitReadUnsignedInt(7);
               param1.stopImmediatePropagation();
               if(!(_loc7_ = this.getInsultronUserByUid(_loc4_)))
               {
                  _loc7_ = new BblTrackerUser();
                  this.insultronUserList.push(_loc7_);
               }
               _loc7_.ptsAlert += _loc6_;
               if(_loc7_.ptsAlert > 60)
               {
                  _loc7_.ptsAlertVisible = true;
               }
               _loc7_.pseudo = _loc5_;
               _loc7_.ip = _loc3_;
               _loc7_.uid = _loc4_;
               _loc7_.addMessage("<span class=\'insultron\'>(" + _loc6_ + ") - " + GlobalProperties.htmlEncode(_loc2_.bitReadString()) + "</span>");
               this.dispatchEvent(new Event("onInsultronChange"));
            }
         }
      }
   }
}
