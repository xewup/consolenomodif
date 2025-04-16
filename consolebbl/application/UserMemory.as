package consolebbl.application
{
   import bbl.GlobalProperties;
   import bbl.Tracker;
   import consolebbl.GlobalConsoleProperties;
   import flash.display.MovieClip;
   import flash.events.Event;
   import ui.DragDropItem;
   import ui.List;
   import ui.ListGraphicEvent;
   import ui.ListTreeNode;
   
   [Embed(source="/_assets/assets.swf", symbol="consolebbl.application.UserMemory")]
   public class UserMemory extends MovieClip
   {
       
      
      public var liste:List;
      
      public var dragDrop:DragDropItem;
      
      public var rectangle:MovieClip;
      
      public function UserMemory()
      {
         super();
         this.addEventListener(Event.ADDED,this.init,false,0,true);
      }
      
      public function init(param1:Event) : *
      {
         if(stage)
         {
            Object(parent).resizer.visible = true;
            this.removeEventListener(Event.ADDED,this.init,false);
            parent.height = !!GlobalProperties.sharedObject.data.POPUP.USERMEMORY_H ? Number(GlobalProperties.sharedObject.data.POPUP.USERMEMORY_H) : 180;
            parent.addEventListener("onKill",this.onKill,false,0,true);
            parent.addEventListener("onResized",this.onResized,false,0,true);
            this.liste.addEventListener("onClick",this.onListClick,false,0,true);
            this.liste.addEventListener("onIconClick",this.onListIconClick,false,0,true);
            this.liste.size = 0;
            this.dragDrop = GlobalConsoleProperties.console.dragDrop.addItem();
            this.dragDrop.addEventListener("onTestDrag",this.onTestDrag,false,0,true);
            this.dragDrop.addEventListener("onAdd",this.onAdd,false,0,true);
            this.dragDrop.targetSprite = this;
            this.onResized();
            Object(parent).redraw();
         }
      }
      
      public function onListIconClick(param1:ListGraphicEvent) : *
      {
         this.liste.node.removeChild(param1.graphic.node);
         var _loc2_:uint = 0;
         while(_loc2_ < param1.graphic.node.data.TLIST.length)
         {
            GlobalConsoleProperties.console.blablaland.unRegisterTracker(param1.graphic.node.data.TLIST[_loc2_]);
            _loc2_++;
         }
         this.liste.redraw();
      }
      
      public function onListClick(param1:ListGraphicEvent) : *
      {
         var _loc2_:String = null;
         if(param1.graphic.node.data.UID)
         {
            _loc2_ = "track_UID_" + param1.graphic.node.data.UID;
         }
         else
         {
            _loc2_ = "track_PID_" + param1.graphic.node.data.PID;
         }
         var _loc3_:Object = new Object();
         _loc3_.IP = param1.graphic.node.data.IP;
         _loc3_.PID = param1.graphic.node.data.PID;
         _loc3_.UID = param1.graphic.node.data.UID;
         _loc3_.PSEUDO = param1.graphic.node.data.PSEUDO;
         GlobalConsoleProperties.console.winPopup.open({
            "APP":AffUserTracker,
            "ID":_loc2_,
            "TITLE":"Poursuite : " + param1.graphic.node.data.PSEUDO
         },_loc3_);
      }
      
      public function onAdd(param1:Event) : *
      {
         var _loc3_:uint = 0;
         var _loc4_:ListTreeNode = null;
         var _loc5_:Tracker = null;
         var _loc6_:ListTreeNode = null;
         var _loc2_:Boolean = false;
         _loc3_ = 0;
         while(_loc3_ < this.liste.node.childNode.length)
         {
            if((_loc4_ = this.liste.node.childNode[_loc3_]).data.UID == this.dragDrop.system.dragger.data.UID && _loc4_.data.PID == this.dragDrop.system.dragger.data.PID && _loc4_.data.IP == this.dragDrop.system.dragger.data.IP && _loc4_.data.PSEUDO == this.dragDrop.system.dragger.data.PSEUDO)
            {
               _loc2_ = true;
               break;
            }
            _loc3_++;
         }
         if(_loc2_)
         {
            GlobalConsoleProperties.console.msgPopup.open({
               "APP":PopupMessage,
               "TITLE":"Attention.."
            },{
               "MSG":"Ce blablateur est deja surveillé !!",
               "ACTION":"OK"
            });
         }
         else
         {
            (_loc6_ = ListTreeNode(this.liste.node.addChild())).data.UID = this.dragDrop.system.dragger.data.UID;
            _loc6_.data.PID = this.dragDrop.system.dragger.data.PID;
            _loc6_.data.IP = this.dragDrop.system.dragger.data.IP;
            _loc6_.data.PSEUDO = this.dragDrop.system.dragger.data.PSEUDO;
            _loc6_.data.TLIST = new Array();
            _loc6_.icon = "remove";
            if(_loc6_.data.UID)
            {
               _loc5_ = new Tracker(0,_loc6_.data.UID,0,true,true);
               _loc6_.data.TLIST.push(_loc5_);
               _loc6_.data.T_UID = _loc5_;
            }
            else if(_loc6_.data.PID)
            {
               _loc5_ = new Tracker(0,0,_loc6_.data.PID,true,true);
               _loc6_.data.TLIST.push(_loc5_);
               _loc6_.data.T_PID = _loc5_;
            }
            if(_loc6_.data.IP)
            {
               _loc5_ = new Tracker(_loc6_.data.IP);
               _loc6_.data.TLIST.push(_loc5_);
               _loc6_.data.T_IP = _loc5_;
            }
            _loc3_ = 0;
            while(_loc3_ < _loc6_.data.TLIST.length)
            {
               _loc6_.data.TLIST[_loc3_].addEventListener("onChanged",this.trackerEvent,false,0,true);
               GlobalConsoleProperties.console.blablaland.registerTracker(_loc6_.data.TLIST[_loc3_]);
               _loc3_++;
            }
            this.liste.redraw();
         }
      }
      
      public function trackerEvent(param1:Event) : *
      {
         var _loc3_:ListTreeNode = null;
         var _loc4_:String = null;
         var _loc5_:Tracker = null;
         var _loc6_:* = null;
         var _loc7_:uint = 0;
         var _loc2_:* = 0;
         while(_loc2_ < this.liste.node.childNode.length)
         {
            _loc3_ = this.liste.node.childNode[_loc2_];
            if(_loc3_.data.T_UID == param1.currentTarget || _loc3_.data.T_PID == param1.currentTarget || _loc3_.data.T_IP == param1.currentTarget)
            {
               _loc4_ = "";
               _loc5_ = !!_loc3_.data.T_UID ? _loc3_.data.T_UID : (!!_loc3_.data.T_PID ? _loc3_.data.T_PID : null);
               _loc6_ = "";
               if(_loc5_.userList.length)
               {
                  _loc7_ = 0;
                  while(_loc7_ < GlobalConsoleProperties.console.blablaland.mapList.length)
                  {
                     if(GlobalConsoleProperties.console.blablaland.mapList[_loc7_].id == _loc5_.userList[0].mapId)
                     {
                        _loc6_ = " (" + GlobalConsoleProperties.console.blablaland.mapList[_loc7_].nom + ")";
                        break;
                     }
                     _loc7_++;
                  }
               }
               _loc4_ += "<font color=\'#" + (!!_loc5_.userList.length ? "FF0000" : "000000") + "\'>[" + _loc3_.data.PSEUDO + _loc6_ + "]</font>";
               if(_loc3_.data.T_IP)
               {
                  _loc4_ += "<font color=\'#" + (!!_loc3_.data.T_IP.userList.length ? "FF0000" : "000000") + "\'>[" + _loc3_.data.T_IP.userList.length + "xIP]</font>";
               }
               _loc3_.text = _loc4_;
            }
            _loc2_++;
         }
         this.liste.redraw();
      }
      
      public function onTestDrag(param1:Event) : *
      {
         this.dragDrop.isTarget = this.dragDrop.system.dragger.data.TYPE == "USER" && this.dragDrop.overTarget;
      }
      
      public function onResized(param1:Event = null) : *
      {
         parent.width = 220;
         parent.height = Math.max(parent.height,100);
         parent.height = Math.min(parent.height,400);
         this.redrawSize();
      }
      
      public function redrawSize() : *
      {
         GlobalProperties.sharedObject.data.POPUP.USERMEMORY_H = parent.height;
         var _loc1_:uint = this.liste.size;
         this.liste.size = Math.floor((parent.height - 4) / this.liste.graphicHeight);
         if(_loc1_ != this.liste.size)
         {
            this.liste.redraw();
         }
         this.rectangle.width = parent.width;
         this.rectangle.height = parent.height;
      }
      
      public function onKill(param1:Event) : *
      {
         var _loc3_:* = undefined;
         this.dragDrop.removeEventListener("onTestDrag",this.onTestDrag,false);
         this.dragDrop.removeEventListener("onAdd",this.onAdd,false);
         GlobalConsoleProperties.console.dragDrop.removeItem(this.dragDrop);
         var _loc2_:* = 0;
         while(_loc2_ < this.liste.node.childNode.length)
         {
            _loc3_ = 0;
            while(_loc3_ < this.liste.node.childNode[_loc2_].data.TLIST.length)
            {
               GlobalConsoleProperties.console.blablaland.unRegisterTracker(this.liste.node.childNode[_loc2_].data.TLIST[_loc3_]);
               _loc3_++;
            }
            _loc2_++;
         }
      }
   }
}
