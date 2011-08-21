package pl.twerno.component.common.Env {
	import flash.events.EventDispatcher;
	
	import mx.containers.Accordion;
	
	import net.twerno.eduClient.EduClient;
	import net.twerno.eduClient.RO.Account;
	
	import pl.twerno.component.common.Images;
	import pl.twerno.eduClient.components.loginPage.LoginEvent;

	public class Env extends EventDispatcher {

		public const endPoint : String = 'http://localhost:8080/EduServer/messagebroker/amf';

		public var eduClient : EduClient = new EduClient(endPoint);
		
		public var images : Images = new Images();

		private var _loggedAccount : Account;
		public function get account():Account {return _loggedAccount}

		public function login(account:Account):void {
			_loggedAccount = account;
			dispatchEvent(new LoginEvent(LoginEvent.LOGGED_IN));
		}
		
		public function logout():void {
			if (!eduClient.userService.authenticated()) {
				return
			}

			eduClient.userService.logout();
			_loggedAccount = null;
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