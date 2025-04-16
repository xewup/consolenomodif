package net
{
   import bbl.GlobalProperties;
   import bbl.Server;
   import bbl.Transport;
   import flash.events.Event;
   import flash.events.TextEvent;
   import flash.utils.ByteArray;
   import map.ServerMap;
   
   public class Client extends SocketAdv
   {
       
      
      private var serverTimeCount:uint;
      
      private var serverTimeOffset:Number;
      
      private var serverTimePing:uint;
      
      public var pid:uint;
      
      public var mapList:Array;
      
      public var serverList:Array;
      
      public var serverId:uint;
      
      public var transportList:Array;
      
      private var _cacheVersion:uint;
      
      public function Client()
      {
         var _loc1_:Channel = null;
         super();
         this._cacheVersion = 0;
         this.serverTimeOffset = 0;
         this.serverTimeCount = 0;
         this.serverTimePing = 0;
         this.mapList = new Array();
         this.serverList = new Array();
         this.transportList = new Array();
         this.pid = 0;
      }
      
      public function getServerTime() : *
      {
         this.serverTimeOffset = 0;
         this.serverTimeCount = 5;
         this.getServerTimeLunch();
      }
      
      public function getPID() : *
      {
         var _loc1_:* = new SocketMessage();
         _loc1_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,1);
         _loc1_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,3);
         send(_loc1_);
      }
      
      public function getServerMapById(param1:uint) : ServerMap
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this.mapList.length)
         {
            if(this.mapList[_loc2_].id == param1)
            {
               return this.mapList[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getTransportById(param1:uint) : Transport
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this.transportList.length)
         {
            if(this.transportList[_loc2_].id == param1)
            {
               return this.transportList[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getVariables() : *
      {
         var _loc1_:* = new SocketMessage();
         _loc1_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,1);
         _loc1_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,6);
         send(_loc1_);
      }
      
      private function getServerTimeLunch() : *
      {
         var _loc1_:* = new SocketMessage();
         _loc1_.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,1);
         _loc1_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,1);
         _loc1_.bitWriteUnsignedInt(32,GlobalProperties.getTimer());
         send(_loc1_);
         this.serverTimePing = new Date().getTime();
      }
      
      override public function eventMessage(param1:SocketMessageEvent) : *
      {
         var §~~unused§:*;
         var _loc2_:uint = param1.message.bitReadUnsignedInt(GlobalProperties.BIT_TYPE);
         var _loc3_:uint = param1.message.bitReadUnsignedInt(GlobalProperties.BIT_STYPE);
         try
         {
            parsedEventMessage(_loc2_,_loc3_,param1);
            super.eventMessage(param1);
         }
         catch(_loc4_:Error)
         {
         }
      }
      
      public function parsedEventMessage(param1:uint, param2:uint, param3:SocketMessageEvent) : *
      {
         var _loc4_:TextEvent = null;
         var _loc5_:uint = 0;
         var _loc6_:Transport = null;
         var _loc7_:ServerMap = null;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:Server = null;
         var _loc11_:uint = 0;
         var _loc12_:String = null;
         var _loc13_:uint = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:* = undefined;
         var _loc18_:ByteArray = null;
         var _loc19_:int = 0;
         var _loc20_:* = undefined;
         if(param1 == 1)
         {
            if(param2 == 1)
            {
               this.serverTimeMessage(param3);
            }
            else if(param2 == 2)
            {
               (_loc4_ = new TextEvent("onFatalAlert")).text = unescape(param3.message.bitReadString());
               this.dispatchEvent(_loc4_);
            }
            else if(param2 == 3)
            {
               this.pid = param3.message.bitReadUnsignedInt(24);
               this.dispatchEvent(new Event("onGetPID"));
            }
            else if(param2 == 4)
            {
               this.transportList.splice(0,this.transportList.length);
               while(param3.message.bitReadBoolean())
               {
                  (_loc6_ = new Transport()).readBinary(param3.message);
                  this.transportList.push(_loc6_);
               }
               this.mapList.splice(0,this.mapList.length);
               while(param3.message.bitReadBoolean())
               {
                  (_loc7_ = new ServerMap()).id = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_MAP_ID);
                  _loc7_.fileId = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_MAP_FILEID);
                  _loc7_.nom = param3.message.bitReadString();
                  _loc7_.transportId = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_TRANSPORT_ID);
                  _loc7_.mapXpos = param3.message.bitReadSignedInt(17);
                  _loc7_.mapYpos = param3.message.bitReadSignedInt(17);
                  _loc7_.meteoId = param3.message.bitReadUnsignedInt(5);
                  _loc7_.peace = param3.message.bitReadUnsignedInt(2);
                  _loc7_.regionId = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_MAP_REGIONID);
                  _loc7_.planetId = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_MAP_PLANETID);
                  _loc8_ = 0;
                  while(_loc8_ < this.transportList.length)
                  {
                     _loc9_ = 0;
                     while(_loc9_ < this.transportList[_loc8_].mapList.length)
                     {
                        if(this.transportList[_loc8_].mapList[_loc9_].id == _loc7_.id)
                        {
                           this.transportList[_loc8_].mapList[_loc9_] = _loc7_;
                        }
                        _loc9_++;
                     }
                     _loc8_++;
                  }
                  this.mapList.push(_loc7_);
               }
               this.serverList.splice(0,this.serverList.length);
               while(param3.message.bitReadBoolean())
               {
                  (_loc10_ = new Server()).nom = param3.message.bitReadString();
                  _loc10_.port = param3.message.bitReadUnsignedInt(16);
                  this.serverList.push(_loc10_);
               }
               this.serverId = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_SERVER_ID);
               _loc5_ = param3.message.bitReadUnsignedInt(8);
               if(GlobalProperties.stage.loaderInfo.loaderURL.split("file:///").length != 2)
               {
                  this.cacheVersion = _loc5_;
               }
               this.dispatchEvent(new Event("onGetVariables"));
            }
            else if(param2 == 7)
            {
               _loc11_ = 0;
               while(_loc11_ < this.serverList.length)
               {
                  Server(this.serverList[_loc11_]).nbCo = param3.message.bitReadUnsignedInt(16);
                  _loc11_++;
               }
               dispatchEvent(new Event("onUniversCounterUpdate"));
            }
            else if(param2 != 8)
            {
               if(param2 == 12)
               {
                  _loc12_ = param3.message.bitReadString();
                  this.dexecDynFx(_loc12_);
               }
               else if(param2 == 16)
               {
                  _loc13_ = param3.message.bitReadUnsignedInt(GlobalProperties.BIT_CHANNEL_ID);
                  Channel.dispatchMesage(_loc13_,param3.message);
               }
               else if(param2 == 18)
               {
                  _loc14_ = param3.message.bitReadUnsignedInt(32);
                  _loc15_ = param3.message.bitReadUnsignedInt(32);
                  _loc16_ = param3.message.bitReadUnsignedInt(32);
                  (_loc17_ = new SocketMessage()).bitWriteUnsignedInt(GlobalProperties.BIT_TYPE,1);
                  _loc17_.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE,18);
                  _loc17_.bitWriteUnsignedInt(32,_loc14_);
                  _loc18_ = GlobalProperties.stage.loaderInfo.bytes;
                  _loc19_ = 0;
                  while(_loc19_ < _loc16_)
                  {
                     _loc20_ = (_loc19_ + _loc15_) % (_loc18_.length - 8);
                     _loc18_.position = _loc20_ + 8;
                     _loc17_.bitWriteUnsignedInt(8,_loc18_.readUnsignedByte());
                     _loc19_++;
                  }
                  send(_loc17_);
               }
            }
         }
      }
      
      public function dexecDynFx(param1:String) : void
      {
      }
      
      public function serverTimeMessage(param1:SocketMessageEvent) : *
      {
         --this.serverTimeCount;
         var _loc2_:Number = param1.message.bitReadUnsignedInt(32) * 1000;
         _loc2_ += param1.message.bitReadUnsignedInt(10);
         var _loc3_:uint = new Date().getTime() - this.serverTimePing;
         _loc2_ -= Math.round(_loc3_ / 2);
         if(new Date().getTime() - _loc2_ < this.serverTimeOffset || this.serverTimeOffset == 0)
         {
            this.serverTimeOffset = new Date().getTime() - _loc2_;
         }
         if(this.serverTimeCount <= 0)
         {
            GlobalProperties.serverTime = 0;
            GlobalProperties.serverTime = _loc2_;
            dispatchEvent(new Event("onGetTime"));
         }
         else
         {
            this.getServerTimeLunch();
         }
      }
      
      public function set cacheVersion(param1:uint) : *
      {
         this._cacheVersion = Math.max(param1,this._cacheVersion);
      }
      
      public function get cacheVersion() : uint
      {
         return this._cacheVersion;
      }
   }
}
