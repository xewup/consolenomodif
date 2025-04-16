package consolebbl.application
{
   import consolebbl.GlobalConsoleProperties;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="consolebbl.application.Params")]
   public class Params extends MovieClip
   {
       
      
      public var bt_brillance:SimpleButton;
      
      public var bt_akb:SimpleButton;
      
      public var bt_droits:SimpleButton;
      
      public var bt_lvlname:SimpleButton;
      
      public var bt_reglage:SimpleButton;
      
      public var bt_insultron:SimpleButton;
      
      public var bt_adv:SimpleButton;
      
      public var bt_dailymsg:SimpleButton;
      
      public var bt_cam_adv:SimpleButton;
      
      public var bt_secret:SimpleButton;
      
      public var bt_stat_serv:SimpleButton;
      
      public var bt_mass_ban:SimpleButton;
      
      public var bt_mass_CJ:SimpleButton;
      
      public var bt_ban_ip:SimpleButton;
      
      public var bt_color:SimpleButton;
      
      public var bt_blibli_monstre:SimpleButton;
      
      public function Params()
      {
         super();
         this.addEventListener(Event.ADDED,this.init,false,0,true);
         this.bt_brillance.addEventListener("click",this.clickBrillance,false,0,true);
         this.bt_akb.addEventListener("click",this.clickAKB,false,0,true);
         this.bt_droits.addEventListener("click",this.clickDroits,false,0,true);
         this.bt_lvlname.addEventListener("click",this.clickGrades,false,0,true);
         this.bt_reglage.addEventListener("click",this.clickReglages,false,0,true);
         this.bt_insultron.addEventListener("click",this.clickInsultron,false,0,true);
         this.bt_adv.addEventListener("click",this.clickAdv,false,0,true);
         this.bt_dailymsg.addEventListener("click",this.clickDailyMsg,false,0,true);
         this.bt_cam_adv.addEventListener("click",this.clickCamADV,false,0,true);
         this.bt_secret.addEventListener("click",this.clickSecret,false,0,true);
         this.bt_stat_serv.addEventListener("click",this.clickStatServ,false,0,true);
         this.bt_mass_ban.addEventListener("click",this.clickMassBan,false,0,true);
         this.bt_mass_CJ.addEventListener("click",this.clickMassCJ,false,0,true);
         this.bt_ban_ip.addEventListener("click",this.clickBanIP,false,0,true);
         this.bt_color.addEventListener("click",this.clickFontColor,false,0,true);
         this.bt_blibli_monstre.addEventListener("click",this.clickBlibliMonstre,false,0,true);
      }
      
      public function init(param1:Event) : *
      {
         if(stage)
         {
            parent.addEventListener("onKill",this.onKill,false,0,true);
            this.removeEventListener(Event.ADDED,this.init,false);
            parent.width = 150;
            parent.height = 250;
            Object(parent).redraw();
            this.bt_droits.enabled = GlobalConsoleProperties.console.rulesDroitsChange <= GlobalConsoleProperties.console.blablaland.grade;
            this.bt_akb.enabled = GlobalConsoleProperties.console.rulesAkbManager <= GlobalConsoleProperties.console.blablaland.grade;
            this.bt_insultron.enabled = GlobalConsoleProperties.console.rulesInsultronChange <= GlobalConsoleProperties.console.blablaland.grade;
            this.bt_lvlname.enabled = GlobalConsoleProperties.console.rulesLVLChange <= GlobalConsoleProperties.console.blablaland.grade;
            this.bt_adv.enabled = GlobalConsoleProperties.console.rulesAdvAccess <= GlobalConsoleProperties.console.blablaland.grade;
            this.bt_dailymsg.enabled = GlobalConsoleProperties.console.rulesDailyMessage <= GlobalConsoleProperties.console.blablaland.grade;
            this.bt_brillance.enabled = GlobalConsoleProperties.console.rulesLightEffect <= GlobalConsoleProperties.console.blablaland.grade;
            this.bt_secret.enabled = GlobalConsoleProperties.console.rulesSecretAllow <= GlobalConsoleProperties.console.blablaland.grade;
            this.bt_mass_ban.enabled = GlobalConsoleProperties.console.rulesMassBan <= GlobalConsoleProperties.console.blablaland.grade;
            this.bt_mass_CJ.enabled = GlobalConsoleProperties.console.rulesMassBan <= GlobalConsoleProperties.console.blablaland.grade;
            this.bt_ban_ip.enabled = GlobalConsoleProperties.console.rulesMassBan <= GlobalConsoleProperties.console.blablaland.grade;
         }
      }
      
      public function clickBlibliMonstre(param1:Event) : *
      {
         GlobalConsoleProperties.console.winPopup.open({
            "APP":BlibliMonstre,
            "TITLE":"Gestion blibli monstre..."
         });
      }
      
      public function clickStatServ(param1:Event) : *
      {
         GlobalConsoleProperties.console.winPopup.open({
            "APP":ServerStat,
            "TITLE":"Stats serveur.."
         });
      }
      
      public function clickSecret(param1:Event) : *
      {
         if(param1.currentTarget.enabled)
         {
            GlobalConsoleProperties.console.winPopup.open({
               "APP":SecretManager,
               "ID":"Secret",
               "TITLE":"Secret.."
            });
         }
      }
      
      public function clickReglages(param1:Event) : *
      {
         if(param1.currentTarget.enabled)
         {
            GlobalConsoleProperties.console.winPopup.open({
               "APP":ReglagesManager,
               "ID":"Reglages",
               "TITLE":"Droits.."
            });
         }
      }
      
      public function clickCamADV(param1:Event) : *
      {
         if(param1.currentTarget.enabled)
         {
            GlobalConsoleProperties.console.winPopup.open({
               "APP":CamADV,
               "TITLE":"Camera ADV.."
            });
         }
      }
      
      public function clickDroits(param1:Event) : *
      {
         if(param1.currentTarget.enabled)
         {
            GlobalConsoleProperties.console.winPopup.open({
               "APP":DroitsManager,
               "ID":"DroitsManager",
               "TITLE":"Droits.."
            });
         }
      }
      
      public function clickBrillance(param1:Event) : *
      {
         if(param1.currentTarget.enabled)
         {
            GlobalConsoleProperties.console.winPopup.open({
               "APP":BrillanceManager,
               "ID":"Brillance",
               "TITLE":"Brillance.."
            });
         }
      }
      
      public function clickAKB(param1:Event) : *
      {
         if(param1.currentTarget.enabled)
         {
            GlobalConsoleProperties.console.winPopup.open({
               "APP":AKBManager,
               "ID":"AKBEdit",
               "TITLE":"Edition AKB.."
            });
         }
      }
      
      public function clickGrades(param1:Event) : *
      {
         if(param1.currentTarget.enabled)
         {
            GlobalConsoleProperties.console.winPopup.open({
               "APP":GradeNameEditor,
               "ID":"GradesEdit",
               "TITLE":"Edition des grades.."
            });
         }
      }
      
      public function clickInsultron(param1:Event) : *
      {
         if(param1.currentTarget.enabled)
         {
            GlobalConsoleProperties.console.winPopup.open({
               "APP":InsultronManager,
               "ID":"InsultronEdit",
               "TITLE":"Gestion de la censure.."
            });
         }
      }
      
      public function clickAdv(param1:Event) : *
      {
         if(param1.currentTarget.enabled)
         {
            GlobalConsoleProperties.console.winPopup.open({
               "APP":AdvAccess,
               "ID":"AdvAccess",
               "TITLE":"Gestions avancées.."
            });
         }
      }
      
      public function clickDailyMsg(param1:Event) : *
      {
         if(param1.currentTarget.enabled)
         {
            GlobalConsoleProperties.console.winPopup.open({
               "APP":DailyMessage,
               "ID":"DailyMessage",
               "TITLE":"Messages du jour.."
            });
         }
      }
      
      public function clickFontColor(param1:Event) : *
      {
         GlobalConsoleProperties.console.winPopup.open({
            "APP":FontColor,
            "ID":"FontColor",
            "TITLE":"Couleurs.."
         });
      }
      
      public function clickMassBan(param1:Event) : *
      {
         if(param1.currentTarget.enabled)
         {
            GlobalConsoleProperties.console.winPopup.open({
               "APP":MassBan,
               "TITLE":"Mass Ban.."
            });
         }
      }
      
      public function clickBanIP(param1:Event) : *
      {
         if(param1.currentTarget.enabled)
         {
            GlobalConsoleProperties.console.winPopup.open({
               "APP":BanIp,
               "TITLE":"Ban IP FireWall.."
            });
         }
      }
      
      public function clickMassCJ(param1:Event) : *
      {
         if(param1.currentTarget.enabled)
         {
            GlobalConsoleProperties.console.winPopup.open({
               "APP":MassCJ,
               "ID":"MassCJ",
               "TITLE":"Mass CJ.."
            });
         }
      }
      
      public function onKill(param1:Event) : *
      {
      }
   }
}
