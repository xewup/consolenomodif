package consolebbl
{
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="consolebbl.ConsoleMenu")]
   public class ConsoleMenu extends Sprite
   {
       
      
      public var bt_search:SimpleButton;
      
      public var bt_param:SimpleButton;
      
      public var bt_chat:SimpleButton;
      
      public var bt_memory:SimpleButton;
      
      public var bt_camera:SimpleButton;
      
      public var bt_insultron:SimpleButton;
      
      public var bt_deco:SimpleButton;
      
      public var bt_assistance:SimpleButton;
      
      public function ConsoleMenu()
      {
         super();
         this.bt_chat.addEventListener("click",this.onChat,false,0,true);
         this.bt_search.addEventListener("click",this.onSearch,false,0,true);
         this.bt_param.addEventListener("click",this.onParams,false,0,true);
         this.bt_memory.addEventListener("click",this.onMemory,false,0,true);
         this.bt_camera.addEventListener("click",this.onCamera,false,0,true);
         this.bt_insultron.addEventListener("click",this.onInsultron,false,0,true);
         this.bt_deco.addEventListener("click",this.onDeconnect,false,0,true);
         this.bt_assistance.addEventListener("click",this.onAssistance,false,0,true);
      }
      
      public function onChat(param1:Event) : *
      {
         this.dispatchEvent(new Event("onChat"));
      }
      
      public function onSearch(param1:Event) : *
      {
         this.dispatchEvent(new Event("onSearch"));
      }
      
      public function onParams(param1:Event) : *
      {
         this.dispatchEvent(new Event("onParams"));
      }
      
      public function onMemory(param1:Event) : *
      {
         this.dispatchEvent(new Event("onMemory"));
      }
      
      public function onCamera(param1:Event) : *
      {
         this.dispatchEvent(new Event("onCamera"));
      }
      
      public function onInsultron(param1:Event) : *
      {
         this.dispatchEvent(new Event("onInsultron"));
      }
      
      public function onDeconnect(param1:Event) : *
      {
         this.dispatchEvent(new Event("onDeconnect"));
      }
      
      public function onAssistance(param1:Event) : *
      {
         this.dispatchEvent(new Event("onAssistance"));
      }
   }
}
