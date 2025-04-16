package consolebbl.application.fx
{
   import bbl.GlobalProperties;
   import consolebbl.GlobalConsoleProperties;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import net.Binary;
   import net.SocketMessage;
   import ui.DragDropItem;
   import ui.ValueSelector;
   
   [Embed(source="/_assets/assets.swf", symbol="consolebbl.application.fx.PlaceText")]
   public class PlaceText extends MovieClip
   {
       
      
      public var vs_duration:ValueSelector;
      
      public var txt_input:TextField;
      
      public var bt_place:SimpleButton;
      
      public var bt_delete:SimpleButton;
      
      public var dragDrop:DragDropItem;
      
      private var sampleTxt:TextField;
      
      private var fxTrouve:Array;
      
      public function PlaceText()
      {
         super();
         this.addEventListener(Event.ADDED,this.init,false,0,true);
      }
      
      public function init(param1:Event) : *
      {
         if(stage)
         {
            this.removeEventListener(Event.ADDED,this.init,false);
            parent.width = 230;
            parent.height = 160;
            Object(parent).redraw();
            parent.addEventListener("onKill",this.onKill,false,0,true);
            this.vs_duration.maxValue = 99999;
            this.vs_duration.minValue = 0;
            this.vs_duration.value = 120;
            this.vs_duration.resolution = 1;
            this.vs_duration.step = 10;
            this.sampleTxt = new TextField();
            this.sampleTxt.autoSize = "left";
            this.sampleTxt.multiline = false;
            this.sampleTxt.selectable = false;
            this.bt_place.addEventListener(MouseEvent.MOUSE_DOWN,this.iconDropDown,false,0,true);
            this.bt_delete.addEventListener(MouseEvent.MOUSE_DOWN,this.iconDeleteDown,false,0,true);
            this.dragDrop = GlobalConsoleProperties.console.dragDrop.addItem();
         }
      }
      
      public function iconDropMove(param1:Event = null) : *
      {
         var _loc4_:Object = null;
         if(this.sampleTxt.parent)
         {
            this.sampleTxt.parent.removeChild(this.sampleTxt);
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
                  _loc4_.userContent.addChildAt(this.sampleTxt,0);
                  this.sampleTxt.x = Math.round(_loc4_.userContent.mouseX);
                  this.sampleTxt.y = Math.round(_loc4_.userContent.mouseY);
               }
            }
         }
      }
      
      public function iconDropUp(param1:Event) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:Binary = null;
         if(this.sampleTxt.parent)
         {
            this.sampleTxt.parent.removeChild(this.sampleTxt);
         }
         GlobalProperties.stage.removeEventListener(MouseEvent.MOUSE_UP,this.iconDropUp,false);
         GlobalProperties.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.iconDropMove,false);
         GlobalProperties.cursor.removeCursor(this);
         var _loc2_:Array = this.dragDrop.testDrag();
         if(_loc2_.length && this.sampleTxt.textHeight > 5 && this.sampleTxt.textWidth > 5)
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
                  _loc3_.bitWriteUnsignedInt(GlobalProperties.BIT_FX_SID,3);
                  _loc3_.bitWriteBoolean(true);
                  (_loc4_ = new Binary()).bitWriteSignedInt(17,Math.round(_loc2_[0].data.CAMERA.userContent.mouseX));
                  _loc4_.bitWriteSignedInt(17,Math.round(_loc2_[0].data.CAMERA.userContent.mouseY));
                  _loc4_.bitWriteString(this.txt_input.text);
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
         this.sampleTxt.htmlText = this.txt_input.text;
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
                        if(_loc6_.ptext)
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
         if(this.sampleTxt.parent)
         {
            this.sampleTxt.parent.removeChild(this.sampleTxt);
         }
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
                     _loc4_.bitWriteUnsignedInt(GlobalProperties.BIT_FX_SID,3);
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
         GlobalConsoleProperties.console.dragDrop.removeItem(this.dragDrop);
      }
   }
}
