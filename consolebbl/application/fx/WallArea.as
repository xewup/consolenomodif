package consolebbl.application.fx
{
   import bbl.GlobalProperties;
   import consolebbl.GlobalConsoleProperties;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import net.Binary;
   import net.SocketMessage;
   import ui.CheckBox;
   import ui.DragDropItem;
   import ui.ScrollRectArea;
   import ui.ValueSelector;
   
   [Embed(source="/_assets/assets.swf", symbol="consolebbl.application.fx.WallArea")]
   public class WallArea extends MovieClip
   {
       
      
      public var vs_duration:ValueSelector;
      
      public var vs_epaisseur:ValueSelector;
      
      public var ch_visible:CheckBox;
      
      public var ch_cloud:CheckBox;
      
      public var ch_solid:CheckBox;
      
      public var bt_place:SimpleButton;
      
      public var bt_delete:SimpleButton;
      
      public var bt_clear:SimpleButton;
      
      public var dragDrop:DragDropItem;
      
      public var clip_area:Sprite;
      
      private var reactArea:ScrollRectArea;
      
      private var fxTrouve:Array;
      
      private var contentWall:Sprite;
      
      private var drawing:Boolean;
      
      private var lineData:Binary;
      
      public function WallArea()
      {
         super();
         this.addEventListener(Event.ADDED,this.init,false,0,true);
      }
      
      public function init(param1:Event) : *
      {
         if(stage)
         {
            this.removeEventListener(Event.ADDED,this.init,false);
            parent.width = 340;
            parent.height = 290;
            Object(parent).resizer.visible = true;
            Object(parent).areaPanel.alpha = 0.4;
            Object(parent).fontPanel.alpha = 0.4;
            parent.addEventListener("onKill",this.onKill,false,0,true);
            parent.addEventListener("onResized",this.onResized,false,0,true);
            this.reactArea = new ScrollRectArea();
            addChild(this.reactArea);
            this.reactArea.x = 10;
            this.reactArea.y = 80;
            this.reactArea.areaWidth = 310;
            this.reactArea.areaHeight = 160;
            this.reactArea.contentWidth = 950;
            this.reactArea.contentHeight = 425;
            this.onResized(null);
            this.contentWall = new Sprite();
            this.reactArea.content.addChild(this.contentWall);
            this.lineData = new Binary();
            this.vs_duration.maxValue = 9999;
            this.vs_duration.minValue = 0;
            this.vs_duration.value = 10;
            this.vs_epaisseur.maxValue = 20;
            this.vs_epaisseur.minValue = 2;
            this.vs_epaisseur.value = 6;
            this.ch_solid.value = true;
            this.ch_visible.value = true;
            this.ch_cloud.value = true;
            addEventListener(MouseEvent.MOUSE_DOWN,this.contentDownEvt,false,0,true);
            this.bt_clear.addEventListener("click",this.clearEvt,false,0,true);
            this.bt_place.addEventListener(MouseEvent.MOUSE_DOWN,this.iconDropDown,false,0,true);
            this.bt_delete.addEventListener(MouseEvent.MOUSE_DOWN,this.iconDeleteDown,false,0,true);
            this.dragDrop = GlobalConsoleProperties.console.dragDrop.addItem();
         }
      }
      
      public function onResized(param1:Event) : *
      {
         parent.width = Math.max(340,parent.width);
         parent.height = Math.max(290,parent.height);
         this.reactArea.areaWidth = 310 + parent.width - 340;
         this.reactArea.areaHeight = 160 + parent.height - 290;
         this.clip_area.width = this.reactArea.areaWidth;
         this.clip_area.height = this.reactArea.areaHeight;
         var _loc2_:* = 0;
         while(_loc2_ < this.numChildren)
         {
            if(this.getChildAt(_loc2_).y > 200)
            {
               this.getChildAt(_loc2_).y = this.reactArea.areaHeight + this.reactArea.y + (this.getChildAt(_loc2_) is SimpleButton ? 30 : 25);
            }
            _loc2_++;
         }
         Object(parent).redraw();
      }
      
      public function contentDownEvt(param1:Event = null) : *
      {
         if(this.reactArea.mouseX >= 0 && this.reactArea.mouseY >= 0 && this.reactArea.mouseX <= this.reactArea.areaWidth && this.reactArea.mouseY <= this.reactArea.areaHeight)
         {
            stage.addEventListener(MouseEvent.MOUSE_UP,this.contentUpEvt,false);
            this.contentWall.graphics.lineStyle(this.vs_epaisseur.value,this.ch_cloud.value ? 16776960 : 16711935,this.ch_visible.value ? 1 : 0.2);
            this.contentWall.graphics.moveTo(this.contentWall.mouseX,this.contentWall.mouseY);
            this.lineData.bitWriteBoolean(this.ch_cloud.value);
            this.lineData.bitWriteBoolean(this.ch_visible.value);
            this.lineData.bitWriteBoolean(this.ch_solid.value);
            this.lineData.bitWriteUnsignedInt(5,this.vs_epaisseur.value);
            this.lineData.bitWriteSignedInt(17,this.contentWall.mouseX);
            this.lineData.bitWriteSignedInt(17,this.contentWall.mouseY);
            this.drawing = true;
         }
      }
      
      public function contentUpEvt(param1:Event = null) : *
      {
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.contentUpEvt,false);
         if(this.drawing)
         {
            this.contentWall.graphics.lineTo(this.contentWall.mouseX,this.contentWall.mouseY);
            this.lineData.bitWriteSignedInt(17,this.contentWall.mouseX);
            this.lineData.bitWriteSignedInt(17,this.contentWall.mouseY);
            this.drawing = false;
         }
      }
      
      public function clearEvt(param1:Event = null) : *
      {
         this.lineData = new Binary();
         this.contentWall.graphics.clear();
      }
      
      public function iconDropMove(param1:Event = null) : *
      {
         var _loc4_:Object = null;
         if(this.contentWall.parent)
         {
            this.contentWall.parent.removeChild(this.contentWall);
         }
         var _loc2_:Array = this.dragDrop.testDrag();
         var _loc3_:MovieClip = GlobalProperties.cursor.addCursor(this,null);
         _loc3_.gotoAndStop(!!_loc2_.length ? "CAMERA" : "CAMERA_FORBIDEN");
         if(_loc2_.length)
         {
            if(_loc2_[0].data.CAMERA)
            {
               if((_loc4_ = _loc2_[0].data.CAMERA).cameraReady)
               {
                  _loc4_.userContent.addChildAt(this.contentWall,0);
                  this.contentWall.x = Math.round(_loc4_.userContent.mouseX);
                  this.contentWall.y = Math.round(_loc4_.userContent.mouseY);
               }
            }
         }
      }
      
      public function iconDropUp(param1:Event) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:Binary = null;
         if(this.contentWall.parent)
         {
            this.contentWall.parent.removeChild(this.contentWall);
         }
         this.reactArea.content.addChild(this.contentWall);
         this.contentWall.x = 0;
         this.contentWall.y = 0;
         GlobalProperties.stage.removeEventListener(MouseEvent.MOUSE_UP,this.iconDropUp,false);
         GlobalProperties.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.iconDropMove,false);
         GlobalProperties.cursor.removeCursor(this);
         var _loc2_:Array = this.dragDrop.testDrag();
         if(Boolean(_loc2_.length) && Boolean(this.lineData.length))
         {
            if(_loc2_[0].data.CAMERA)
            {
               if(_loc2_[0].data.CAMERA.cameraReady)
               {
                  _loc3_ = new SocketMessage();
                  _loc3_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,4);
                  _loc3_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,21);
                  _loc3_.bitWriteUnsignedInt(GlobalProperties.BIT_MAP_ID,_loc2_[0].data.CAMERA.mapId);
                  _loc3_.bitWriteUnsignedInt(GlobalProperties.BIT_SERVER_ID,_loc2_[0].data.CAMERA.serverId);
                  _loc3_.bitWriteUnsignedInt(2,0);
                  _loc3_.bitWriteUnsignedInt(GlobalProperties.BIT_FX_ID,7);
                  _loc3_.bitWriteUnsignedInt(GlobalProperties.BIT_FX_SID,6);
                  _loc3_.bitWriteBoolean(true);
                  (_loc4_ = new Binary()).bitWriteSignedInt(17,Math.round(_loc2_[0].data.CAMERA.userContent.mouseX));
                  _loc4_.bitWriteSignedInt(17,Math.round(_loc2_[0].data.CAMERA.userContent.mouseY));
                  _loc4_.bitWriteBinaryData(this.lineData);
                  _loc3_.bitWriteBinaryData(_loc4_);
                  if(this.vs_duration.value > 0)
                  {
                     _loc3_.bitWriteBoolean(true);
                     _loc3_.bitWriteUnsignedInt(32,this.vs_duration.value);
                  }
                  else
                  {
                     _loc3_.bitWriteBoolean(false);
                  }
                  GlobalConsoleProperties.console.blablaland.send(_loc3_);
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
      
      public function iconDeleteMove(param1:Event = null) : *
      {
         var _loc4_:Object = null;
         var _loc5_:* = undefined;
         var _loc6_:Object = null;
         var _loc2_:Array = this.dragDrop.testDrag();
         this.fxTrouve = new Array();
         if(_loc2_.length)
         {
            if(_loc2_[0].data.CAMERA)
            {
               if((_loc4_ = _loc2_[0].data.CAMERA).cameraReady)
               {
                  _loc5_ = _loc4_.fxMemory.length - 1;
                  while(_loc5_ >= 0)
                  {
                     _loc6_ = _loc4_.fxMemory[_loc5_];
                     try
                     {
                        if(_loc6_.wallArea)
                        {
                           this.fxTrouve.push(_loc6_);
                        }
                     }
                     catch(err:Error)
                     {
                     }
                     _loc5_--;
                  }
               }
            }
         }
         var _loc3_:MovieClip = GlobalProperties.cursor.addCursor(this,null);
         _loc3_.gotoAndStop(!!this.fxTrouve.length ? "BEEN" : "FORBIDEN");
      }
      
      public function iconDeleteUp(param1:Event) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         GlobalProperties.stage.removeEventListener(MouseEvent.MOUSE_UP,this.iconDeleteUp,false);
         GlobalProperties.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.iconDeleteMove,false);
         GlobalProperties.cursor.removeCursor(this);
         var _loc2_:Array = this.dragDrop.testDrag();
         if(Boolean(_loc2_.length) && Boolean(this.fxTrouve))
         {
            if(_loc2_[0].data.CAMERA)
            {
               if(_loc2_[0].data.CAMERA.cameraReady)
               {
                  _loc3_ = 0;
                  while(_loc3_ < this.fxTrouve.length)
                  {
                     (_loc4_ = new SocketMessage()).bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,4);
                     _loc4_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,21);
                     _loc4_.bitWriteUnsignedInt(GlobalProperties.BIT_MAP_ID,_loc2_[0].data.CAMERA.mapId);
                     _loc4_.bitWriteUnsignedInt(GlobalProperties.BIT_SERVER_ID,_loc2_[0].data.CAMERA.serverId);
                     _loc4_.bitWriteUnsignedInt(2,1);
                     _loc4_.bitWriteUnsignedInt(GlobalProperties.BIT_FX_ID,7);
                     _loc4_.bitWriteUnsignedInt(GlobalProperties.BIT_FX_SID,6);
                     _loc4_.bitWriteUnsignedInt(GlobalProperties.BIT_FX_SID,this.fxTrouve[_loc3_].fxSid);
                     _loc4_.bitWriteBoolean(false);
                     GlobalConsoleProperties.console.blablaland.send(_loc4_);
                     _loc3_++;
                  }
               }
            }
         }
      }
      
      public function iconDeleteDown(param1:Event) : *
      {
         this.dragDrop.data.TYPE = "CAMERA";
         GlobalProperties.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.iconDeleteMove,false,0,true);
         GlobalProperties.stage.addEventListener(MouseEvent.MOUSE_UP,this.iconDeleteUp,false,0,true);
         this.iconDeleteMove();
      }
      
      public function onKill(param1:Event) : *
      {
         this.contentUpEvt(null);
         GlobalConsoleProperties.console.dragDrop.removeItem(this.dragDrop);
      }
   }
}
