package consolebbl.application
{
   public class AKBItem
   {
       
      
      public var desc:String;
      
      public var motif:String;
      
      public var banDure:uint;
      
      public var lvlMp:uint;
      
      public var lvlKick:uint;
      
      public var lvlBan:uint;
      
      public function AKBItem()
      {
         super();
         this.desc = "Decription";
         this.motif = "Un motif";
         this.banDure = 0;
         this.lvlMp = 9999;
         this.lvlKick = 9999;
         this.lvlBan = 9999;
      }
   }
}
