package consolebbl.application
{
   import bbl.GlobalProperties;
   import consolebbl.GlobalConsoleProperties;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.text.TextField;
   import net.ParsedMessageEvent;
   import net.SocketMessage;
   import ui.CheckBox;
   import ui.List;
   import ui.ListGraphicEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="consolebbl.application.RechercheUser")]
   public class RechercheUser extends MovieClip
   {
       
      
      public var bt_search:SimpleButton;
      
      public var bt_listing:SimpleButton;
      
      public var bt_ip_db:SimpleButton;
      
      public var bt_ip_track:SimpleButton;
      
      public var txt_search:TextField;
      
      public var liste:List;
      
      public var ch_online:CheckBox;
      
      public var ch_offline:CheckBox;
      
      public function RechercheUser()
      {
         super();
         this.addEventListener(Event.ADDED,this.init,false,0,true);
         this.bt_search.addEventListener("click",this.onSearch,false,0,true);
         this.bt_listing.addEventListener("click",this.onListing,false,0,true);
         this.bt_ip_db.addEventListener("click",this.onIPLogDB,false,0,true);
         this.bt_ip_track.addEventListener("click",this.onIPTrack,false,0,true);
         this.txt_search.addEventListener("change",this.onTxtChanged,false,0,true);
         this.liste.addEventListener("onClick",this.clickevt,false,0,true);
         GlobalProperties.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownEvt,false,0,true);
         this.liste.size = 10;
         this.ch_online.value = true;
         this.ch_online.addEventListener("onChanged",this.chEvent,false,0,true);
         this.ch_offline.addEventListener("onChanged",this.chEvent,false,0,true);
      }
      
      public function init(param1:Event) : *
      {
         if(stage)
         {
            this.removeEventListener(Event.ADDED,this.init,false);
            parent.width = 230;
            parent.height = 230;
            Object(parent).redraw();
            parent.addEventListener("onKill",this.onKill,false,0,true);
         }
      }
      
      public function chEvent(param1:Event) : *
      {
         if(param1.currentTarget == this.ch_online)
         {
            this.ch_offline.value = !param1.currentTarget.value;
         }
         else
         {
            this.ch_online.value = !param1.currentTarget.value;
         }
      }
      
      public function onKeyDownEvt(param1:KeyboardEvent) : *
      {
         if(GlobalProperties.stage.focus == this.txt_search && param1.keyCode == 13 && Boolean(Object(parent).focus))
         {
            this.onSearch();
         }
      }
      
      public function clickevt(param1:ListGraphicEvent) : *
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
      
      public function onTxtChanged(param1:Event) : *
      {
         var _loc2_:* = this.txt_search.text.length >= 3;
         this.bt_search.enabled = _loc2_;
         this.bt_search.alpha = _loc2_ ? 1 : 0.5;
         this.txt_search.textColor = _loc2_ ? 56576 : 16711680;
      }
      
      public function onKill(param1:Event) : *
      {
         GlobalProperties.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownEvt,false);
         GlobalConsoleProperties.console.blablaland.removeEventListener("onParsedMessage",this.onMessage,false);
      }
      
      public function onIPTrack(param1:Event = null) : *
      {
         GlobalConsoleProperties.console.winPopup.open({
            "APP":IpList,
            "TITLE":"Listing IP "
         });
      }
      
      public function onIPLogDB(param1:Event = null) : *
      {
         GlobalConsoleProperties.console.winPopup.open({
            "APP":IPLogDB,
            "TITLE":"Base de données des connections.."
         });
      }
      
      public function onListing(param1:Event = null) : *
      {
         GlobalConsoleProperties.console.winPopup.open({
            "APP":UserListing,
            "ID":"SearchList",
            "TITLE":"Liste complete.."
         });
      }
      
      public function onSearch(param1:Event = null) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:URLVariables = null;
         var _loc4_:URLRequest = null;
         var _loc5_:URLLoader = null;
         if(this.bt_search.enabled && this.txt_search.text.length > 2)
         {
            if(this.ch_online.value)
            {
               GlobalConsoleProperties.console.blablaland.addEventListener("onParsedMessage",this.onMessage,false,0,true);
               this.bt_search.enabled = false;
               this.bt_search.alpha = this.bt_search.enabled ? 1 : 0.5;
               _loc2_ = new SocketMessage();
               _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,4);
               _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,1);
               _loc2_.bitWriteUnsignedInt(16,Object(parent).pid);
               _loc2_.bitWriteString(this.txt_search.text);
               GlobalConsoleProperties.console.blablaland.send(_loc2_);
            }
            else
            {
               _loc3_ = new URLVariables();
               _loc3_.SESSION = GlobalConsoleProperties.console.session;
               _loc3_.PSEUDO = this.txt_search.text;
               _loc3_.CACHE = new Date().getTime();
               (_loc4_ = new URLRequest(GlobalProperties.scriptAdr + "console/searchUser.php")).method = "POST";
               _loc4_.data = _loc3_;
               (_loc5_ = new URLLoader()).dataFormat = "variables";
               _loc5_.load(_loc4_);
               _loc5_.addEventListener("complete",this.onSearchUser,false,0,true);
               alpha = 0.5;
               mouseChildren = false;
            }
         }
      }
      
      public function onSearchUser(param1:Event) : *
      {
         var _loc2_:uint = 0;
         var _loc3_:* = undefined;
         param1.currentTarget.removeEventListener("complete",this.onSearchUser,false);
         alpha = 1;
         mouseChildren = true;
         this.liste.node.removeAllChild();
         if(param1.currentTarget.data.RESULT == 1)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.currentTarget.data.NB)
            {
               _loc3_ = this.liste.node.addChild();
               _loc3_.data.PSEUDO = param1.currentTarget.data["PSEUDO_" + _loc2_];
               _loc3_.data.PID = 0;
               _loc3_.data.UID = param1.currentTarget.data["UID_" + _loc2_];
               _loc3_.data.IP = param1.currentTarget.data["IP_" + _loc2_];
               _loc3_.text = _loc3_.data.PSEUDO;
               _loc2_++;
            }
         }
         this.liste.redraw();
      }
      
      public function onMessage(param1:ParsedMessageEvent) : *
      {
         var _loc2_:SocketMessage = null;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(param1.evtType == 6 && param1.evtStype == 1)
         {
            _loc2_ = param1.getMessage();
            _loc3_ = _loc2_.bitReadUnsignedInt(16);
            if(_loc3_ == Object(parent).pid)
            {
               param1.stopImmediatePropagation();
               this.bt_search.enabled = true;
               this.bt_search.alpha = this.bt_search.enabled ? 1 : 0.5;
               GlobalConsoleProperties.console.blablaland.removeEventListener("onParsedMessage",this.onMessage,false);
               this.liste.node.removeAllChild();
               while(_loc2_.bitReadBoolean())
               {
                  (_loc4_ = this.liste.node.addChild()).data.PSEUDO = _loc2_.bitReadString();
                  _loc4_.data.PID = _loc2_.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID);
                  _loc4_.data.UID = _loc2_.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID);
                  _loc4_.data.IP = _loc2_.bitReadUnsignedInt(32);
                  _loc4_.text = _loc4_.data.PSEUDO;
               }
               this.liste.node.childNode.sortOn("text",Array.CASEINSENSITIVE);
               this.liste.redraw();
            }
         }
      }
   }
}
