package consolebbl.application
{
   import bbl.GlobalProperties;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import ui.CheckBox;
   import ui.ValueSelector;
   
   [Embed(source="/_assets/assets.swf", symbol="consolebbl.application.ReglagesManager")]
   public class ReglagesManager extends MovieClip
   {
       
      
      public var bt_autodetect:SimpleButton;
      
      public var vs_rain:ValueSelector;
      
      public var vs_qgraph:ValueSelector;
      
      public var vs_move:ValueSelector;
      
      public var vs_volume:ValueSelector;
      
      public var vs_volume_amb:ValueSelector;
      
      public var vs_volume_action:ValueSelector;
      
      public var vs_volume_interface:ValueSelector;
      
      public var ch_scroll:CheckBox;
      
      public function ReglagesManager()
      {
         super();
         this.addEventListener(Event.ADDED,this.init,false,0,true);
      }
      
      public function init(param1:Event) : *
      {
         if(stage)
         {
            this.removeEventListener(Event.ADDED,this.init,false);
            parent.width = 240;
            parent.height = 265;
            Object(parent).redraw();
            this.bt_autodetect.addEventListener("click",this.onUserAutoDetect,false,0,true);
            this.ch_scroll.addEventListener("onChanged",this.onUserChange,false,0,true);
            this.vs_rain.addEventListener("onFixed",this.onUserChange,false,0,true);
            this.vs_qgraph.addEventListener("onFixed",this.onUserChange,false,0,true);
            this.vs_move.addEventListener("onFixed",this.onUserChange,false,0,true);
            this.vs_volume.addEventListener("onChanged",this.onUserChange,false,0,true);
            this.vs_volume_amb.addEventListener("onChanged",this.onUserChange,false,0,true);
            this.vs_volume_action.addEventListener("onChanged",this.onUserChange,false,0,true);
            this.vs_volume_interface.addEventListener("onChanged",this.onUserChange,false,0,true);
            this.vs_qgraph.maxValue = 3;
            this.vs_qgraph.minValue = 1;
            this.vs_move.maxValue = 5;
            this.vs_move.minValue = 1;
            this.vs_rain.maxValue = 5;
            this.vs_rain.minValue = 1;
            this.vs_volume.maxValue = 100;
            this.vs_volume.minValue = 0;
            this.vs_volume_amb.maxValue = 100;
            this.vs_volume_amb.minValue = 0;
            this.vs_volume_action.maxValue = 100;
            this.vs_volume_action.minValue = 0;
            this.vs_volume_interface.maxValue = 100;
            this.vs_volume_interface.minValue = 0;
            this.readQuality();
         }
      }
      
      public function onUserAutoDetect(param1:Event) : *
      {
         GlobalProperties.sharedObject.data.QUALITY.quality.autoDetect();
         this.readQuality();
      }
      
      public function onUserChange(param1:Event) : *
      {
         if(param1.currentTarget == this.ch_scroll)
         {
            GlobalProperties.sharedObject.data.QUALITY.quality.scrollMode = Number(this.ch_scroll.value);
         }
         if(param1.currentTarget == this.vs_rain)
         {
            GlobalProperties.sharedObject.data.QUALITY.quality.rainRateQuality = this.vs_rain.value;
         }
         if(param1.currentTarget == this.vs_qgraph)
         {
            GlobalProperties.sharedObject.data.QUALITY.quality.graphicQuality = this.vs_qgraph.value;
         }
         if(param1.currentTarget == this.vs_move)
         {
            GlobalProperties.sharedObject.data.QUALITY.quality.persoMoveQuality = this.vs_move.value;
         }
         if(param1.currentTarget == this.vs_volume)
         {
            GlobalProperties.sharedObject.data.QUALITY.quality.generalVolume = this.vs_volume.value / 100;
         }
         if(param1.currentTarget == this.vs_volume_amb)
         {
            GlobalProperties.sharedObject.data.QUALITY.quality.ambiantVolume = this.vs_volume_amb.value / 100;
         }
         if(param1.currentTarget == this.vs_volume_interface)
         {
            GlobalProperties.sharedObject.data.QUALITY.quality.interfaceVolume = this.vs_volume_interface.value / 100;
         }
         if(param1.currentTarget == this.vs_volume_action)
         {
            GlobalProperties.sharedObject.data.QUALITY.quality.actionVolume = this.vs_volume_action.value / 100;
         }
      }
      
      internal function readQuality() : *
      {
         this.ch_scroll.value = GlobalProperties.sharedObject.data.QUALITY.quality.scrollMode == 1;
         this.vs_rain.value = GlobalProperties.sharedObject.data.QUALITY.quality.rainRateQuality;
         this.vs_qgraph.value = GlobalProperties.sharedObject.data.QUALITY.quality.graphicQuality;
         this.vs_move.value = GlobalProperties.sharedObject.data.QUALITY.quality.persoMoveQuality;
         this.vs_volume.value = GlobalProperties.sharedObject.data.QUALITY.quality.generalVolume * 100;
         this.vs_volume_amb.value = GlobalProperties.sharedObject.data.QUALITY.quality.ambiantVolume * 100;
         this.vs_volume_action.value = GlobalProperties.sharedObject.data.QUALITY.quality.actionVolume * 100;
         this.vs_volume_interface.value = GlobalProperties.sharedObject.data.QUALITY.quality.interfaceVolume * 100;
      }
   }
}
