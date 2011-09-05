package pl.twerno.eduClient.panels.nauczyciel {
	import flash.events.Event;
	
	public class NauczycielEvent extends Event {
		
		public static const TYP_WYBORU_CHANGED : String = 'TYP_WYBORU_CHANGED';
		
		public function NauczycielEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
	}
}