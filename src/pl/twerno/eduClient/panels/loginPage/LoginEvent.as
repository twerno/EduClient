package pl.twerno.eduClient.panels.loginPage {
	import flash.events.Event;
	
	public class LoginEvent extends Event {
		public static const LOGGED_IN : String = 'LOGGED_IN';
		public static const LOGGED_OUT : String = 'LOGGED_OUT';
		
		public function LoginEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
	}
}