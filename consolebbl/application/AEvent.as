package consolebbl.application
{
   import bbl.GlobalProperties;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="consolebbl.application.AEvent")]
   public class AEvent extends MovieClip
   {
       
      
      public var txt_last:TextField;
      
      public var txt_list:TextField;
      
      public var messageList:Array;
      
      private var sndChannel:SoundChannel;
      
      private var count:uint;
      
      public function AEvent()
      {
         super();
         this.count = 0;
         this.addEventListener(Event.ADDED,this.popinit,false,0,true);
         this.txt_last.text = "";
         this.txt_list.text = "";
         this.messageList = new Array();
      }
      
      public function popinit(param1:Event) : *
      {
         if(stage)
         {
            this.removeEventListener(Event.ADDED,this.popinit,false);
            parent.width = 150;
            parent.height = 150;
            Object(parent).redraw();
            parent.addEventListener("onKill",this.onKill,false,0,true);
            GlobalProperties.mainApplication.addEventListener("onNewAmount",this.onNewAmount,false);
         }
      }
      
      public function onNewAmount(param1:Event) : *
      {
         var _loc5_:MovieClip = null;
         var _loc6_:Point = null;
         var _loc2_:Number = GlobalProperties.mainApplication.lastAmount / 1000;
         this.txt_last.text = _loc2_.toString();
         var _loc3_:Date = new Date();
         this.messageList.push(_loc2_.toString() + "\t\t=> " + this.dualDigit(_loc3_.getHours()) + ":" + this.dualDigit(_loc3_.getMinutes()) + ":" + this.dualDigit(_loc3_.getSeconds()));
         while(this.messageList.length > 20)
         {
            this.messageList.shift();
         }
         this.txt_list.text = this.messageList.join("\n");
         this.txt_list.scrollV = this.txt_list.maxScrollV;
         var _loc4_:Sound = new SndEvent();
         this.sndChannel = _loc4_.play(0,0,new SoundTransform(2.5));
         _loc5_ = new TxtEvent();
         GlobalProperties.mainApplication.addChild(_loc5_);
         _loc6_ = new Point();
         _loc6_ = this.localToGlobal(_loc6_);
         _loc6_ = GlobalProperties.mainApplication.globalToLocal(_loc6_);
         _loc5_.x = _loc6_.x + this.count % 5 * 20;
         _loc5_.y = _loc6_.y - 10;
         Object(_loc5_).sclip.txt.text = _loc2_.toString();
         ++this.count;
      }
      
      public function onKill(param1:Event) : *
      {
         GlobalProperties.mainApplication.removeEventListener("onNewAmount",this.onNewAmount,false);
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
