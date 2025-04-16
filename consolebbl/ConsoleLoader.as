package consolebbl
{
   import bbl.ExternalLoader;
   import bbl.GlobalProperties;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   public class ConsoleLoader extends MovieClip
   {
       
      
      public var externalLoader:ExternalLoader;
      
      public function ConsoleLoader()
      {
         super();
         stop();
         this.externalLoader = new ExternalLoader();
         addEventListener("enterFrame",this.enterFrameLoader,false,0,true);
      }
      
      public function enterFrameLoader(param1:Event) : *
      {
         var _loc2_:URLRequest = null;
         var _loc3_:URLLoader = null;
         if(stage.loaderInfo.bytesTotal >= stage.loaderInfo.bytesLoaded || !stage.loaderInfo.bytesTotal)
         {
            removeEventListener("enterFrame",this.enterFrameLoader,false);
            this.externalLoader.addEventListener("onReady",this.onExternalReady,false,0,true);
            this.externalLoader.load();
         }
      }
      
      public function onXmlReady(param1:Event = null) : *
      {
         var _loc2_:XML = new XML(param1.currentTarget.data);
         if(_loc2_.scriptAdr.length())
         {
            GlobalProperties.scriptAdr = _loc2_.scriptAdr.@value;
         }
         if(_loc2_.socket.@host.length())
         {
            GlobalProperties.socketHost = _loc2_.socket.@host;
         }
         if(_loc2_.socket.@port.length())
         {
            GlobalProperties.socketPort = uint(_loc2_.socket.@port);
         }
      }
      
      public function onExternalReady(param1:Event) : *
      {
         this.externalLoader.removeEventListener("onReady",this.onExternalReady,false);
         nextFrame();
      }
   }
}
