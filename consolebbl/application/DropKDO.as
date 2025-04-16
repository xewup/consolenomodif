package consolebbl.application
{
   import bbl.GlobalProperties;
   import consolebbl.GlobalConsoleProperties;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import net.SocketMessage;
   import ui.DragDropItem;
   import ui.ValueSelector;
   
   [Embed(source="/_assets/assets.swf", symbol="consolebbl.application.DropKDO")]
   public class DropKDO extends MovieClip
   {
       
      
      public var vs_bbl:ValueSelector;
      
      public var bt_drop:SimpleButton;
      
      public var dragDrop:DragDropItem;
      
      public function DropKDO()
      {
         super();
         this.addEventListener(Event.ADDED,this.init,false,0,true);
      }
      
      public function init(param1:Event) : *
      {
         if(stage)
         {
            this.removeEventListener(Event.ADDED,this.init,false);
            parent.width = 150;
            parent.height = 100;
            Object(parent).redraw();
            parent.addEventListener("onKill",this.onKill,false,0,true);
            this.vs_bbl.maxValue = 1000;
            this.vs_bbl.minValue = 10;
            this.vs_bbl.value = 50;
            this.vs_bbl.resolution = this.vs_bbl.step = 10;
            this.bt_drop.addEventListener(MouseEvent.MOUSE_DOWN,this.iconDropDown,false,0,true);
            this.dragDrop = GlobalConsoleProperties.console.dragDrop.addItem();
         }
      }
      
      public function iconDropMove(param1:Event = null) : *
      {
         var _loc2_:Array = this.dragDrop.testDrag();
         var _loc3_:MovieClip = GlobalProperties.cursor.addCursor(this,null);
         _loc3_.gotoAndStop(!!_loc2_.length ? "KDO" : "KDO_FORBIDEN");
      }
      
      public function iconDropUp(param1:Event) : *
      {
         var _loc3_:* = undefined;
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
                  _loc3_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,20);
                  _loc3_.bitWriteUnsignedInt(GlobalProperties.BIT_MAP_ID,_loc2_[0].data.CAMERA.mapId);
                  _loc3_.bitWriteUnsignedInt(GlobalProperties.BIT_SERVER_ID,_loc2_[0].data.CAMERA.serverId);
                  _loc3_.bitWriteUnsignedInt(16,this.vs_bbl.value);
                  GlobalConsoleProperties.console.blablaland.send(_loc3_);
               }
            }
         }
      }
      
      public function iconDropDown(param1:Event) : *
      {
         this.dragDrop.data.TYPE = "KDO";
         GlobalProperties.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.iconDropMove,false,0,true);
         GlobalProperties.stage.addEventListener(MouseEvent.MOUSE_UP,this.iconDropUp,false,0,true);
         this.iconDropMove();
      }
      
      public function onKill(param1:Event) : *
      {
         GlobalConsoleProperties.console.dragDrop.removeItem(this.dragDrop);
      }
   }
}
