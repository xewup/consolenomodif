package
{
   import adobe.utils.*;
   import flash.accessibility.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.globalization.*;
   import flash.media.*;
   import flash.net.*;
   import flash.net.drm.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.sampler.*;
   import flash.sensors.*;
   import flash.system.*;
   import flash.text.*;
   import flash.text.engine.*;
   import flash.text.ime.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   import ui.CheckBox;
   
   [Embed(source="/_assets/assets.swf", symbol="PopupMessage")]
   public dynamic class PopupMessage extends MovieClip
   {
       
      
      public var bt_cancel:SimpleButton;
      
      public var bt_ok:SimpleButton;
      
      public var ch_valA:CheckBox;
      
      public var ch_valB:CheckBox;
      
      public var login:TextField;
      
      public var pass:TextField;
      
      public var txt:TextField;
      
      public var txt_msg:TextField;
      
      public var txt_valA:TextField;
      
      public var txt_valB:TextField;
      
      public var i:*;
      
      public function PopupMessage()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,2,this.frame3,3,this.frame4,4,this.frame5);
      }
      
      public function clickEvent(param1:Event) : *
      {
         parent.dispatchEvent(new Event("onEvent"));
         Object(parent).close();
      }
      
      public function yesnoClickEventOK(param1:Event) : *
      {
         Object(parent).data.RES = true;
         parent.dispatchEvent(new Event("onEvent"));
         Object(parent).close();
      }
      
      public function yesnoClickEventCancel(param1:Event) : *
      {
         Object(parent).data.RES = false;
         parent.dispatchEvent(new Event("onEvent"));
         Object(parent).close();
      }
      
      public function askClickEvent(param1:Event = null) : *
      {
         if(Boolean(this.login.text.length) && Boolean(this.pass.text.length))
         {
            parent.dispatchEvent(new Event("onEvent"));
         }
      }
      
      public function onKeyDownEvt(param1:KeyboardEvent) : *
      {
         if((stage.focus == this.login || stage.focus == this.pass) && param1.keyCode == 13 && Boolean(Object(parent).focus))
         {
            this.askClickEvent();
         }
      }
      
      public function removed(param1:Event) : *
      {
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownEvt,false);
      }
      
      public function onOptChChange(param1:Event = null) : *
      {
         if(param1.currentTarget == this.ch_valA)
         {
            this.ch_valB.value = !this.ch_valA.value;
         }
         else
         {
            this.ch_valA.value = !this.ch_valB.value;
         }
         Object(parent).data.RESB = this.ch_valB.value;
         Object(parent).data.RESA = this.ch_valA.value;
      }
      
      public function optClickEvent(param1:Event = null) : *
      {
         if(param1.currentTarget == this.bt_cancel)
         {
            Object(parent).data.RESA = false;
            Object(parent).data.RESB = false;
         }
         parent.dispatchEvent(new Event("onEvent"));
         Object(parent).close();
      }
      
      public function onOptKeyDownEvt(param1:KeyboardEvent) : *
      {
         if(param1.keyCode == 13 && Boolean(Object(parent).focus))
         {
            this.bt_ok.dispatchEvent(new Event(MouseEvent.CLICK));
         }
      }
      
      public function optremoved(param1:Event) : *
      {
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownEvt,false);
      }
      
      internal function frame1() : *
      {
         gotoAndStop(Object(parent).data.ACTION);
      }
      
      internal function frame2() : *
      {
         this.txt = TextField(getChildByName("txt"));
         this.bt_ok = SimpleButton(getChildByName("bt_ok"));
         this.txt.mouseEnabled = false;
         this.txt.autoSize = "left";
         if(Object(parent).data.HTMLMSG)
         {
            this.txt.htmlText = Object(parent).data.HTMLMSG;
         }
         else
         {
            this.txt.text = Object(parent).data.MSG;
         }
         this.txt.width = 200;
         this.i = 0;
         while(this.i < numChildren - 1)
         {
            this.getChildAt(this.i).y = this.getChildAt(this.i).y + this.txt.height;
            ++this.i;
         }
         parent.width = 200;
         parent.height = this.txt.height + 35;
         Object(parent).redraw();
         this.bt_ok.addEventListener(MouseEvent.CLICK,this.clickEvent);
      }
      
      internal function frame3() : *
      {
         this.txt = TextField(getChildByName("txt"));
         this.bt_ok = SimpleButton(getChildByName("bt_ok"));
         this.bt_cancel = SimpleButton(getChildByName("bt_cancel"));
         this.txt.mouseEnabled = false;
         this.txt.autoSize = "left";
         if(Object(parent).data.HTMLMSG)
         {
            this.txt.htmlText = Object(parent).data.HTMLMSG;
         }
         else
         {
            this.txt.text = Object(parent).data.MSG;
         }
         this.txt.width = 200;
         this.i = 0;
         while(this.i < numChildren - 1)
         {
            this.getChildAt(this.i).y = this.getChildAt(this.i).y + this.txt.height;
            ++this.i;
         }
         parent.width = 200;
         parent.height = this.txt.height + 35;
         Object(parent).redraw();
         this.bt_ok.addEventListener(MouseEvent.CLICK,this.yesnoClickEventOK);
         this.bt_cancel.addEventListener(MouseEvent.CLICK,this.yesnoClickEventCancel);
      }
      
      internal function frame4() : *
      {
         parent.width = 205;
         parent.height = 120;
         Object(parent).redraw();
         this.login = TextField(getChildByName("login"));
         this.pass = TextField(getChildByName("pass"));
         this.txt_msg = TextField(getChildByName("txt_msg"));
         this.bt_ok = SimpleButton(getChildByName("bt_ok"));
         this.login.text = !!Object(parent).data.LOGIN ? String(Object(parent).data.LOGIN) : "";
         if(this.login.text.length)
         {
            stage.focus = this.pass;
            this.pass.setSelection(this.pass.length,this.pass.length);
         }
         else
         {
            stage.focus = this.login;
            this.login.setSelection(this.login.length,this.login.length);
         }
         this.bt_ok.addEventListener(MouseEvent.CLICK,this.askClickEvent);
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownEvt,false,0,true);
         parent.addEventListener("onKill",this.removed,false,0,true);
      }
      
      internal function frame5() : *
      {
         parent.width = 205;
         parent.height = 120;
         Object(parent).redraw();
         this.txt_valA = TextField(getChildByName("txt_valA"));
         this.txt_valB = TextField(getChildByName("txt_valB"));
         this.txt_msg = TextField(getChildByName("txt_msg"));
         this.ch_valA = CheckBox(getChildByName("ch_valA"));
         this.ch_valB = CheckBox(getChildByName("ch_valB"));
         this.bt_ok = SimpleButton(getChildByName("bt_ok"));
         this.bt_cancel = SimpleButton(getChildByName("bt_cancel"));
         this.txt_valA.text = !!Object(parent).data.VALA ? String(Object(parent).data.VALA) : "";
         this.txt_valB.text = !!Object(parent).data.VALB ? String(Object(parent).data.VALB) : "";
         this.txt_msg.text = !!Object(parent).data.MSG ? String(Object(parent).data.MSG) : "";
         if(Object(parent).data.SWITCH)
         {
            this.ch_valB.value = true;
         }
         else
         {
            this.ch_valA.value = true;
         }
         Object(parent).data.RESA = this.ch_valA.value;
         Object(parent).data.RESB = this.ch_valB.value;
         this.ch_valA.addEventListener("onChanged",this.onOptChChange,false,0,true);
         this.ch_valB.addEventListener("onChanged",this.onOptChChange,false,0,true);
         this.bt_ok.addEventListener(MouseEvent.CLICK,this.optClickEvent,false,0,true);
         this.bt_cancel.addEventListener(MouseEvent.CLICK,this.optClickEvent,false,0,true);
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onOptKeyDownEvt,false,0,true);
         parent.addEventListener("onKill",this.optremoved,false,0,true);
      }
   }
}
