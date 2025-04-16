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
   import ui.List;
   import ui.ListGraphicEvent;
   import ui.ListTreeNode;
   
   [Embed(source="/_assets/assets.swf", symbol="consolebbl.application.MailerAdmin")]
   public class MailerAdmin extends MovieClip
   {
       
      
      public var liste:List;
      
      public var bt_transmit:SimpleButton;
      
      public function MailerAdmin()
      {
         super();
         this.addEventListener(Event.ADDED,this.init,false,0,true);
      }
      
      public function init(param1:Event) : *
      {
         if(stage)
         {
            this.removeEventListener(Event.ADDED,this.init,false);
            parent.width = 220;
            parent.height = 200;
            Object(parent).redraw();
            this.liste.size = 9;
            this.liste.addEventListener("onClick",this.onListClick,false,0,true);
            this.bt_transmit.addEventListener("click",this.onBtTransmitEvt,false,0,true);
            this.loadList();
         }
      }
      
      public function onBtTransmitEvt(param1:Event = null) : *
      {
         var _loc3_:URLVariables = null;
         var _loc4_:URLRequest = null;
         var _loc5_:URLLoader = null;
         var _loc2_:* = this.liste.node.getSelectedList();
         if(_loc2_.length)
         {
            _loc3_ = new URLVariables();
            _loc3_.session = GlobalConsoleProperties.console.session;
            _loc3_.mailingid = _loc2_[0].data.ID;
            _loc3_.action = 2;
            _loc3_.CACHE = new Date().getTime();
            (_loc4_ = new URLRequest(GlobalProperties.scriptAdr + "console/mailerAdmin.php")).method = "GET";
            _loc4_.data = _loc3_;
            (_loc5_ = new URLLoader()).dataFormat = "variables";
            _loc5_.load(_loc4_);
            _loc5_.addEventListener("complete",this.onTransmitEvt,false,0,true);
            mouseChildren = false;
            alpha = 0.5;
         }
      }
      
      public function onTransmitEvt(param1:Event) : *
      {
         param1.currentTarget.removeEventListener("complete",this.onTransmitEvt,false);
         if(param1.currentTarget.data.RES)
         {
            mouseChildren = true;
            alpha = 1;
         }
         if(param1.currentTarget.data.RES == "0")
         {
            GlobalConsoleProperties.console.msgPopup.open({
               "APP":PopupMessage,
               "TITLE":"Attention..."
            },{
               "MSG":"Processus deja en cours d\'éxecution.",
               "ACTION":"OK"
            });
         }
      }
      
      public function loadList(param1:Event = null) : *
      {
         var _loc2_:URLVariables = new URLVariables();
         _loc2_.session = GlobalConsoleProperties.console.session;
         _loc2_.CACHE = new Date().getTime();
         _loc2_.action = 1;
         var _loc3_:URLRequest = new URLRequest(GlobalProperties.scriptAdr + "console/mailerAdmin.php");
         _loc3_.method = "GET";
         _loc3_.data = _loc2_;
         var _loc4_:URLLoader;
         (_loc4_ = new URLLoader()).dataFormat = "variables";
         _loc4_.load(_loc3_);
         _loc4_.addEventListener("complete",this.onGetList,false,0,true);
         mouseChildren = false;
         alpha = 0.5;
      }
      
      public function onGetList(param1:Event) : *
      {
         var _loc2_:URLLoader = null;
         var _loc3_:uint = 0;
         var _loc4_:ListTreeNode = null;
         _loc2_ = URLLoader(param1.currentTarget);
         _loc2_.removeEventListener("complete",this.onGetList,false);
         if(param1.currentTarget.data.RES == 1)
         {
            mouseChildren = true;
            alpha = 1;
            this.liste.node.removeAllChild();
            _loc3_ = 0;
            while(_loc3_ < _loc2_.data.NB)
            {
               (_loc4_ = ListTreeNode(this.liste.node.addChild())).data.ID = _loc2_.data["MID_" + _loc3_];
               _loc4_.data.DESC = _loc2_.data["MDESC_" + _loc3_];
               _loc4_.text = _loc4_.data.DESC;
               _loc3_++;
            }
            this.liste.redraw();
         }
      }
      
      public function onListClick(param1:ListGraphicEvent) : *
      {
         this.liste.node.unSelectAllItem();
         param1.graphic.node.selected = true;
         this.liste.redraw();
      }
      
      public function onKill(param1:Event) : *
      {
      }
   }
}
