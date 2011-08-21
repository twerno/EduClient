package pl.twerno.eduClient.Env {
	import flash.events.EventDispatcher;
	
	import mx.containers.Accordion;
	
	import net.twerno.eduClient.EduClient;
	import net.twerno.eduClient.RO.Account;
	
	import pl.twerno.component.loginPage.LoginEvent;

	public class Env extends EventDispatcher {

		public const endPoint : String = 'http://localhost:8080/EduServer/messagebroker/amf';

		public var eduClient : EduClient = new EduClient(endPoint);

		public var loggedAccount : Account;

		public function login(account:Account):void {
			loggedAccount = account;
			dispatchEvent(new LoginEvent(LoginEvent.LOGGED_IN));
		}
		
		public function logout():void {
			if (!eduClient.userService.authenticated()) {
				return
			}

			eduClient.userService.logout();
			loggedAccount = null;
			dispatchEvent(new LoginEvent(LoginEvent.LOGGED_OUT));
		}
		
		public function bladPolaczenia():void {
			eduClient.otwartePolaczenie = false;
			logout();
		}
		
		private static var _env : Env;
		public static function get env():Env {
			if (!_env) {_env = new Env()}
			return _env;
		}

		public function Env() {
			if (_env) {
				throw new Error('Env może być tylko jeden.');
			}
		}
	}
}