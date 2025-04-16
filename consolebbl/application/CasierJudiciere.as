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
   import flash.net.navigateToURL;
   import flash.text.TextField;
   import net.SocketMessage;
   
   [Embed(source="/_assets/assets.swf", symbol="consolebbl.application.CasierJudiciere")]
   public class CasierJudiciere extends MovieClip
   {
       
      
      public var bt_see_casier:SimpleButton;
      
      public var bt_addnew:SimpleButton;
      
      public var txt_newdata:TextField;
      
      public var bt_free:SimpleButton;
      
      public var txt_motiffree:TextField;
      
      public function CasierJudiciere()
      {
         super();
         this.addEventListener(Event.ADDED,this.init,false,0,true);
      }
      
      public function init(param1:Event) : *
      {
         if(stage)
         {
            this.removeEventListener(Event.ADDED,this.init,false);
            parent.addEventListener("onKill",this.onKill,false,0,true);
            parent.width = 250;
            parent.height = 215;
            Object(parent).redraw();
            this.bt_see_casier.addEventListener("click",this.onSeeCasier,false,0,true);
            this.bt_addnew.addEventListener("click",this.onAddCasier,false,0,true);
            this.bt_free.addEventListener("click",this.onLibere,false,0,true);
         }
      }
      
      public function onSeeCasier(param1:Event) : *
      {
         var _loc2_:Object = Object(parent).data;
         navigateToURL(new URLRequest(GlobalProperties.scriptAdr + "console/casierJudiciere.php?&UID=" + _loc2_.UID + "&SESSION=" + GlobalConsoleProperties.console.session),"_blank");
      }
      
      public function onLibere(param1:Event) : *
      {
         var _loc2_:Object = null;
         var _loc3_:SocketMessage = null;
         if(GlobalConsoleProperties.console.rulesFreePrison <= GlobalConsoleProperties.console.blablaland.grade)
         {
            _loc2_ = Object(parent).data;
            if(this.txt_motiffree.text.length)
            {
               _loc3_ = new SocketMessage();
               _loc3_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,4);
               _loc3_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,12);
               _loc3_.bitWriteUnsignedInt(GlobalProperties.BIT_USER_ID,_loc2_.UID);
               _loc3_.bitWriteString(this.txt_motiffree.text);
               GlobalConsoleProperties.console.blablaland.send(_loc3_);
               this.txt_motiffree.text = "";
               GlobalConsoleProperties.console.msgPopup.open({
                  "APP":PopupMessage,
                  "TITLE":"Resultat...",
                  "DEPEND":this
               },{
                  "MSG":"Commande enregistrée, l\'action est inscrite au casier judiciere.",
                  "ACTION":"OK"
               });
            }
         }
         else
         {
            GlobalConsoleProperties.console.msgPopup.open({
               "APP":PopupMessage,
               "TITLE":"Attention :",
               "DEPEND":this
            },{
               "MSG":"Grade insuffisant pour liberer de prison !",
               "ACTION":"OK"
            });
         }
      }
      
      public function onAddCasier(param1:Event) : *
      {
         var _loc3_:URLVariables = null;
         var _loc4_:URLRequest = null;
         var _loc5_:URLLoader = null;
         var _loc2_:Object = Object(parent).data;
         if(this.txt_newdata.text.length)
         {
            _loc3_ = new URLVariables();
            _loc3_.SESSION = GlobalConsoleProperties.console.session;
            _loc3_.UID = _loc2_.UID;
            _loc3_.PSEUDO = _loc2_.PSEUDO;
            _loc3_.DATA = this.txt_newdata.text;
            _loc3_.CACHE = new Date().getTime();
            (_loc4_ = new URLRequest(GlobalProperties.scriptAdr + "console/casierJudiciereAdd.php")).method = "POST";
            _loc4_.data = _loc3_;
            (_loc5_ = new URLLoader()).dataFormat = "variables";
            _loc5_.load(_loc4_);
            _loc5_.addEventListener("complete",this.onUrlSaved,false,0,true);
            mouseChildren = false;
            alpha = 0.5;
            this.txt_newdata.text = "";
         }
      }
      
      public function onUrlSaved(param1:Event) : *
      {
         mouseChildren = true;
         alpha = 1;
         GlobalConsoleProperties.console.msgPopup.open({
            "APP":PopupMessage,
            "TITLE":"Resultat...",
            "DEPEND":this
         },{
            "MSG":"Info ajoutée au casier judiciere !",
            "ACTION":"OK"
         });
      }
      
      public function onKill(param1:Event) : *
      {
      }
   }
}
