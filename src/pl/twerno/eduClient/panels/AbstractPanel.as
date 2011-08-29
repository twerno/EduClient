package pl.twerno.eduClient.panels {
	import spark.components.Group;
	
	public class AbstractPanel extends Group {
		
		public function AbstractPanel() {
			super();
			top    = 10;
			left   = 10;
			right  = 10;
			bottom = 10;
		}
		
		public function init():void {
			// virtual
		}
	}
}