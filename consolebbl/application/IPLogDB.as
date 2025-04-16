package consolebbl.application
{
   import bbl.GlobalProperties;
   import consolebbl.GlobalConsoleProperties;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TextEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.text.StyleSheet;
   import flash.text.TextField;
   import flash.utils.getTimer;
   import net.Binary;
   import net.SocketMessage;
   import ui.CheckBox;
   import ui.Scroll;
   import ui.ValueSelector;
   
   [Embed(source="/_assets/assets.swf", symbol="consolebbl.application.IPLogDB")]
   public class IPLogDB extends MovieClip
   {
       
      
      public var bt_load_db:SimpleButton;
      
      public var bt_search:SimpleButton;
      
      public var txt_search:TextField;
      
      public var txt_result:TextField;
      
      public var txt_interval:TextField;
      
      public var scr_result:Scroll;
      
      public var vs_nb_day:ValueSelector;
      
      public var vs_start_day:ValueSelector;
      
      public var maskLoader:Sprite;
      
      public var ch_is_ip:CheckBox;
      
      public var ch_is_pseudo:CheckBox;
      
      public var ch_is_uid:CheckBox;
      
      public var ch_is_chat:CheckBox;
      
      public var ch_is_console:CheckBox;
      
      private var dataBase:Binary;
      
      private var currentLoader:URLLoader;
      
      private var queryString:String;
      
      private var queryUint:uint;
      
      private var queryResult:String;
      
      public function IPLogDB()
      {
         super();
         this.addEventListener(Event.ADDED,this.init,false,0,true);
         this.maskLoader.visible = false;
         this.currentLoader = null;
         this.dataBase = new Binary();
      }
      
      public function init(param1:Event) : *
      {
         var _loc2_:* = undefined;
         if(stage)
         {
            this.removeEventListener(Event.ADDED,this.init,false);
            parent.addEventListener("onKill",this.onKill,false,0,true);
            parent.width = 380;
            parent.height = 500;
            Object(parent).redraw();
            this.vs_nb_day.minValue = 1;
            this.vs_nb_day.maxValue = 90;
            this.vs_nb_day.value = 2;
            this.vs_start_day.minValue = 0;
            this.vs_start_day.maxValue = 9999;
            this.scr_result.size = this.txt_result.height;
            this.scr_result.value = 1;
            this.txt_result.htmlText = "";
            this.ch_is_pseudo.value = true;
            this.ch_is_chat.value = true;
            this.ch_is_console.value = true;
            this.bt_load_db.addEventListener("click",this.onLoadDB,false,0,true);
            this.bt_search.addEventListener("click",this.onSearch,false,0,true);
            this.ch_is_pseudo.addEventListener("onChanged",this.onChChanged,false,0,true);
            this.ch_is_uid.addEventListener("onChanged",this.onChChanged,false,0,true);
            this.ch_is_ip.addEventListener("onChanged",this.onChChanged,false,0,true);
            this.ch_is_chat.addEventListener("onChanged",this.onChChanged,false,0,true);
            this.ch_is_console.addEventListener("onChanged",this.onChChanged,false,0,true);
            this.scr_result.addEventListener("onChanged",this.updateResultByScroll,false,0,true);
            this.vs_start_day.addEventListener("onChanged",this.updateInterval,false,0,true);
            this.vs_nb_day.addEventListener("onChanged",this.updateInterval,false,0,true);
            this.updateInterval(null);
            _loc2_ = new StyleSheet();
            _loc2_.setStyle("a",{"color":"#0000FF"});
            this.txt_result.styleSheet = _loc2_;
            this.txt_result.addEventListener(TextEvent.LINK,this.resultClickEvent,false,0,true);
            if(GlobalConsoleProperties.console.blablaland.grade < GlobalConsoleProperties.console.rulesIpLogDB)
            {
               GlobalConsoleProperties.console.msgPopup.open({
                  "APP":PopupMessage,
                  "TITLE":"Attention..."
               },{
                  "MSG":"Vous n\'avez pas le grade necessaire pour acceder à cette section.",
                  "ACTION":"OK"
               });
               Object(parent).close();
            }
         }
      }
      
      public function updateInterval(param1:Event) : *
      {
         var _loc2_:Date = new Date();
         _loc2_.setTime(GlobalProperties.serverTime - this.vs_start_day.value * 24 * 3600 * 1000);
         var _loc3_:String = this.multiDigit(_loc2_.getDate()) + "/" + this.multiDigit(_loc2_.getMonth() + 1) + "/" + _loc2_.getFullYear() + " " + this.multiDigit(_loc2_.getHours()) + ":" + this.multiDigit(_loc2_.getMinutes());
         _loc2_.setTime(_loc2_.getTime() - this.vs_nb_day.value * 24 * 3600 * 1000);
         var _loc4_:String = this.multiDigit(_loc2_.getDate()) + "/" + this.multiDigit(_loc2_.getMonth() + 1) + "/" + _loc2_.getFullYear() + " " + this.multiDigit(_loc2_.getHours()) + ":" + this.multiDigit(_loc2_.getMinutes());
         this.txt_interval.text = "Depuis le [" + _loc4_ + "] jusq\'au [" + _loc3_ + "]";
      }
      
      public function onChChanged(param1:Event) : *
      {
         if(param1.currentTarget == this.ch_is_pseudo)
         {
            this.ch_is_uid.value = false;
            this.ch_is_ip.value = false;
            this.ch_is_pseudo.value = true;
         }
         if(param1.currentTarget == this.ch_is_uid)
         {
            this.ch_is_pseudo.value = false;
            this.ch_is_ip.value = false;
            this.ch_is_uid.value = true;
         }
         if(param1.currentTarget == this.ch_is_ip)
         {
            this.ch_is_uid.value = false;
            this.ch_is_pseudo.value = false;
            this.ch_is_ip.value = true;
         }
         if(param1.currentTarget == this.ch_is_chat)
         {
            this.ch_is_console.value = true;
         }
         if(param1.currentTarget == this.ch_is_console)
         {
            this.ch_is_chat.value = true;
         }
      }
      
      public function onLoadDB(param1:Event) : *
      {
         var _loc2_:* = new SocketMessage();
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,4);
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,19);
         GlobalConsoleProperties.console.blablaland.send(_loc2_);
         this.txt_result.htmlText = "";
         var _loc3_:URLVariables = new URLVariables();
         _loc3_.SESSION = GlobalConsoleProperties.console.session;
         _loc3_.CACHE = new Date().getTime();
         _loc3_.STARTAT = Math.round(GlobalProperties.serverTime / 1000) + 10 - this.vs_start_day.value * 24 * 3600;
         _loc3_.BACKTO = _loc3_.STARTAT - this.vs_nb_day.value * 24 * 3600;
         var _loc4_:URLRequest;
         (_loc4_ = new URLRequest(GlobalProperties.scriptAdr + "console/IPLogDB.php")).method = "POST";
         _loc4_.data = _loc3_;
         var _loc5_:URLLoader = new URLLoader();
         this.currentLoader = _loc5_;
         _loc5_.dataFormat = "binary";
         _loc5_.load(_loc4_);
         _loc5_.addEventListener("complete",this.onGetDataBase,false,0,true);
         this.maskLoader.visible = true;
         addEventListener("enterFrame",this.loaderEnterFrame,false,0,true);
         this.loaderEnterFrame(null);
      }
      
      public function loaderEnterFrame(param1:Event) : *
      {
         var _loc2_:Number = 0;
         if(this.currentLoader.bytesTotal)
         {
            _loc2_ = this.currentLoader.bytesLoaded / this.currentLoader.bytesTotal;
         }
         TextField(this.maskLoader.getChildByName("txt")).text = "Téléchargement : " + Math.round(this.currentLoader.bytesLoaded / 1000) + " Ko ..";
      }
      
      public function onGetDataBase(param1:Event) : *
      {
         param1.currentTarget.removeEventListener("complete",this.onGetDataBase,false);
         removeEventListener("enterFrame",this.loaderEnterFrame,false);
         this.maskLoader.visible = false;
         this.dataBase = new Binary();
         this.dataBase.writeBytes(param1.currentTarget.data);
         this.dataBase.bitLength = this.dataBase.length * 8;
      }
      
      public function onSearch(param1:Event) : *
      {
         var _loc2_:* = false;
         var _loc3_:Array = null;
         var _loc4_:* = undefined;
         this.maskLoader.visible = true;
         addEventListener("enterFrame",this.searchEnterFrame,false,0,true);
         this.dataBase.bitPosition = 0;
         this.queryResult = "";
         if(this.ch_is_pseudo.value)
         {
            this.queryString = this.txt_search.text.toLowerCase();
         }
         if(this.ch_is_uid.value)
         {
            this.queryUint = uint(this.txt_search.text);
         }
         if(this.ch_is_ip.value)
         {
            this.queryUint = 0;
            _loc2_ = this.txt_search.text.length > 4;
            _loc3_ = this.txt_search.text.split(".");
            if(_loc2_)
            {
               _loc2_ = _loc3_.length != 0 && _loc3_.length != 3;
            }
            if(_loc2_)
            {
               _loc4_ = 0;
               if(_loc3_.length == 1 && !isNaN(Number(this.txt_search.text)))
               {
                  _loc4_ = Number(this.txt_search.text);
               }
               else
               {
                  _loc4_ = _loc3_[0] * Math.pow(2,24) + _loc3_[1] * Math.pow(2,16) + _loc3_[2] * Math.pow(2,8) + Number(_loc3_[3]);
               }
               this.txt_search.text = this.Rshift(_loc4_,24) + "." + (this.Rshift(_loc4_,16) & 255) + "." + (this.Rshift(_loc4_,8) & 255) + "." + (_loc4_ & 255);
               this.queryUint = _loc4_;
            }
         }
         this.searchEnterFrame(null);
      }
      
      public function searchEnterFrame(param1:Event) : *
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:String = null;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:* = undefined;
         var _loc10_:Number = NaN;
         var _loc2_:uint = uint(getTimer());
         while(this.dataBase.bitPosition < this.dataBase.bitLength && _loc2_ + 100 > getTimer())
         {
            _loc3_ = this.dataBase.bitReadUnsignedInt(32);
            _loc4_ = this.dataBase.bitReadUnsignedInt(32);
            _loc5_ = this.dataBase.bitReadUnsignedInt(32);
            _loc6_ = this.dataBase.bitReadString();
            _loc7_ = false;
            if(_loc3_ > 1225778431)
            {
               _loc7_ = this.dataBase.bitReadBoolean();
               this.dataBase.bitReadBoolean();
               this.dataBase.bitReadBoolean();
               this.dataBase.bitReadBoolean();
               this.dataBase.bitReadBoolean();
               this.dataBase.bitReadBoolean();
               this.dataBase.bitReadBoolean();
               this.dataBase.bitReadBoolean();
            }
            _loc8_ = false;
            if(this.ch_is_chat.value && !_loc7_ || this.ch_is_console.value && _loc7_)
            {
               if(this.ch_is_ip.value)
               {
                  if(_loc5_ == this.queryUint)
                  {
                     _loc8_ = true;
                  }
               }
               else if(this.ch_is_uid.value)
               {
                  if(_loc4_ == this.queryUint)
                  {
                     _loc8_ = true;
                  }
               }
               else if(this.ch_is_pseudo.value)
               {
                  if(_loc6_.toLowerCase() == this.queryString)
                  {
                     _loc8_ = true;
                  }
               }
            }
            if(_loc8_)
            {
               (_loc9_ = new Date()).setTime(_loc3_ * 1000);
               this.queryResult += (_loc7_ ? "<FONT COLOR=\'#FF0000\'>Console</FONT>" : "<FONT COLOR=\'#00000FF\'>Chat</FONT>") + " ";
               this.queryResult += "[" + this.multiDigit(_loc9_.getDate()) + "/" + this.multiDigit(_loc9_.getMonth() + 1) + "/" + _loc9_.getFullYear() + " " + this.multiDigit(_loc9_.getHours()) + ":" + this.multiDigit(_loc9_.getMinutes()) + "] ";
               this.queryResult += "[<A HREF=\'event:0_" + _loc4_ + "_" + _loc5_ + "_" + _loc6_ + "\'>" + _loc4_ + "</A>] ";
               this.queryResult += "[<A HREF=\'event:1_" + _loc5_ + "\'>" + this.Rshift(_loc5_,24) + "." + (this.Rshift(_loc5_,16) & 255) + "." + (this.Rshift(_loc5_,8) & 255) + "." + (_loc5_ & 255) + "</A>] ";
               this.queryResult += "[<A HREF=\'event:2_" + _loc6_ + "\'>" + _loc6_ + "</A>] \n";
            }
         }
         if(this.dataBase.bitPosition >= this.dataBase.bitLength)
         {
            removeEventListener("enterFrame",this.searchEnterFrame,false);
            this.maskLoader.visible = false;
            this.txt_result.htmlText = this.queryResult;
            this.scr_result.value = 1;
            this.updateResultByScroll();
         }
         else
         {
            _loc10_ = 0;
            _loc10_ = this.dataBase.bitPosition / this.dataBase.bitLength;
            TextField(this.maskLoader.getChildByName("txt")).text = "Recherche : " + Math.round(_loc10_ * 100) + " %";
         }
      }
      
      public function updateResultByScroll(param1:Event = null) : *
      {
         this.txt_result.scrollV = (this.txt_result.maxScrollV - 1) * this.scr_result.value + 1;
      }
      
      public function resultClickEvent(param1:TextEvent) : *
      {
         var _loc3_:String = null;
         var _loc4_:Object = null;
         var _loc2_:Array = param1.text.split("_");
         if(_loc2_[0] == 0)
         {
            if(_loc2_[1] > 0)
            {
               _loc3_ = "track_UID_" + _loc2_[1];
               (_loc4_ = new Object()).IP = _loc2_[2];
               _loc4_.PID = 0;
               _loc4_.UID = _loc2_[1];
               _loc2_.shift();
               _loc2_.shift();
               _loc2_.shift();
               _loc4_.PSEUDO = _loc2_.join("_");
               GlobalConsoleProperties.console.winPopup.open({
                  "APP":AffUserTracker,
                  "ID":_loc3_,
                  "TITLE":"Poursuite : " + _loc2_.join("_")
               },_loc4_);
            }
         }
         else if(_loc2_[0] == 1)
         {
            GlobalConsoleProperties.console.winPopup.open({
               "APP":IpList,
               "TITLE":"Listing IP "
            },{"IP":Number(_loc2_[1])});
         }
         else if(_loc2_[0] == 2)
         {
            _loc2_.shift();
            this.txt_search.text = _loc2_.join("_");
            this.ch_is_pseudo.dispatchEvent(new Event("onChanged"));
         }
      }
      
      public function onKill(param1:Event) : *
      {
         removeEventListener("enterFrame",this.searchEnterFrame,false);
         removeEventListener("enterFrame",this.loaderEnterFrame,false);
         if(this.currentLoader)
         {
            try
            {
               this.currentLoader.close();
            }
            catch(e:*)
            {
            }
         }
      }
      
      public function multiDigit(param1:int, param2:uint = 2) : String
      {
         var _loc3_:String = param1.toString();
         while(_loc3_.length < param2)
         {
            _loc3_ = "0" + _loc3_;
         }
         return _loc3_;
      }
      
      public function Rshift(param1:Number, param2:int) : Number
      {
         return Math.floor(param1 / Math.pow(2,param2));
      }
   }
}
