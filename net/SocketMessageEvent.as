package net
{
   import flash.events.Event;
   
   public class SocketMessageEvent extends Event
   {
       
      
      public var message:SocketMessage;
      
      public function SocketMessageEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
         this.message = new SocketMessage();
      }
      
      public function duplicate() : SocketMessageEvent
      {
         var _loc1_:SocketMessageEvent = new SocketMessageEvent(type,bubbles,cancelable);
         _loc1_.message = this.message.duplicate();
         return _loc1_;
      }
   }
}
