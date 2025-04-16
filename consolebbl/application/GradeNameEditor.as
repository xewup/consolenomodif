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
   import ui.List;
   import ui.ListGraphicEvent;
   import ui.ListTreeNode;
   import ui.ValueSelector;
   
   [Embed(source="/_assets/assets.swf", symbol="consolebbl.application.GradeNameEditor")]
   public class GradeNameEditor extends MovieClip
   {
       
      
      public var vs_grade:ValueSelector;
      
      public var vs_xp:ValueSelector;
      
      public var bt_new:SimpleButton;
      
      public var bt_save:SimpleButton;
      
      public var bt_del:SimpleButton;
      
      public var txt_nom:TextField;
      
      public var liste:List;
      
      private var lastSelected:uint;
      
      public function GradeNameEditor()
      {
         super();
         this.addEventListener(Event.ADDED,this.init,false,0,true);
         this.lastSelected = 0;
      }
      
      public function init(param1:Event) : *
      {
         if(stage)
         {
            this.removeEventListener(Event.ADDED,this.init,false);
            parent.width = 220;
            parent.height = 245;
            Object(parent).redraw();
            this.liste.size = 8;
            this.liste.addEventListener("onClick",this.clickevt,false,0,true);
            this.vs_grade.minValue = 0;
            this.vs_grade.maxValue = 65536;
            this.vs_xp.minValue = 0;
            this.vs_xp.maxValue = 9999999;
            this.bt_new.addEventListener("click",this.onNewGrade,false,0,true);
            this.bt_del.addEventListener("click",this.onDelGrade,false,0,true);
            this.bt_save.addEventListener("click",this.onApplyGrade,false,0,true);
            this.loadList();
         }
      }
      
      public function updateSelected() : *
      {
         var _loc1_:Array = this.liste.node.getSelectedList();
         if(_loc1_.length)
         {
            this.vs_grade.value = _loc1_[0].data.GRADE;
            this.vs_xp.value = _loc1_[0].data.XP;
            this.txt_nom.text = _loc1_[0].data.NAME;
            this.txt_nom.backgroundColor = 16777215;
            this.txt_nom.type = "input";
         }
         else
         {
            this.vs_grade.value = 0;
            this.vs_xp.value = 0;
            this.txt_nom.text = "";
            this.txt_nom.backgroundColor = 12632256;
            this.txt_nom.type = "dynamic";
         }
      }
      
      public function onApplyGrade(param1:Event = null) : *
      {
         var _loc2_:Array = null;
         var _loc3_:URLVariables = null;
         var _loc4_:URLRequest = null;
         var _loc5_:URLLoader = null;
         _loc2_ = this.liste.node.getSelectedList();
         if(_loc2_.length)
         {
            _loc3_ = new URLVariables();
            _loc3_.SESSION = GlobalConsoleProperties.console.session;
            _loc3_.CACHE = new Date().getTime();
            _loc3_.SAVEID = _loc2_[0].data.ID;
            _loc3_.XP = this.vs_xp.value;
            _loc3_.GRADE = this.vs_grade.value;
            _loc3_.NAME = this.txt_nom.text;
            (_loc4_ = new URLRequest(GlobalProperties.scriptAdr + "console/gradesNameList.php")).method = "POST";
            _loc4_.data = _loc3_;
            (_loc5_ = new URLLoader()).dataFormat = "variables";
            _loc5_.load(_loc4_);
            _loc5_.addEventListener("complete",this.onUrlMessageSet,false,0,true);
            mouseChildren = false;
            alpha = 0.5;
            this.lastSelected = _loc2_[0].data.ID;
         }
      }
      
      public function onDelGrade(param1:Event = null) : *
      {
         var _loc3_:URLVariables = null;
         var _loc4_:URLRequest = null;
         var _loc5_:URLLoader = null;
         var _loc2_:Array = this.liste.node.getSelectedList();
         if(_loc2_.length)
         {
            _loc3_ = new URLVariables();
            _loc3_.SESSION = GlobalConsoleProperties.console.session;
            _loc3_.CACHE = new Date().getTime();
            _loc3_.REMOVEID = _loc2_[0].data.ID;
            (_loc4_ = new URLRequest(GlobalProperties.scriptAdr + "console/gradesNameList.php")).method = "POST";
            _loc4_.data = _loc3_;
            (_loc5_ = new URLLoader()).dataFormat = "variables";
            _loc5_.load(_loc4_);
            _loc5_.addEventListener("complete",this.onUrlMessageSet,false,0,true);
            mouseChildren = false;
            alpha = 0.5;
         }
      }
      
      public function onNewGrade(param1:Event = null) : *
      {
         var _loc2_:URLVariables = new URLVariables();
         _loc2_.SESSION = GlobalConsoleProperties.console.session;
         _loc2_.CACHE = new Date().getTime();
         _loc2_.NEW = 1;
         var _loc3_:URLRequest = new URLRequest(GlobalProperties.scriptAdr + "console/gradesNameList.php");
         _loc3_.method = "POST";
         _loc3_.data = _loc2_;
         var _loc4_:URLLoader;
         (_loc4_ = new URLLoader()).dataFormat = "variables";
         _loc4_.load(_loc3_);
         _loc4_.addEventListener("complete",this.onUrlMessageSet,false,0,true);
         mouseChildren = false;
         alpha = 0.5;
         this.lastSelected = 0;
      }
      
      public function onUrlMessageSet(param1:Event) : *
      {
         param1.currentTarget.removeEventListener("complete",this.onUrlMessageSet,false);
         this.loadList();
      }
      
      public function loadList(param1:Event = null) : *
      {
         var _loc2_:URLVariables = new URLVariables();
         _loc2_.SESSION = GlobalConsoleProperties.console.session;
         _loc2_.CACHE = new Date().getTime();
         _loc2_.GET = 1;
         var _loc3_:URLRequest = new URLRequest(GlobalProperties.scriptAdr + "console/gradesNameList.php");
         _loc3_.method = "POST";
         _loc3_.data = _loc2_;
         var _loc4_:URLLoader;
         (_loc4_ = new URLLoader()).dataFormat = "variables";
         _loc4_.load(_loc3_);
         _loc4_.addEventListener("complete",this.onUrlMessageGet,false,0,true);
         mouseChildren = false;
         alpha = 0.5;
      }
      
      public function onUrlMessageGet(param1:Event) : *
      {
         var _loc2_:uint = 0;
         var _loc3_:ListTreeNode = null;
         param1.currentTarget.removeEventListener("complete",this.onUrlMessageGet,false);
         if(param1.currentTarget.data.RESULT == 1)
         {
            mouseChildren = true;
            alpha = 1;
            this.liste.node.removeAllChild();
            _loc2_ = 0;
            while(_loc2_ < param1.currentTarget.data.NB)
            {
               _loc3_ = ListTreeNode(this.liste.node.addChild());
               _loc3_.data.ID = Number(param1.currentTarget.data["ID_" + _loc2_]);
               _loc3_.data.GRADE = Number(param1.currentTarget.data["LEVEL_" + _loc2_]);
               _loc3_.data.XP = Number(param1.currentTarget.data["XP_" + _loc2_]);
               _loc3_.data.NAME = param1.currentTarget.data["NAME_" + _loc2_];
               _loc3_.text = "[<font color=\'#FF0000\'>" + _loc3_.data.GRADE + "</font>][<font color=\'#0000D0\'>" + _loc3_.data.XP + "</font>] " + _loc3_.data.NAME;
               if(_loc3_.data.ID == this.lastSelected)
               {
                  _loc3_.selected = true;
               }
               _loc2_++;
            }
            this.liste.node.childNode.sort(this.sortFunction);
            this.liste.redraw();
            this.updateSelected();
         }
         else if(param1.currentTarget.data.ERROR == 1)
         {
            GlobalConsoleProperties.console.msgPopup.open({
               "APP":PopupMessage,
               "TITLE":"Attention..."
            },{
               "MSG":"Vous n\'avez pas le grade necessaire pour acceder à cette section.",
               "ACTION":"OK"
            });
            Object(parent).close();
         }
      }
      
      public function sortFunction(param1:ListTreeNode, param2:ListTreeNode) : int
      {
         if(param1.data.GRADE > param2.data.GRADE)
         {
            return 1;
         }
         if(param1.data.GRADE < param2.data.GRADE)
         {
            return -1;
         }
         if(param1.data.GRADE == param2.data.GRADE)
         {
            if(param1.data.XP > param2.data.XP)
            {
               return 1;
            }
            if(param1.data.XP < param2.data.XP)
            {
               return -1;
            }
            if(param1.data.XP == param2.data.XP)
            {
               if(param1.data.ID > param2.data.ID)
               {
                  return -1;
               }
               if(param1.data.ID < param2.data.ID)
               {
                  return 1;
               }
            }
         }
         return 0;
      }
      
      public function clickevt(param1:ListGraphicEvent) : *
      {
         this.liste.node.unSelectAllItem();
         param1.graphic.node.selected = true;
         this.liste.redraw();
         this.updateSelected();
      }
   }
}
