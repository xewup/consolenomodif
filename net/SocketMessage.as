package net
{
   import flash.utils.ByteArray;
   
   public class SocketMessage extends Binary
   {
       
      
      public function SocketMessage()
      {
         super();
      }
      
      public function duplicate() : SocketMessage
      {
         var _loc1_:SocketMessage = new SocketMessage();
         _loc1_.writeBytes(this,0,this.length);
         _loc1_.bitLength = bitLength;
         _loc1_.bitPosition = bitPosition;
         return _loc1_;
      }
      
      public function readMessage(param1:ByteArray) : *
      {
         var _loc2_:* = 0;
         while(_loc2_ < param1.length)
         {
            if(param1[_loc2_] == 1)
            {
               _loc2_++;
               this.writeByte(param1[_loc2_] == 2 ? 1 : 0);
            }
            else
            {
               this.writeByte(param1[_loc2_]);
            }
            _loc2_++;
         }
         bitLength = length * 8;
      }
      
      public function exportMessage() : ByteArray
      {
         var _loc1_:* = new ByteArray();
         var _loc2_:* = 0;
         while(_loc2_ < this.length)
         {
            if(this[_loc2_] == 0)
            {
               _loc1_.writeByte(1);
               _loc1_.writeByte(3);
            }
            else if(this[_loc2_] == 1)
            {
               _loc1_.writeByte(1);
               _loc1_.writeByte(2);
            }
            else
            {
               _loc1_.writeByte(this[_loc2_]);
            }
            _loc2_++;
         }
         return _loc1_;
      }
   }
}
