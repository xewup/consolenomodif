package consolebbl.application
{
   import bbl.GlobalProperties;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="consolebbl.application.WeekAccessViewer")]
   public class WeekAccessViewer extends MovieClip
   {
       
      
      public function WeekAccessViewer()
      {
         super();
         this.addEventListener(Event.ADDED,this.popinit,false,0,true);
      }
      
      public function popinit(param1:Event) : *
      {
         this.removeEventListener(Event.ADDED,this.popinit,false);
         parent.width = 580;
         parent.height = 160;
         Object(parent).redraw();
         this.loadData();
      }
      
      public function loadData() : *
      {
         var _loc4_:uint = 0;
         var _loc5_:TextField = null;
         var _loc1_:URLVariables = new URLVariables();
         _loc1_.CACHE = new Date().getTime();
         _loc1_.UID = Object(parent).data.UID;
         var _loc2_:URLRequest = new URLRequest(GlobalProperties.scriptAdr + "console/getWeekAccess.php");
         _loc2_.method = "POST";
         _loc2_.data = _loc1_;
         var _loc3_:URLLoader = new URLLoader();
         _loc3_.dataFormat = "variables";
         _loc3_.load(_loc2_);
         _loc3_.addEventListener("complete",this.onUrlMessage,false,0,true);
         _loc4_ = 0;
         while(_loc4_ < 7)
         {
            _loc5_ = new TextField();
            addChild(_loc5_);
            if(_loc4_ == 0)
            {
               _loc5_.text = "Lundi :";
            }
            if(_loc4_ == 1)
            {
               _loc5_.text = "Mardi :";
            }
            if(_loc4_ == 2)
            {
               _loc5_.text = "Mercredi :";
            }
            if(_loc4_ == 3)
            {
               _loc5_.text = "Jeudi :";
            }
            if(_loc4_ == 4)
            {
               _loc5_.text = "Vendredi :";
            }
            if(_loc4_ == 5)
            {
               _loc5_.text = "Samedi :";
            }
            if(_loc4_ == 6)
            {
               _loc5_.text = "Dimanche :";
            }
            _loc5_.y = 20 + _loc4_ * 18;
            _loc5_.x = 2;
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < 24)
         {
            _loc5_ = new TextField();
            addChild(_loc5_);
            _loc5_.text = _loc4_.toString() + "h";
            _loc5_.autoSize = "center";
            _loc5_.x = 60 + _loc4_ * 20;
            _loc4_ += 3;
         }
      }
      
      public function addSignal(param1:uint, param2:uint, param3:Number) : *
      {
         var _loc6_:uint = 0;
         var _loc7_:Sprite = null;
         var _loc4_:Number = Math.min(param3 * 2,1);
         var _loc5_:Number = Math.min((1 - param3) * 2,1);
         _loc6_ = Math.round(_loc4_ * 255) * 65536 + Math.round(_loc5_ * 255) * 256;
         _loc7_ = new Sprite();
         addChild(_loc7_);
         _loc7_.x = 60 + 20 * param2 + 2;
         _loc7_.y = 20 + 18 * param1 + 2;
         _loc7_.graphics.clear();
         _loc7_.graphics.lineStyle(0,0,0);
         _loc7_.graphics.beginFill(_loc6_,1);
         _loc7_.graphics.lineTo(16,0);
         _loc7_.graphics.lineTo(16,14);
         _loc7_.graphics.lineTo(0,14);
         _loc7_.graphics.lineTo(0,0);
         _loc7_.graphics.endFill();
      }
      
      public function onUrlMessage(param1:Event) : *
      {
         var _loc2_:Array = null;
         var _loc3_:* = undefined;
         var _loc4_:uint = 0;
         param1.currentTarget.removeEventListener("complete",this.onUrlMessage,false);
         if(param1.currentTarget.data.RESULT == 1)
         {
            _loc2_ = param1.currentTarget.data.DATA.split(",");
            _loc4_ = 0;
            _loc3_ = 0;
            while(_loc3_ < 168)
            {
               _loc4_ = Math.max(Number(_loc2_[_loc3_]),_loc4_);
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < 168)
            {
               this.addSignal((Math.floor(_loc3_ / 24) + 6) % 7,_loc3_ % 24,_loc4_ > 0 ? Number(_loc2_[_loc3_]) / _loc4_ : 0);
               _loc3_++;
            }
         }
      }
   }
}
