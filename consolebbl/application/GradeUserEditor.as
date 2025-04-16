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
   import net.SocketMessage;
   import ui.ValueSelector;
   
   [Embed(source="/_assets/assets.swf", symbol="consolebbl.application.GradeUserEditor")]
   public class GradeUserEditor extends MovieClip
   {
       
      
      public var vs_grade:ValueSelector;
      
      public var bt_save:SimpleButton;
      
      public function GradeUserEditor()
      {
         super();
         this.addEventListener(Event.ADDED,this.init,false,0,true);
      }
      
      public function init(param1:Event) : *
      {
         if(stage)
         {
            this.removeEventListener(Event.ADDED,this.init,false);
            parent.width = 125;
            parent.height = 75;
            Object(parent).redraw();
            parent.addEventListener("onKill",this.onKill,false,0,true);
            this.bt_save.addEventListener("click",this.onSave,false,0,true);
            this.loadGrade();
         }
      }
      
      public function onSave(param1:Event = null) : *
      {
         var _loc2_:URLVariables = new URLVariables();
         _loc2_.SESSION = GlobalConsoleProperties.console.session;
         _loc2_.CACHE = new Date().getTime();
         _loc2_.UID = Object(parent).data.UID;
         _loc2_.GRADE = this.vs_grade.value;
         var _loc3_:URLRequest = new URLRequest(GlobalProperties.scriptAdr + "console/setGradeUser.php");
         _loc3_.method = "POST";
         _loc3_.data = _loc2_;
         var _loc4_:URLLoader;
         (_loc4_ = new URLLoader()).dataFormat = "variables";
         _loc4_.load(_loc3_);
         _loc4_.addEventListener("complete",this.onUrlMessageSaved,false,0,true);
         mouseChildren = false;
         alpha = 0.5;
      }
      
      public function onUrlMessageSaved(param1:Event) : *
      {
         var _loc2_:* = undefined;
         param1.currentTarget.removeEventListener("complete",this.onUrlMessageSaved,false);
         if(param1.currentTarget.data.RESULT == 1)
         {
            mouseChildren = true;
            alpha = 1;
            Object(parent).close();
            _loc2_ = new SocketMessage();
            _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,4);
            _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,13);
            _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_USER_ID,Object(parent).data.UID);
            GlobalConsoleProperties.console.blablaland.send(_loc2_);
            Object(parent).close();
         }
      }
      
      public function loadGrade(param1:Event = null) : *
      {
         var _loc2_:URLVariables = new URLVariables();
         _loc2_.SESSION = GlobalConsoleProperties.console.session;
         _loc2_.CACHE = new Date().getTime();
         _loc2_.UID = Object(parent).data.UID;
         var _loc3_:URLRequest = new URLRequest(GlobalProperties.scriptAdr + "console/getGradeUser.php");
         _loc3_.method = "POST";
         _loc3_.data = _loc2_;
         var _loc4_:URLLoader;
         (_loc4_ = new URLLoader()).dataFormat = "variables";
         _loc4_.load(_loc3_);
         _loc4_.addEventListener("complete",this.onUrlMessage,false,0,true);
         mouseChildren = false;
         alpha = 0.5;
      }
      
      public function onUrlMessage(param1:Event) : *
      {
         param1.currentTarget.removeEventListener("complete",this.onUrlMessage,false);
         if(param1.currentTarget.data.RESULT == 1)
         {
            mouseChildren = true;
            alpha = 1;
            this.vs_grade.value = param1.currentTarget.data.GRADE;
            if(this.vs_grade.value < GlobalConsoleProperties.console.blablaland.grade)
            {
               this.vs_grade.maxValue = GlobalConsoleProperties.console.blablaland.grade - 1;
            }
         }
      }
      
      public function onKill(param1:Event) : *
      {
      }
   }
}
