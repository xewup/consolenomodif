package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="TxtEvent")]
   public dynamic class TxtEvent extends MovieClip
   {
       
      
      public var sclip:MovieClip;
      
      public function TxtEvent()
      {
         super();
         addFrameScript(0,this.frame1,79,this.frame80);
      }
      
      internal function frame1() : *
      {
         this.mouseEnabled = false;
         this.mouseChildren = false;
      }
      
      internal function frame80() : *
      {
         stop();
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
