package consolebbl.application
{
   import bbl.BblTrackerUser;
   import bbl.GlobalProperties;
   import consolebbl.GlobalConsoleProperties;
   import flash.display.MovieClip;
   import flash.events.Event;
   import ui.List;
   import ui.ListGraphicEvent;
   import ui.ListTreeNode;
   
   [Embed(source="/_assets/assets.swf", symbol="consolebbl.application.InsultronViewer")]
   public class InsultronViewer extends MovieClip
   {
       
      
      public var liste:List;
      
      public function InsultronViewer()
      {
         super();
         this.addEventListener(Event.ADDED,this.init,false,0,true);
      }
      
      public function init(param1:Event) : *
      {
         if(stage)
         {
            Object(parent).resizer.visible = true;
            this.removeEventListener(Event.ADDED,this.init,false);
            parent.height = !!GlobalProperties.sharedObject.data.POPUP.INSULTRONVIEW_H ? Number(GlobalProperties.sharedObject.data.POPUP.INSULTRONVIEW_H) : 180;
            parent.addEventListener("onKill",this.onKill,false,0,true);
            parent.addEventListener("onResized",this.onResized,false,0,true);
            this.liste.addEventListener("onIconClick",this.onListIconClick,false,0,true);
            this.liste.addEventListener("onClick",this.onListClick,false,0,true);
            this.liste.size = 0;
            GlobalConsoleProperties.console.addEventListener("onInsultronChange",this.onInsultronChange,false,0,true);
            this.onInsultronChange();
            this.onResized();
            Object(parent).redraw();
         }
      }
      
      public function onListIconClick(param1:ListGraphicEvent) : *
      {
         this.liste.node.removeChild(param1.graphic.node);
         GlobalConsoleProperties.console.removeInsultronUser(param1.graphic.node.data.UID);
         this.liste.redraw();
      }
      
      public function onListClick(param1:ListGraphicEvent) : *
      {
         var _loc2_:String = "track_UID_" + param1.graphic.node.data.UID;
         var _loc3_:Object = new Object();
         _loc3_.IP = param1.graphic.node.data.IP;
         _loc3_.UID = param1.graphic.node.data.UID;
         _loc3_.PSEUDO = param1.graphic.node.data.PSEUDO;
         _loc3_.INSULTRON = param1.graphic.node.data.USER.msgList;
         GlobalConsoleProperties.console.winPopup.open({
            "APP":AffUserTracker,
            "ID":_loc2_,
            "TITLE":"Poursuite : " + param1.graphic.node.data.PSEUDO
         },_loc3_);
      }
      
      public function onInsultronChange(param1:Event = null) : *
      {
         var i:uint;
         var user:BblTrackerUser = null;
         var it:ListTreeNode = null;
         var evt:Event = param1;
         this.liste.node.removeAllChild();
         i = 0;
         while(i < GlobalConsoleProperties.console.insultronUserList.length)
         {
            user = GlobalConsoleProperties.console.insultronUserList[i];
            if(user.ptsAlertVisible)
            {
               it = ListTreeNode(this.liste.node.addChild());
               it.data.USER = user;
               it.data.PSEUDO = user.pseudo;
               it.data.UID = user.uid;
               it.data.IP = user.ip;
               it.data.PTS = user.ptsAlert;
               it.text = "[" + Math.round(it.data.PTS) + "] " + it.data.PSEUDO;
               it.icon = "remove";
            }
            i++;
         }
         this.liste.node.childNode.sort(function(param1:*, param2:*):*
         {
            return param1.data.PTS < param2.data.PTS ? 1 : (param1.data.PTS > param2.data.PTS ? -1 : 0);
         });
         this.liste.redraw();
      }
      
      public function onResized(param1:Event = null) : *
      {
         parent.width = 220;
         parent.height = Math.max(parent.height,100);
         parent.height = Math.min(parent.height,400);
         this.redrawSize();
      }
      
      public function redrawSize() : *
      {
         GlobalProperties.sharedObject.data.POPUP.INSULTRONVIEW_H = parent.height;
         var _loc1_:uint = this.liste.size;
         this.liste.size = Math.floor((parent.height - 4) / this.liste.graphicHeight);
         if(_loc1_ != this.liste.size)
         {
            this.liste.redraw();
         }
      }
      
      public function onKill(param1:Event) : *
      {
         GlobalConsoleProperties.console.removeEventListener("onInsultronChange",this.onInsultronChange,false);
      }
   }
}
