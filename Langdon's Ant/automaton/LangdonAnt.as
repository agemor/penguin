package automaton 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * 랭던의 개미 시뮬레이터
	 * 
	 * @author 김현준
	 */
	public class LangdonAnt {
		
		// 오토마톤 진행 상황이 표시될 비트맵 데이터
		private var output:BitmapData;
		
		// 디폴트 값으로 설정할 랭던의 개미 규칙
		public var rules:Array = [
			{color:0x333333, clockwise:true},			
					{color:0x000000, clockwise:false}
		]
		
		// 갱신을 위한 좌표 정보
		private var center:Point;
		private var current:Point;
		private var previous:Point;
		private var width:int;
		private var height:int;
		
		// 스텝 카운터
		public var stepCount:int = 0;
		
		/**
		 * 새로운 랭던의 개미 오토마톤을 생성한다.
		 * 
		 * @param	width 진행 상황이 표시될 비트맵의 가로 크기
		 * @param	height 진행 상황이 표시될 비트맵의 세로 크기
		 * @param	rules 랭던의 개미 규칙
		 */
		public function LangdonAnt(width:int, height:int, rules:Array = null) {
			
			if (rules != null) this.rules = rules;
			
			this.width = width;
			this.height = height;
			
			output = new BitmapData(width, height, false, 0x333333);
			center = new Point(Math.floor(width / 2), Math.floor(height / 2));
			current = new Point(0, 0);
			previous = new Point(0, -1);
		}
		
		/**
		 * 현재 좌표 데이터를 바탕으로 오토마톤을 진행한다.
		 */
		public function step():void {
			
			// 현재 개미가 있는 위치의 픽셀 색상을 가져온다.
			var currentCellColor:uint = output.getPixel(center.x + current.x, center.y + current.y);
			var nextCellColor:uint = 0;
			var isClockwise:Boolean = false;
			
	
			// 변경할 조건을 가져온다.
			for (var i:int = 0; i < rules.length; i++) {				
				if (rules[i]["color"] == currentCellColor) {					
					var nextRule:Object = rules[(i+1) % (rules.length)];
					nextCellColor = nextRule["color"] as uint;
					isClockwise = nextRule["clockwise"] as Boolean;
					break;
				}
			}
			// 선택된 픽셀의 색상을 갱신한다.	
			output.setPixel(center.x + current.x, center.y + current.y, nextCellColor);	
			
			// 개미의 좌표를 갱신한다.
			var nextX:int = (current.y - previous.y) * (isClockwise ? 1 : -1);
			var nextY:int = (current.x - previous.x) * (isClockwise ? -1 : 1);
			
			previous.x = current.x;
			previous.y = current.y;
			current.x += nextX;
			current.y += nextY;
			
			stepCount++;
		}
		
		/**
		 * 모든 정보를 초기화한다.
		 */
		public function clear():void {
			stepCount = 0;
			previous.x = 0
			previous.y = -1;
			current.x = 0;
			current.y = 0;
			output.fillRect(new Rectangle(0, 0, width, height), 0x333333);
		}
		
		public function getBitmapData():BitmapData {
			return output;
		}
	}
}