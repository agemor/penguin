package  
{
	import automaton.LangdonAnt;
	import flash.display.Bitmap;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	/**
	 * 랭던의 개미 런처
	 * 
	 * @author 김현준
	 */
	public class Main extends Sprite {
		
		// 사용자 UI
		var startButton:SimpleButton;
		var pauseButton:SimpleButton;
		var stopButton:SimpleButton;
		var renderingSpeedText:TextField;
		var optionsText:TextField;
		var stepsText:TextField;
		
		// 오토마톤
		var langdon:LangdonAnt;
		
		// 비트맵 캔버스
		var canvas:Bitmap;
		
		//타이머
		var timer:Timer;		
		var speed:int = 1000;
		
		public function Main() {	
			
			langdon = new LangdonAnt(500, 500);
			canvas = new Bitmap(langdon.getBitmapData());
			addChild(canvas);
			
			canvas.y = 65;
			canvas.x = 5;
			
			timer = new Timer(1);
			timer.addEventListener(TimerEvent.TIMER, tick);
			
			
			addEventListener(Event.ADDED_TO_STAGE, onStageLoad);
		}
		
		/**
		 * 옵션을 파싱한다.
		 * 
		 * @param	raw
		 * @return
		 */
		private function parseOption(raw:String):Array {
			
			var lines:Array = raw.split("\r");
			var rules:Array = [];
			
			for (var i:int = 0; i < lines.length; i++) {
				var data:Array = lines[i].split(",");
				
				if (data.length < 2) continue;
				
				var rawColor:String = trim(data[0]);
				var rawClockwise:String = trim(data[1]);
				
				if (rawColor.length < 1 || rawClockwise.length < 1) continue;
				if (rawClockwise != "1" && rawClockwise != "0") continue;
				
				var rule:Object = new Object();
				rule["color"] = int("0x"+rawColor);
				rule["clockwise"] = rawClockwise == "1" ? true : false;
				
				rules.push(rule);				
			}
			
			if (rules.length < 1) {
				rules = [
					{color:0x333333, clockwise:true},			
					{color:0x000000, clockwise:false}
				]
			}
			
			return rules;
		}
		
		private function onStartButtonClick(e:MouseEvent):void {
			
			langdon.rules = parseOption(optionsText.text)
			
			speed = int(renderingSpeedText.text);			
			timer.start();			
			
		}
		private function onPauseButtonClick(e:MouseEvent):void {
			timer.stop();
		}
		
		private function onStopButtonClick(e:MouseEvent):void {
			timer.stop();
			langdon.clear();
		}
		
		private function onStageLoad(e:Event):void {
			
			startButton = getChildByName("start_button") as SimpleButton;			
			pauseButton = getChildByName("pause_button") as SimpleButton;
			stopButton = getChildByName("stop_button") as SimpleButton;
			renderingSpeedText = getChildByName("speed_text") as TextField;
			optionsText = getChildByName("options_text") as TextField;
			stepsText = getChildByName("steps_text") as TextField;
			
			startButton.addEventListener(MouseEvent.CLICK, onStartButtonClick);
			pauseButton.addEventListener(MouseEvent.CLICK, onPauseButtonClick);
			stopButton.addEventListener(MouseEvent.CLICK, onStopButtonClick);
		}
		
		var current:Number = 0;
		var previous:Number = 0;
		var delta:Number;
		private function tick(e:TimerEvent):void {
			
			current = getTimer();
			delta = current - previous;
			previous = current;
			
			canvas.bitmapData.lock();
			for (var i:int = 0; i < speed; i++) langdon.step();
			canvas.bitmapData.unlock();
			
			stepsText.text = String(langdon.stepCount) + "/" + Math.round(speed/delta*2);
		}
		
		public function trim( s:String ):String{
			return s.replace( /^([\s|\t|\n]+)?(.*)([\s|\t|\n]+)?$/gm, "$2" );
		}
	}

}