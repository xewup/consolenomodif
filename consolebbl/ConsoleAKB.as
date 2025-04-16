package consolebbl
{
   import bbl.GlobalProperties;
   import consolebbl.application.AKBItem;
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import net.ParsedMessageEvent;
   
   public class ConsoleAKB extends ConsoleChat
   {
       
      
      public var AKBReady:Boolean;
      
      public var AKBList:Array;
      
      public function ConsoleAKB()
      {
         super();
         blablaland.addEventListener("onParsedMessage",this.onAKBMessage,false,0,true);
      }
      
      public function onAKBMessage(param1:ParsedMessageEvent) : *
      {
         if(param1.evtType == 6 && param1.evtStype == 6)
         {
            this.AKBReloadMotif();
            param1.stopImmediatePropagation();
         }
      }
      
      override public function onStart() : *
      {
         this.AKBReloadMotif();
         super.onStart();
      }
      
      public function AKBReloadMotif() : *
      {
         this.AKBReady = false;
         this.AKBList = new Array();
         var _loc1_:URLVariables = new URLVariables();
         _loc1_.SESSION = GlobalConsoleProperties.console.session;
         _loc1_.CACHE = new Date().getTime();
         var _loc2_:URLRequest = new URLRequest(GlobalProperties.scriptAdr + "console/getAKBList.php");
         _loc2_.method = "POST";
         _loc2_.data = _loc1_;
         var _loc3_:URLLoader = new URLLoader();
         _loc3_.dataFormat = "variables";
         _loc3_.load(_loc2_);
         _loc3_.addEventListener("complete",this.onUrlMessage,false,0,true);
      }
      
      public function onUrlMessage(param1:Event) : *
      {
         var _loc2_:uint = 0;
         var _loc3_:AKBItem = null;
         param1.currentTarget.removeEventListener("complete",this.onUrlMessage,false);
         if(param1.currentTarget.data.RESULT == 1)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.currentTarget.data.NB)
            {
               _loc3_ = new AKBItem();
               this.AKBList.push(_loc3_);
               _loc3_.desc = param1.currentTarget.data["DESC_" + _loc2_];
               _loc3_.motif = param1.currentTarget.data["MOTIF_" + _loc2_];
               _loc3_.banDure = uint(param1.currentTarget.data["DURE_" + _loc2_]);
               _loc3_.lvlMp = uint(param1.currentTarget.data["LVLMP_" + _loc2_]);
               _loc3_.lvlKick = uint(param1.currentTarget.data["LVLKICK_" + _loc2_]);
               _loc3_.lvlBan = uint(param1.currentTarget.data["LVLBAN_" + _loc2_]);
               _loc2_++;
            }
         }
         this.dispatchEvent(new Event("onAKBChange"));
      }
   }
}
