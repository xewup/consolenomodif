package net
{
   import flash.events.Event;
   import flash.events.ProgressEvent;
   import flash.net.Socket;
   import flash.system.Security;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   
   public class SocketAdv extends Socket
   {
       
      
      private var inBuffer:ByteArray;
      
      private var inCmpt:uint;
      
      private var outCmpt:uint;
      
      private var flushTimer:Timer;
      
      private var keepAliveTimer:Timer;
      
      public function SocketAdv()
      {
         super();
         addEventListener(ProgressEvent.SOCKET_DATA,this.socketDataHandler);
         this.inBuffer = new ByteArray();
         this.flushTimer = new Timer(1);
         this.flushTimer.addEventListener("timer",this.flushEvent,false,0,true);
         this.keepAliveTimer = new Timer(20000);
         this.keepAliveTimer.addEventListener("timer",this.keepAliveTimerEvt,false,0,true);
      }
      
      public function keepAliveTimerEvt(param1:Event) : *
      {
         var _loc2_:* = undefined;
         if(connected)
         {
            _loc2_ = new SocketMessage();
            this.send(_loc2_);
         }
      }
      
      public function flushEvent(param1:Event) : *
      {
         if(connected)
         {
            this.flush();
         }
         this.flushTimer.stop();
      }
      
      public function send(param1:SocketMessage, param2:Boolean = false) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(connected)
         {
            this.keepAliveTimer.reset();
            this.keepAliveTimer.start();
            ++this.outCmpt;
            if(this.outCmpt >= 65530)
            {
               this.outCmpt = 12;
            }
            _loc3_ = new SocketMessage();
            _loc3_.bitWriteUnsignedInt(16,this.outCmpt);
            _loc4_ = _loc3_.exportMessage();
            this.writeBytes(_loc4_);
            _loc4_ = param1.exportMessage();
            this.writeBytes(_loc4_);
            this.writeByte(0);
            if(param2)
            {
               this.flush();
            }
            else
            {
               this.flushTimer.start();
            }
         }
      }
      
      override public function close() : void
      {
         if(connected)
         {
            super.close();
         }
      }
      
      override public function connect(param1:String, param2:int) : void
      {
         this.inCmpt = 12;
         this.outCmpt = 12;
         this.inBuffer = new ByteArray();
         Security.loadPolicyFile("xmlsocket://" + param1 + ":" + param2);
         super.connect(param1,param2);
      }
      
      public function eventMessage(param1:SocketMessageEvent) : *
      {
         dispatchEvent(param1);
      }
      
      public function socketDataHandler(param1:ProgressEvent) : *
      {
         var _loc4_:uint = 0;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc2_:* = this.bytesAvailable;
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_ && connected)
         {
            if((_loc4_ = uint(this.readByte())) == 0)
            {
               ++this.inCmpt;
               if(this.inCmpt >= 65530)
               {
                  this.inCmpt = 12;
               }
               (_loc5_ = new SocketMessage()).readMessage(this.inBuffer);
               if(!((_loc4_ = uint(_loc5_.bitReadUnsignedInt(16))) < this.inCmpt || _loc4_ > this.inCmpt + 20))
               {
                  (_loc6_ = new SocketMessageEvent("onMessage",true,true)).message.writeBytes(_loc5_,2,0);
                  _loc6_.message.bitLength = _loc6_.message.length * 8;
                  this.eventMessage(_loc6_);
                  this.inBuffer = new ByteArray();
               }
            }
            else
            {
               this.inBuffer.writeByte(_loc4_);
            }
            _loc3_++;
         }
      }
   }
}
