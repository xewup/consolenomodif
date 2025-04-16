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
   import flash.text.TextField;
   import ui.DragDropItem;
   import ui.Scroll;
   
   [Embed(source="/_assets/assets.swf", symbol="consolebbl.application.Assistance")]
   public class Assistance extends MovieClip
   {
       
      
      public var txt_message:TextField;
      
      public var bt_send:SimpleButton;
      
      public var dragDrop:DragDropItem;
      
      public var discut_scr:Scroll;
      
      public function Assistance()
      {
         super();
         this.addEventListener(Event.ADDED,this.popinit,false,0,true);
         this.txt_message.text = "";
      }
      
      public function popinit(param1:Event) : *
      {
         if(stage)
         {
            this.removeEventListener(Event.ADDED,this.popinit,false);
            parent.width = 310;
            parent.height = 170;
            Object(parent).redraw();
            this.txt_message.addEventListener(Event.CHANGE,this.onDiscutChange,false,0,true);
            this.txt_message.addEventListener(Event.SCROLL,this.onDiscutChange,false,0,true);
            this.dragDrop = GlobalConsoleProperties.console.dragDrop.addItem();
            this.dragDrop.addEventListener("onTestDrag",this.onTestDrag,false,0,true);
            this.dragDrop.addEventListener("onAdd",this.onAdd,false,0,true);
            this.dragDrop.targetSprite = this;
            this.discut_scr.size = this.txt_message.height;
            this.discut_scr.addEventListener("onChanged",this.updateDiscutByScroll,false,0,true);
            this.discut_scr.value = 1;
            this.bt_send.addEventListener("click",this.onSend);
         }
      }
      
      public function onSend(param1:Event) : *
      {
         var _loc2_:URLVariables = new URLVariables();
         _loc2_.SESSION = GlobalConsoleProperties.console.session;
         _loc2_.MESSAGE = this.txt_message.text;
         _loc2_.CACHE = new Date().getTime();
         var _loc3_:URLRequest = new URLRequest(GlobalProperties.scriptAdr + "console/assistance.php");
         _loc3_.method = "POST";
         _loc3_.data = _loc2_;
         var _loc4_:URLLoader;
         (_loc4_ = new URLLoader()).dataFormat = "text";
         _loc4_.load(_loc3_);
         Object(parent).close();
      }
      
      public function onDiscutChange(param1:Event) : *
      {
         this.discut_scr.value = this.txt_message.maxScrollV <= 1 ? 0 : (this.txt_message.scrollV - 1) / (this.txt_message.maxScrollV - 1);
      }
      
      public function updateDiscutByScroll(param1:Event = null) : *
      {
         this.txt_message.scrollV = (this.txt_message.maxScrollV - 1) * this.discut_scr.value + 1;
      }
      
      public function onAdd(param1:Event) : *
      {
         this.dragDrop.system.dragger.data.UID;
         this.txt_message.appendText("\n");
         this.txt_message.appendText("UID : " + this.dragDrop.system.dragger.data.UID + "\n");
         this.txt_message.appendText("PSEUDO : " + this.dragDrop.system.dragger.data.PSEUDO + "\n");
         this.txt_message.appendText("\n");
      }
      
      public function onTestDrag(param1:Event) : *
      {
         this.dragDrop.isTarget = this.dragDrop.system.dragger.data.TYPE == "USER" && this.dragDrop.overTarget;
      }
      
      public function onKill(param1:Event) : *
      {
      }
   }
}
