package consolebbl.application
{
   import bbl.GlobalProperties;
   import consolebbl.GlobalConsoleProperties;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import net.ParsedMessageEvent;
   import net.SocketMessage;
   import ui.ValueSelector;
   
   [Embed(source="/_assets/assets.swf", symbol="consolebbl.application.ServerStat")]
   public class ServerStat extends MovieClip
   {
       
      
      public var screenArea:MovieClip;
      
      public var statType:uint;
      
      public var stepTimer:Timer;
      
      public var lastValue:Number;
      
      public var ecran:Sprite;
      
      public var content:Sprite;
      
      public var lastScreenPos:Point;
      
      public var lastTime:Number;
      
      public var statList:Array;
      
      public var vs_interval:ValueSelector;
      
      public var dataList:Array;
      
      public var bt_nextStat:SimpleButton;
      
      public var txt_stat_desc:TextField;
      
      public var txt_last_val:TextField;
      
      public var txt_max_val:TextField;
      
      public function ServerStat()
      {
         super();
         this.addEventListener(Event.ADDED,this.init,false,0,true);
         this.statType = 0;
         this.dataList = new Array();
      }
      
      public function init(param1:Event) : *
      {
         if(stage)
         {
            this.removeEventListener(Event.ADDED,this.init,false);
            parent.width = 400;
            parent.height = 200;
            Object(parent).redraw();
            parent.addEventListener("onKill",this.onKill,false,0,true);
            GlobalConsoleProperties.console.blablaland.addEventListener("onParsedMessage",this.onMessage,false,0,true);
            this.statList = new Array();
            this.statList.push({
               "unit":"/s",
               "desc":"Connection user par seconde."
            });
            this.statList.push({
               "unit":"/s",
               "desc":"Déconnection user par seconde."
            });
            this.statList.push({
               "unit":"/s",
               "desc":"TCP connection par seconde."
            });
            this.statList.push({
               "unit":"o/s",
               "desc":"Nombre octets envoyés par seconde."
            });
            this.statList.push({
               "unit":"o/s",
               "desc":"Nombre octets reçus par seconde."
            });
            this.statList.push({
               "unit":"/s",
               "desc":"Nombre de messages socket envoyés par seconde."
            });
            this.statList.push({
               "unit":"/s",
               "desc":"Nombre de messages socket reçus par seconde."
            });
            this.statList.push({
               "unit":"/s",
               "desc":"Nombre de traitements dans l\'insultron par seconde."
            });
            this.statList.push({
               "unit":"/s",
               "desc":"Nombre de recherche de user sur PID."
            });
            this.statList.push({
               "unit":"/s",
               "desc":"Nombre de recherche de user sur UID."
            });
            this.statList.push({
               "unit":"/s",
               "desc":"Nombre d\'entrées dans une map par seconde."
            });
            this.statList.push({
               "unit":"/s",
               "desc":"Nombre de recherches sur pseudo."
            });
            this.vs_interval.value = 1;
            this.vs_interval.minValue = 1;
            this.vs_interval.maxValue = 60;
            this.vs_interval.addEventListener("onChanged",this.onChangedEvt,false);
            this.bt_nextStat.addEventListener("click",this.btStatChangeEvt,false);
            this.content = new Sprite();
            this.content.scaleY = -1;
            this.content.y = this.screenArea.height;
            addChild(this.content);
            this.ecran = new Sprite();
            this.content.addChild(this.ecran);
            this.changeStatType(0);
            this.stepTimer = new Timer(this.vs_interval.value * 1000);
            this.stepTimer.start();
            this.stepTimer.addEventListener("timer",this.onTimerEvt,false);
         }
      }
      
      public function btStatChangeEvt(param1:Event) : *
      {
         if(this.statType < this.statList.length - 1)
         {
            this.changeStatType(this.statType + 1);
         }
         else
         {
            this.changeStatType(0);
         }
      }
      
      public function onChangedEvt(param1:Event) : *
      {
         this.stepTimer.reset();
         this.stepTimer.delay = this.vs_interval.value * 1000;
         this.stepTimer.start();
      }
      
      public function resetEcran() : *
      {
         this.ecran.graphics.clear();
         this.ecran.graphics.lineStyle(0,255,1);
      }
      
      public function clearEcran() : *
      {
         this.resetEcran();
         this.dataList = new Array();
         this.lastScreenPos = new Point(0,0);
         this.ecran.x = 0;
         this.ecran.y = 0;
      }
      
      public function onTimerEvt(param1:Event) : *
      {
         var _loc2_:SocketMessage = new SocketMessage();
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,4);
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,25);
         _loc2_.bitWriteUnsignedInt(8,this.statType);
         _loc2_.bitWriteUnsignedInt(16,Object(parent).pid);
         GlobalConsoleProperties.console.blablaland.send(_loc2_);
      }
      
      public function displayValue(param1:Number) : String
      {
         var _loc2_:String = "";
         var _loc3_:String = Math.round(param1).toString();
         if(_loc3_.length > 4)
         {
            _loc2_ = "K";
            param1 = Math.round(param1 / 100) / 10;
         }
         else if(_loc3_.length > 7)
         {
            _loc2_ = "M";
            param1 = Math.round(param1 / 100000) / 10;
         }
         else
         {
            param1 = Math.round(param1 * 10) / 10;
         }
         return param1.toString() + " " + _loc2_ + this.statList[this.statType].unit;
      }
      
      public function onSocketData(param1:uint) : *
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Array = null;
         if(this.lastValue >= 0)
         {
            _loc2_ = getTimer() - this.lastTime;
            _loc3_ = 0;
            if(param1 >= this.lastValue)
            {
               _loc3_ = param1 - this.lastValue;
            }
            else
            {
               _loc3_ = param1 + (uint(-1) - this.lastValue) + 1;
            }
            _loc4_ = _loc3_ / (_loc2_ / 1000);
            (_loc5_ = new Array()).push(this.lastScreenPos.clone());
            this.ecran.graphics.moveTo(this.lastScreenPos.x,this.lastScreenPos.y);
            this.lastScreenPos.x += 10;
            this.lastScreenPos.y = _loc4_;
            _loc5_.push(this.lastScreenPos.clone());
            this.ecran.graphics.lineTo(this.lastScreenPos.x,this.lastScreenPos.y);
            this.dataList.push(_loc5_);
            if(this.dataList.length * 10 > this.screenArea.width)
            {
               this.resetEcran();
               _loc5_ = null;
               while(this.dataList.length)
               {
                  _loc5_ = this.dataList.pop();
                  this.ecran.graphics.moveTo(_loc5_[1].x - this.lastScreenPos.x,_loc5_[1].y);
                  this.ecran.graphics.lineTo(_loc5_[0].x - this.lastScreenPos.x,_loc5_[0].y);
               }
               this.ecran.graphics.lineTo(_loc5_[0].x - this.lastScreenPos.x,0);
               this.lastScreenPos.x = 0;
            }
            if(this.ecran.height)
            {
               this.ecran.height = this.screenArea.height;
            }
            else
            {
               this.ecran.scaleY = 1;
            }
            this.ecran.x = parent.width - this.lastScreenPos.x;
            this.txt_last_val.text = this.displayValue(_loc4_);
            this.txt_max_val.text = this.displayValue(this.ecran.height / this.ecran.scaleY);
         }
         this.lastValue = param1;
         this.lastTime = getTimer();
      }
      
      public function changeStatType(param1:uint) : *
      {
         this.statType = param1;
         this.clearEcran();
         this.lastValue = -1;
         this.txt_stat_desc.text = this.statList[this.statType].desc;
         this.txt_last_val.text = "";
         this.txt_max_val.text = "";
      }
      
      public function onMessage(param1:ParsedMessageEvent) : *
      {
         var _loc2_:SocketMessage = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         if(param1.evtType == 6)
         {
            if(param1.evtStype == 13)
            {
               _loc2_ = param1.getMessage();
               _loc3_ = _loc2_.bitReadUnsignedInt(16);
               if(_loc3_ == Object(parent).pid)
               {
                  param1.stopImmediatePropagation();
                  _loc4_ = _loc2_.bitReadUnsignedInt(8);
                  _loc5_ = _loc2_.bitReadUnsignedInt(32);
                  if(_loc4_ == this.statType)
                  {
                     this.onSocketData(_loc5_);
                  }
               }
            }
         }
      }
      
      public function onKill(param1:Event) : *
      {
         this.stepTimer.stop();
         parent.removeEventListener("onKill",this.onKill,false);
      }
   }
}
