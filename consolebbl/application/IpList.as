package consolebbl.application
{
   import bbl.GlobalProperties;
   import bbl.Tracker;
   import consolebbl.GlobalConsoleProperties;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.net.navigateToURL;
   import flash.text.TextField;
   import ui.CheckBox;
   import ui.List;
   import ui.ListGraphicEvent;
   import ui.ListTreeNode;
   
   [Embed(source="/_assets/assets.swf", symbol="consolebbl.application.IpList")]
   public class IpList extends MovieClip
   {
       
      
      public var liste:List;
      
      public var bt_geo:SimpleButton;
      
      public var txt_ip:TextField;
      
      public var tracker:Tracker;
      
      public var chk_chat:CheckBox;
      
      public var chk_bdd:CheckBox;
      
      public var bt_search:SimpleButton;
      
      private var curIp:String;
      
      public function IpList()
      {
         super();
         this.liste.addEventListener("onClick",this.clickevt,false,0,true);
         this.liste.size = 5;
         this.liste.redraw();
         this.tracker = null;
         if(GlobalConsoleProperties.console.blablaland.grade < GlobalConsoleProperties.console.rulesViewIp)
         {
            this.bt_geo.enabled = false;
         }
         else
         {
            this.bt_geo.addEventListener("click",this.onGeoEvt,false,0,true);
         }
         this.addEventListener(Event.ADDED,this.popinit,false,0,true);
      }
      
      public function popinit(param1:Event) : *
      {
         var _loc2_:Object = null;
         if(stage)
         {
            this.removeEventListener(Event.ADDED,this.popinit,false);
            parent.width = 230;
            parent.height = 140;
            Object(parent).redraw();
            parent.addEventListener("onKill",this.onKill,false,0,true);
            if(!Object(parent).data)
            {
               Object(parent).data = new Object();
            }
            _loc2_ = Object(parent).data;
            this.chk_chat.value = true;
            this.chk_chat.addEventListener("onChanged",this.chkSelector,false,0,true);
            this.chk_bdd.addEventListener("onChanged",this.chkSelector,false,0,true);
            this.bt_search.addEventListener("click",this.onSearchEvt,false,0,true);
            this.curIp = null;
            if(_loc2_.IP)
            {
               this.txt_ip.text = this.Rshift(_loc2_.IP,24) + "." + (this.Rshift(_loc2_.IP,16) & 255) + "." + (this.Rshift(_loc2_.IP,8) & 255) + "." + (_loc2_.IP & 255);
               if(GlobalConsoleProperties.console.blablaland.grade < GlobalConsoleProperties.console.rulesViewIp)
               {
                  this.txt_ip.text = "";
               }
               this.initChatTracker();
            }
         }
      }
      
      public function chkSelector(param1:Event) : *
      {
         if(CheckBox(param1.target).value)
         {
            if(param1.target == this.chk_chat)
            {
               this.chk_bdd.value = false;
               this.initChatTracker();
            }
            else
            {
               this.chk_chat.value = false;
               this.initBDDSearch();
            }
         }
         else
         {
            CheckBox(param1.target).value = true;
         }
      }
      
      public function onSearchEvt(param1:Event) : *
      {
         var _loc4_:* = undefined;
         var _loc2_:* = this.txt_ip.text.length > 4;
         var _loc3_:Array = this.txt_ip.text.split(".");
         if(_loc2_)
         {
            _loc2_ = _loc3_.length != 0 && _loc3_.length != 3;
         }
         if(_loc2_)
         {
            _loc4_ = 0;
            if(_loc3_.length == 1 && !isNaN(Number(this.txt_ip.text)))
            {
               _loc4_ = Number(this.txt_ip.text);
            }
            else
            {
               _loc4_ = _loc3_[0] * Math.pow(2,24) + _loc3_[1] * Math.pow(2,16) + _loc3_[2] * Math.pow(2,8) + Number(_loc3_[3]);
            }
            this.txt_ip.text = this.Rshift(_loc4_,24) + "." + (this.Rshift(_loc4_,16) & 255) + "." + (this.Rshift(_loc4_,8) & 255) + "." + (_loc4_ & 255);
            Object(parent).data.IP = _loc4_;
            if(this.chk_bdd.value)
            {
               this.initBDDSearch();
            }
            else
            {
               this.initChatTracker();
            }
         }
      }
      
      public function initBDDSearch() : *
      {
         if(this.tracker)
         {
            GlobalConsoleProperties.console.blablaland.unRegisterTracker(this.tracker);
            this.tracker.removeEventListener("onChanged",this.onTrackerEvt,false);
            this.tracker = null;
         }
         this.txt_ip.textColor = 0;
         var _loc1_:URLVariables = new URLVariables();
         _loc1_.SESSION = GlobalConsoleProperties.console.session;
         _loc1_.CACHE = new Date().getTime();
         _loc1_.IP = Object(parent).data.IP;
         var _loc2_:URLRequest = new URLRequest(GlobalProperties.scriptAdr + "console/getUserByIp.php");
         _loc2_.method = "POST";
         _loc2_.data = _loc1_;
         var _loc3_:URLLoader = new URLLoader();
         _loc3_.dataFormat = "variables";
         _loc3_.load(_loc2_);
         _loc3_.addEventListener("complete",this.onUrlMessage,false,0,true);
         mouseChildren = false;
         alpha = 0.5;
      }
      
      public function onUrlMessage(param1:Event) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:ListTreeNode = null;
         param1.currentTarget.removeEventListener("complete",this.onUrlMessage,false);
         if(param1.currentTarget.data.RESULT == 1)
         {
            this.liste.node.removeAllChild();
            _loc2_ = 0;
            while(_loc2_ < param1.currentTarget.data.NB)
            {
               _loc3_ = ListTreeNode(this.liste.node.addChild());
               _loc3_.data.UID = param1.currentTarget.data["UID_" + _loc2_];
               _loc3_.data.PSEUDO = param1.currentTarget.data["PSEUDO_" + _loc2_];
               _loc3_.data.GRADE = param1.currentTarget.data["GRADE_" + _loc2_];
               _loc3_.data.ONLINE = Number(param1.currentTarget.data["ONLINE_" + _loc2_]);
               _loc3_.text = (!!_loc3_.data.ONLINE ? "<font color=\'#FF0000\'>" : "") + _loc3_.data.PSEUDO + "</font>";
               _loc2_++;
            }
            this.liste.redraw();
         }
         mouseChildren = true;
         alpha = 1;
      }
      
      public function initChatTracker() : *
      {
         if(this.tracker)
         {
            GlobalConsoleProperties.console.blablaland.unRegisterTracker(this.tracker);
            this.tracker.removeEventListener("onChanged",this.onTrackerEvt,false);
            this.tracker = null;
         }
         if(!this.tracker)
         {
            this.txt_ip.textColor = 0;
            this.liste.node.removeAllChild();
            this.liste.redraw();
            this.tracker = new Tracker(Object(parent).data.IP);
            this.tracker.addEventListener("onChanged",this.onTrackerEvt,false,0,true);
            GlobalConsoleProperties.console.blablaland.registerTracker(this.tracker);
         }
      }
      
      public function Rshift(param1:Number, param2:int) : Number
      {
         return Math.floor(param1 / Math.pow(2,param2));
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
         _loc3_.IP = Object(parent).data.IP;
         _loc3_.UID = param1.graphic.node.data.UID;
         if(!_loc3_.UID)
         {
            _loc3_.PID = param1.graphic.node.data.PID;
         }
         _loc3_.PSEUDO = param1.graphic.node.data.PSEUDO;
         GlobalConsoleProperties.console.winPopup.open({
            "APP":AffUserTracker,
            "ID":_loc2_,
            "TITLE":"Poursuite : " + param1.graphic.node.data.PSEUDO
         },_loc3_);
      }
      
      public function onTrackerEvt(param1:Event) : *
      {
         var _loc3_:ListTreeNode = null;
         this.liste.node.removeAllChild();
         var _loc2_:* = 0;
         while(_loc2_ < this.tracker.userList.length)
         {
            _loc3_ = ListTreeNode(this.liste.node.addChild());
            _loc3_.data.PSEUDO = this.tracker.userList[_loc2_].pseudo;
            _loc3_.data.UID = this.tracker.userList[_loc2_].uid;
            _loc3_.data.PID = this.tracker.userList[_loc2_].pid;
            _loc3_.text = _loc3_.data.PSEUDO;
            _loc2_++;
         }
         if(this.tracker.userList.length)
         {
            this.txt_ip.textColor = 16711680;
         }
         else
         {
            this.txt_ip.textColor = 0;
         }
         this.liste.redraw();
      }
      
      public function onGeoEvt(param1:Event) : *
      {
         var _loc2_:Object = Object(parent).data;
         navigateToURL(new URLRequest("http://www.ip2location.com/" + (_loc2_.IP >> 24 & 255) + "." + (_loc2_.IP >> 16 & 255) + "." + (_loc2_.IP >> 8 & 255) + "." + (_loc2_.IP & 255) + ""),"_blank");
      }
      
      public function onKill(param1:Event) : *
      {
         if(this.tracker)
         {
            GlobalConsoleProperties.console.blablaland.unRegisterTracker(this.tracker);
            this.tracker.removeEventListener("onChanged",this.onTrackerEvt,false);
            this.tracker = null;
         }
      }
   }
}
