package consolebbl
{
   import bbl.InterfaceSmiley;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.text.TextField;
   import ui.CheckBox;
   
   [Embed(source="/_assets/assets.swf", symbol="consolebbl.Interface")]
   public class Interface extends InterfaceSmiley
   {
       
      
      public var ch_map:CheckBox;
      
      public var ch_alluni:CheckBox;
      
      public var ch_allmap:CheckBox;
      
      public var ch_allmap_conf:CheckBox;
      
      public var btChangeMap:SimpleButton;
      
      public var btTracker:SimpleButton;
      
      public var txt_tracker:TextField;
      
      public function Interface()
      {
         super();
         this.ch_map.value = true;
         this.ch_map.addEventListener("onChanged",this.onChChanged,false,0,true);
         this.ch_alluni.value = false;
         this.ch_allmap.addEventListener("onChanged",this.onChChanged,false,0,true);
         this.ch_allmap_conf.value = true;
         this.btChangeMap.addEventListener("click",this.btOnChangeMap,false,0,true);
         this.btTracker.addEventListener("click",this.btOnTracker,false,0,true);
         this.txt_tracker.mouseEnabled = false;
      }
      
      public function onChChanged(param1:Event) : *
      {
         if(param1.currentTarget.value)
         {
            if(param1.currentTarget == this.ch_map)
            {
               this.ch_allmap.value = false;
            }
            else
            {
               this.ch_map.value = false;
            }
         }
         param1.currentTarget.value = true;
      }
      
      public function btOnChangeMap(param1:Event) : *
      {
         this.dispatchEvent(new Event("btChangeMap"));
      }
      
      public function btOnTracker(param1:Event) : *
      {
         this.dispatchEvent(new Event("btTracker"));
      }
   }
}
