package consolebbl.application
{
   import bbl.GlobalProperties;
   import consolebbl.GlobalConsoleProperties;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import ui.CheckBox;
   import ui.DragDropItem;
   
   [Embed(source="/_assets/assets.swf", symbol="consolebbl.application.CamADV")]
   public class CamADV extends MovieClip
   {
      
      public static var refList:Array = new Array();
       
      
      public var bt_drop:MovieClip;
      
      public var ch_decor:CheckBox;
      
      public var ch_rain:CheckBox;
      
      public var ch_userContent:CheckBox;
      
      public var ch_engine:CheckBox;
      
      public var dragDrop:DragDropItem;
      
      public var cameraList:Array;
      
      public function CamADV()
      {
         super();
         this.addEventListener(Event.ADDED,this.init,false,0,true);
      }
      
      public function init(param1:Event) : *
      {
         if(stage)
         {
            refList.push(this);
            this.removeEventListener(Event.ADDED,this.init,false);
            this.bt_drop.buttonMode = true;
            this.ch_decor.value = true;
            this.ch_userContent.value = true;
            this.ch_rain.value = true;
            this.ch_engine.value = true;
            this.ch_decor.addEventListener("onChanged",this.onParamChanged,false);
            this.ch_userContent.addEventListener("onChanged",this.onParamChanged,false);
            this.ch_rain.addEventListener("onChanged",this.onParamChanged,false);
            this.ch_engine.addEventListener("onChanged",this.onParamChanged,false);
            parent.width = 150;
            parent.height = 100;
            Object(parent).redraw();
            parent.addEventListener("onKill",this.onKill,false,0,true);
            this.cameraList = new Array();
            this.bt_drop.addEventListener(MouseEvent.MOUSE_DOWN,this.iconDropDown,false,0,true);
            this.dragDrop = GlobalConsoleProperties.console.dragDrop.addItem();
         }
      }
      
      public function iconDropMove(param1:Event = null) : *
      {
         var _loc2_:Array = this.dragDrop.testDrag();
         var _loc3_:MovieClip = GlobalProperties.cursor.addCursor(this,null);
         _loc3_.gotoAndStop(!!_loc2_.length ? "CAMERA" : "CAMERA_FORBIDEN");
      }
      
      public function iconDropUp(param1:Event) : *
      {
         GlobalProperties.stage.removeEventListener(MouseEvent.MOUSE_UP,this.iconDropUp,false);
         GlobalProperties.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.iconDropMove,false);
         GlobalProperties.cursor.removeCursor(this);
         var _loc2_:Array = this.dragDrop.testDrag();
         if(_loc2_.length)
         {
            if(_loc2_[0].data.CAMERA)
            {
               if(!this.haveCamera(_loc2_[0].data.CAMERA))
               {
                  this.addCamera(_loc2_[0].data.CAMERA);
               }
            }
         }
      }
      
      public function iconDropDown(param1:Event) : *
      {
         this.dragDrop.data.TYPE = "CAMERA";
         GlobalProperties.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.iconDropMove,false,0,true);
         GlobalProperties.stage.addEventListener(MouseEvent.MOUSE_UP,this.iconDropUp,false,0,true);
         this.iconDropMove();
      }
      
      public function haveCamera(param1:Object) : Boolean
      {
         var _loc2_:* = 0;
         while(_loc2_ < this.cameraList.length)
         {
            if(this.cameraList[_loc2_] == param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function removeCamera(param1:Object) : *
      {
         var _loc2_:* = 0;
         while(_loc2_ < this.cameraList.length)
         {
            if(this.cameraList[_loc2_] == param1)
            {
               param1.removeEventListener("onDisposed",this.onCamDisposed,false);
               param1.removeEventListener("onCameraReady",this.onCamReady,false);
               this.cameraList.splice(_loc2_,1);
               this.updateCamera(param1,true);
               break;
            }
            _loc2_++;
         }
      }
      
      public function addCamera(param1:Object) : *
      {
         var _loc2_:* = 0;
         while(_loc2_ < refList.length)
         {
            if(refList[_loc2_].haveCamera(param1))
            {
               refList[_loc2_].removeCamera(param1);
               break;
            }
            _loc2_++;
         }
         if(!this.haveCamera(param1))
         {
            this.cameraList.push(param1);
            param1.addEventListener("onDisposed",this.onCamDisposed,false);
            param1.addEventListener("onCameraReady",this.onCamReady,false);
            this.updateCamera(param1);
         }
      }
      
      public function onCamDisposed(param1:Event) : *
      {
         this.removeCamera(param1.currentTarget);
      }
      
      public function onCamReady(param1:Event) : *
      {
         this.updateCamera(param1.currentTarget);
      }
      
      public function updateCamera(param1:Object, param2:Boolean = false) : *
      {
         var _loc3_:uint = 0;
         var _loc4_:DisplayObjectContainer = null;
         var _loc5_:* = undefined;
         var _loc6_:DisplayObject = null;
         if(param1.cameraReady)
         {
            if(param1.userContentList)
            {
               _loc3_ = 0;
               while(_loc3_ < param1.userContentList.length)
               {
                  param1.userContentList[_loc3_].y = this.ch_userContent.value || param2 ? 0 : -9000;
                  _loc3_++;
               }
            }
            if(param1.currentMap)
            {
               _loc3_ = 0;
               while(_loc3_ < param1.currentMap.graphic.numChildren)
               {
                  _loc4_ = param1.currentMap.graphic.getChildAt(_loc3_);
                  _loc5_ = 0;
                  while(_loc5_ < _loc4_.numChildren)
                  {
                     if((_loc6_ = _loc4_.getChildAt(_loc5_)).name.split("userContent").length == 1 && _loc6_.name.split("rainMask").length == 1)
                     {
                        if(_loc6_.y < -9000 && (this.ch_decor.value || param2))
                        {
                           _loc6_.y += 99999;
                        }
                        else if(_loc6_.y > -9000 && !(this.ch_decor.value || param2))
                        {
                           _loc6_.y -= 99999;
                        }
                     }
                     _loc5_++;
                  }
                  _loc3_++;
               }
            }
            param1.physicEngine = param1.graphicEngine = this.ch_engine.value || param2;
            if(param1.rainEffect)
            {
               _loc3_ = 0;
               while(_loc3_ < param1.rainEffect.itemList.length)
               {
                  if(param1.rainEffect.itemList[_loc3_].y < -9000 && (this.ch_rain.value || param2))
                  {
                     param1.rainEffect.itemList[_loc3_].y += 99999;
                  }
                  else if(param1.rainEffect.itemList[_loc3_].y > -9000 && !(this.ch_rain.value || param2))
                  {
                     param1.rainEffect.itemList[_loc3_].y -= 99999;
                  }
                  _loc3_++;
               }
            }
         }
      }
      
      public function onParamChanged(param1:Event) : *
      {
         var _loc2_:* = 0;
         while(_loc2_ < this.cameraList.length)
         {
            this.updateCamera(this.cameraList[_loc2_]);
            _loc2_++;
         }
      }
      
      public function onKill(param1:Event) : *
      {
         this.ch_decor.removeEventListener("onChanged",this.onParamChanged,false);
         this.ch_userContent.removeEventListener("onChanged",this.onParamChanged,false);
         this.ch_rain.removeEventListener("onChanged",this.onParamChanged,false);
         this.ch_engine.removeEventListener("onChanged",this.onParamChanged,false);
         GlobalConsoleProperties.console.dragDrop.removeItem(this.dragDrop);
         var _loc2_:* = 0;
         while(_loc2_ < refList.length)
         {
            if(refList[_loc2_] == this)
            {
               refList.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
         while(this.cameraList.length)
         {
            this.removeCamera(this.cameraList[0]);
         }
      }
   }
}
