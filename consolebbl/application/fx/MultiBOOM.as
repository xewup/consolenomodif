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
   import ui.CheckBox;
   import ui.DragDropItem;
   import ui.ValueSelector;
   
   [Embed(source="/_assets/assets.swf", symbol="consolebbl.application.fx.MultiBOOM")]
   public class MultiBOOM extends MovieClip
   {
       
      
      public var vs_duration:ValueSelector;
      
      public var vs_size:ValueSelector;
      
      public var vs_interval:ValueSelector;
      
      public var bt_place:SimpleButton;
      
      public var bt_delete:SimpleButton;
      
      public var dragDrop:DragDropItem;
      
      public var ch_die_std:CheckBox;
      
      public var ch_die_shield:CheckBox;
      
      public var ch_audio:CheckBox;
      
      public var txt_motif:TextField;
      
      private var fxTrouve:Array;
      
      public function MultiBOOM()
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
            parent.height = 190;
            Object(parent).redraw();
            parent.addEventListener("onKill",this.onKill,false,0,true);
            this.vs_duration.maxValue = 20;
            this.vs_duration.minValue = 1;
            this.vs_duration.value = 5;
            this.vs_size.maxValue = 1000;
            this.vs_size.minValue = 1;
            this.vs_size.value = 100;
            this.vs_interval.maxValue = 2000;
            this.vs_interval.minValue = 10;
            this.vs_interval.value = 100;
            this.ch_audio.value = true;
            this.ch_die_std.value = true;
            this.ch_die_shield.value = false;
            this.bt_place.addEventListener(MouseEvent.MOUSE_DOWN,this.iconDropDown,false,0,true);
            this.bt_delete.addEventListener(MouseEvent.MOUSE_DOWN,this.iconDeleteDown,false,0,true);
            this.dragDrop = GlobalConsoleProperties.console.dragDrop.addItem();
         }
      }
      
      public function iconDropMove(param1:Event = null) : *
      {
         var _loc4_:Object = null;
         var _loc2_:Array = this.dragDrop.testDrag();
         var _loc3_:MovieClip = GlobalProperties.cursor.addCursor(this,null);
         _loc3_.gotoAndStop(!!_loc2_.length ? "CAMERA" : "CAMERA_FORBIDEN");
         if(_loc2_.length)
         {
            if(_loc2_[0].data.CAMERA)
            {
               if(!(_loc4_ = _loc2_[0].data.CAMERA).cameraReady)
               {
               }
            }
         }
      }
      
      public function iconDropUp(param1:Event) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:Binary = null;
         GlobalProperties.stage.removeEventListener(MouseEvent.MOUSE_UP,this.iconDropUp,false);
         GlobalProperties.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.iconDropMove,false);
         GlobalProperties.cursor.removeCursor(this);
         var _loc2_:Array = this.dragDrop.testDrag();
         if(_loc2_.length)
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
                  _loc3_.bitWriteUnsignedInt(GlobalProperties.BIT_FX_SID,4);
                  _loc3_.bitWriteBoolean(true);
                  (_loc4_ = new Binary()).bitWriteBoolean(this.ch_die_std.value);
                  _loc4_.bitWriteBoolean(this.ch_die_shield.value);
                  _loc4_.bitWriteBoolean(this.ch_audio.value);
                  _loc4_.bitWriteUnsignedInt(10,this.vs_size.value);
                  _loc4_.bitWriteUnsignedInt(10,this.vs_interval.value);
                  _loc4_.bitWriteString(this.txt_motif.text);
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
                        if(_loc6_.mboom)
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
                     _loc4_.bitWriteUnsignedInt(GlobalProperties.BIT_FX_SID,4);
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
