package ui
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="ui.ColorPanel")]
   public class ColorPanel extends Sprite
   {
       
      
      public var palette:Object;
      
      public var luminance:Object;
      
      public var preview:Object;
      
      public var vsr:ValueSelector;
      
      public var vsg:ValueSelector;
      
      public var vsb:ValueSelector;
      
      public function ColorPanel()
      {
         super();
         this.vsr.maxValue = 255;
         this.vsr.minValue = 0;
         this.vsg.maxValue = 255;
         this.vsg.minValue = 0;
         this.vsb.maxValue = 255;
         this.vsb.minValue = 0;
         this.vsr.addEventListener("onChanged",this.changeSelector,false,0,true);
         this.vsg.addEventListener("onChanged",this.changeSelector,false,0,true);
         this.vsb.addEventListener("onChanged",this.changeSelector,false,0,true);
         this.vsr.addEventListener("onFixed",this.fixSelector,false,0,true);
         this.vsg.addEventListener("onFixed",this.fixSelector,false,0,true);
         this.vsb.addEventListener("onFixed",this.fixSelector,false,0,true);
         this.palette.addEventListener(MouseEvent.MOUSE_DOWN,this.paletteDown,false,0,true);
         this.luminance.addEventListener(MouseEvent.MOUSE_DOWN,this.luminanceDown,false,0,true);
         this.palette.buttonMode = true;
         this.luminance.buttonMode = true;
      }
      
      public function get DEC() : uint
      {
         return (this.vsr.value << 16) + (this.vsg.value << 8) + this.vsb.value;
      }
      
      public function set DEC(param1:uint) : *
      {
         this.vsr.value = param1 >> 16;
         this.vsg.value = param1 >> 8 & 255;
         this.vsb.value = param1 & 255;
         this.updateBySelector();
      }
      
      public function get HSL() : Object
      {
         return {
            "h":this.palette.croix.x,
            "s":100 - this.palette.croix.y,
            "l":100 - this.luminance.flesh.y
         };
      }
      
      public function set HSL(param1:Object) : *
      {
         var _loc2_:Object = this.convertHSLtoRGB(param1);
         this.vsr.value = _loc2_.r;
         this.vsg.value = _loc2_.g;
         this.vsb.value = _loc2_.b;
         this.updateBySelector();
      }
      
      public function get RGB() : Object
      {
         return {
            "r":this.vsr.value,
            "g":this.vsg.value,
            "b":this.vsb.value
         };
      }
      
      public function set RGB(param1:Object) : *
      {
         this.vsr.value = param1.r;
         this.vsg.value = param1.g;
         this.vsb.value = param1.b;
         this.updateBySelector();
      }
      
      public function changeSelector(param1:Event) : *
      {
         this.updateBySelector();
         dispatchEvent(new Event("onChanged"));
      }
      
      public function fixSelector(param1:Event) : *
      {
         this.updateBySelector();
         dispatchEvent(new Event("onFixed"));
      }
      
      public function paletteMove(param1:MouseEvent = null) : *
      {
         this.palette.croix.x = Math.max(Math.min(this.palette.mouseX,100),0);
         this.palette.croix.y = Math.max(Math.min(this.palette.mouseY,100),0);
         this.updateByPalette();
         dispatchEvent(new Event("onChanged"));
         if(param1)
         {
            param1.updateAfterEvent();
         }
      }
      
      public function paletteUp(param1:Event) : *
      {
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.paletteMove,false);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.paletteUp,false);
         dispatchEvent(new Event("onFixed"));
      }
      
      public function paletteDown(param1:Event) : *
      {
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.paletteMove,false,0,true);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.paletteUp,false,0,true);
         this.paletteMove();
      }
      
      public function luminanceMove(param1:MouseEvent = null) : *
      {
         this.luminance.flesh.y = Math.max(Math.min(this.luminance.mouseY,100),0);
         this.updateByLuminance();
         dispatchEvent(new Event("onChanged"));
         if(param1)
         {
            param1.updateAfterEvent();
         }
      }
      
      public function luminanceUp(param1:Event) : *
      {
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.luminanceMove,false);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.luminanceUp,false);
         dispatchEvent(new Event("onFixed"));
      }
      
      public function luminanceDown(param1:Event) : *
      {
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.luminanceMove,false,0,true);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.luminanceUp,false,0,true);
         this.luminanceMove();
      }
      
      public function updateByLuminance() : *
      {
         this.updateByPalette();
      }
      
      public function updateByPalette() : *
      {
         var _loc1_:Object = this.HSL;
         var _loc2_:Object = this.convertHSLtoRGB(_loc1_);
         var _loc3_:* = this.HSL;
         _loc3_.l = 50;
         _loc3_.s = 100;
         var _loc4_:* = this.convertHSLtoRGB(_loc3_);
         var _loc5_:*;
         (_loc5_ = this.luminance.preview.transform.colorTransform).redOffset = _loc4_.r;
         _loc5_.greenOffset = _loc4_.g;
         _loc5_.blueOffset = _loc4_.b;
         this.luminance.preview.transform.colorTransform = _loc5_;
         this.luminance.sat.alpha = (100 - _loc1_.s) / 100;
         (_loc5_ = this.preview.preview.transform.colorTransform).redOffset = _loc2_.r;
         _loc5_.greenOffset = _loc2_.g;
         _loc5_.blueOffset = _loc2_.b;
         this.preview.preview.transform.colorTransform = _loc5_;
         this.vsr.value = _loc2_.r;
         this.vsg.value = _loc2_.g;
         this.vsb.value = _loc2_.b;
      }
      
      public function updateBySelector() : *
      {
         var _loc1_:Object = this.RGB;
         var _loc2_:Object = this.convertRGBtoHSL(_loc1_);
         this.palette.croix.x = _loc2_.h;
         this.palette.croix.y = 100 - _loc2_.s;
         this.luminance.flesh.y = 100 - _loc2_.l;
         this.luminance.sat.alpha = (100 - _loc2_.s) / 100;
         var _loc3_:Object = this.convertRGBtoHSL(_loc1_);
         _loc3_.l = 50;
         _loc3_.s = 100;
         var _loc4_:Object = this.convertHSLtoRGB(_loc3_);
         var _loc5_:*;
         (_loc5_ = this.luminance.preview.transform.colorTransform).redOffset = _loc4_.r;
         _loc5_.greenOffset = _loc4_.g;
         _loc5_.blueOffset = _loc4_.b;
         this.luminance.preview.transform.colorTransform = _loc5_;
         (_loc5_ = this.preview.preview.transform.colorTransform).redOffset = _loc1_.r;
         _loc5_.greenOffset = _loc1_.g;
         _loc5_.blueOffset = _loc1_.b;
         this.preview.preview.transform.colorTransform = _loc5_;
      }
      
      private function colorSwitch(param1:Number, param2:Number, param3:Number) : *
      {
         var _loc4_:Number = NaN;
         if(6 * param3 < 1)
         {
            _loc4_ = param1 + (param2 - param1) * 6 * param3;
         }
         else if(2 * param3 < 1)
         {
            _loc4_ = param2;
         }
         else if(3 * param3 < 2)
         {
            _loc4_ = param1 + (param2 - param1) * (2 / 3 - param3) * 6;
         }
         else
         {
            _loc4_ = param1;
         }
         return _loc4_;
      }
      
      public function convertRGBtoHSL(param1:Object) : Object
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc2_:* = {
            "r":param1.r / 255,
            "g":param1.g / 255,
            "b":param1.b / 255
         };
         var _loc3_:* = {
            "h":0,
            "s":0,
            "l":0
         };
         _loc4_ = Math.max(_loc2_.r,_loc2_.g);
         _loc4_ = Math.max(_loc4_,_loc2_.b);
         _loc5_ = Math.min(_loc2_.r,_loc2_.g);
         _loc5_ = Math.min(_loc5_,_loc2_.b);
         if((_loc3_.l = (_loc5_ + _loc4_) / 2) <= 0)
         {
            return _loc3_;
         }
         if((_loc3_.s = _loc6_ = _loc4_ - _loc5_) > 0)
         {
            _loc3_.s /= _loc3_.l <= 0.5 ? _loc4_ + _loc5_ : 2 - _loc4_ - _loc5_;
            _loc7_ = (_loc4_ - _loc2_.r) / _loc6_;
            _loc8_ = (_loc4_ - _loc2_.g) / _loc6_;
            _loc9_ = (_loc4_ - _loc2_.b) / _loc6_;
            if(_loc2_.r == _loc4_)
            {
               _loc3_.h = _loc2_.g == _loc5_ ? 5 + _loc9_ : 1 - _loc8_;
            }
            else if(_loc2_.g == _loc4_)
            {
               _loc3_.h = _loc2_.b == _loc5_ ? 1 + _loc7_ : 3 - _loc9_;
            }
            else
            {
               _loc3_.h = _loc2_.r == _loc5_ ? 3 + _loc8_ : 5 - _loc7_;
            }
            _loc3_.h /= 6;
            return {
               "h":_loc3_.h * 100,
               "s":_loc3_.s * 100,
               "l":_loc3_.l * 100
            };
         }
         return {
            "h":_loc3_.h * 100,
            "s":_loc3_.s * 100,
            "l":_loc3_.l * 100
         };
      }
      
      public function convertHSLtoRGB(param1:Object) : Object
      {
         var temp3:* = undefined;
         var temp2:* = undefined;
         var temp1:* = undefined;
         var func:Function = null;
         var hsl:Object = param1;
         hsl = {
            "h":hsl.h / 100,
            "s":hsl.s / 100,
            "l":hsl.l / 100
         };
         var rgb:* = {
            "r":0,
            "g":0,
            "b":0
         };
         if(hsl.s == 0)
         {
            rgb.r = rgb.g = rgb.b = hsl.l;
         }
         else
         {
            if(hsl.l < 0.5)
            {
               temp2 = hsl.l * (1 + hsl.s);
            }
            if(hsl.l >= 0.5)
            {
               temp2 = hsl.l + hsl.s - hsl.l * hsl.s;
            }
            temp1 = 2 * hsl.l - temp2;
            func = function(param1:*, param2:*, param3:*):*
            {
               var _loc4_:* = undefined;
               if(6 * param3 < 1)
               {
                  _loc4_ = param1 + (param2 - param1) * 6 * param3;
               }
               else if(2 * param3 < 1)
               {
                  _loc4_ = param2;
               }
               else if(3 * param3 < 2)
               {
                  _loc4_ = param1 + (param2 - param1) * (2 / 3 - param3) * 6;
               }
               else
               {
                  _loc4_ = param1;
               }
               return _loc4_;
            };
            temp3 = hsl.h + 1 / 3;
            if(temp3 < 0)
            {
               temp3 += 1;
            }
            if(temp3 > 1)
            {
               temp3--;
            }
            rgb.r = this.colorSwitch(temp1,temp2,temp3);
            temp3 = hsl.h;
            if(temp3 < 0)
            {
               temp3 += 1;
            }
            if(temp3 > 1)
            {
               temp3--;
            }
            rgb.g = this.colorSwitch(temp1,temp2,temp3);
            temp3 = hsl.h - 1 / 3;
            if(temp3 < 0)
            {
               temp3 += 1;
            }
            if(temp3 > 1)
            {
               temp3--;
            }
            rgb.b = this.colorSwitch(temp1,temp2,temp3);
         }
         return {
            "r":Math.round(rgb.r * 255),
            "g":Math.round(rgb.g * 255),
            "b":Math.round(rgb.b * 255)
         };
      }
   }
}
