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
   import flash.text.TextFieldType;
   import net.SocketMessage;
   import ui.List;
   import ui.ListGraphicEvent;
   import ui.ListTreeNode;
   import ui.ValueSelector;
   
   [Embed(source="/_assets/assets.swf", symbol="consolebbl.application.AKBManager")]
   public class AKBManager extends MovieClip
   {
       
      
      public var liste:List;
      
      public var bt_add:SimpleButton;
      
      public var bt_del:SimpleButton;
      
      public var bt_up:SimpleButton;
      
      public var bt_dn:SimpleButton;
      
      public var bt_save:SimpleButton;
      
      public var txt_desc:TextField;
      
      public var txt_motif:TextField;
      
      public var ban_dure:ValueSelector;
      
      public var lvl_mp:ValueSelector;
      
      public var lvl_kick:ValueSelector;
      
      public var lvl_ban:ValueSelector;
      
      public function AKBManager()
      {
         super();
         this.liste.addEventListener("onClick",this.clickevt,false,0,true);
         this.liste.size = 10;
         this.liste.graphicLink = ListGraphicShort;
         this.liste.graphicWidth = 80;
         this.liste.redraw();
         this.addEventListener(Event.ADDED,this.popinit,false,0,true);
         this.ban_dure.maxValue = 999;
      }
      
      public function popinit(param1:Event) : *
      {
         var _loc2_:Object = null;
         if(stage)
         {
            this.removeEventListener(Event.ADDED,this.popinit,false);
            parent.width = 330;
            parent.height = 180;
            Object(parent).redraw();
            parent.addEventListener("onKill",this.onKill,false,0,true);
            _loc2_ = Object(parent).data;
            GlobalConsoleProperties.console.addEventListener("onAKBChange",this.reloadList,false,0,true);
            this.reloadList();
            this.bt_save.addEventListener("click",this.saveList,false,0,true);
            this.bt_up.addEventListener("click",this.changePosEvt,false,0,true);
            this.bt_dn.addEventListener("click",this.changePosEvt,false,0,true);
            this.bt_del.addEventListener("click",this.removeAKB,false,0,true);
            this.bt_add.addEventListener("click",this.addAKB,false,0,true);
            this.lvl_ban.addEventListener("onFixed",this.setAKB,false,0,true);
            this.lvl_mp.addEventListener("onFixed",this.setAKB,false,0,true);
            this.lvl_kick.addEventListener("onFixed",this.setAKB,false,0,true);
            this.ban_dure.addEventListener("onFixed",this.setAKB,false,0,true);
            this.txt_motif.addEventListener("change",this.setAKB,false,0,true);
            this.txt_desc.addEventListener("change",this.setAKB,false,0,true);
         }
      }
      
      public function saveList(param1:Event) : *
      {
         var _loc2_:URLVariables = new URLVariables();
         _loc2_.SESSION = GlobalConsoleProperties.console.session;
         _loc2_.CACHE = new Date().getTime();
         var _loc3_:uint = 0;
         while(_loc3_ < this.liste.node.childNode.length)
         {
            _loc2_["DESC_" + _loc3_] = this.liste.node.childNode[_loc3_].data.AKB.desc;
            _loc2_["DURE_" + _loc3_] = this.liste.node.childNode[_loc3_].data.AKB.banDure;
            _loc2_["MOTIF_" + _loc3_] = this.liste.node.childNode[_loc3_].data.AKB.motif;
            _loc2_["LVLMP_" + _loc3_] = this.liste.node.childNode[_loc3_].data.AKB.lvlMp;
            _loc2_["LVLKICK_" + _loc3_] = this.liste.node.childNode[_loc3_].data.AKB.lvlKick;
            _loc2_["LVLBAN_" + _loc3_] = this.liste.node.childNode[_loc3_].data.AKB.lvlBan;
            _loc3_++;
         }
         _loc2_.NB = this.liste.node.childNode.length;
         var _loc4_:URLRequest;
         (_loc4_ = new URLRequest(GlobalProperties.scriptAdr + "console/setAKBList.php")).method = "POST";
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
         var _loc2_:* = undefined;
         param1.currentTarget.removeEventListener("complete",this.onUrlMessage,false);
         if(param1.currentTarget.data.RESULT == 1)
         {
            _loc2_ = new SocketMessage();
            _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,4);
            _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,4);
            GlobalConsoleProperties.console.blablaland.send(_loc2_);
         }
         else
         {
            this.reloadList();
         }
      }
      
      public function setAKB(param1:Event = null) : *
      {
         var _loc2_:* = this.liste.node.getSelectedList();
         if(_loc2_.length)
         {
            _loc2_[0].data.AKB.banDure = this.ban_dure.value;
            _loc2_[0].data.AKB.desc = this.txt_desc.text;
            _loc2_[0].data.AKB.motif = this.txt_motif.text;
            _loc2_[0].data.AKB.lvlMp = this.lvl_mp.value;
            _loc2_[0].data.AKB.lvlKick = this.lvl_kick.value;
            _loc2_[0].data.AKB.lvlBan = this.lvl_ban.value;
            _loc2_[0].text = _loc2_[0].data.AKB.desc;
            this.liste.redraw();
         }
      }
      
      public function showSelectedAKB() : *
      {
         var _loc1_:* = this.liste.node.getSelectedList();
         if(_loc1_.length)
         {
            this.lvl_mp.maxValue = Math.max(GlobalConsoleProperties.console.blablaland.grade,_loc1_[0].data.AKB.lvlMp);
            this.lvl_kick.maxValue = Math.max(GlobalConsoleProperties.console.blablaland.grade,_loc1_[0].data.AKB.lvlKick);
            this.lvl_ban.maxValue = Math.max(GlobalConsoleProperties.console.blablaland.grade,_loc1_[0].data.AKB.lvlBan);
            this.ban_dure.value = _loc1_[0].data.AKB.banDure;
            this.txt_desc.text = _loc1_[0].data.AKB.desc;
            this.txt_motif.text = _loc1_[0].data.AKB.motif;
            this.lvl_mp.value = _loc1_[0].data.AKB.lvlMp;
            this.lvl_kick.value = _loc1_[0].data.AKB.lvlKick;
            this.lvl_ban.value = _loc1_[0].data.AKB.lvlBan;
         }
         this.txt_desc.backgroundColor = _loc1_.length > 0 ? 16777215 : 14540253;
         this.txt_motif.backgroundColor = _loc1_.length > 0 ? 16777215 : 14540253;
         this.txt_desc.type = _loc1_.length > 0 ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
         this.txt_motif.type = _loc1_.length > 0 ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
         this.ban_dure.visible = _loc1_.length > 0;
         this.lvl_mp.visible = _loc1_.length > 0;
         this.lvl_kick.visible = _loc1_.length > 0;
         this.lvl_ban.visible = _loc1_.length > 0;
      }
      
      public function addAKB(param1:Event) : *
      {
         this.liste.node.unSelectAllItem();
         var _loc2_:ListTreeNode = ListTreeNode(this.liste.node.addChild());
         _loc2_.data.AKB = new AKBItem();
         _loc2_.data.AKB.lvlMp = GlobalConsoleProperties.console.blablaland.grade;
         _loc2_.data.AKB.lvlKick = GlobalConsoleProperties.console.blablaland.grade;
         _loc2_.data.AKB.lvlBan = GlobalConsoleProperties.console.blablaland.grade;
         _loc2_.text = _loc2_.data.AKB.desc;
         _loc2_.selected = true;
         this.liste.redraw();
         this.showSelectedAKB();
      }
      
      public function removeAKB(param1:Event) : *
      {
         var _loc2_:* = this.liste.node.getSelectedList();
         if(_loc2_.length)
         {
            this.liste.node.removeChild(_loc2_[0]);
            this.liste.redraw();
         }
         this.showSelectedAKB();
      }
      
      public function changePosEvt(param1:Event) : *
      {
         var _loc3_:* = undefined;
         var _loc2_:* = this.liste.node.getSelectedList();
         if(_loc2_.length)
         {
            _loc3_ = 0;
            while(_loc3_ < this.liste.node.childNode.length)
            {
               if(this.liste.node.childNode[_loc3_] == _loc2_[0])
               {
                  this.liste.node.swapChild(_loc2_[0],_loc3_ + (param1.currentTarget == this.bt_dn ? 1 : -1));
                  this.liste.redraw();
                  break;
               }
               _loc3_++;
            }
         }
      }
      
      public function reloadList(param1:Event = null) : *
      {
         var _loc4_:ListTreeNode = null;
         this.liste.node.removeAllChild();
         var _loc2_:* = GlobalConsoleProperties.console.AKBList;
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_.length)
         {
            (_loc4_ = ListTreeNode(this.liste.node.addChild())).data.AKB = _loc2_[_loc3_];
            _loc4_.text = _loc4_.data.AKB.desc;
            _loc3_++;
         }
         this.liste.redraw();
         this.showSelectedAKB();
         mouseChildren = true;
         alpha = 1;
      }
      
      public function clickevt(param1:ListGraphicEvent) : *
      {
         this.liste.node.unSelectAllItem();
         param1.graphic.node.selected = true;
         this.liste.redraw();
         this.showSelectedAKB();
      }
      
      public function onKill(param1:Event) : *
      {
         GlobalConsoleProperties.console.removeEventListener("onAKBChange",this.reloadList,false);
      }
   }
}
