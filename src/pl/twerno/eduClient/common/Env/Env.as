package pl.twerno.eduClient.common.Env {
	import flash.events.EventDispatcher;
	
	import mx.containers.Accordion;
	import mx.controls.Alert;
	import mx.rpc.events.FaultEvent;
	
	import net.twerno.eduClient.EduClient;
	import net.twerno.eduClient.RO.ROOEntity;
	import net.twerno.eduClient.RO.user.Account;
	import net.twerno.eduClient.rpc.tokens.RpcToken;
	
	import pl.twerno.eduClient.panels.loginPage.LoginEvent;

	public class Env extends EventDispatcher {

		public const endPoint : String = 'http://localhost:8080/EduServer/messagebroker/amf';

		public var eduClient : EduClient = new EduClient(endPoint);
		
		[Bindable]
		public var adminEnv:AdminEnv = new AdminEnv();
		
		[Bindable]
		public var nauczycielEnv:NauczycielEnv = new NauczycielEnv();

		private var _loggedAccount : Account;
		public function get account():Account {return _loggedAccount}

		public function login(account:Account):void {
			_loggedAccount = account;
			dispatchEvent(new LoginEvent(LoginEvent.LOGGED_IN));
		}
		
		public function logout():void {
			adminEnv.clean();
			nauczycielEnv.clean();
			
//			if (!eduClient.userService.authenticated()) {
//				return
//			}

			eduClient.userService.logout();
			_loggedAccount = null;
			dispatchEvent(new LoginEvent(LoginEvent.LOGGED_OUT));
		}

		public function bladPolaczenia():void {
			Alert.show("Błąd połączenia");
			eduClient.otwartePolaczenie = false;
			logout();
		}
		
		public function FaultHandler(info:FaultEvent, token:RpcToken):void {
			RPCErrorHandler.handleError(info, true);
		}
		
		public function showDetails(rooEntity:ROOEntity):void {
			Alert.show(rooEntity.detailedToString());
		}
		
		
		private static var _env : Env;
		public static function get get():Env {
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