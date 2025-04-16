package consolebbl
{
   import bbl.BblLogged;
   import bbl.GlobalProperties;
   import chatbbl.*;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.TextEvent;
   import flash.net.SharedObject;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.utils.Timer;
   import net.ParsedMessageEvent;
   import net.SocketMessage;
   import ui.Cursor;
   import ui.DragDrop;
   import ui.Popup;
   import ui.PopupItemMsgbox;
   import ui.PopupItemWindow;
   
   public class ConsoleInit extends ConsoleLoader
   {
       
      
      public var dragDrop:DragDrop;
      
      public var winPopup:Popup;
      
      public var msgPopup:Popup;
      
      public var blablaland:BblLogged;
      
      public var session:String;
      
      public var keepAlive:Timer;
      
      public var isConsole:Boolean;
      
      private var winLog:Object;
      
      public function ConsoleInit()
      {
         super();
         this.isConsole = true;
         GlobalProperties.stage = stage;
         GlobalProperties.mainApplication = this;
         GlobalConsoleProperties.console = Console(this);
         this.keepAlive = new Timer(GlobalProperties.keepAliveDelay);
         this.keepAlive.addEventListener("timer",this.keepAliveEvent,false,0,true);
         stage.scaleMode = "noScale";
         stage.align = "TL";
         this.dragDrop = new DragDrop();
         this.winPopup = new Popup();
         this.msgPopup = new Popup();
         this.msgPopup.linkPopup(this.winPopup);
         this.winPopup.linkPopup(this.msgPopup);
         this.winPopup.itemClass = PopupItemWindow;
         this.msgPopup.itemClass = PopupItemMsgbox;
         addChild(this.winPopup);
         addChild(this.msgPopup);
         this.blablaland = new BblLogged();
         this.blablaland.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onBblEvent);
         this.blablaland.addEventListener(IOErrorEvent.IO_ERROR,this.onBblEvent);
         this.blablaland.addEventListener(Event.CLOSE,this.onBblEvent);
         this.blablaland.addEventListener("onReady",this.onBblReady);
         this.blablaland.addEventListener("onIdentity",this.onIdentity,false,0,true);
         this.blablaland.addEventListener("onFatalAlert",this.onFatalAlert,false,0,true);
         this.blablaland.addEventListener("onParsedMessage",this.onInitMessage,false,0,true);
         if(stage.loaderInfo.parameters.CACHE_VERSION)
         {
            this.blablaland.cacheVersion = Number(stage.loaderInfo.parameters.CACHE_VERSION);
         }
         stage.addEventListener("resize",this.onResize,false,0,true);
         GlobalProperties.cursor = new Cursor();
         addChild(GlobalProperties.cursor);
      }
      
      public function close() : *
      {
         this.keepAlive.stop();
         this.msgPopup.killAll();
         this.winPopup.killAll();
         this.blablaland.close();
         gotoAndStop("vide");
         this.onQuit();
      }
      
      public function onResize(param1:Event = null) : *
      {
         this.winPopup.areaLimit.right = this.msgPopup.areaLimit.right = stage.stageWidth;
         this.winPopup.areaLimit.bottom = this.msgPopup.areaLimit.bottom = stage.stageHeight;
         this.winPopup.verifiPosition();
         this.msgPopup.verifiPosition();
      }
      
      override public function onExternalReady(param1:Event) : *
      {
         this.onResize();
         super.onExternalReady(param1);
         GlobalProperties.cursor.source = Class(externalLoader.getClass("CursorContent"));
         this.init();
      }
      
      public function init() : *
      {
         this.blablaland.init();
      }
      
      public function addTextAlert(param1:String, param2:Boolean = false) : *
      {
      }
      
      public function onFatalAlert(param1:TextEvent = null) : *
      {
         this.close();
         this.msgPopup.open({
            "APP":PopupMessage,
            "TITLE":"Evenement serveur"
         },{
            "MSG":param1.text,
            "ACTION":"OK"
         });
      }
      
      public function onBblEvent(param1:Event) : *
      {
         this.close();
         this.msgPopup.open({
            "APP":PopupMessage,
            "TITLE":"Evenement socket"
         },{
            "MSG":"Vous recevez une évenement socket entrainant la fermeture du systeme.\nType : " + param1.type,
            "ACTION":"OK"
         });
      }
      
      public function onBblReady(param1:Event) : *
      {
         var _loc2_:SharedObject = SharedObject.getLocal("console_start");
         this.winLog = this.msgPopup.open({
            "APP":PopupMessage,
            "TITLE":"Identification"
         },{
            "EVT":param1,
            "LOGIN":_loc2_.data.session,
            "ACTION":"ASKLOG"
         });
         this.winLog.addEventListener("onEvent",this.logEvent,false,0,true);
         gotoAndStop("vide");
      }
      
      public function logEvent(param1:Event) : *
      {
         param1.currentTarget.visible = false;
         var _loc2_:SharedObject = SharedObject.getLocal("console_start");
         _loc2_.data.session = this.winLog.content.login.text;
         var _loc3_:URLVariables = new URLVariables();
         _loc3_.LOGIN = this.winLog.content.login.text;
         _loc3_.PASS = this.winLog.content.pass.text;
         _loc3_.CACHE = new Date().getTime();
         var _loc4_:URLRequest;
         (_loc4_ = new URLRequest(GlobalProperties.scriptAdr + "console/getsession.php")).method = "POST";
         _loc4_.data = _loc3_;
         var _loc5_:URLLoader;
         (_loc5_ = new URLLoader()).dataFormat = "variables";
         _loc5_.load(_loc4_);
         _loc5_.addEventListener("complete",this.initOnComplete,false,0,true);
      }
      
      public function initOnComplete(param1:Event) : *
      {
         param1.currentTarget.removeEventListener("complete",this.initOnComplete,false);
         if(param1.currentTarget.data.RESULT == 1)
         {
            this.session = param1.currentTarget.data.SESSION;
            this.keepAlive.start();
            this.blablaland.login(this.session);
         }
         else
         {
            this.winLog.visible = true;
            this.msgPopup.open({
               "APP":PopupMessage,
               "TITLE":"Erreur"
            },{
               "MSG":"Mauvais login ou mot de passe.\nAccès refusé !",
               "ACTION":"OK"
            });
         }
      }
      
      public function activTimerEvent() : *
      {
         var _loc1_:Object = this.msgPopup.open({
            "APP":PopupMessage,
            "TITLE":"Activité !"
         },{
            "MSG":"Popup d\'activité... Ce popup vous informe que vous ne gagnerez plus d\'XP tant que vous n\'aurez pas clické sur OK.",
            "ACTION":"OK"
         });
         _loc1_.addEventListener("onEvent",this.onActivPopEvent,false,0,true);
      }
      
      public function onActivPopEvent(param1:Event = null) : *
      {
         var _loc2_:* = new SocketMessage();
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,4);
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,17);
         this.blablaland.send(_loc2_);
      }
      
      public function keepAliveEvent(param1:Event) : *
      {
         var _loc2_:URLVariables = new URLVariables();
         _loc2_.SESSION = this.session;
         _loc2_.CACHE = new Date().getTime();
         var _loc3_:URLRequest = new URLRequest(GlobalProperties.scriptAdr + "console/keepalive.php");
         _loc3_.method = "POST";
         _loc3_.data = _loc2_;
         var _loc4_:URLLoader;
         (_loc4_ = new URLLoader()).dataFormat = "variables";
         _loc4_.load(_loc3_);
         _loc4_.addEventListener("complete",this.onKeepAlive,false,0,true);
      }
      
      public function onKeepAlive(param1:Event) : *
      {
         if(param1.currentTarget.data.RESULT == "0")
         {
            this.close();
            this.msgPopup.open({
               "APP":PopupMessage,
               "TITLE":"Security !!"
            },{
               "MSG":"Votre session ne semble plus etre valide.\nConnection interrompue !",
               "ACTION":"OK"
            });
         }
      }
      
      public function onQualityChange(param1:Event) : *
      {
         var _loc2_:uint = 0;
         _loc2_ = 0;
         while(_loc2_ < this.winPopup.itemList.length)
         {
            this.winPopup.itemList[_loc2_].redraw();
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.msgPopup.itemList.length)
         {
            this.msgPopup.itemList[_loc2_].redraw();
            _loc2_++;
         }
      }
      
      public function onIdentity(param1:Event) : *
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:* = undefined;
         var _loc5_:Object = null;
         if(this.blablaland.uid)
         {
            GlobalProperties.loadSharedData("console_" + this.blablaland.uid);
            GlobalProperties.sharedObject.data.QUALITY.quality.addEventListener("onChanged",this.onQualityChange,false,0,true);
            if(GlobalProperties.sharedObject.data.POPUP.FONT_COLOR !== undefined)
            {
               stage.color = GlobalProperties.sharedObject.data.POPUP.FONT_COLOR;
            }
            _loc2_ = uint(GlobalProperties.sharedObject.data.POPUP.SECRETCHAT);
            _loc3_ = uint(GlobalProperties.sharedObject.data.POPUP.SECRETPOURSUITE);
            if(!_loc2_)
            {
               _loc2_ = 0;
            }
            if(!_loc3_)
            {
               _loc3_ = 0;
            }
            (_loc4_ = new SocketMessage()).bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,2);
            _loc4_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,3);
            _loc4_.bitWriteUnsignedInt(GlobalProperties.BIT_GRADE,_loc2_);
            _loc4_.bitWriteUnsignedInt(GlobalProperties.BIT_GRADE,_loc3_);
            if(Boolean(_loc2_) || Boolean(_loc3_))
            {
               (_loc5_ = this.msgPopup.open({
                  "APP":PopupMessage,
                  "TITLE":"Rappel"
               },{
                  "MSG":"Tu es actuellement en mode secret :\nChat : " + _loc2_ + "\nPoursuite : " + _loc3_ + "\nChanger ?",
                  "ACTION":"YESNO"
               })).addEventListener("onEvent",this.SecretChangeEvt,false,0,true);
            }
            this.blablaland.send(_loc4_);
         }
         else
         {
            this.msgPopup.open({
               "APP":PopupMessage,
               "TITLE":"Erreur"
            },{
               "MSG":"Erreur d\'identification.\nAccès refusé !",
               "ACTION":"OK"
            });
            this.winLog.visible = true;
         }
      }
      
      public function SecretChangeEvt(param1:Event) : *
      {
         if(param1.currentTarget.data.RES)
         {
            GlobalConsoleProperties.console.winPopup.open({
               "APP":SecretManager,
               "ID":"Secret",
               "TITLE":"Secret.."
            });
         }
      }
      
      public function onInitMessage(param1:ParsedMessageEvent) : *
      {
         var _loc2_:SocketMessage = null;
         var _loc3_:uint = 0;
         if(param1.evtType == 2 && param1.evtStype == 3)
         {
            _loc2_ = param1.getMessage();
            _loc3_ = _loc2_.bitReadUnsignedInt(GlobalProperties.BIT_ERROR_ID);
            if(_loc3_ == 0)
            {
               this.winLog.close();
               this.onStart();
            }
            else
            {
               this.blablaland.close();
               gotoAndStop("vide");
               this.msgPopup.open({
                  "APP":PopupMessage,
                  "TITLE":"Erreur"
               },{
                  "MSG":"Accès refusé ! Erreur " + _loc3_ + "",
                  "ACTION":"OK"
               });
            }
         }
         else if(param1.evtType == 6 && param1.evtStype == 11)
         {
            this.activTimerEvent();
         }
      }
      
      public function onStart() : *
      {
         if(GlobalProperties.serverTime > 1733562000000 && GlobalProperties.serverTime < 1735729200000)
         {
            GlobalProperties.noelFx.GB = GlobalProperties;
            GlobalProperties.noelFx.init();
         }
      }
      
      public function onQuit() : *
      {
      }
      
      public function onExternalFileLoaded(param1:int, param2:int, param3:uint) : *
      {
         var _loc5_:* = new SocketMessage();
         _loc5_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,1);
         _loc5_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,16);
         _loc5_.bitWriteUnsignedInt(4,param1);
         _loc5_.bitWriteUnsignedInt(16,param2);
         _loc5_.bitWriteUnsignedInt(32,param3);
         this.blablaland.send(_loc5_);
      }
   }
}
