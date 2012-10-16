package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	[ SWF( width = "400", height = "400", frameRate = "60", backgroundColor = "#FFFFFF" ) ]
	public class ClickGame extends Sprite
	{
		[ Embed( source = "KoPubBatangMedium.ttf", fontName = "KoPubBatangMedium", mimeType = "application/x-font-truetype", advancedAntiAliasing="true", embedAsCFF = "false", unicodeRange = "U+0020,U+ae00,U+c790,U+b97c,U+d558,U+b098,U+b77c,U+b3c4,U+d074,U+b9ad,U+ae30,U+b9cc,U+ba74,U+c2b9,U+b9ac,U+b294,U+ac8c,U+c784,U+c600,U+c2b5,U+b2c8,U+b2e4" ) ]
		public static var KoPub:Class;
		private static const mainComment:String = "글자를 하나라도 클릭하기만 하면 승리하는 게임";
		private static const successComment:String = "승리하였습니다";
		private var koPubFormat:TextFormat;
		private var mainField:TextField;
		private var successField:TextField;
		private var subFields:Array;
		
		public function ClickGame()
		{
			var koPub:Font = new KoPub;
			koPubFormat = new TextFormat( koPub.fontName, 17, 0 );
			mainField = createTextField( mainComment );
			subFields = splitByChar( mainField );
			for each( var subField:TextField in subFields )
			{
				makeAvoider( subField );
				addChild( subField );
				addEventListener( MouseEvent.CLICK, CLICK );
			}
			successField = addChild( createTextField( successComment ) ) as TextField;
			successField.visible = false;
		}
		
		private function CLICK( e:MouseEvent ):void
		{
			for each( var subField:TextField in subFields )
			{
				removeChild( subField );
				removeEventListener( MouseEvent.CLICK, CLICK );
			}
			successField.visible = true;
		}
		
		private function makeAvoider( avoider:DisplayObject, speed:Number = 0.35, factor:Number = 250000 ):void
		{
			var cx:Number = avoider.x;
			var cy:Number = avoider.y;
			function avoid( e:Event ):void
			{
				var dx:Number = avoider.x - mouseX;
				var dy:Number = avoider.y - mouseY;
				var dist:Number = Math.sqrt( dx * dx + dy * dy );
				var dist3:Number = dist * dist * dist;
				var fx:Number = factor / dist3 * dx;
				var fy:Number = factor / dist3 * dy;
				avoider.x = avoider.x + speed * ( cx + fx - avoider.x );
				avoider.y = avoider.y + speed * ( cy + fy - avoider.y );
			}
			avoider.addEventListener( Event.ENTER_FRAME, avoid );
		}
		
		private function createTextField( text:String ):TextField
		{
			var field:TextField = new TextField;
			field.embedFonts = true;
			field.antiAliasType = AntiAliasType.ADVANCED;
			field.autoSize = TextFieldAutoSize.LEFT;
			field.defaultTextFormat = koPubFormat;
			field.text = text;
			field.x = ( stage.stageWidth / 2 ) - ( field.width / 2 );
			field.y = ( stage.stageHeight / 2 ) - ( field.height / 2 );
			field.selectable = false;
			return field;
		}
		
		private function splitByChar( tf:TextField, splitSpace:Boolean = false ):Array {
			var returnArray:Array = new Array;
			var currentTextRect:Rectangle = tf.getCharBoundaries( 0 );
			var currentChar:String;
			var currentLength:int;
			var adjustValue:Point = new Point;
			adjustValue.x = tf.x - currentTextRect.x;
			adjustValue.y = tf.y - currentTextRect.y;
			for( var i:int; i<tf.length; ++i ) {
				currentChar = tf.text.charAt( i );
				if( currentChar == "\r" || ( splitSpace && ( currentChar == " " || currentChar == "\t" ) ) ) {
					continue;
				}
				returnArray.push( new TextField );
				currentLength = returnArray.length - 1;
				currentTextRect = tf.getCharBoundaries( i );
				with( returnArray[ currentLength ] )
				{
					x = currentTextRect.x + adjustValue.x;
					y = currentTextRect.y + adjustValue.y;
					text = currentChar;
					autoSize = TextFieldAutoSize.LEFT;
					multiline = false;
					mouseWheelEnabled = false;
					embedFonts = tf.embedFonts;
					type = tf.type;
					selectable = tf.selectable;
					antiAliasType = tf.antiAliasType;
					defaultTextFormat = tf.defaultTextFormat;
					setTextFormat( tf.getTextFormat( i, i+1 ) );
				}
			}
			return returnArray;
		}
		
	}
}