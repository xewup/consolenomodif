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
   
   [Embed(source="/_assets/assets.swf", symbol="consolebbl.application.DroitsManager")]
   public class DroitsManager extends MovieClip
   {
       
      
      public var lvl_akb:ValueSelector;
      
      public var lvl_akb_mng:ValueSelector;
      
      public var lvl_droits:ValueSelector;
      
      public var lvl_msg_map:ValueSelector;
      
      public var lvl_msg_allmap:ValueSelector;
      
      public var lvl_msg_alluni:ValueSelector;
      
      public var lvl_casier:ValueSelector;
      
      public var lvl_casieradv:ValueSelector;
      
      public var lvl_grades:ValueSelector;
      
      public var lvl_insultron:ValueSelector;
      
      public var lvl_teleport:ValueSelector;
      
      public var lvl_teleport_self:ValueSelector;
      
      public var lvl_modoforum:ValueSelector;
      
      public var lvl_dailymsg:ValueSelector;
      
      public var lvl_freeprison:ValueSelector;
      
      public var lvl_trackmp:ValueSelector;
      
      public var lvl_lighteffect:ValueSelector;
      
      public var lvl_Vinsultron:ValueSelector;
      
      public var lvl_secret:ValueSelector;
      
      public var lvl_lvlname:ValueSelector;
      
      public var lvl_iplogdb:ValueSelector;
      
      public var lvl_kickconsole:ValueSelector;
      
      public var lvl_reset_pseudo:ValueSelector;
      
      public var lvl_massban:ValueSelector;
      
      public var lvl_viewip:ValueSelector;
      
      public var bt_save:SimpleButton;
      
      public function DroitsManager()
      {
         super();
         this.addEventListener(Event.ADDED,this.init,false,0,true);
         GlobalConsoleProperties.console.addEventListener("chatChangeDroits",this.readDroits,false,0,true);
         this.bt_save.addEventListener("click",this.onSave,false,0,true);
      }
      
      public function init(param1:Event) : *
      {
         if(stage)
         {
            this.removeEventListener(Event.ADDED,this.init,false);
            parent.width = 430;
            parent.height = 365;
            Object(parent).redraw();
            parent.addEventListener("onKill",this.onKill,false,0,true);
            this.readDroits();
         }
      }
      
      public function readDroits(param1:Event = null) : *
      {
         var _loc2_:* = GlobalConsoleProperties.console.rulesDroitsChange <= GlobalConsoleProperties.console.blablaland.grade;
         this.lvl_akb.maxValue = 5000;
         this.lvl_akb.value = GlobalConsoleProperties.console.rulesAkbChange;
         this.lvl_akb.enabled = _loc2_ && GlobalConsoleProperties.console.rulesAkbChange <= GlobalConsoleProperties.console.blablaland.grade;
         this.lvl_akb.maxValue = this.lvl_akb.enabled ? GlobalConsoleProperties.console.blablaland.grade : this.lvl_akb.value;
         this.lvl_akb_mng.maxValue = 5000;
         this.lvl_akb_mng.value = GlobalConsoleProperties.console.rulesAkbManager;
         this.lvl_akb_mng.enabled = _loc2_ && GlobalConsoleProperties.console.rulesAkbManager <= GlobalConsoleProperties.console.blablaland.grade;
         this.lvl_akb_mng.maxValue = this.lvl_akb_mng.enabled ? GlobalConsoleProperties.console.blablaland.grade : this.lvl_akb_mng.value;
         this.lvl_droits.maxValue = 5000;
         this.lvl_droits.value = GlobalConsoleProperties.console.rulesDroitsChange;
         this.lvl_droits.enabled = _loc2_;
         this.lvl_droits.maxValue = this.lvl_droits.enabled ? GlobalConsoleProperties.console.blablaland.grade : this.lvl_droits.value;
         this.lvl_msg_map.maxValue = 5000;
         this.lvl_msg_map.value = GlobalConsoleProperties.console.rulesDroitsMsgMap;
         this.lvl_msg_map.enabled = _loc2_ && GlobalConsoleProperties.console.rulesDroitsMsgMap <= GlobalConsoleProperties.console.blablaland.grade;
         this.lvl_msg_map.maxValue = this.lvl_msg_map.enabled ? GlobalConsoleProperties.console.blablaland.grade : this.lvl_msg_map.value;
         this.lvl_msg_allmap.maxValue = 5000;
         this.lvl_msg_allmap.value = GlobalConsoleProperties.console.rulesDroitsMsgAllMap;
         this.lvl_msg_allmap.enabled = _loc2_ && GlobalConsoleProperties.console.rulesDroitsMsgAllMap <= GlobalConsoleProperties.console.blablaland.grade;
         this.lvl_msg_allmap.maxValue = this.lvl_msg_allmap.enabled ? GlobalConsoleProperties.console.blablaland.grade : this.lvl_msg_allmap.value;
         this.lvl_msg_alluni.maxValue = 5000;
         this.lvl_msg_alluni.value = GlobalConsoleProperties.console.rulesDroitsMsgAllUni;
         this.lvl_msg_alluni.enabled = _loc2_ && GlobalConsoleProperties.console.rulesDroitsMsgAllUni <= GlobalConsoleProperties.console.blablaland.grade;
         this.lvl_msg_alluni.maxValue = this.lvl_msg_alluni.enabled ? GlobalConsoleProperties.console.blablaland.grade : this.lvl_msg_alluni.value;
         this.lvl_casier.maxValue = 5000;
         this.lvl_casier.value = GlobalConsoleProperties.console.rulesDroitsCasier;
         this.lvl_casier.enabled = _loc2_ && GlobalConsoleProperties.console.rulesDroitsCasier <= GlobalConsoleProperties.console.blablaland.grade;
         this.lvl_casier.maxValue = this.lvl_casier.enabled ? GlobalConsoleProperties.console.blablaland.grade : this.lvl_casier.value;
         this.lvl_casieradv.maxValue = 5000;
         this.lvl_casieradv.value = GlobalConsoleProperties.console.rulesDroitsCasierAdv;
         this.lvl_casieradv.enabled = _loc2_ && GlobalConsoleProperties.console.rulesDroitsCasierAdv <= GlobalConsoleProperties.console.blablaland.grade;
         this.lvl_casieradv.maxValue = this.lvl_casier.enabled ? GlobalConsoleProperties.console.blablaland.grade : this.lvl_casieradv.value;
         this.lvl_grades.maxValue = 5000;
         this.lvl_grades.value = GlobalConsoleProperties.console.rulesGradeChange;
         this.lvl_grades.enabled = _loc2_ && GlobalConsoleProperties.console.rulesGradeChange <= GlobalConsoleProperties.console.blablaland.grade;
         this.lvl_grades.maxValue = this.lvl_grades.enabled ? GlobalConsoleProperties.console.blablaland.grade : this.lvl_grades.value;
         this.lvl_insultron.maxValue = 5000;
         this.lvl_insultron.value = GlobalConsoleProperties.console.rulesInsultronChange;
         this.lvl_insultron.enabled = _loc2_ && GlobalConsoleProperties.console.rulesInsultronChange <= GlobalConsoleProperties.console.blablaland.grade;
         this.lvl_insultron.maxValue = this.lvl_insultron.enabled ? GlobalConsoleProperties.console.blablaland.grade : this.lvl_insultron.value;
         this.lvl_teleport.maxValue = 5000;
         this.lvl_teleport.value = GlobalConsoleProperties.console.rulesDroitsTeleport;
         this.lvl_teleport.enabled = _loc2_ && GlobalConsoleProperties.console.rulesDroitsTeleport <= GlobalConsoleProperties.console.blablaland.grade;
         this.lvl_teleport.maxValue = this.lvl_teleport.enabled ? GlobalConsoleProperties.console.blablaland.grade : this.lvl_teleport.value;
         this.lvl_teleport_self.maxValue = 5000;
         this.lvl_teleport_self.value = GlobalConsoleProperties.console.rulesDroitsTeleportSelf;
         this.lvl_teleport_self.enabled = _loc2_ && GlobalConsoleProperties.console.rulesDroitsTeleportSelf <= GlobalConsoleProperties.console.blablaland.grade;
         this.lvl_teleport_self.maxValue = this.lvl_teleport_self.enabled ? GlobalConsoleProperties.console.blablaland.grade : this.lvl_teleport_self.value;
         this.lvl_modoforum.maxValue = 5000;
         this.lvl_modoforum.value = GlobalConsoleProperties.console.rulesDroitsModoForum;
         this.lvl_modoforum.enabled = _loc2_ && GlobalConsoleProperties.console.rulesDroitsModoForum <= GlobalConsoleProperties.console.blablaland.grade;
         this.lvl_modoforum.maxValue = this.lvl_modoforum.enabled ? GlobalConsoleProperties.console.blablaland.grade : this.lvl_modoforum.value;
         this.lvl_dailymsg.maxValue = 5000;
         this.lvl_dailymsg.value = GlobalConsoleProperties.console.rulesDailyMessage;
         this.lvl_dailymsg.enabled = _loc2_ && GlobalConsoleProperties.console.rulesDailyMessage <= GlobalConsoleProperties.console.blablaland.grade;
         this.lvl_dailymsg.maxValue = this.lvl_dailymsg.enabled ? GlobalConsoleProperties.console.blablaland.grade : this.lvl_dailymsg.value;
         this.lvl_freeprison.maxValue = 5000;
         this.lvl_freeprison.value = GlobalConsoleProperties.console.rulesFreePrison;
         this.lvl_freeprison.enabled = _loc2_ && GlobalConsoleProperties.console.rulesFreePrison <= GlobalConsoleProperties.console.blablaland.grade;
         this.lvl_freeprison.maxValue = this.lvl_freeprison.enabled ? GlobalConsoleProperties.console.blablaland.grade : this.lvl_freeprison.value;
         this.lvl_trackmp.maxValue = 5000;
         this.lvl_trackmp.value = GlobalConsoleProperties.console.rulesTrackMp;
         this.lvl_trackmp.enabled = _loc2_ && GlobalConsoleProperties.console.rulesTrackMp <= GlobalConsoleProperties.console.blablaland.grade;
         this.lvl_trackmp.maxValue = this.lvl_trackmp.enabled ? GlobalConsoleProperties.console.blablaland.grade : this.lvl_trackmp.value;
         this.lvl_lighteffect.maxValue = 5000;
         this.lvl_lighteffect.value = GlobalConsoleProperties.console.rulesLightEffect;
         this.lvl_lighteffect.enabled = _loc2_ && GlobalConsoleProperties.console.rulesLightEffect <= GlobalConsoleProperties.console.blablaland.grade;
         this.lvl_lighteffect.maxValue = this.lvl_lighteffect.enabled ? GlobalConsoleProperties.console.blablaland.grade : this.lvl_lighteffect.value;
         this.lvl_Vinsultron.maxValue = 5000;
         this.lvl_Vinsultron.value = GlobalConsoleProperties.console.rulesVInsultron;
         this.lvl_Vinsultron.enabled = _loc2_ && GlobalConsoleProperties.console.rulesVInsultron <= GlobalConsoleProperties.console.blablaland.grade;
         this.lvl_Vinsultron.maxValue = this.lvl_Vinsultron.enabled ? GlobalConsoleProperties.console.blablaland.grade : this.lvl_Vinsultron.value;
         this.lvl_lvlname.maxValue = 5000;
         this.lvl_lvlname.value = GlobalConsoleProperties.console.rulesLVLChange;
         this.lvl_lvlname.enabled = _loc2_ && GlobalConsoleProperties.console.rulesLVLChange <= GlobalConsoleProperties.console.blablaland.grade;
         this.lvl_lvlname.maxValue = this.lvl_lvlname.enabled ? GlobalConsoleProperties.console.blablaland.grade : this.lvl_lvlname.value;
         this.lvl_secret.maxValue = 5000;
         this.lvl_secret.value = GlobalConsoleProperties.console.rulesSecretAllow;
         this.lvl_secret.enabled = _loc2_ && GlobalConsoleProperties.console.rulesSecretAllow <= GlobalConsoleProperties.console.blablaland.grade;
         this.lvl_secret.maxValue = this.lvl_secret.enabled ? GlobalConsoleProperties.console.blablaland.grade : this.lvl_secret.value;
         this.lvl_iplogdb.maxValue = 5000;
         this.lvl_iplogdb.value = GlobalConsoleProperties.console.rulesIpLogDB;
         this.lvl_iplogdb.enabled = _loc2_ && GlobalConsoleProperties.console.rulesIpLogDB <= GlobalConsoleProperties.console.blablaland.grade;
         this.lvl_iplogdb.maxValue = this.lvl_iplogdb.enabled ? GlobalConsoleProperties.console.blablaland.grade : this.lvl_iplogdb.value;
         this.lvl_kickconsole.maxValue = 5000;
         this.lvl_kickconsole.value = GlobalConsoleProperties.console.rulesKickConsole;
         this.lvl_kickconsole.enabled = _loc2_ && GlobalConsoleProperties.console.rulesKickConsole <= GlobalConsoleProperties.console.blablaland.grade;
         this.lvl_kickconsole.maxValue = this.lvl_kickconsole.enabled ? GlobalConsoleProperties.console.blablaland.grade : this.lvl_kickconsole.value;
         this.lvl_reset_pseudo.maxValue = 5000;
         this.lvl_reset_pseudo.value = GlobalConsoleProperties.console.rulesUpdatePseudo;
         this.lvl_reset_pseudo.enabled = _loc2_ && GlobalConsoleProperties.console.rulesUpdatePseudo <= GlobalConsoleProperties.console.blablaland.grade;
         this.lvl_reset_pseudo.maxValue = this.lvl_reset_pseudo.enabled ? GlobalConsoleProperties.console.blablaland.grade : this.lvl_reset_pseudo.value;
         this.lvl_massban.maxValue = 5000;
         this.lvl_massban.value = GlobalConsoleProperties.console.rulesMassBan;
         this.lvl_massban.enabled = _loc2_ && GlobalConsoleProperties.console.rulesMassBan <= GlobalConsoleProperties.console.blablaland.grade;
         this.lvl_massban.maxValue = this.lvl_massban.enabled ? GlobalConsoleProperties.console.blablaland.grade : this.lvl_massban.value;
         this.lvl_viewip.maxValue = 5000;
         this.lvl_viewip.value = GlobalConsoleProperties.console.rulesViewIp;
         this.lvl_viewip.enabled = _loc2_ && GlobalConsoleProperties.console.rulesViewIp <= GlobalConsoleProperties.console.blablaland.grade;
         this.lvl_viewip.maxValue = this.lvl_viewip.enabled ? GlobalConsoleProperties.console.blablaland.grade : this.lvl_viewip.value;
         mouseChildren = true;
         alpha = 1;
      }
      
      public function onSave(param1:Event) : *
      {
         var _loc2_:URLVariables = new URLVariables();
         _loc2_.SESSION = GlobalConsoleProperties.console.session;
         _loc2_.CACHE = new Date().getTime();
         _loc2_.AKBCHANGE = this.lvl_akb.value;
         _loc2_.AKBMANAGER = this.lvl_akb_mng.value;
         _loc2_.DROITSCHANGE = this.lvl_droits.value;
         _loc2_.MSGMAP = this.lvl_msg_map.value;
         _loc2_.MSGALLMAP = this.lvl_msg_allmap.value;
         _loc2_.MSGALLUNI = this.lvl_msg_alluni.value;
         _loc2_.USERCASIER = this.lvl_casier.value;
         _loc2_.USERCASIERADV = this.lvl_casieradv.value;
         _loc2_.GRADESCHANGE = this.lvl_grades.value;
         _loc2_.INSULTRONCHANGE = this.lvl_insultron.value;
         _loc2_.DROITSTELEPORTO = this.lvl_teleport.value;
         _loc2_.DROITSTELEPORTS = this.lvl_teleport_self.value;
         _loc2_.MODOFORUM = this.lvl_modoforum.value;
         _loc2_.DAILYMSGCHANGE = this.lvl_dailymsg.value;
         _loc2_.FREEPRISON = this.lvl_freeprison.value;
         _loc2_.TRACKMP = this.lvl_trackmp.value;
         _loc2_.LIGHTEFFECT = this.lvl_lighteffect.value;
         _loc2_.DROITSVINSULTRON = this.lvl_Vinsultron.value;
         _loc2_.LVLNAMECHANGE = this.lvl_lvlname.value;
         _loc2_.SECRETALLOW = this.lvl_secret.value;
         _loc2_.IPLOGDB = this.lvl_iplogdb.value;
         _loc2_.KICKCONSOLE = this.lvl_kickconsole.value;
         _loc2_.MASSBAN = this.lvl_massban.value;
         _loc2_.VIEWIP = this.lvl_viewip.value;
         _loc2_.UPDATEPSEUDO = this.lvl_reset_pseudo.value;
         var _loc3_:URLRequest = new URLRequest(GlobalProperties.scriptAdr + "console/setDroits.php");
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
         var _loc2_:* = undefined;
         param1.currentTarget.removeEventListener("complete",this.onUrlMessage,false);
         if(param1.currentTarget.data.RESULT == 1)
         {
            _loc2_ = new SocketMessage();
            _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,4);
            _loc2_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,5);
            GlobalConsoleProperties.console.blablaland.send(_loc2_);
         }
         else
         {
            this.readDroits();
         }
      }
      
      public function onKill(param1:Event) : *
      {
         GlobalConsoleProperties.console.removeEventListener("chatChangeDroits",this.readDroits,false);
      }
   }
}
