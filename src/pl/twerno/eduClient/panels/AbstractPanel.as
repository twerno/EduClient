package pl.twerno.eduClient.panels {
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	
	import pl.twerno.eduClient.Env.Env;
	
	import spark.components.Group;
	import spark.effects.Fade;
	
	public class AbstractPanel extends Group {
		
		public var fadeIn:Fade;
		public var fadeOut:Fade;
		
		[Bindable]
		protected var env:Env = Env.get;
		
		public function AbstractPanel() {
			super();
			top    = 10;
			left   = 10;
			right  = 10;
			bottom = 10;
			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
			addEventListener(Event.ADDED_TO_STAGE, addedHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedHandler);
			
			fadeIn           = new Fade(this);
			fadeIn.alphaFrom = 0;
			fadeIn.alphaTo   = 1;
			fadeIn.duration  = 300;
			
			fadeOut           = new Fade(this);
			fadeOut.alphaFrom = 1;
			fadeOut.alphaTo   = 0;
			fadeOut.duration  = 200;         
		}
		
		public function init():void {
			// virtual
		}
		
		protected function creationCompleteHandler(event:FlexEvent):void {
//			init();
		}
		
		protected function addedHandler(event:Event):void {
			fadeIn.play([this]);
		}
		
		protected function removedHandler(event:Event):void {
			fadeOut.play([this]);
		}
	}
}