package consolebbl.application
{
   import bbl.BblTrackerUser;
   import bbl.GlobalProperties;
   import bbl.Tracker;
   import consolebbl.GlobalConsoleProperties;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.geom.ColorTransform;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.net.navigateToURL;
   import flash.text.StyleSheet;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import map.ServerMap;
   import net.SocketMessage;
   import perso.SkinManager;
   import ui.DragDropItem;
   import ui.List;
   import ui.ListGraphicEvent;
   import ui.ListTreeNode;
   import ui.RectArea;
   import ui.Scroll;
   import ui.ValueSelector;
   
   [Embed(source="/_assets/assets.swf", symbol="consolebbl.application.AffUserTracker")]
   public class AffUserTracker extends MovieClip
   {
       
      
      public var txt_pid:TextField;
      
      public var txt_uid:TextField;
      
      public var txt_ip:TextField;
      
      public var txt_motif:TextField;
      
      public var txt_discut:TextField;
      
      public var txt_cur_pseudo:TextField;
      
      public var txt_cur_login:TextField;
      
      public var txt_cur_ip:TextField;
      
      public var txt_cur_grade:TextField;
      
      public var txt_cur_map:TextField;
      
      public var txt_cur_univ:TextField;
      
      public var txt_info_cj:TextField;
      
      public var discut_scr:Scroll;
      
      public var akbList:List;
      
      public var bt_mp:Sprite;
      
      public var bt_kick:Sprite;
      
      public var bt_jail:Sprite;
      
      public var bt_profil:SimpleButton;
      
      public var bt_casier:SimpleButton;
      
      public var bt_grade:SimpleButton;
      
      public var bt_horaire:SimpleButton;
      
      public var bt_reset_pseudo:SimpleButton;
      
      public var bt_deroule:SimpleButton;
      
      public var ban_dure:ValueSelector;
      
      public var iconUser:Sprite;
      
      public var iconCamera:Sprite;
      
      public var dragDrop:DragDropItem;
      
      public var skin:SkinManager;
      
      public var tracker_uid:Tracker;
      
      public var tracker_pid:Tracker;
      
      public var tracker_ip:Tracker;
      
      public var trackerList:Array;
      
      public var highestTracker:Tracker;
      
      private var msgList:Array;
      
      private var insultronInit:Boolean;
      
      private var lastLogged:Boolean;
      
      private var lastInformed:Boolean;
      
      private var cj_rectArea:RectArea;
      
      public function AffUserTracker()
      {
         var _loc1_:* = undefined;
         super();
         this.lastLogged = false;
         this.lastInformed = false;
         this.insultronInit = false;
         this.trackerList = new Array();
         this.txt_pid.text = "{UNKNOWN}";
         this.txt_uid.text = "{UNKNOWN}";
         this.txt_ip.text = "{UNKNOWN}";
         this.msgList = new Array();
         this.txt_discut.htmlText = "";
         _loc1_ = new StyleSheet();
         _loc1_.setStyle(".insultron",{"color":"#00A000"});
         _loc1_.setStyle(".info",{"color":"#DD00FF"});
         _loc1_.setStyle(".user",{"color":"#0000FF"});
         _loc1_.setStyle(".user_mp",{"color":"#0000FF"});
         _loc1_.setStyle(".user_modo",{"color":"#FF0000"});
         _loc1_.setStyle(".user_modo_mp",{"color":"#00B000"});
         _loc1_.setStyle(".message_U",{"color":"#000000"});
         _loc1_.setStyle(".message_M",{"color":"#005EF0"});
         _loc1_.setStyle(".message_F",{"color":"#FE5EF0"});
         _loc1_.setStyle(".message_mp",{"color":"#505080"});
         _loc1_.setStyle(".message_modo",{"color":"#FF0000"});
         _loc1_.setStyle(".message_modo_mp",{"color":"#00B000"});
         this.cj_rectArea = new RectArea();
         addChildAt(this.cj_rectArea,0);
         this.cj_rectArea.x = 320;
         this.cj_rectArea.y = 5;
         this.cj_rectArea.areaWidth = 225;
         this.cj_rectArea.areaHeight = 250;
         this.cj_rectArea.scrollControlV = 2;
         this.cj_rectArea.scrollSpeed = 12;
         this.cj_rectArea.mouseBorderMarge = 50;
         this.txt_discut.styleSheet = _loc1_;
         this.discut_scr.size = this.txt_discut.height;
         this.discut_scr.addEventListener("onChanged",this.updateDiscutByScroll,false,0,true);
         this.discut_scr.value = 1;
         this.txt_ip.addEventListener(TextEvent.LINK,this.trackIpEvent,false,0,true);
         this.skin = new SkinManager();
         this.skin.x = 30;
         this.skin.y = 100;
         addChild(this.skin);
         this.addEventListener(Event.ADDED,this.popinit,false,0,true);
         this.ban_dure.maxValue = GlobalConsoleProperties.console.blablaland.grade >= 300 ? 999 : 360;
         this.ban_dure.minValue = 1;
         this.bt_casier.addEventListener("click",this.onCasierJudiciere,false,0,true);
         this.txt_cur_grade.mouseEnabled = false;
         this.dragDrop = GlobalConsoleProperties.console.dragDrop.addItem();
         this.dragDrop.addEventListener("onTestDrag",this.onTestDrag,false,0,true);
      }
      
      public function Rshift(param1:Number, param2:int) : Number
      {
         return Math.floor(param1 / Math.pow(2,param2));
      }
      
      public function onTestDrag(param1:Event) : *
      {
      }
      
      public function popinit(param1:Event) : *
      {
         var _loc2_:Object = null;
         var _loc3_:* = undefined;
         var _loc4_:SocketMessage = null;
         if(stage)
         {
            this.removeEventListener(Event.ADDED,this.popinit,false);
            parent.width = 320;
            parent.height = 280;
            Object(parent).redraw();
            parent.addEventListener("onKill",this.onKill,false,0,true);
            _loc2_ = Object(parent).data;
            if(_loc2_.UID)
            {
               this.tracker_uid = new Tracker(0,_loc2_.UID);
               this.trackerList.push(this.tracker_uid);
            }
            else if(_loc2_.PID)
            {
               this.tracker_pid = new Tracker(0,0,_loc2_.PID);
               this.trackerList.push(this.tracker_pid);
            }
            if(_loc2_.IP)
            {
               this.tracker_ip = new Tracker(_loc2_.IP);
               this.trackerList.push(this.tracker_ip);
            }
            if(_loc2_.PSEUDO)
            {
               this.dragDrop.data.PSEUDO = _loc2_.PSEUDO;
            }
            if(_loc2_.UID)
            {
               this.dragDrop.data.UID = _loc2_.UID;
            }
            if(_loc2_.IP)
            {
               this.dragDrop.data.IP = _loc2_.IP;
            }
            if(_loc2_.UID)
            {
               GlobalProperties.data["CONSOLEUSERCHAT_" + _loc2_.UID] = this;
               (_loc4_ = new SocketMessage()).bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,4);
               _loc4_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,30);
               _loc4_.bitWriteUnsignedInt(GlobalProperties.BIT_USER_ID,_loc2_.UID);
               GlobalConsoleProperties.console.blablaland.send(_loc4_);
            }
            this.update(null);
            this.highestTracker = !!this.tracker_uid ? this.tracker_uid : this.tracker_pid;
            if(this.highestTracker)
            {
               this.highestTracker.addEventListener("onTextEvent",this.highTrackerTextEvent,false,0,true);
               this.highestTracker.addEventListener("onChanged",this.highTrackerEvent,false,0,true);
               this.highestTracker.addEventListener("onMessage",this.highTrackerEvent,false,0,true);
            }
            _loc3_ = 0;
            while(_loc3_ < this.trackerList.length)
            {
               this.trackerList[_loc3_].addEventListener("onChanged",this.onTrackerEvt,false,0,true);
               if(this.highestTracker == this.trackerList[_loc3_])
               {
                  this.highestTracker.msgInform = true;
                  this.highestTracker.mapInform = true;
               }
               GlobalConsoleProperties.console.blablaland.registerTracker(this.trackerList[_loc3_]);
               _loc3_++;
            }
            GlobalConsoleProperties.console.addEventListener("onAKBChange",this.reloadAKBList,false,0,true);
            this.akbList.size = 6;
            this.akbList.graphicLink = ListGraphicShort;
            this.akbList.graphicWidth = 80;
            this.akbList.redraw();
            this.akbList.addEventListener("onClick",this.clickevt,false,0,true);
            this.reloadAKBList();
            this.reloadDroits();
            this.bt_deroule.addEventListener("click",this.derouleClickEvent,false);
            this.bt_mp.addEventListener("click",this.AKBClickEvent,false);
            this.bt_kick.addEventListener("click",this.AKBClickEvent,false);
            this.bt_jail.addEventListener("click",this.AKBClickEvent,false);
            this.bt_grade.addEventListener("click",this.onEditGrade,false);
            this.bt_reset_pseudo.addEventListener("click",this.onResetPseudo,false);
            this.bt_horaire.addEventListener("click",this.onShowHoraire,false);
            this.bt_profil.addEventListener("click",this.onShowProfil,false);
            this.iconUser.addEventListener(MouseEvent.MOUSE_DOWN,this.iconUserDown,false,0,true);
            this.iconUser.buttonMode = true;
            this.iconCamera.addEventListener(MouseEvent.MOUSE_DOWN,this.iconCameraDown,false,0,true);
            this.iconCamera.buttonMode = true;
            if(_loc2_.INSULTRON)
            {
               this.addMessageList(_loc2_.INSULTRON);
            }
         }
      }
      
      public function reLoadCj() : *
      {
         this.cj_rectArea.clearContent();
         var _loc1_:Object = Object(parent).data;
         var _loc2_:URLVariables = new URLVariables();
         _loc2_.SESSION = GlobalConsoleProperties.console.session;
         _loc2_.CACHE = new Date().getTime();
         _loc2_.UID = _loc1_.UID;
         var _loc3_:URLRequest = new URLRequest(GlobalProperties.scriptAdr + "console/getCasierJudiciere.php");
         _loc3_.method = "POST";
         _loc3_.data = _loc2_;
         var _loc4_:URLLoader;
         (_loc4_ = new URLLoader()).dataFormat = "variables";
         _loc4_.load(_loc3_);
         _loc4_.addEventListener("complete",this.onCJData,false,0,true);
      }
      
      public function onCJData(param1:Event) : *
      {
         var _loc5_:CJItem = null;
         var _loc6_:String = null;
         var _loc7_:Number = NaN;
         var _loc2_:Object = URLLoader(param1.currentTarget).data;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_.NB)
         {
            _loc5_ = new CJItem();
            this.cj_rectArea.content.addChild(_loc5_);
            _loc5_.y = _loc3_;
            _loc3_ += _loc5_.height + 1;
            _loc5_.fond.transform.colorTransform = new ColorTransform(0,0,0,1,200,200,200);
            _loc5_.txt_info.text = _loc2_["DATA_" + _loc4_];
            _loc5_.txt_dure.text = "--";
            if((_loc6_ = String(_loc2_["TYPE_" + _loc4_])) == "BAN" || _loc6_ == "FORUM_BAN")
            {
               _loc5_.fond.transform.colorTransform = new ColorTransform(0,0,0,1,238,109,109);
               _loc5_.txt_dure.text = _loc2_["NB_" + _loc4_];
            }
            else if(_loc6_ == "KICK")
            {
               _loc5_.fond.transform.colorTransform = new ColorTransform(0,0,0,1,231,157,67);
            }
            else if(_loc6_ == "INFO")
            {
               _loc5_.fond.transform.colorTransform = new ColorTransform(0,0,0,1,148,148,210);
            }
            else if(_loc6_ == "LIBERE")
            {
               _loc5_.fond.transform.colorTransform = new ColorTransform(0,0,0,1,85,217,132);
            }
            if((_loc7_ = (_loc7_ = GlobalProperties.serverTime - _loc2_["DATE_" + _loc4_] * 1000) / 1000 / 60) < 60)
            {
               _loc5_.txt_tm.text = Math.ceil(_loc7_) + " min";
            }
            else if(_loc7_ < 60 * 24)
            {
               _loc5_.txt_tm.text = Math.round(10 * _loc7_ / 60) / 10 + " heures";
            }
            else if(_loc7_ < 60 * 24 * 30)
            {
               _loc5_.txt_tm.text = Math.round(10 * _loc7_ / (60 * 24)) / 10 + " jours";
            }
            else if(_loc7_ < 60 * 24 * 30 * 12)
            {
               _loc5_.txt_tm.text = Math.round(10 * _loc7_ / (60 * 24 * 30)) / 10 + " mois";
            }
            else
            {
               _loc5_.txt_tm.text = Math.round(10 * _loc7_ / (60 * 24 * 30 * 12)) / 10 + " ans";
            }
            _loc4_++;
         }
         this.txt_info_cj.text = "Tot kick : " + _loc2_.TOTKICK + " || Tot ban : " + _loc2_.TOTBAN + " (" + Math.round(_loc2_.TOTBANDURE / 6) / 10 + " heures)";
         this.cj_rectArea.resetPosition();
         this.cj_rectArea.contentHeight = this.cj_rectArea.content.height;
         this.cj_rectArea.contentWidth = this.cj_rectArea.content.width;
      }
      
      public function derouleClickEvent(param1:Event) : *
      {
         if(parent.width > 400)
         {
            parent.width = 320;
         }
         else
         {
            parent.width = 555;
            if(Object(parent).data.UID)
            {
               this.reLoadCj();
            }
         }
         Object(parent).redraw();
      }
      
      public function iconUserMove(param1:Event = null) : *
      {
         var _loc2_:Array = this.dragDrop.testDrag();
         var _loc3_:MovieClip = GlobalProperties.cursor.addCursor(this,null);
         _loc3_.gotoAndStop(!!_loc2_.length ? "SKIN" : "SKIN_FORBIDEN");
      }
      
      public function iconUserUp(param1:Event) : *
      {
         var _loc3_:Object = null;
         GlobalProperties.stage.removeEventListener(MouseEvent.MOUSE_UP,this.iconUserUp,false);
         GlobalProperties.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.iconUserMove,false);
         GlobalProperties.cursor.removeCursor(this);
         var _loc2_:Array = this.dragDrop.testDrag();
         if(_loc2_.length)
         {
            _loc3_ = Object(parent).data;
            this.dragDrop.data.UID = _loc3_.UID;
            this.dragDrop.data.IP = _loc3_.IP;
            _loc2_[0].dispatchEvent(new Event("onAdd"));
         }
      }
      
      public function iconUserDown(param1:Event) : *
      {
         this.dragDrop.data.TYPE = "USER";
         GlobalProperties.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.iconUserMove,false,0,true);
         GlobalProperties.stage.addEventListener(MouseEvent.MOUSE_UP,this.iconUserUp,false,0,true);
         this.iconUserMove();
      }
      
      public function iconCameraMove(param1:Event = null) : *
      {
         var _loc2_:Array = this.dragDrop.testDrag();
         var _loc3_:MovieClip = GlobalProperties.cursor.addCursor(this,null);
         _loc3_.gotoAndStop(!!_loc2_.length ? "CAMERA" : "CAMERA_FORBIDEN");
      }
      
      public function iconCameraUp(param1:Event) : *
      {
         var _loc3_:Object = null;
         GlobalProperties.stage.removeEventListener(MouseEvent.MOUSE_UP,this.iconCameraUp,false);
         GlobalProperties.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.iconCameraMove,false);
         this.iconCamera.removeEventListener(MouseEvent.MOUSE_UP,this.iconCameraMove,false);
         GlobalProperties.cursor.removeCursor(this);
         var _loc2_:Array = this.dragDrop.testDrag();
         if(_loc2_.length)
         {
            _loc3_ = Object(parent).data;
            this.dragDrop.data.MAPID = !!this.highestTracker.userList.length ? this.highestTracker.userList[0].id : null;
            this.dragDrop.data.SERVERID = !!this.highestTracker.userList.length ? this.highestTracker.userList[0].serverId : null;
            _loc2_[0].dispatchEvent(new Event("onSetCamera"));
         }
         if(param1.currentTarget == this.iconCamera && Boolean(this.highestTracker.userList.length))
         {
            GlobalConsoleProperties.console.winPopup.open({
               "APP":FreeCamera,
               "TITLE":"Caméra.."
            },{
               "MAPID":this.highestTracker.userList[0].id,
               "SERVERID":this.highestTracker.userList[0].serverId
            });
         }
      }
      
      public function iconCameraDown(param1:Event) : *
      {
         this.dragDrop.data.TYPE = "CAMERA";
         this.iconCamera.addEventListener(MouseEvent.MOUSE_UP,this.iconCameraUp,false,0,true);
         GlobalProperties.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.iconCameraMove,false,0,true);
         GlobalProperties.stage.addEventListener(MouseEvent.MOUSE_UP,this.iconCameraUp,false,0,true);
         this.iconCameraMove();
      }
      
      public function onCasierJudiciere(param1:Event) : *
      {
         var _loc2_:Object = Object(parent).data;
         if(!_loc2_.UID)
         {
            GlobalConsoleProperties.console.msgPopup.open({
               "APP":PopupMessage,
               "TITLE":"Attention...",
               "DEPEND":this
            },{
               "MSG":"Les touristes n\'ont pas de casier judiciaire !",
               "ACTION":"OK"
            });
         }
         else if(GlobalConsoleProperties.console.blablaland.grade < GlobalConsoleProperties.console.rulesDroitsCasier && GlobalConsoleProperties.console.blablaland.grade < GlobalConsoleProperties.console.rulesDroitsCasierAdv)
         {
            GlobalConsoleProperties.console.msgPopup.open({
               "APP":PopupMessage,
               "TITLE":"Attention...",
               "DEPEND":this
            },{
               "MSG":"Vous n\'avez pas le grade necessaire pour acceder à cette section.",
               "ACTION":"OK"
            });
         }
         else
         {
            GlobalConsoleProperties.console.winPopup.open({
               "APP":CasierJudiciere,
               "ID":"casier_" + _loc2_.UID,
               "TITLE":"Casier judiciaire de : " + _loc2_.PSEUDO
            },{
               "UID":_loc2_.UID,
               "PSEUDO":_loc2_.PSEUDO
            });
         }
      }
      
      public function onResetPseudo(param1:Event) : *
      {
         var _loc3_:Object = null;
         var _loc2_:Object = Object(parent).data;
         if(!_loc2_.UID)
         {
            GlobalConsoleProperties.console.msgPopup.open({
               "APP":PopupMessage,
               "TITLE":"Attention...",
               "DEPEND":this
            },{
               "MSG":"Pas de pseudo pour les touristes.",
               "ACTION":"OK"
            });
         }
         else
         {
            _loc3_ = GlobalConsoleProperties.console.msgPopup.open({
               "APP":PopupMessage,
               "TITLE":"Confirmer :",
               "DEPEND":this
            },{
               "MSG":"Recopier son login sur son pseudo ?",
               "ACTION":"YESNO"
            });
            _loc3_.addEventListener("onEvent",this.onResetPseudoConfirm,false,0,true);
         }
      }
      
      public function onResetPseudoConfirm(param1:Event) : *
      {
         var _loc3_:URLVariables = null;
         var _loc4_:URLRequest = null;
         var _loc5_:URLLoader = null;
         var _loc2_:Object = Object(parent).data;
         if(param1.currentTarget.data.RES)
         {
            _loc3_ = new URLVariables();
            _loc3_.SESSION = GlobalConsoleProperties.console.session;
            _loc3_.CACHE = new Date().getTime();
            _loc3_.UID = _loc2_.UID;
            (_loc4_ = new URLRequest(GlobalProperties.scriptAdr + "console/updatePseudo.php")).method = "POST";
            _loc4_.data = _loc3_;
            (_loc5_ = new URLLoader()).dataFormat = "variables";
            _loc5_.load(_loc4_);
            _loc5_.addEventListener("complete",this.onResetPseudoMessage,false,0,true);
         }
      }
      
      public function onResetPseudoMessage(param1:Event) : *
      {
         param1.currentTarget.removeEventListener("complete",this.onResetPseudoMessage,false);
         if(param1.currentTarget.data.RESULT == 1)
         {
            GlobalConsoleProperties.console.msgPopup.open({
               "APP":PopupMessage,
               "TITLE":"Resultat :",
               "DEPEND":this
            },{
               "MSG":"Changement effectué et info enregistrée dans le casier.",
               "ACTION":"OK"
            });
         }
         else if(param1.currentTarget.data.RESULT == 3)
         {
            GlobalConsoleProperties.console.msgPopup.open({
               "APP":PopupMessage,
               "TITLE":"Resultat :",
               "DEPEND":this
            },{
               "MSG":"Le pseudo etait déja identique au login ou une erreur est survenue.",
               "ACTION":"OK"
            });
         }
         else if(param1.currentTarget.data.RESULT == 2)
         {
            GlobalConsoleProperties.console.msgPopup.open({
               "APP":PopupMessage,
               "TITLE":"Resultat :",
               "DEPEND":this
            },{
               "MSG":"Vous devez avoir un grade supérieur à lui pour cela.",
               "ACTION":"OK"
            });
         }
         else
         {
            GlobalConsoleProperties.console.msgPopup.open({
               "APP":PopupMessage,
               "TITLE":"Resultat :",
               "DEPEND":this
            },{
               "MSG":"Grade insuffisant.",
               "ACTION":"OK"
            });
         }
      }
      
      public function onShowHoraire(param1:Event) : *
      {
         var _loc2_:Object = Object(parent).data;
         if(!_loc2_.UID)
         {
            GlobalConsoleProperties.console.msgPopup.open({
               "APP":PopupMessage,
               "TITLE":"Attention...",
               "DEPEND":this
            },{
               "MSG":"Les touristes n\'ont pas d\'horaire mémorisées !",
               "ACTION":"OK"
            });
         }
         else
         {
            GlobalConsoleProperties.console.winPopup.open({
               "APP":WeekAccessViewer,
               "ID":"weekAccess_" + _loc2_.UID,
               "TITLE":"Horaires de connection de : " + _loc2_.PSEUDO
            },{"UID":_loc2_.UID});
         }
      }
      
      public function onShowProfil(param1:Event) : *
      {
         navigateToURL(new URLRequest("/site/membres.php?&border=0&p=" + Object(parent).data.UID),"_blank");
      }
      
      public function onEditGrade(param1:Event) : *
      {
         var _loc2_:Object = Object(parent).data;
         if(!_loc2_.UID)
         {
            GlobalConsoleProperties.console.msgPopup.open({
               "APP":PopupMessage,
               "TITLE":"Attention...",
               "DEPEND":this
            },{
               "MSG":"Les touristes n\'ont pas de grade !",
               "ACTION":"OK"
            });
         }
         else if(GlobalConsoleProperties.console.blablaland.grade < GlobalConsoleProperties.console.rulesGradeChange)
         {
            GlobalConsoleProperties.console.msgPopup.open({
               "APP":PopupMessage,
               "TITLE":"Attention...",
               "DEPEND":this
            },{
               "MSG":"Vous n\'avez pas le grade necessaire pour acceder à cette section.",
               "ACTION":"OK"
            });
         }
         else
         {
            GlobalConsoleProperties.console.winPopup.open({
               "APP":GradeUserEditor,
               "ID":"grade_" + _loc2_.UID,
               "DEPEND":this,
               "TITLE":"Grade de : " + _loc2_.PSEUDO
            },{
               "UID":_loc2_.UID,
               "PSEUDO":_loc2_.PSEUDO
            });
         }
      }
      
      public function reloadDroits(param1:Event = null) : *
      {
         this.ban_dure.enabled = GlobalConsoleProperties.console.blablaland.grade >= GlobalConsoleProperties.console.rulesAkbChange;
         this.txt_motif.backgroundColor = this.ban_dure.enabled ? 16777215 : 14540253;
         this.txt_motif.type = this.ban_dure.enabled ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
      }
      
      public function AKBClickEvent(param1:Event) : *
      {
         var _loc2_:SocketMessage = null;
         if(this.txt_motif.text.length)
         {
            if(this.highestTracker.userList.length)
            {
               if(param1.currentTarget == this.bt_mp)
               {
                  _loc2_ = new SocketMessage();
                  _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,4);
                  _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,6);
                  _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_USER_PID,this.highestTracker.userList[0].pid);
                  _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_SERVER_ID,this.highestTracker.userList[0].serverId);
                  _loc2_.bitWriteBoolean(false);
                  _loc2_.bitWriteString(this.txt_motif.text);
                  GlobalConsoleProperties.console.blablaland.send(_loc2_);
               }
               else if(param1.currentTarget == this.bt_kick)
               {
                  _loc2_ = new SocketMessage();
                  _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,4);
                  _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,7);
                  _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_USER_PID,this.highestTracker.userList[0].pid);
                  _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_SERVER_ID,this.highestTracker.userList[0].serverId);
                  _loc2_.bitWriteBoolean(false);
                  _loc2_.bitWriteString(this.txt_motif.text);
                  GlobalConsoleProperties.console.blablaland.send(_loc2_);
               }
            }
            else if(param1.currentTarget != this.bt_jail)
            {
               GlobalConsoleProperties.console.msgPopup.open({
                  "APP":PopupMessage,
                  "TITLE":"Attention...",
                  "DEPEND":this,
                  "ID":"alert_login_" + Object(parent).pid
               },{
                  "MSG":"La cible doit etre connectée pour etre kickée ou pour recevoir un mp. Par contre elle peut quand même etre envoyée en prison !",
                  "ACTION":"OK"
               });
            }
            if(param1.currentTarget == this.bt_jail)
            {
               if(Object(parent).data.UID)
               {
                  _loc2_ = new SocketMessage();
                  _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,4);
                  _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,8);
                  _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_USER_ID,Object(parent).data.UID);
                  _loc2_.bitWriteBoolean(false);
                  _loc2_.bitWriteString(this.txt_motif.text);
                  _loc2_.bitWriteUnsignedInt(16,this.ban_dure.value);
                  GlobalConsoleProperties.console.blablaland.send(_loc2_);
                  this.addMessage("<span class=\'info\'>Ordre de prison envoyé !</span>");
               }
               else
               {
                  GlobalConsoleProperties.console.msgPopup.open({
                     "APP":PopupMessage,
                     "TITLE":"Attention...",
                     "DEPEND":this,
                     "ID":"jail_alert_" + Object(parent).pid
                  },{
                     "MSG":"La cible ne doit pas etre un touriste pour etre envoyée en prison !",
                     "ACTION":"OK"
                  });
               }
            }
         }
         else if(!this.txt_motif.text.length)
         {
            GlobalConsoleProperties.console.msgPopup.open({
               "APP":PopupMessage,
               "TITLE":"Attention...",
               "DEPEND":this,
               "ID":"alert_nomotif_" + Object(parent).pid
            },{
               "MSG":"Vous devez choisir un motif",
               "ACTION":"OK"
            });
         }
      }
      
      public function clickevt(param1:ListGraphicEvent) : *
      {
         this.bt_mp.visible = GlobalConsoleProperties.console.blablaland.grade >= param1.graphic.node.data.AKB.lvlMp || this.ban_dure.enabled;
         this.bt_kick.visible = GlobalConsoleProperties.console.blablaland.grade >= param1.graphic.node.data.AKB.lvlKick || this.ban_dure.enabled;
         this.bt_jail.visible = GlobalConsoleProperties.console.blablaland.grade >= param1.graphic.node.data.AKB.lvlBan || this.ban_dure.enabled;
         this.txt_motif.text = param1.graphic.node.data.AKB.motif;
         this.ban_dure.value = Number(param1.graphic.node.data.AKB.banDure);
      }
      
      public function trackIpEvent(param1:TextEvent) : *
      {
         var _loc2_:Array = param1.text.split("_");
         if(_loc2_[0] == 0)
         {
            GlobalConsoleProperties.console.winPopup.open({
               "APP":IpList,
               "TITLE":"Listing IP "
            },{"IP":Number(_loc2_[1])});
         }
      }
      
      public function reloadAKBList(param1:Event = null) : *
      {
         var _loc4_:ListTreeNode = null;
         this.akbList.node.removeAllChild();
         var _loc2_:* = GlobalConsoleProperties.console.AKBList;
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(GlobalConsoleProperties.console.blablaland.grade >= _loc2_[_loc3_].lvlMp || GlobalConsoleProperties.console.blablaland.grade >= _loc2_[_loc3_].lvlKick || GlobalConsoleProperties.console.blablaland.grade >= _loc2_[_loc3_].lvlBan)
            {
               (_loc4_ = ListTreeNode(this.akbList.node.addChild())).data.AKB = _loc2_[_loc3_];
               _loc4_.text = _loc4_.data.AKB.desc;
            }
            _loc3_++;
         }
         this.akbList.redraw();
      }
      
      public function onTrackerEvt(param1:Event) : *
      {
         var _loc3_:String = null;
         var _loc2_:Object = Object(parent).data;
         if(param1.currentTarget == this.tracker_uid)
         {
            this.txt_uid.text = "[" + this.tracker_uid.uid + "] " + _loc2_.PSEUDO;
            this.txt_uid.textColor = !!this.tracker_uid.userList.length ? 16711680 : 0;
         }
         if(param1.currentTarget == this.tracker_pid)
         {
            this.txt_pid.text = "[" + this.tracker_pid.pid + "] " + _loc2_.PSEUDO;
            this.txt_pid.textColor = !!this.tracker_pid.userList.length ? 16711680 : 0;
         }
         if(param1.currentTarget == this.tracker_ip)
         {
            _loc3_ = this.Rshift(this.tracker_ip.ip,24) + "." + (this.Rshift(this.tracker_ip.ip,16) & 255) + "." + (this.Rshift(this.tracker_ip.ip,8) & 255) + "." + (this.tracker_ip.ip & 255);
            if(GlobalConsoleProperties.console.blablaland.grade < GlobalConsoleProperties.console.rulesViewIp)
            {
               _loc3_ = "------";
            }
            this.txt_ip.htmlText = "<A HREF=\'event:0_" + this.tracker_ip.ip + "\'><U>" + this.tracker_ip.userList.length + "x (" + _loc3_ + ")</U></A>";
            this.txt_ip.textColor = !!this.tracker_ip.userList.length ? 16711680 : 0;
         }
      }
      
      public function updateDiscutByScroll(param1:Event = null) : *
      {
         this.txt_discut.scrollV = (this.txt_discut.maxScrollV - 1) * this.discut_scr.value + 1;
      }
      
      public function highTrackerEvent(param1:Event) : *
      {
         this.update(!!this.highestTracker.userList.length ? this.highestTracker.userList[0] : null,param1);
      }
      
      public function highTrackerTextEvent(param1:Event) : *
      {
         this.addMessage("<span class=\"info\">" + param1.currentTarget.textEventLast + "</span>");
      }
      
      public function addMessageList(param1:Array) : *
      {
         var _loc2_:* = 0;
         while(_loc2_ < param1.length)
         {
            this.addMessage(param1[_loc2_]);
            _loc2_++;
         }
      }
      
      public function addMessage(param1:String) : *
      {
         this.msgList.push(param1);
         while(this.msgList.length > 50)
         {
            this.msgList.shift();
         }
         this.txt_discut.htmlText = this.msgList.join("<br>");
         this.updateDiscutByScroll();
      }
      
      public function update(param1:BblTrackerUser = null, param2:Event = null) : *
      {
         var _loc3_:uint = 0;
         var _loc4_:ServerMap = null;
         if(param1)
         {
            if(this.lastInformed && !this.lastLogged)
            {
               this.lastLogged = true;
               this.addMessage("<span class=\"info\">&lt;-- se connecte --&gt;</span>");
            }
            if(!this.lastInformed)
            {
               this.addMessageList(param1.msgList);
            }
            if(param2)
            {
               if(param2.type == "onMessage" && Boolean(param1.msgList.length))
               {
                  this.addMessage(param1.msgList[param1.msgList.length - 1]);
               }
            }
            this.txt_cur_pseudo.textColor = 16711680;
            this.txt_cur_login.textColor = 16711680;
            this.txt_cur_ip.textColor = 16711680;
            this.txt_cur_pseudo.text = param1.pseudo;
            this.txt_cur_login.text = param1.login;
            this.txt_cur_grade.text = "Grade " + param1.grade;
            this.txt_cur_ip.text = this.Rshift(param1.ip,24) + "." + (this.Rshift(param1.ip,16) & 255) + "." + (this.Rshift(param1.ip,8) & 255) + "." + (param1.ip & 255);
            if(GlobalConsoleProperties.console.blablaland.grade < GlobalConsoleProperties.console.rulesViewIp)
            {
               this.txt_cur_ip.text = "------";
            }
            this.skin.visible = true;
            this.iconCamera.visible = true;
            this.skin.skinColor = param1.skinColor;
            this.skin.skinId = param1.skinId;
            _loc4_ = GlobalConsoleProperties.console.blablaland.getServerMapById(10);
            if(this.txt_cur_map.text == _loc4_.nom && param1.mapId != 10)
            {
               this.addMessage("<span class=\"info\">&lt;-- sort de prison --&gt;</span>");
            }
            this.txt_cur_map.textColor = 16711680;
            _loc4_ = GlobalConsoleProperties.console.blablaland.getServerMapById(param1.mapId);
            this.txt_cur_map.text = !!_loc4_ ? _loc4_.nom : "{UNKNOW}";
            this.txt_cur_univ.textColor = 16711680;
            this.txt_cur_univ.text = GlobalConsoleProperties.console.blablaland.serverList[param1.serverId].nom;
            this.dragDrop.data.PID = param1.pid;
            this.dragDrop.data.SERVERID = param1.serverId;
         }
         else
         {
            if(this.lastInformed && this.lastLogged)
            {
               this.lastLogged = false;
               this.addMessage("<span class=\"info\">&lt;-- se déconnecte --&gt;</span>");
            }
            this.txt_cur_pseudo.textColor = 0;
            this.txt_cur_login.textColor = 0;
            this.txt_cur_ip.textColor = 0;
            this.txt_cur_map.textColor = 0;
            this.txt_cur_univ.textColor = 0;
            this.txt_cur_grade.text = "Grade";
            this.txt_cur_pseudo.text = "{UNKNOW}";
            this.txt_cur_login.text = "{UNKNOW}";
            this.txt_cur_ip.text = "{UNKNOW}";
            this.txt_cur_map.text = "{UNKNOW}";
            this.txt_cur_univ.text = "{UNKNOW}";
            this.skin.visible = false;
            this.iconCamera.visible = false;
         }
         if(this.highestTracker)
         {
            if(this.highestTracker.trackerInstance.informed)
            {
               this.lastLogged = !!param1 ? true : false;
               this.lastInformed = true;
            }
         }
      }
      
      public function onKill(param1:Event) : *
      {
         var _loc4_:SocketMessage = null;
         var _loc2_:Object = Object(parent).data;
         if(_loc2_.UID)
         {
            delete GlobalProperties.data["CONSOLEUSERCHAT_" + _loc2_.UID];
            (_loc4_ = new SocketMessage()).bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,4);
            _loc4_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,31);
            _loc4_.bitWriteUnsignedInt(GlobalProperties.BIT_USER_ID,_loc2_.UID);
            GlobalConsoleProperties.console.blablaland.send(_loc4_);
         }
         GlobalConsoleProperties.console.removeEventListener("onAKBChange",this.reloadAKBList,false);
         GlobalConsoleProperties.console.dragDrop.removeItem(this.dragDrop);
         var _loc3_:* = 0;
         while(_loc3_ < this.trackerList.length)
         {
            GlobalConsoleProperties.console.blablaland.unRegisterTracker(this.trackerList[_loc3_]);
            _loc3_++;
         }
      }
   }
}
