package pl.twerno.eduClient.Env {
	import mx.controls.Alert;
	import mx.rpc.events.FaultEvent;
	
	import net.twerno.eduClient.rpc.tokens.RpcToken;

	public class RPCErrorHandler {
		
		private static var env:Env = Env.get;

		public static function handleError(info:FaultEvent, token:RpcToken, obsluzNieznane: Boolean = false):Boolean {
			if (info.fault.faultCode == 'Client.Error.MessageSend') {
				env.bladPolaczenia();
				throw new Error(dajFaultString2('Błąd połączenia z serwerem', info, token));
			}

			if (info.fault.faultCode == 'Client.Authorization') {
				env.logout();
				Alert.show("Przekroczono czas bezczynności. Zostałeś wylogowany.");
				return true;
//				throw new Error(dajFaultString2('Błąd autoryzacji.', info, token));
			}

			if (info.fault.faultCode == 'Server.ResourceUnavailable')
				throw new Error(dajFaultString2('Brak serwisu docelowego.', info, token));

			if (obsluzNieznane)
				throw new Error(dajFaultString2('Nieznany błąd', info, token));

			return false;
		} 

		public static function dajFaultString(info: String, faultEvent:FaultEvent):String {
			return info+'\n'
				+'<' +faultEvent.fault.faultCode +'>\n'
				+faultEvent.fault.faultString+'\n\n'
				+faultEvent.fault.faultDetail;
		}
		
		public static function dajFaultString2(info: String, faultEvent:FaultEvent, token:RpcToken):String {
			return '[' +token.destination +'.' +token.remoteMethod +'()] ' 
				+info+'\n'
				+'<' +faultEvent.fault.faultCode +'>\n'
				+faultEvent.fault.faultString+'\n\n'
				+faultEvent.fault.faultDetail;
		}
	}
}