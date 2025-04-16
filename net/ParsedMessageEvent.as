package net
{
   import bbl.GlobalProperties;
   import flash.events.Event;
   
   public class ParsedMessageEvent extends Event
   {
       
      
      public var _message:SocketMessage;
      
      public var evtType:uint;
      
      public var evtStype:uint;
      
      public function ParsedMessageEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      public function getMessage() : SocketMessage
      {
         this._message.bitPosition = GlobalProperties.BIT_TYPE + GlobalProperties.BIT_STYPE;
         return this._message;
      }
   }
}
