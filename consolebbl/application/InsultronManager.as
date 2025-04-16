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
   import net.SocketMessage;
   import ui.CheckBox;
   import ui.List;
   import ui.ListGraphicEvent;
   import ui.ListTreeNode;
   import ui.ValueSelector;
   
   [Embed(source="/_assets/assets.swf", symbol="consolebbl.application.InsultronManager")]
   public class InsultronManager extends MovieClip
   {
       
      
      public var liste:List;
      
      public var bt_add:SimpleButton;
      
      public var bt_del:SimpleButton;
      
      public var bt_up:SimpleButton;
      
      public var bt_dn:SimpleButton;
      
      public var bt_save:SimpleButton;
      
      public var txt_query:TextField;
      
      public var txt_replace:TextField;
      
      public var txt_simuin:TextField;
      
      public var txt_simuout:TextField;
      
      public var txt_simupts:TextField;
      
      public var ch_censure:CheckBox;
      
      public var ch_public:CheckBox;
      
      public var ch_prive:CheckBox;
      
      public var ch_censureall:CheckBox;
      
      public var ch_extrachar:CheckBox;
      
      public var ch_simusel:CheckBox;
      
      public var vs_ptsalert:ValueSelector;
      
      public function InsultronManager()
      {
         super();
         this.liste.addEventListener("onClick",this.clickevt,false,0,true);
         this.liste.size = 10;
         this.vs_ptsalert.maxValue = 127;
         this.liste.redraw();
         this.addEventListener(Event.ADDED,this.popinit,false,0,true);
      }
      
      public function popinit(param1:Event) : *
      {
         if(stage)
         {
            this.removeEventListener(Event.ADDED,this.popinit,false);
            parent.width = 450;
            parent.height = 270;
            Object(parent).redraw();
            parent.addEventListener("onKill",this.onKill,false,0,true);
            this.reloadList();
            this.bt_save.addEventListener("click",this.saveList,false,0,true);
            this.bt_up.addEventListener("click",this.changePosEvt,false,0,true);
            this.bt_dn.addEventListener("click",this.changePosEvt,false,0,true);
            this.bt_del.addEventListener("click",this.removeAKB,false,0,true);
            this.bt_add.addEventListener("click",this.addAKB,false,0,true);
            this.txt_query.addEventListener("change",this.setAKB,false,0,true);
            this.txt_replace.addEventListener("change",this.setAKB,false,0,true);
            this.txt_simuin.addEventListener("change",this.simuInsultron,false,0,true);
            this.vs_ptsalert.addEventListener("onChanged",this.setAKB,false,0,true);
            this.ch_public.addEventListener("onChanged",this.setAKB,false,0,true);
            this.ch_censure.addEventListener("onChanged",this.setAKB,false,0,true);
            this.ch_prive.addEventListener("onChanged",this.setAKB,false,0,true);
            this.ch_censureall.addEventListener("onChanged",this.setAKB,false,0,true);
            this.ch_extrachar.addEventListener("onChanged",this.setAKB,false,0,true);
            this.ch_simusel.addEventListener("onChanged",this.simuInsultron,false,0,true);
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
            _loc2_["QUERY_" + _loc3_] = this.liste.node.childNode[_loc3_].data.QUERY;
            _loc2_["REPLACE_" + _loc3_] = this.liste.node.childNode[_loc3_].data.REPLACE;
            _loc2_["PUBLIC_" + _loc3_] = this.liste.node.childNode[_loc3_].data.PUBLIC;
            _loc2_["PRIVE_" + _loc3_] = this.liste.node.childNode[_loc3_].data.PRIVE;
            _loc2_["CENSUREALL_" + _loc3_] = this.liste.node.childNode[_loc3_].data.CENSUREALL;
            _loc2_["CENSURE_" + _loc3_] = this.liste.node.childNode[_loc3_].data.CENSURE;
            _loc2_["EXTRACHAR_" + _loc3_] = this.liste.node.childNode[_loc3_].data.EXTRACHAR;
            _loc2_["PTSALERT_" + _loc3_] = this.liste.node.childNode[_loc3_].data.PTSALERT;
            _loc3_++;
         }
         _loc2_.NB = this.liste.node.childNode.length;
         var _loc4_:URLRequest;
         (_loc4_ = new URLRequest(GlobalProperties.scriptAdr + "console/setInsultronList.php")).method = "POST";
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
            mouseChildren = true;
            alpha = 1;
            _loc2_ = new SocketMessage();
            _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,4);
            _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,14);
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
            _loc2_[0].data.QUERY = this.txt_query.text;
            _loc2_[0].data.REPLACE = this.txt_replace.text;
            _loc2_[0].data.PUBLIC = Number(this.ch_public.value);
            _loc2_[0].data.PRIVE = Number(this.ch_prive.value);
            _loc2_[0].data.EXTRACHAR = Number(this.ch_extrachar.value);
            _loc2_[0].data.CENSURE = Number(this.ch_censure.value);
            _loc2_[0].data.CENSUREALL = Number(this.ch_censureall.value);
            _loc2_[0].data.PTSALERT = this.vs_ptsalert.value;
            _loc2_[0].text = _loc2_[0].data.PTSALERT + " " + _loc2_[0].data.QUERY;
            this.liste.redraw();
            this.simuInsultron();
         }
      }
      
      public function showSelectedAKB() : *
      {
         var _loc1_:* = this.liste.node.getSelectedList();
         if(_loc1_.length)
         {
            this.txt_query.text = _loc1_[0].data.QUERY;
            this.txt_replace.text = _loc1_[0].data.REPLACE;
            this.ch_public.value = _loc1_[0].data.PUBLIC;
            this.ch_prive.value = _loc1_[0].data.PRIVE;
            this.ch_extrachar.value = _loc1_[0].data.EXTRACHAR;
            this.ch_censureall.value = _loc1_[0].data.CENSUREALL;
            this.ch_censure.value = _loc1_[0].data.CENSURE;
            this.vs_ptsalert.value = _loc1_[0].data.PTSALERT;
            this.simuInsultron();
         }
      }
      
      public function addAKB(param1:Event) : *
      {
         this.liste.node.unSelectAllItem();
         var _loc2_:ListTreeNode = ListTreeNode(this.liste.node.addChild());
         _loc2_.selected = true;
         this.setAKB();
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
         var _loc2_:URLVariables = new URLVariables();
         _loc2_.SESSION = GlobalConsoleProperties.console.session;
         _loc2_.CACHE = new Date().getTime();
         var _loc3_:URLRequest = new URLRequest(GlobalProperties.scriptAdr + "console/getInsultronList.php");
         _loc3_.method = "POST";
         _loc3_.data = _loc2_;
         var _loc4_:URLLoader;
         (_loc4_ = new URLLoader()).dataFormat = "variables";
         _loc4_.load(_loc3_);
         _loc4_.addEventListener("complete",this.onGetListMessage,false,0,true);
         mouseChildren = false;
         alpha = 0.5;
      }
      
      public function onGetListMessage(param1:Event) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:ListTreeNode = null;
         this.liste.node.removeAllChild();
         param1.currentTarget.removeEventListener("complete",this.onGetListMessage,false);
         if(param1.currentTarget.data.RESULT == 1)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.currentTarget.data.NB)
            {
               _loc3_ = ListTreeNode(this.liste.node.addChild());
               _loc3_.data.QUERY = param1.currentTarget.data["QUERY_" + _loc2_];
               _loc3_.data.REPLACE = param1.currentTarget.data["REPLACE_" + _loc2_];
               _loc3_.data.PUBLIC = Number(param1.currentTarget.data["PUBLIC_" + _loc2_]);
               _loc3_.data.PRIVE = Number(param1.currentTarget.data["PRIVE_" + _loc2_]);
               _loc3_.data.EXTRACHAR = Number(param1.currentTarget.data["EXTRACHAR_" + _loc2_]);
               _loc3_.data.CENSURE = Number(param1.currentTarget.data["CENSURE_" + _loc2_]);
               _loc3_.data.CENSUREALL = Number(param1.currentTarget.data["CENSUREALL_" + _loc2_]);
               _loc3_.data.PTSALERT = Number(param1.currentTarget.data["PTSALERT_" + _loc2_]);
               _loc3_.text = _loc3_.data.PTSALERT + " " + _loc3_.data.QUERY;
               _loc2_++;
            }
            this.simuInsultron();
            this.liste.redraw();
            mouseChildren = true;
            alpha = 1;
         }
      }
      
      public function clickevt(param1:ListGraphicEvent) : *
      {
         this.liste.node.unSelectAllItem();
         param1.graphic.node.selected = true;
         this.liste.redraw();
         this.showSelectedAKB();
      }
      
      public function simuInsultron(param1:Event = null) : *
      {
         var _loc6_:ListTreeNode = null;
         var _loc7_:* = undefined;
         var _loc2_:uint = 0;
         var _loc3_:String = this.txt_simuin.text;
         var _loc4_:Boolean = false;
         var _loc5_:* = 0;
         while(_loc5_ < this.liste.node.childNode.length)
         {
            if((_loc6_ = this.liste.node.childNode[_loc5_]).selected || !this.ch_simusel.value)
            {
               _loc7_ = _loc3_;
               if(_loc6_.data.EXTRACHAR)
               {
                  _loc7_ = (_loc7_ = (_loc7_ = (_loc7_ = _loc7_.replace(/[éèê]/gi,"e")).replace(/[@à]/gi,"a")).replace(/(.)\1*/gi,"$1")).replace(/[\x00-\x2F\x3A-\x40\x5B-\x60\x7b-\xff]+/gi,"");
               }
               if(!_loc4_)
               {
                  if(_loc7_.search(new RegExp(_loc6_.data.QUERY,"i")) != -1)
                  {
                     _loc2_ += _loc6_.data.PTSALERT;
                     if(_loc6_.data.CENSURE)
                     {
                        if(Boolean(_loc6_.data.CENSUREALL) && Boolean(_loc6_.data.REPLACE.length))
                        {
                           _loc3_ = String(_loc6_.data.REPLACE);
                           _loc4_ = true;
                        }
                        else if(_loc6_.data.CENSUREALL)
                        {
                           _loc3_ = "*vive blablaland*";
                           _loc4_ = true;
                        }
                        else
                        {
                           _loc3_ = _loc3_.replace(new RegExp(_loc6_.data.QUERY,"ig"),_loc6_.data.REPLACE);
                        }
                     }
                  }
               }
            }
            _loc5_++;
         }
         this.txt_simupts.text = _loc2_.toString();
         this.txt_simuout.text = _loc3_;
      }
      
      public function onKill(param1:Event) : *
      {
      }
   }
}
