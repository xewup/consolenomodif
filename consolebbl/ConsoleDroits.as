package consolebbl
{
   import flash.events.Event;
   import net.ParsedMessageEvent;
   import net.SocketMessage;
   
   public class ConsoleDroits extends ConsoleAKB
   {
       
      
      public var rulesAkbChange:uint;
      
      public var rulesAkbManager:uint;
      
      public var rulesDroitsChange:uint;
      
      public var rulesDroitsMsgMap:uint;
      
      public var rulesDroitsMsgAllMap:uint;
      
      public var rulesDroitsMsgAllUni:uint;
      
      public var rulesDroitsCasier:uint;
      
      public var rulesDroitsCasierAdv:uint;
      
      public var rulesGradeChange:uint;
      
      public var rulesInsultronChange:uint;
      
      public var rulesDroitsTeleport:uint;
      
      public var rulesDroitsTeleportSelf:uint;
      
      public var rulesDroitsModoForum:uint;
      
      public var rulesAdvAccess:uint;
      
      public var rulesDailyMessage:uint;
      
      public var rulesFreePrison:uint;
      
      public var rulesTrackMp:uint;
      
      public var rulesLightEffect:uint;
      
      public var rulesVInsultron:uint;
      
      public var rulesLVLChange:uint;
      
      public var rulesSecretAllow:uint;
      
      public var rulesIpLogDB:uint;
      
      public var rulesKickConsole:uint;
      
      public var rulesUpdatePseudo:uint;
      
      public var rulesMassBan:uint;
      
      public var rulesViewIp:uint;
      
      public function ConsoleDroits()
      {
         super();
         blablaland.addEventListener("onParsedMessage",this.onDroitsMessage,false,0,true);
      }
      
      public function onDroitsMessage(param1:ParsedMessageEvent) : *
      {
         var _loc2_:SocketMessage = param1.getMessage();
         if(param1.evtType == 6 && param1.evtStype == 7)
         {
            this.rulesAkbChange = _loc2_.bitReadUnsignedInt(16);
            this.rulesDroitsChange = _loc2_.bitReadUnsignedInt(16);
            this.rulesDroitsMsgMap = _loc2_.bitReadUnsignedInt(16);
            this.rulesDroitsMsgAllMap = _loc2_.bitReadUnsignedInt(16);
            this.rulesDroitsMsgAllUni = _loc2_.bitReadUnsignedInt(16);
            this.rulesDroitsCasier = _loc2_.bitReadUnsignedInt(16);
            this.rulesGradeChange = _loc2_.bitReadUnsignedInt(16);
            this.rulesInsultronChange = _loc2_.bitReadUnsignedInt(16);
            this.rulesDroitsTeleport = _loc2_.bitReadUnsignedInt(16);
            this.rulesDroitsModoForum = _loc2_.bitReadUnsignedInt(16);
            this.rulesAdvAccess = _loc2_.bitReadUnsignedInt(16);
            this.rulesDailyMessage = _loc2_.bitReadUnsignedInt(16);
            this.rulesFreePrison = _loc2_.bitReadUnsignedInt(16);
            this.rulesTrackMp = _loc2_.bitReadUnsignedInt(16);
            this.rulesLightEffect = _loc2_.bitReadUnsignedInt(16);
            this.rulesDroitsCasierAdv = _loc2_.bitReadUnsignedInt(16);
            this.rulesAkbManager = _loc2_.bitReadUnsignedInt(16);
            this.rulesDroitsTeleportSelf = _loc2_.bitReadUnsignedInt(16);
            this.rulesVInsultron = _loc2_.bitReadUnsignedInt(16);
            this.rulesLVLChange = _loc2_.bitReadUnsignedInt(16);
            this.rulesSecretAllow = _loc2_.bitReadUnsignedInt(16);
            this.rulesIpLogDB = _loc2_.bitReadUnsignedInt(16);
            this.rulesKickConsole = _loc2_.bitReadUnsignedInt(16);
            this.rulesUpdatePseudo = _loc2_.bitReadUnsignedInt(16);
            this.rulesMassBan = _loc2_.bitReadUnsignedInt(16);
            this.rulesViewIp = _loc2_.bitReadUnsignedInt(16);
            this.dispatchEvent(new Event("chatChangeDroits"));
            param1.stopImmediatePropagation();
         }
      }
   }
}
