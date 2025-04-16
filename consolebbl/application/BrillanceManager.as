package consolebbl.application
{
   import bbl.GlobalProperties;
   import consolebbl.GlobalConsoleProperties;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import fx.UserFx;
   import net.SocketMessage;
   import ui.CheckBox;
   import ui.ColorPanel;
   
   [Embed(source="/_assets/assets.swf", symbol="consolebbl.application.BrillanceManager")]
   public class BrillanceManager extends MovieClip
   {
       
      
      public var bt_save:SimpleButton;
      
      public var ch_brille:CheckBox;
      
      public var palette:ColorPanel;
      
      private var demoSkin:UserFx;
      
      public function BrillanceManager()
      {
         super();
         this.addEventListener(Event.ADDED,this.init,false,0,true);
         this.bt_save.addEventListener("click",this.onSave,false,0,true);
         this.palette.addEventListener("onChanged",this.updateDemo,false,0,true);
         this.ch_brille.addEventListener("onChanged",this.updateDemo,false,0,true);
         this.demoSkin = new UserFx();
         this.addChild(this.demoSkin);
         this.demoSkin.skinId = 0;
         this.demoSkin.action = 10;
         this.demoSkin.x = 120;
         this.demoSkin.y = 245;
         this.demoSkin.skinColor.setValue([2,0,4,5,6]);
         mouseChildren = false;
         alpha = 0.5;
      }
      
      public function init(param1:Event) : *
      {
         var _loc2_:URLVariables = null;
         var _loc3_:URLRequest = null;
         var _loc4_:URLLoader = null;
         if(stage)
         {
            this.removeEventListener(Event.ADDED,this.init,false);
            parent.width = 160;
            parent.height = 270;
            Object(parent).redraw();
            parent.addEventListener("onKill",this.onKill,false,0,true);
            _loc2_ = new URLVariables();
            _loc2_.SESSION = GlobalConsoleProperties.console.session;
            _loc2_.CACHE = new Date().getTime();
            _loc3_ = new URLRequest(GlobalProperties.scriptAdr + "console/getLightEffect.php");
            _loc3_.method = "POST";
            _loc3_.data = _loc2_;
            (_loc4_ = new URLLoader()).dataFormat = "variables";
            _loc4_.load(_loc3_);
            _loc4_.addEventListener("complete",this.onUrlMessage,false,0,true);
         }
      }
      
      public function updateDemo(param1:Event = null) : *
      {
         this.demoSkin.lightEffect = this.ch_brille.value;
         this.demoSkin.lightEffectColor = this.palette.DEC;
         this.demoSkin.updateLightEffect();
      }
      
      public function onKill(param1:Event) : *
      {
      }
      
      public function onSave(param1:Event) : *
      {
         var _loc2_:* = new SocketMessage();
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,4);
         _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,2);
         _loc2_.bitWriteBoolean(this.ch_brille.value);
         _loc2_.bitWriteUnsignedInt(24,this.palette.DEC);
         GlobalConsoleProperties.console.blablaland.send(_loc2_);
         var _loc3_:URLVariables = new URLVariables();
         _loc3_.SESSION = GlobalConsoleProperties.console.session;
         _loc3_.LIGHT = Number(this.ch_brille.value);
         _loc3_.COLOR = this.palette.DEC;
         _loc3_.CACHE = new Date().getTime();
         var _loc4_:URLRequest;
         (_loc4_ = new URLRequest(GlobalProperties.scriptAdr + "console/setLightEffect.php")).method = "POST";
         _loc4_.data = _loc3_;
         var _loc5_:URLLoader;
         (_loc5_ = new URLLoader()).dataFormat = "variables";
         _loc5_.load(_loc4_);
         _loc5_.addEventListener("complete",this.onUrlSaved,false,0,true);
         mouseChildren = false;
         alpha = 0.5;
      }
      
      public function onUrlSaved(param1:Event) : *
      {
         mouseChildren = true;
         alpha = 1;
      }
      
      public function onUrlMessage(param1:Event) : *
      {
         param1.currentTarget.removeEventListener("complete",this.onUrlMessage,false);
         if(param1.currentTarget.data.RESULT == 1)
         {
            this.ch_brille.value = Boolean(Number(param1.currentTarget.data.LIGHT));
            this.palette.DEC = Number(param1.currentTarget.data.COLOR);
            mouseChildren = true;
            alpha = 1;
            this.updateDemo();
         }
      }
   }
}
