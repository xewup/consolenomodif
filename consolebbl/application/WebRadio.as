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
   import ui.Scroll;
   
   [Embed(source="/_assets/assets.swf", symbol="consolebbl.application.WebRadio")]
   public class WebRadio extends MovieClip
   {
       
      
      public var j_0:MovieClip;
      
      public var j_1:MovieClip;
      
      public var j_2:MovieClip;
      
      public var j_3:MovieClip;
      
      public var j_4:MovieClip;
      
      public var j_5:MovieClip;
      
      public var j_6:MovieClip;
      
      public var txt_start:TextField;
      
      public var txt_end:TextField;
      
      public var scr_start:Scroll;
      
      public var scr_end:Scroll;
      
      public var bt_save:SimpleButton;
      
      public var channel:Channel;
      
      public function WebRadio()
      {
         super();
         this.addEventListener(Event.ADDED,this.popinit,false,0,true);
      }
      
      public function popinit(param1:Event) : *
      {
         var _loc2_:int = 0;
         if(stage)
         {
            this.removeEventListener(Event.ADDED,this.popinit,false);
            parent.width = 200;
            parent.height = 120;
            Object(parent).redraw();
            parent.addEventListener("onKill",this.onKill,false,0,true);
            this.scr_start.size = this.scr_end.size = 135;
            this.scr_start.value = this.scr_end.value = 0;
            this.scr_start.ratio = this.scr_end.ratio = 0.1;
            this.scr_start.changeStep = this.scr_end.changeStep = 1 / 1440;
            this.scr_start.addEventListener("onChanged",this.updateByUI);
            this.scr_end.addEventListener("onChanged",this.updateByUI);
            this.bt_save.addEventListener("click",this.onSave);
            this.channel = new Channel();
            this.channel.addEventListener("onMessage",this.onChannelMessage);
            _loc2_ = 0;
            while(_loc2_ < 7)
            {
               this["j_" + _loc2_].gotoAndStop(1);
               this["j_" + _loc2_].addEventListener("click",this.onDayClick);
               this["j_" + _loc2_].buttonMode = true;
               _loc2_++;
            }
            this.readData();
         }
      }
      
      public function onSave(param1:Event) : *
      {
         var _loc5_:int = 0;
         mouseChildren = false;
         alpha = 0.5;
         var _loc2_:* = 0;
         var _loc3_:int = 0;
         while(_loc3_ < 7)
         {
            _loc5_ = this["j_" + _loc3_].currentFrame == 2 ? 1 : 0;
            _loc2_ |= _loc5_ << _loc3_;
            _loc3_++;
         }
         var _loc4_:SocketMessage;
         (_loc4_ = new SocketMessage()).bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,12);
         _loc4_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,1);
         _loc4_.bitWriteUnsignedInt(8,2);
         _loc4_.bitWriteUnsignedInt(GlobalProperties.BIT_CHANNEL_ID,this.channel.id);
         _loc4_.bitWriteUnsignedInt(32,_loc2_);
         _loc4_.bitWriteUnsignedInt(32,Math.round(this.scr_start.value * 1440));
         _loc4_.bitWriteUnsignedInt(32,Math.round(this.scr_end.value * 1440));
         GlobalConsoleProperties.console.blablaland.send(_loc4_);
      }
      
      public function readData() : *
      {
         mouseChildren = false;
         alpha = 0.5;
         var _loc1_:SocketMessage = new SocketMessage();
         _loc1_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,12);
         _loc1_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,1);
         _loc1_.bitWriteUnsignedInt(8,1);
         _loc1_.bitWriteUnsignedInt(GlobalProperties.BIT_CHANNEL_ID,this.channel.id);
         GlobalConsoleProperties.console.blablaland.send(_loc1_);
      }
      
      public function onChannelMessage(param1:Event) : *
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:int = this.channel.message.bitReadUnsignedInt(8);
         if(_loc2_ == 1)
         {
            _loc3_ = Math.min(Math.max(this.channel.message.bitReadUnsignedInt(32),0),127);
            _loc4_ = Math.min(Math.max(this.channel.message.bitReadUnsignedInt(32),0),1440);
            _loc5_ = Math.min(Math.max(this.channel.message.bitReadUnsignedInt(32),0),1440);
            _loc6_ = 0;
            while(_loc6_ < 7)
            {
               this["j_" + _loc6_].gotoAndStop(!!(_loc3_ >> _loc6_ & 1) ? 2 : 1);
               _loc6_++;
            }
            this.scr_start.value = _loc4_ / 1440;
            this.scr_end.value = _loc5_ / 1440;
            this.updateByUI(null);
            mouseChildren = true;
            alpha = 1;
         }
         else if(_loc2_ == 2)
         {
            mouseChildren = true;
            alpha = 1;
         }
      }
      
      public function updateByUI(param1:Event) : *
      {
         if(param1 && param1.currentTarget == this.scr_start && this.scr_start.value > this.scr_end.value)
         {
            this.scr_end.value = this.scr_start.value;
         }
         if(param1 && param1.currentTarget == this.scr_end && this.scr_end.value < this.scr_start.value)
         {
            this.scr_start.value = this.scr_end.value;
         }
         var _loc2_:int = Math.round(this.scr_start.value * 1440);
         var _loc3_:int = Math.round(this.scr_end.value * 1440);
         this.txt_start.text = "De : " + this.dualDigit(Math.floor(_loc2_ / 60) % 24) + "h" + this.dualDigit(_loc2_ % 60);
         this.txt_end.text = "A : " + this.dualDigit(Math.floor(_loc3_ / 60) % 24) + "h" + this.dualDigit(_loc3_ % 60);
      }
      
      public function onDayClick(param1:Event) : *
      {
         var _loc2_:* = param1.currentTarget.currentFrame == 2;
         param1.currentTarget.gotoAndStop(_loc2_ ? 1 : 2);
      }
      
      public function onKill(param1:Event) : *
      {
         this.channel.dispose();
      }
      
      public function dualDigit(param1:uint) : String
      {
         var _loc2_:String = param1.toString();
         if(_loc2_.length < 2)
         {
            _loc2_ = "0" + _loc2_;
         }
         return _loc2_;
      }
   }
}
