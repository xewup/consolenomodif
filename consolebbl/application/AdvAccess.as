package consolebbl.application
{
   import bbl.GlobalProperties;
   import consolebbl.GlobalConsoleProperties;
   import consolebbl.application.fx.MultiBOOM;
   import consolebbl.application.fx.MultiMedia;
   import consolebbl.application.fx.PlaceText;
   import consolebbl.application.fx.WallArea;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.text.TextField;
   import net.Binary;
   import net.SocketMessage;
   import ui.CheckBox;
   import ui.ValueSelector;
   
   [Embed(source="/_assets/assets.swf", symbol="consolebbl.application.AdvAccess")]
   public class AdvAccess extends MovieClip
   {
       
      
      public var bt_kill:SimpleButton;
      
      public var txt_killMotif:TextField;
      
      public var chk_reboot:CheckBox;
      
      public var vs_maxcon:ValueSelector;
      
      public var bt_apply:SimpleButton;
      
      public var bt_clear_skin:SimpleButton;
      
      public var bt_clear_fx:SimpleButton;
      
      public var bt_clear_map:SimpleButton;
      
      public var bt_write_log:SimpleButton;
      
      public var bt_multi_boom:SimpleButton;
      
      public var bt_multi_media:SimpleButton;
      
      public var bt_kdo_drop:SimpleButton;
      
      public var bt_wall:SimpleButton;
      
      public var bt_mailadmin:SimpleButton;
      
      public var bt_place_txt:SimpleButton;
      
      public var bt_a_event:SimpleButton;
      
      public var bt_dyn_fx:SimpleButton;
      
      public var bt_web_radio:SimpleButton;
      
      public var txt_cache_id:TextField;
      
      public function AdvAccess()
      {
         super();
         this.addEventListener(Event.ADDED,this.init,false,0,true);
         this.txt_killMotif.text = "Fermeture de blablaland pour maintenance. Merci de revenir dans qq minutes.";
         this.bt_kill.addEventListener("click",this.btKillEvent,false,0,true);
         this.bt_apply.addEventListener("click",this.btApplyEvt,false,0,true);
         this.bt_clear_skin.addEventListener("click",this.btClearEvt,false,0,true);
         this.bt_clear_map.addEventListener("click",this.btClearEvt,false,0,true);
         this.bt_clear_fx.addEventListener("click",this.btClearEvt,false,0,true);
         this.bt_kdo_drop.addEventListener("click",this.btDropKDOEvt,false,0,true);
         this.bt_wall.addEventListener("click",this.btWallEvt,false,0,true);
         this.bt_multi_boom.addEventListener("click",this.btMultiBoomEvt,false,0,true);
         this.bt_multi_media.addEventListener("click",this.btMultiMediaEvt,false,0,true);
         this.bt_place_txt.addEventListener("click",this.btPlaceTxtEvt,false,0,true);
         this.bt_mailadmin.addEventListener("click",this.btMailerAdminEvt,false,0,true);
         this.bt_a_event.addEventListener("click",this.btAEventEvt,false,0,true);
         this.bt_write_log.addEventListener("click",this.btWriteLogEvt,false,0,true);
         this.bt_dyn_fx.addEventListener("click",this.btDynFxEvt,false,0,true);
         this.bt_web_radio.addEventListener("click",this.btWebRadioEvt,false,0,true);
         this.vs_maxcon.maxValue = 9999;
      }
      
      public function init(param1:Event) : *
      {
         var _loc2_:URLVariables = null;
         var _loc3_:URLRequest = null;
         var _loc4_:URLLoader = null;
         if(stage)
         {
            this.removeEventListener(Event.ADDED,this.init,false);
            parent.width = 250;
            parent.height = 280;
            Object(parent).redraw();
            this.chk_reboot.value = true;
            _loc2_ = new URLVariables();
            _loc2_.ACT = "GET";
            _loc2_.SESSION = GlobalConsoleProperties.console.session;
            _loc2_.CACHE = new Date().getTime();
            _loc3_ = new URLRequest(GlobalProperties.scriptAdr + "console/advServer.php");
            _loc3_.method = "POST";
            _loc3_.data = _loc2_;
            (_loc4_ = new URLLoader()).dataFormat = "variables";
            _loc4_.load(_loc3_);
            _loc4_.addEventListener("complete",this.onUrlMessage,false,0,true);
            mouseChildren = false;
            alpha = 0.5;
         }
      }
      
      public function onUrlMessage(param1:Event) : *
      {
         param1.currentTarget.removeEventListener("complete",this.onUrlMessage,false);
         if(param1.currentTarget.data.RESULT == 1)
         {
            mouseChildren = true;
            alpha = 1;
            this.vs_maxcon.value = param1.currentTarget.data.MAX_CON;
         }
      }
      
      public function btDynFxEvt(param1:Event) : *
      {
         GlobalConsoleProperties.console.winPopup.open({
            "APP":DynFx,
            "TITLE":"DynFx"
         });
      }
      
      public function btMailerAdminEvt(param1:Event) : *
      {
         GlobalConsoleProperties.console.winPopup.open({
            "APP":MailerAdmin,
            "TITLE":"MailerAdmin"
         });
      }
      
      public function btWallEvt(param1:Event) : *
      {
         GlobalConsoleProperties.console.winPopup.open({
            "APP":WallArea,
            "TITLE":"Wall Area"
         });
      }
      
      public function btMultiMediaEvt(param1:Event) : *
      {
         GlobalConsoleProperties.console.winPopup.open({
            "APP":MultiMedia,
            "TITLE":"Multi media.."
         });
      }
      
      public function btMultiBoomEvt(param1:Event) : *
      {
         GlobalConsoleProperties.console.winPopup.open({
            "APP":MultiBOOM,
            "TITLE":"Place texte.."
         });
      }
      
      public function btPlaceTxtEvt(param1:Event) : *
      {
         GlobalConsoleProperties.console.winPopup.open({
            "APP":PlaceText,
            "TITLE":"Place texte.."
         });
      }
      
      public function btDropKDOEvt(param1:Event) : *
      {
         GlobalConsoleProperties.console.winPopup.open({
            "APP":DropKDO,
            "TITLE":"Drop KDO.."
         });
      }
      
      public function btAEventEvt(param1:Event) : *
      {
         GlobalConsoleProperties.console.winPopup.open({
            "APP":AEvent,
            "TITLE":"A.Event..",
            "ID":"AEvent"
         });
      }
      
      public function btWebRadioEvt(param1:Event) : *
      {
         GlobalConsoleProperties.console.winPopup.open({
            "APP":WebRadio,
            "TITLE":"Web Radio..",
            "ID":"WebRadio"
         });
      }
      
      public function btWriteLogEvt(param1:Event) : *
      {
         var _loc2_:* = new SocketMessage();
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,4);
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,26);
         _loc2_.bitWriteUnsignedInt(10,0);
         GlobalConsoleProperties.console.blablaland.send(_loc2_);
      }
      
      public function btClearEvt(param1:Event) : *
      {
         var _loc6_:Array = null;
         var _loc7_:uint = 0;
         var _loc2_:uint = 0;
         if(param1.currentTarget == this.bt_clear_skin)
         {
            _loc2_ = 0;
         }
         if(param1.currentTarget == this.bt_clear_map)
         {
            _loc2_ = 1;
         }
         if(param1.currentTarget == this.bt_clear_fx)
         {
            _loc2_ = 2;
         }
         var _loc3_:* = new SocketMessage();
         _loc3_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,4);
         _loc3_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,18);
         var _loc4_:*;
         (_loc4_ = new Binary()).bitWriteUnsignedInt(4,_loc2_);
         var _loc5_:uint = _loc2_ == 0 ? GlobalProperties.BIT_SKIN_ID : (_loc2_ == 1 ? GlobalProperties.BIT_MAP_ID : GlobalProperties.BIT_FX_ID);
         if(this.txt_cache_id.text.length)
         {
            _loc4_.bitWriteBoolean(true);
            _loc6_ = this.txt_cache_id.text.split(",");
            _loc7_ = 0;
            while(_loc7_ < _loc6_.length)
            {
               _loc4_.bitWriteBoolean(true);
               _loc4_.bitWriteUnsignedInt(_loc5_,uint(_loc6_[_loc7_]));
               _loc7_++;
            }
         }
         else
         {
            _loc4_.bitWriteBoolean(false);
         }
         _loc3_.bitWriteBinaryData(_loc4_);
         GlobalConsoleProperties.console.blablaland.send(_loc3_);
      }
      
      public function btApplyEvt(param1:Event) : *
      {
         var _loc2_:URLVariables = new URLVariables();
         _loc2_.ACT = "SET";
         _loc2_.MAX_CON = this.vs_maxcon.value;
         _loc2_.SESSION = GlobalConsoleProperties.console.session;
         _loc2_.CACHE = new Date().getTime();
         var _loc3_:URLRequest = new URLRequest(GlobalProperties.scriptAdr + "console/advServer.php");
         _loc3_.method = "POST";
         _loc3_.data = _loc2_;
         var _loc4_:URLLoader;
         (_loc4_ = new URLLoader()).dataFormat = "variables";
         _loc4_.load(_loc3_);
         _loc4_.addEventListener("complete",this.onApplyUrlMessage,false,0,true);
         mouseChildren = false;
         alpha = 0.5;
      }
      
      public function onApplyUrlMessage(param1:Event) : *
      {
         var _loc2_:* = undefined;
         param1.currentTarget.removeEventListener("complete",this.onApplyUrlMessage,false);
         if(param1.currentTarget.data.RESULT == 1)
         {
            mouseChildren = true;
            alpha = 1;
            _loc2_ = new SocketMessage();
            _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,4);
            _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,14);
            GlobalConsoleProperties.console.blablaland.send(_loc2_);
         }
      }
      
      public function btKillEvent(param1:Event) : *
      {
         var _loc2_:* = new SocketMessage();
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,4);
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,16);
         _loc2_.bitWriteString(this.txt_killMotif.text);
         _loc2_.bitWriteBoolean(this.chk_reboot.value);
         GlobalConsoleProperties.console.blablaland.send(_loc2_);
      }
   }
}
