package consolebbl.application
{
   import bbl.CameraMapControl;
   import bbl.GlobalProperties;
   import bbl.InterfaceEvent;
   import bbl.Tracker;
   import chatbbl.*;
   import consolebbl.GlobalConsoleProperties;
   import consolebbl.Interface;
   import engine.DDpoint;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.geom.Point;
   import fx.FxLoader;
   import map.MapSelector;
   import net.ParsedMessageEvent;
   import net.SocketMessage;
   import perso.User;
   import perso.WalkerPhysicEvent;
   import ui.DragDropItem;
   import ui.PopupItem;
   
   [Embed(source="/_assets/assets.swf", symbol="consolebbl.application.FreeCamera")]
   public class FreeCamera extends MovieClip
   {
       
      
      public var camInterface:Interface;
      
      public var dragDrop:DragDropItem;
      
      public var rectangle:MovieClip;
      
      public var camera:CameraMapControl;
      
      private var screenWidth:Number;
      
      private var screenHeight:Number;
      
      private var contentHeight:Number;
      
      private var tracker:Tracker;
      
      private var userTarget:MovieClip;
      
      private var userTracked:User;
      
      public var fxHalloween:FxLoader;
      
      public var fxHalloweenMng:Object;
      
      public function FreeCamera()
      {
         super();
         this.addEventListener(Event.ADDED,this.init,false,0,true);
         this.camera = null;
         this.screenWidth = 950;
         this.screenHeight = 425;
         this.contentHeight = 140;
         this.tracker = null;
      }
      
      public function init(param1:Event) : *
      {
         if(stage)
         {
            this.removeEventListener(Event.ADDED,this.init,false);
            Object(parent).resizer.visible = true;
            parent.width = this.screenWidth / 2;
            parent.height = this.screenHeight / 2 + this.contentHeight;
            parent.addEventListener("onKill",this.onKill,false,0,true);
            parent.addEventListener("onResized",this.onResized,false,0,true);
            this.userTracked = null;
            this.userTarget = new UserTarget();
            this.userTarget.mouseChildren = false;
            this.userTarget.mouseEnabled = false;
            this.userTarget.addEventListener("enterFrame",this.targetEnterFrame,false,0,true);
            this.dragDrop = GlobalConsoleProperties.console.dragDrop.addItem();
            this.dragDrop.addEventListener("onTestDrag",this.onTestDrag,false,0,true);
            this.dragDrop.addEventListener("onSetCamera",this.onSetCamera,false,0,true);
            this.dragDrop.addEventListener("onAdd",this.onAdd,false,0,true);
            this.dragDrop.targetSprite = this;
            addEventListener(MouseEvent.MOUSE_DOWN,this.rectangleDownEvent,false,0,true);
            this.onResized();
            GlobalConsoleProperties.console.blablaland.addEventListener("onNewCamera",this.onGetCamera,false,0,true);
            GlobalConsoleProperties.console.blablaland.addEventListener("onWorldCounterUpdate",this.onWorldCounterUpdate,false,0,true);
            GlobalConsoleProperties.console.blablaland.createNewCamera();
            this.camInterface.addEventListener("onSelectUser",this.onInterfaceSelectUser,false,0,true);
            this.camInterface.addEventListener("onSendMessage",this.onInterfaceSendMessage,false,0,true);
            this.camInterface.addEventListener("btChangeMap",this.btOnChangeMap,false,0,true);
            this.camInterface.addEventListener("btTracker",this.btOnTracker,false,0,true);
            this.camInterface.txt_tracker.text = "{NO TRACK}";
         }
      }
      
      public function rectangleUpEvent(param1:Event) : *
      {
         removeEventListener("enterFrame",this.enterframe,false);
         GlobalProperties.stage.removeEventListener(MouseEvent.MOUSE_UP,this.rectangleUpEvent,false);
      }
      
      public function rectangleDownEvent(param1:Event) : *
      {
         addEventListener("enterFrame",this.enterframe,false,0,true);
         GlobalProperties.stage.addEventListener(MouseEvent.MOUSE_UP,this.rectangleUpEvent,false,0,true);
      }
      
      public function targetEnterFrame(param1:Event) : *
      {
         var _loc2_:Point = null;
         if(this.camera)
         {
            if(!this.userTarget.parent && this.userTracked && this.camera.currentMap)
            {
               this.camera.addChild(this.userTarget);
            }
            else if((!this.userTracked || !this.camera.currentMap) && this.userTarget.parent)
            {
               this.camera.removeChild(this.userTarget);
            }
            if(this.userTarget.parent)
            {
               if(this.userTracked.parent)
               {
                  _loc2_ = new Point(this.userTracked.x,this.userTracked.y);
                  this.userTracked.parent.localToGlobal(_loc2_);
                  this.camera.globalToLocal(_loc2_);
                  if(this.userTarget.x != _loc2_.x || this.userTarget.y != _loc2_.y)
                  {
                     this.userTarget.x = _loc2_.x;
                     this.userTarget.y = _loc2_.y;
                  }
                  if(this.userTarget.scaleX != this.userTracked.skinGraphicHeight / 10)
                  {
                     this.userTarget.scaleX = this.userTarget.scaleY = this.userTracked.skinGraphicHeight / 10;
                  }
               }
            }
         }
      }
      
      public function enterframe(param1:Event) : *
      {
         var _loc2_:uint = 20;
         if(this.camera)
         {
            if(this.camera.currentMap)
            {
               if(this.camera.screenWidth < this.camera.currentMap.mapWidth)
               {
                  if(this.mouseX >= 0 && this.mouseX <= _loc2_)
                  {
                     this.camera.scroller.scrollX(Math.max(this.camera.scroller.curScrollX - 0.05,0));
                  }
                  if(this.mouseX <= this.camera.scaleX * this.screenWidth && this.mouseX >= this.camera.scaleX * this.screenWidth - _loc2_)
                  {
                     this.camera.scroller.scrollX(Math.min(this.camera.scroller.curScrollX + 0.05,1));
                  }
               }
               if(this.camera.screenHeight < this.camera.currentMap.mapHeight)
               {
                  if(this.mouseY >= 0 && this.mouseY <= _loc2_)
                  {
                     this.camera.scroller.scrollY(Math.max(this.camera.scroller.curScrollY - 0.05,0));
                  }
                  if(this.mouseY <= this.camera.scaleY * this.screenHeight && this.mouseY >= this.camera.scaleY * this.screenHeight - _loc2_)
                  {
                     this.camera.scroller.scrollY(Math.min(this.camera.scroller.curScrollY + 0.05,1));
                  }
               }
            }
         }
      }
      
      public function onMapCountChange(param1:Event) : *
      {
         this.camInterface.mapCount = this.camera.userList.length;
      }
      
      public function onWorldCounterUpdate(param1:Event) : *
      {
         this.camInterface.worldCount = GlobalConsoleProperties.console.blablaland.worldCount;
         this.camInterface.universCount = GlobalConsoleProperties.console.blablaland.universCount;
      }
      
      public function onInterfaceSendMessage(param1:TextEvent) : *
      {
         var _loc2_:Object = null;
         if(this.camera.cameraReady)
         {
            if(this.camInterface.ch_allmap_conf.value)
            {
               _loc2_ = GlobalConsoleProperties.console.msgPopup.open({
                  "APP":PopupMessage,
                  "TITLE":"Confirmer :",
                  "DEPEND":this
               },{
                  "MSG":"Envoyer le message : \"" + param1.text + "\"",
                  "ACTION":"YESNO",
                  "EVT":param1
               });
               _loc2_.addEventListener("onEvent",this.confirmMessageEvent,false,0,true);
            }
            else
            {
               this.sendMessage(param1);
            }
         }
      }
      
      public function confirmMessageEvent(param1:Event) : *
      {
         if(param1.currentTarget.data.RES)
         {
            this.sendMessage(param1.currentTarget.data.EVT);
         }
      }
      
      public function sendMessage(param1:TextEvent) : *
      {
         var _loc2_:SocketMessage = null;
         if(this.camera.cameraReady)
         {
            _loc2_ = new SocketMessage();
            if(this.camInterface.ch_alluni.value && GlobalConsoleProperties.console.blablaland.grade < GlobalConsoleProperties.console.rulesDroitsMsgAllUni)
            {
               GlobalConsoleProperties.console.msgPopup.open({
                  "APP":PopupMessage,
                  "TITLE":"Action refusée",
                  "DEPEND":this
               },{
                  "MSG":"Vous n\'avez pas le grade necessaire pour envoyer à tous les univers.",
                  "ACTION":"OK"
               });
            }
            else if(this.camInterface.ch_map.value)
            {
               if(GlobalConsoleProperties.console.blablaland.grade >= GlobalConsoleProperties.console.rulesDroitsMsgMap)
               {
                  _loc2_ = new SocketMessage();
                  _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,4);
                  _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,9);
                  _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_MAP_ID,this.camera.mapId);
                  _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_SERVER_ID,this.camera.serverId);
                  _loc2_.bitWriteBoolean(false);
                  _loc2_.bitWriteString(param1.text);
                  _loc2_.bitWriteBoolean(this.camInterface.ch_alluni.value);
                  GlobalConsoleProperties.console.blablaland.send(_loc2_);
               }
               else
               {
                  GlobalConsoleProperties.console.msgPopup.open({
                     "APP":PopupMessage,
                     "TITLE":"Action refusée",
                     "DEPEND":this
                  },{
                     "MSG":"Vous n\'avez pas le grade necessaire pour cette action.",
                     "ACTION":"OK"
                  });
               }
            }
            else if(GlobalConsoleProperties.console.blablaland.grade >= GlobalConsoleProperties.console.rulesDroitsMsgAllMap)
            {
               _loc2_ = new SocketMessage();
               _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,4);
               _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,10);
               _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_SERVER_ID,this.camera.serverId);
               _loc2_.bitWriteBoolean(false);
               _loc2_.bitWriteString(param1.text);
               _loc2_.bitWriteBoolean(this.camInterface.ch_alluni.value);
               GlobalConsoleProperties.console.blablaland.send(_loc2_);
            }
            else
            {
               GlobalConsoleProperties.console.msgPopup.open({
                  "APP":PopupMessage,
                  "TITLE":"Action refusée",
                  "DEPEND":this
               },{
                  "MSG":"Vous n\'avez pas le grade necessaire pour cette action.",
                  "ACTION":"OK"
               });
            }
         }
      }
      
      public function onInterfaceSelectUser(param1:InterfaceEvent) : *
      {
         this.openAffUserTracker(param1.pid,param1.serverId);
      }
      
      public function onAddPerso(param1:Object) : *
      {
         this.removeTracker();
         if(param1.UID)
         {
            this.tracker = new Tracker(0,param1.UID);
         }
         else if(param1.PID)
         {
            this.tracker = new Tracker(0,0,param1.PID);
         }
         if(this.tracker)
         {
            this.tracker.mapInform = true;
            this.camInterface.txt_tracker.text = param1.PSEUDO;
            this.tracker.addEventListener("onChanged",this.onTrackerEvent,false,0,true);
            GlobalConsoleProperties.console.blablaland.registerTracker(this.tracker);
            this.lookForCameraTarget();
         }
      }
      
      public function lookForCameraTarget() : *
      {
         var _loc1_:Boolean = false;
         var _loc2_:User = null;
         if(this.camera)
         {
            _loc1_ = true;
            if(this.tracker && this.camera.cameraReady)
            {
               if(this.tracker.userList.length)
               {
                  _loc1_ = false;
                  _loc2_ = this.camera.getUserByPid(this.tracker.userList[0].pid);
                  if(_loc2_)
                  {
                     this.camera.cameraTarget = _loc2_.position;
                     this.userTracked = _loc2_;
                  }
               }
            }
            if(_loc1_)
            {
               this.userTracked = null;
               this.camera.cameraTarget = null;
            }
         }
      }
      
      public function selOptEvent(param1:Event) : *
      {
         var _loc2_:SocketMessage = null;
         if(param1.currentTarget.data.RESA)
         {
            this.onAddPerso(param1.currentTarget.data.DATA);
         }
         if(param1.currentTarget.data.RESB && this.camera)
         {
            if(this.camera.cameraReady)
            {
               _loc2_ = new SocketMessage();
               _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,4);
               _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,15);
               _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_USER_PID,param1.currentTarget.data.DATA.PID);
               _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_SERVER_ID,param1.currentTarget.data.DATA.SERVERID);
               _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_MAP_ID,this.camera.mapId);
               _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_SERVER_ID,this.camera.serverId);
               GlobalConsoleProperties.console.blablaland.send(_loc2_);
            }
         }
      }
      
      public function onAdd(param1:Event) : *
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:* = undefined;
         var _loc6_:PopupItem = null;
         if(this.camera)
         {
            _loc2_ = this.dragDrop.system.dragger.data.UID && this.dragDrop.system.dragger.data.UID == GlobalConsoleProperties.console.blablaland.uid;
            _loc3_ = GlobalConsoleProperties.console.blablaland.grade >= GlobalConsoleProperties.console.rulesDroitsTeleport && !_loc2_;
            _loc4_ = GlobalConsoleProperties.console.blablaland.grade >= GlobalConsoleProperties.console.rulesDroitsTeleportSelf && _loc2_;
            if(_loc3_ || _loc4_)
            {
               _loc5_ = GlobalConsoleProperties.console.blablaland.grade == 94;
               (_loc6_ = PopupItem(GlobalConsoleProperties.console.msgPopup.open({
                  "APP":PopupMessage,
                  "TITLE":"Action possible :",
                  "DEPEND":this
               },{
                  "MSG":"Choisissez si vous voulez traquer " + this.dragDrop.system.dragger.data.PSEUDO + " ou le téléporter ici.",
                  "VALA":"Le tracker",
                  "VALB":"Le téléporter",
                  "SWITCH":_loc5_,
                  "DATA":this.dragDrop.system.dragger.data,
                  "ACTION":"2OPTOKCANCEL"
               }))).addEventListener("onEvent",this.selOptEvent,false,0,true);
            }
            else
            {
               this.onAddPerso(this.dragDrop.system.dragger.data);
            }
         }
      }
      
      public function onTrackerEvent(param1:Event) : *
      {
         this.lookForCameraTarget();
         if(param1.currentTarget.userList.length && param1.currentTarget.trackerInstance.mapInformed)
         {
            this.camInterface.txt_tracker.text = param1.currentTarget.userList[0].pseudo;
            GlobalConsoleProperties.console.blablaland.moveCameraToMap(this.camera,param1.currentTarget.userList[0].id,0,param1.currentTarget.userList[0].serverId);
         }
      }
      
      public function onSetCamera(param1:Event) : *
      {
         if(this.camera)
         {
            this.removeTracker();
            GlobalConsoleProperties.console.blablaland.moveCameraToMap(this.camera,this.dragDrop.system.dragger.data.MAPID,0,this.dragDrop.system.dragger.data.SERVERID);
         }
      }
      
      public function onTestDrag(param1:Event) : *
      {
         this.dragDrop.isTarget = this.dragDrop.overTarget && (this.dragDrop.system.dragger.data.TYPE == "USER" || this.dragDrop.system.dragger.data.TYPE == "CAMERA" || this.dragDrop.system.dragger.data.TYPE == "KDO");
      }
      
      public function onResized(param1:Event = null) : *
      {
         var _loc4_:DDpoint = null;
         var _loc2_:* = this.screenWidth;
         if(this.camera)
         {
            if(this.camera.currentMap)
            {
               _loc2_ = Math.min(this.camera.currentMap.mapWidth,this.screenWidth);
            }
         }
         parent.width = Math.max(Math.min(parent.width,_loc2_),400);
         parent.height = Math.max(Math.min(parent.height,this.screenHeight + this.contentHeight),200 + this.contentHeight);
         var _loc3_:Number = Math.sqrt(parent.width * parent.width + Math.pow(parent.height - this.contentHeight,2));
         (_loc4_ = new DDpoint()).x = _loc2_;
         _loc4_.y = this.screenHeight;
         _loc4_.normalize();
         _loc4_.x *= _loc3_;
         _loc4_.y *= _loc3_;
         if(this.camera)
         {
            this.camera.scaleX = _loc4_.x / _loc2_;
            this.camera.scaleY = _loc4_.y / this.screenHeight;
         }
         parent.width = _loc4_.x;
         parent.height = _loc4_.y + this.contentHeight;
         this.camInterface.y = _loc4_.y + 2;
         this.rectangle.width = parent.width;
         this.rectangle.height = parent.height;
         if(!param1)
         {
            Object(parent).redraw();
         }
      }
      
      public function onGetCamera(param1:Event) : *
      {
         GlobalConsoleProperties.console.blablaland.removeEventListener("onNewCamera",this.onGetCamera,false);
         this.camera = GlobalConsoleProperties.console.blablaland.newCamera;
         this.dragDrop.data.CAMERA = this.camera;
         if(GlobalProperties.serverTime > 1728653400000 && GlobalProperties.serverTime < 1730530800000)
         {
            this.fxHalloween = new FxLoader();
            this.fxHalloween.addEventListener("onFxLoaded",this.halloweenLoaded);
            this.fxHalloween.loadFx(12);
         }
         else
         {
            this.camera.init();
         }
         if(Object(parent).data)
         {
            if(Object(parent).data.MAPID !== undefined)
            {
               GlobalConsoleProperties.console.blablaland.moveCameraToMap(this.camera,Object(parent).data.MAPID,0,Object(parent).data.SERVERID);
            }
         }
         this.camera.visible = false;
         this.camera.scaleX = 0.5;
         this.camera.scaleY = 0.5;
         this.camera.quality = GlobalProperties.sharedObject.data.QUALITY.quality;
         this.camera.userInterface = this.camInterface;
         addChild(this.camera);
         this.camera.addEventListener("onClickUser",this.onClickUser,false,0,true);
         this.camera.addEventListener("onCameraReady",this.onCameraEvent,false,0,true);
         this.camera.addEventListener("onUnloadMap",this.onCameraEvent,false,0,true);
         this.camera.addEventListener("onMapCountChange",this.onMapCountChange,false,0,true);
         this.onResized();
      }
      
      public function onMessage(param1:ParsedMessageEvent) : *
      {
         var _loc2_:SocketMessage = null;
         var _loc3_:uint = 0;
         var _loc4_:String = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:String = null;
         if(param1.evtType == 6)
         {
            if(param1.evtStype == 8)
            {
               _loc2_ = param1.getMessage();
               _loc3_ = _loc2_.bitReadUnsignedInt(16);
               if(_loc3_ == Object(parent).pid)
               {
                  param1.stopImmediatePropagation();
                  GlobalConsoleProperties.console.blablaland.removeEventListener("onParsedMessage",this.onMessage,false);
                  _loc4_ = _loc2_.bitReadString();
                  _loc5_ = _loc2_.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID);
                  _loc6_ = _loc2_.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID);
                  _loc7_ = _loc2_.bitReadUnsignedInt(32);
                  if(_loc6_)
                  {
                     _loc8_ = "track_UID_" + _loc6_;
                  }
                  else
                  {
                     _loc8_ = "track_PID_" + _loc5_;
                  }
                  GlobalConsoleProperties.console.winPopup.open({
                     "APP":AffUserTracker,
                     "ID":_loc8_,
                     "TITLE":"Poursuite : " + _loc4_
                  },{
                     "IP":_loc7_,
                     "UID":_loc6_,
                     "PID":_loc5_,
                     "PSEUDO":_loc4_
                  });
               }
            }
         }
      }
      
      public function openAffUserTracker(param1:uint, param2:uint) : *
      {
         GlobalConsoleProperties.console.blablaland.addEventListener("onParsedMessage",this.onMessage,false,0,true);
         var _loc3_:SocketMessage = new SocketMessage();
         _loc3_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,4);
         _loc3_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,11);
         _loc3_.bitWriteUnsignedInt(16,Object(parent).pid);
         _loc3_.bitWriteUnsignedInt(GlobalProperties.BIT_USER_PID,param1);
         _loc3_.bitWriteUnsignedInt(GlobalProperties.BIT_SERVER_ID,param2);
         GlobalConsoleProperties.console.blablaland.send(_loc3_);
      }
      
      public function onClickUser(param1:WalkerPhysicEvent) : *
      {
         this.openAffUserTracker(User(param1.walker).userPid,this.camera.serverId);
      }
      
      public function onCameraEvent(param1:Event) : *
      {
         if(!this.camera.currentMap && this.userTarget.parent)
         {
            this.userTarget.parent.removeChild(this.userTarget);
         }
         this.camera.visible = this.camera.cameraReady;
         this.onResized();
         if(this.camera.cameraReady)
         {
            this.lookForCameraTarget();
         }
      }
      
      public function removeTracker() : *
      {
         if(this.tracker)
         {
            GlobalConsoleProperties.console.blablaland.unRegisterTracker(this.tracker);
            this.tracker = null;
            this.userTracked = null;
         }
         this.camInterface.txt_tracker.text = "{NO TRACK}";
         this.lookForCameraTarget();
      }
      
      public function btOnTracker(param1:Event) : *
      {
         if(this.tracker)
         {
            this.removeTracker();
            GlobalConsoleProperties.console.msgPopup.open({
               "APP":PopupMessage,
               "TITLE":"Action."
            },{
               "MSG":"La camera ne surveille plus personne.",
               "ACTION":"OK"
            });
         }
         else
         {
            GlobalConsoleProperties.console.msgPopup.open({
               "APP":PopupMessage,
               "TITLE":"Action."
            },{
               "MSG":"La camera ne surveille actuellement personne.",
               "ACTION":"OK"
            });
         }
      }
      
      public function btOnChangeMap(param1:Event) : *
      {
         var _loc2_:* = new Object();
         if(this.camera)
         {
            _loc2_.CAMERA = this.camera;
            _loc2_.SERVERID = this.camera.serverId;
            _loc2_.SELECTION = [this.camera.mapId];
         }
         var _loc3_:Object = GlobalConsoleProperties.console.winPopup.open({
            "APP":MapSelector,
            "TITLE":"Choix de la map",
            "DEPEND":this
         },_loc2_);
         _loc3_.addEventListener("onChanged",this.onSelectMap,false,0,true);
      }
      
      public function onSelectMap(param1:Event) : *
      {
         if(param1.currentTarget.content.mapList.length)
         {
            param1.currentTarget.close();
            this.removeTracker();
            GlobalConsoleProperties.console.blablaland.moveCameraToMap(this.camera,param1.currentTarget.content.mapList[0].id,0,param1.currentTarget.content.serverId);
         }
      }
      
      public function onKill(param1:Event) : *
      {
         if(this.fxHalloweenMng)
         {
            this.fxHalloweenMng.dispose();
         }
         if(this.fxHalloween)
         {
            this.fxHalloween.removeEventListener("onFxLoaded",this.halloweenLoaded);
         }
         this.removeTracker();
         this.userTarget.removeEventListener("enterFrame",this.targetEnterFrame,false);
         GlobalConsoleProperties.console.blablaland.removeEventListener("onParsedMessage",this.onMessage,false);
         GlobalConsoleProperties.console.blablaland.removeEventListener("onNewCamera",this.onGetCamera,false);
         if(this.camera)
         {
            GlobalConsoleProperties.console.blablaland.removeCamera(this.camera);
         }
         this.dragDrop.removeEventListener("onTestDrag",this.onTestDrag,false);
         this.dragDrop.removeEventListener("onSetCamera",this.onSetCamera,false);
         GlobalConsoleProperties.console.dragDrop.removeItem(this.dragDrop);
      }
      
      public function halloweenLoaded(param1:Event) : *
      {
         fxHalloweenMng = new (new fxHalloween.lastLoad.classRef().getCameraManager())();
         this.fxHalloweenMng.camera = this.camera;
         this.fxHalloweenMng.init();
         this.camera.init();
      }
   }
}
