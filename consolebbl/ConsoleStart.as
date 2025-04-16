package consolebbl
{
   import bbl.GlobalProperties;
   import bbl.InfoBulle;
   import consolebbl.application.Assistance;
   import consolebbl.application.ConsoleChatApp;
   import consolebbl.application.FreeCamera;
   import consolebbl.application.InsultronViewer;
   import consolebbl.application.Params;
   import consolebbl.application.RechercheUser;
   import consolebbl.application.UserMemory;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TextEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import fx.FxLoader;
   import ui.PopupItemBase;
   
   public class ConsoleStart extends ConsoleInsultron
   {
       
      
      public var menu:Sprite;
      
      private var infoBulleClip:InfoBulle;
      
      public function ConsoleStart()
      {
         super();
         this.infoBulleClip = null;
         this.menu = new ConsoleMenu();
         this.menu.addEventListener("onSearch",this.onSearch,false,0,true);
         this.menu.addEventListener("onParams",this.onParams,false,0,true);
         this.menu.addEventListener("onChat",this.onChat,false,0,true);
         this.menu.addEventListener("onMemory",this.onMemory,false,0,true);
         this.menu.addEventListener("onCamera",this.onCamera,false,0,true);
         this.menu.addEventListener("onInsultron",this.onInsultron,false,0,true);
         this.menu.addEventListener("onDeconnect",this.onDeconnect,false,0,true);
         this.menu.addEventListener("onAssistance",this.onAssistance,false,0,true);
      }
      
      override public function onQuit() : *
      {
         if(this.menu.parent)
         {
            removeChild(this.menu);
         }
         super.onQuit();
      }
      
      override public function onStart() : *
      {
         gotoAndStop("main");
         addChildAt(this.menu,0);
         super.onStart();
      }
      
      public function onChat(param1:Event) : *
      {
         winPopup.open({
            "APP":ConsoleChatApp,
            "ID":"modoChat",
            "TITLE":"Modo Chat"
         });
      }
      
      public function onSearch(param1:Event) : *
      {
         winPopup.open({
            "APP":RechercheUser,
            "TITLE":"Recherche.."
         });
      }
      
      public function onParams(param1:Event) : *
      {
         winPopup.open({
            "APP":Params,
            "ID":"params",
            "TITLE":"Paramètres.."
         });
      }
      
      public function onMemory(param1:Event) : *
      {
         winPopup.open({
            "APP":UserMemory,
            "TITLE":"Mémoire.."
         });
      }
      
      public function onCamera(param1:Event) : *
      {
         winPopup.open({
            "APP":FreeCamera,
            "TITLE":"Caméra.."
         });
      }
      
      public function onInsultron(param1:Event) : *
      {
         winPopup.open({
            "APP":InsultronViewer,
            "TITLE":"Comportement :"
         });
      }
      
      public function onAssistance(param1:Event) : *
      {
         winPopup.open({
            "APP":Assistance,
            "TITLE":"Assistance :"
         });
      }
      
      public function onDeconnect(param1:Event) : *
      {
         var _loc2_:URLVariables = new URLVariables();
         _loc2_.SESSION = session;
         _loc2_.CACHE = new Date().getTime();
         var _loc3_:URLRequest = new URLRequest(GlobalProperties.scriptAdr + "console/clearsession.php");
         _loc3_.method = "POST";
         _loc3_.data = _loc2_;
         var _loc4_:URLLoader;
         (_loc4_ = new URLLoader()).dataFormat = "variables";
         _loc4_.load(_loc3_);
         _loc4_.addEventListener("complete",this.onDeconnectMessage,false,0,true);
      }
      
      public function onDeconnectMessage(param1:Event) : *
      {
         var _loc2_:TextEvent = new TextEvent("FatalAlert");
         _loc2_.text = "Vous vous etes deconnecté de la console.";
         onFatalAlert(_loc2_);
      }
      
      public function openServerSelector(param1:Object) : Object
      {
         var _loc2_:Object = null;
         _loc2_ = winPopup.open({"CLASS":PopupItemBase});
         _loc2_.width = 300;
         _loc2_.height = 200;
         _loc2_.redraw();
         var _loc3_:MovieClip = new LoadingClip();
         _loc2_.addChild(_loc3_);
         _loc3_.x = _loc2_.width / 2;
         _loc3_.y = _loc2_.height / 2;
         param1.LC = _loc3_;
         param1.WIN = _loc2_;
         param1.GP = GlobalProperties;
         var _loc4_:FxLoader;
         (_loc4_ = new FxLoader()).clearInitData = false;
         _loc4_.initData = param1;
         _loc4_.addEventListener("onFxLoaded",this.onSelectorFxLoaded);
         _loc4_.loadFx(31);
         return _loc2_;
      }
      
      public function onSelectorFxLoaded(param1:Event) : *
      {
         var _loc2_:FxLoader = FxLoader(param1.currentTarget);
         if(_loc2_.initData.LC.parent)
         {
            _loc2_.initData.LC.parent.removeChild(_loc2_.initData.LC);
         }
         _loc2_.removeEventListener("onFxLoaded",this.onSelectorFxLoaded);
         var _loc3_:Object = new _loc2_.lastLoad.classRef();
         _loc2_.initData.WIN.addChild(MovieClip(_loc3_));
         _loc3_.init();
      }
      
      public function infoBulle(param1:String) : *
      {
         if(this.infoBulleClip)
         {
            this.infoBulleClip.dispose();
            this.infoBulleClip = null;
         }
         if(param1)
         {
            this.infoBulleClip = new InfoBulle();
            this.infoBulleClip.text = param1;
         }
      }
   }
}
