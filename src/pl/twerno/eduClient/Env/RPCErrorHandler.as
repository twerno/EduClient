package pl.twerno.eduClient.Env {
	import mx.controls.Alert;
	import mx.rpc.events.FaultEvent;

	public class RPCErrorHandler {
		
		private static var env:Env = Env.get;

		public static function handleError(info:FaultEvent, obsluzNieznane: Boolean = false):Boolean {
			if (info.fault.faultCode == 'Client.Error.MessageSend') {
				env.bladPolaczenia();
				throw new Error(dajFaultString('Błąd połączenia z serwerem', info));
			}

			if (info.fault.faultCode == 'Client.Authorization') {
				env.logout();
				Alert.show("Przekroczono czas bezczynności. Zostałeś wylogowany.");
				return true;
//				throw new Error(dajFaultString('Błąd autoryzacji.', info));
			}

			if (info.fault.faultCode == 'Server.ResourceUnavailable')
				throw new Error(dajFaultString('Brak serwisu docelowego.', info));

			if (obsluzNieznane)
				throw new Error(dajFaultString('Nieznany błąd', info));

			return false;
		} 

		public static function dajFaultString(info: String, faultEvent:FaultEvent):String {
			return info+'\n'
				+'<' +faultEvent.fault.faultCode +'>\n'
				+faultEvent.fault.faultString+'\n\n'
				+faultEvent.fault.faultDetail;
		}
	}
}