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
   
   [Embed(source="/_assets/assets.swf", symbol="consolebbl.application.DailyMessage")]
   public class DailyMessage extends MovieClip
   {
       
      
      public var liste:List;
      
      public var bt_new:SimpleButton;
      
      public var bt_del:SimpleButton;
      
      public var bt_save:SimpleButton;
      
      public var txt_content:TextField;
      
      public var ch_multi:CheckBox;
      
      public var ch_new:CheckBox;
      
      public var ch_old:CheckBox;
      
      public function DailyMessage()
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
            parent.height = 310;
            Object(parent).redraw();
            this.liste.size = 9;
            this.liste.addEventListener("onClick",this.onListClick,false,0,true);
            this.bt_new.addEventListener("click",this.onNewEvt,false,0,true);
            this.bt_del.addEventListener("click",this.onDelEvt,false,0,true);
            this.bt_save.addEventListener("click",this.onSaveEvt,false,0,true);
            this.ch_new.addEventListener("onChanged",this.onChNewOldChange,false,0,true);
            this.ch_old.addEventListener("onChanged",this.onChNewOldChange,false,0,true);
            this.loadList();
         }
      }
      
      public function onChNewOldChange(param1:Event = null) : *
      {
         if(param1.currentTarget == this.ch_new && this.ch_new.value)
         {
            this.ch_old.value = false;
         }
         if(param1.currentTarget == this.ch_old && this.ch_old.value)
         {
            this.ch_new.value = false;
         }
      }
      
      public function onSaveEvt(param1:Event = null) : *
      {
         var _loc3_:URLVariables = null;
         var _loc4_:URLRequest = null;
         var _loc5_:URLLoader = null;
         var _loc2_:* = this.liste.node.getSelectedList();
         if(_loc2_.length)
         {
            _loc3_ = new URLVariables();
            _loc3_.SESSION = GlobalConsoleProperties.console.session;
            _loc3_.CACHE = new Date().getTime();
            _loc3_.SAVEONE = 1;
            _loc3_.TEXT = this.txt_content.htmlText;
            _loc3_.MULTI = Number(this.ch_multi.value);
            _loc3_.NEW = Number(this.ch_new.value);
            _loc3_.OLD = Number(this.ch_old.value);
            _loc3_.SAVEID = _loc2_[0].data.ID;
            (_loc4_ = new URLRequest(GlobalProperties.scriptAdr + "console/dailyMessage.php")).method = "POST";
            _loc4_.data = _loc3_;
            (_loc5_ = new URLLoader()).dataFormat = "variables";
            _loc5_.load(_loc4_);
            _loc5_.addEventListener("complete",this.onAdded,false,0,true);
            mouseChildren = false;
            alpha = 0.5;
         }
      }
      
      public function onDelEvt(param1:Event = null) : *
      {
         var _loc3_:URLVariables = null;
         var _loc4_:URLRequest = null;
         var _loc5_:URLLoader = null;
         var _loc2_:* = this.liste.node.getSelectedList();
         if(_loc2_.length)
         {
            _loc3_ = new URLVariables();
            _loc3_.SESSION = GlobalConsoleProperties.console.session;
            _loc3_.CACHE = new Date().getTime();
            _loc3_.DELONE = 1;
            _loc3_.REMOVEID = _loc2_[0].data.ID;
            (_loc4_ = new URLRequest(GlobalProperties.scriptAdr + "console/dailyMessage.php")).method = "POST";
            _loc4_.data = _loc3_;
            (_loc5_ = new URLLoader()).dataFormat = "variables";
            _loc5_.load(_loc4_);
            _loc5_.addEventListener("complete",this.onGetList,false,0,true);
            mouseChildren = false;
            alpha = 0.5;
         }
      }
      
      public function onNewEvt(param1:Event = null) : *
      {
         var _loc2_:URLVariables = new URLVariables();
         _loc2_.SESSION = GlobalConsoleProperties.console.session;
         _loc2_.CACHE = new Date().getTime();
         _loc2_.NEWONE = 1;
         var _loc3_:URLRequest = new URLRequest(GlobalProperties.scriptAdr + "console/dailyMessage.php");
         _loc3_.method = "POST";
         _loc3_.data = _loc2_;
         var _loc4_:URLLoader;
         (_loc4_ = new URLLoader()).dataFormat = "variables";
         _loc4_.load(_loc3_);
         _loc4_.addEventListener("complete",this.onAdded,false,0,true);
         mouseChildren = false;
         alpha = 0.5;
      }
      
      public function onAdded(param1:Event) : *
      {
         var _loc2_:uint = 0;
         param1.currentTarget.removeEventListener("complete",this.onAdded,false);
         if(param1.currentTarget.data.RESULT == 1)
         {
            mouseChildren = true;
            alpha = 1;
            this.parseList(URLLoader(param1.currentTarget));
            _loc2_ = 0;
            while(_loc2_ < this.liste.node.childNode.length)
            {
               if(this.liste.node.childNode[_loc2_].data.ID == param1.currentTarget.data.ID)
               {
                  this.liste.node.childNode[_loc2_].selected = true;
                  break;
               }
               _loc2_++;
            }
            this.liste.redraw();
            this.updateSelected();
         }
      }
      
      public function loadList(param1:Event = null) : *
      {
         var _loc2_:URLVariables = new URLVariables();
         _loc2_.SESSION = GlobalConsoleProperties.console.session;
         _loc2_.CACHE = new Date().getTime();
         _loc2_.GETLIST = 1;
         var _loc3_:URLRequest = new URLRequest(GlobalProperties.scriptAdr + "console/dailyMessage.php");
         _loc3_.method = "POST";
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
         param1.currentTarget.removeEventListener("complete",this.onGetList,false);
         if(param1.currentTarget.data.RESULT == 1)
         {
            mouseChildren = true;
            alpha = 1;
            this.parseList(URLLoader(param1.currentTarget));
            this.updateSelected();
         }
      }
      
      public function updateSelected() : *
      {
         var _loc1_:* = this.liste.node.getSelectedList();
         if(_loc1_.length)
         {
            this.txt_content.htmlText = _loc1_[0].data.TEXT;
            this.ch_multi.value = _loc1_[0].data.MULTI == 1;
            this.ch_new.value = false;
            this.ch_old.value = false;
         }
         else
         {
            this.txt_content.htmlText = "";
         }
      }
      
      public function parseList(param1:URLLoader) : *
      {
         var _loc3_:ListTreeNode = null;
         this.liste.node.removeAllChild();
         var _loc2_:uint = 0;
         while(_loc2_ < param1.data.NB)
         {
            _loc3_ = ListTreeNode(this.liste.node.addChild());
            _loc3_.data.ID = param1.data["ID_" + _loc2_];
            _loc3_.data.TEXT = param1.data["TEXT_" + _loc2_];
            _loc3_.data.MULTI = Number(param1.data["MULTI_" + _loc2_]);
            _loc3_.icon = !!_loc3_.data.MULTI ? "on" : "off";
            this.txt_content.htmlText = _loc3_.data.TEXT;
            _loc3_.text = this.txt_content.text.split("\r").join(" ").substring(0,100);
            _loc2_++;
         }
         this.liste.redraw();
      }
      
      public function onListClick(param1:ListGraphicEvent) : *
      {
         this.liste.node.unSelectAllItem();
         param1.graphic.node.selected = true;
         this.liste.redraw();
         this.updateSelected();
      }
      
      public function onKill(param1:Event) : *
      {
      }
   }
}
