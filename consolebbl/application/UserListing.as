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
   import ui.CheckBox;
   import ui.List;
   import ui.ListGraphicEvent;
   import ui.ListTreeNode;
   import ui.ValueSelector;
   
   [Embed(source="/_assets/assets.swf", symbol="consolebbl.application.UserListing")]
   public class UserListing extends MovieClip
   {
       
      
      public var startAt:ValueSelector;
      
      public var liste:List;
      
      public var bt_prev:SimpleButton;
      
      public var bt_next:SimpleButton;
      
      public var bt_refresh:SimpleButton;
      
      public var ch_tri_0:CheckBox;
      
      public var ch_tri_1:CheckBox;
      
      public var ch_tri_2:CheckBox;
      
      public var txt_tri:TextField;
      
      private var tri:Array;
      
      public function UserListing()
      {
         super();
         this.addEventListener(Event.ADDED,this.init,false,0,true);
         this.tri = new Array();
      }
      
      public function init(param1:Event) : *
      {
         if(stage)
         {
            this.removeEventListener(Event.ADDED,this.init,false);
            parent.width = 220;
            parent.height = 290;
            Object(parent).redraw();
            parent.addEventListener("onKill",this.onKill,false,0,true);
            this.liste.size = 15;
            this.liste.addEventListener("onClick",this.clickevt,false,0,true);
            this.startAt.addEventListener("onFixed",this.loadList,false,0,true);
            this.bt_prev.addEventListener("click",this.btSlide,false,0,true);
            this.bt_next.addEventListener("click",this.btSlide,false,0,true);
            this.bt_refresh.addEventListener("click",this.loadList,false,0,true);
            this.startAt.minValue = 0;
            this.ch_tri_0.addEventListener("onChanged",this.triChange,false,0,true);
            this.ch_tri_1.addEventListener("onChanged",this.triChange,false,0,true);
            this.ch_tri_2.addEventListener("onChanged",this.triChange,false,0,true);
            this.ch_tri_0.value = true;
            this.ch_tri_1.value = true;
            this.ch_tri_1.dispatchEvent(new Event("onChanged"));
            this.ch_tri_0.dispatchEvent(new Event("onChanged"));
            this.loadList();
         }
      }
      
      public function triChange(param1:Event) : *
      {
         var _loc3_:uint = 0;
         var _loc2_:uint = uint(param1.currentTarget.name.split("_")[2]);
         if(param1.currentTarget.value)
         {
            this.tri.push(_loc2_);
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < this.tri.length)
            {
               if(this.tri[_loc3_] == _loc2_)
               {
                  this.tri.splice(_loc3_,1);
                  break;
               }
               _loc3_++;
            }
         }
         this.txt_tri.text = "";
         _loc3_ = 0;
         while(_loc3_ < this.tri.length)
         {
            if(this.tri[_loc3_] == 0)
            {
               this.txt_tri.appendText("PSEUDO ");
            }
            if(this.tri[_loc3_] == 1)
            {
               this.txt_tri.appendText("GRADE ");
            }
            if(this.tri[_loc3_] == 2)
            {
               this.txt_tri.appendText("ONLINE ");
            }
            _loc3_++;
         }
      }
      
      public function btSlide(param1:Event) : *
      {
         var _loc2_:uint = this.startAt.value;
         this.startAt.value += param1.currentTarget == this.bt_next ? 100 : -100;
         if(_loc2_ != this.startAt.value)
         {
            this.loadList();
         }
      }
      
      public function loadList(param1:Event = null) : *
      {
         var _loc2_:URLVariables = new URLVariables();
         _loc2_.SESSION = GlobalConsoleProperties.console.session;
         _loc2_.CACHE = new Date().getTime();
         _loc2_.START = this.startAt.value;
         var _loc3_:String = this.tri.join();
         _loc3_ = _loc3_.replace(/0/,"pseudo ASC");
         _loc3_ = _loc3_.replace(/1/,"grade DESC");
         _loc3_ = _loc3_.replace(/2/,"online DESC");
         _loc2_.SORTBY = _loc3_;
         var _loc4_:URLRequest;
         (_loc4_ = new URLRequest(GlobalProperties.scriptAdr + "console/getUserListing.php")).method = "POST";
         _loc4_.data = _loc2_;
         var _loc5_:URLLoader;
         (_loc5_ = new URLLoader()).dataFormat = "variables";
         _loc5_.load(_loc4_);
         _loc5_.addEventListener("complete",this.onUrlMessage,false,0,true);
         mouseChildren = false;
         alpha = 0.5;
      }
      
      public function onUrlMessage(param1:Event) : *
      {
         var _loc2_:uint = 0;
         var _loc3_:ListTreeNode = null;
         param1.currentTarget.removeEventListener("complete",this.onUrlMessage,false);
         if(param1.currentTarget.data.RESULT == 1)
         {
            mouseChildren = true;
            alpha = 1;
            this.liste.node.removeAllChild();
            _loc2_ = 0;
            while(_loc2_ < param1.currentTarget.data.NB)
            {
               _loc3_ = ListTreeNode(this.liste.node.addChild());
               _loc3_.data.UID = param1.currentTarget.data["UID_" + _loc2_];
               _loc3_.data.PSEUDO = param1.currentTarget.data["PSEUDO_" + _loc2_];
               _loc3_.data.IP = param1.currentTarget.data["IP_" + _loc2_];
               _loc3_.data.ONLINE = Number(param1.currentTarget.data["ONLINE_" + _loc2_]);
               _loc3_.text = (!!_loc3_.data.ONLINE ? "<font color=\'#FF0000\'>" : "") + _loc3_.data.PSEUDO + "</font>";
               _loc2_++;
            }
            this.liste.redraw();
            this.startAt.maxValue = param1.currentTarget.data.TOT;
         }
      }
      
      public function clickevt(param1:ListGraphicEvent) : *
      {
         var _loc2_:String = "track_UID_" + param1.graphic.node.data.UID;
         var _loc3_:Object = new Object();
         _loc3_.IP = param1.graphic.node.data.IP;
         _loc3_.UID = param1.graphic.node.data.UID;
         _loc3_.PSEUDO = param1.graphic.node.data.PSEUDO;
         GlobalConsoleProperties.console.winPopup.open({
            "APP":AffUserTracker,
            "ID":_loc2_,
            "TITLE":"Poursuite : " + param1.graphic.node.data.PSEUDO
         },_loc3_);
      }
      
      public function onKill(param1:Event) : *
      {
      }
   }
}
