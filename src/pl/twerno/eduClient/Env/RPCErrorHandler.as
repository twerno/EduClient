package pl.twerno.eduClient.Env {
	import mx.controls.Alert;
	import mx.rpc.events.FaultEvent;

	public class RPCErrorHandler {
		
		private static var env:Env = Env.env;

		public static function handleError(info:FaultEvent, obsluzNieznane: Boolean = false):Boolean {
			if (info.fault.faultCode == 'Client.Error.MessageSend') {
//				Alert.show('Błąd połączenia z serwerem');
				env.bladPolaczenia();
				throw new Error('Błąd połączenia z serwerem');
//				return true;
			}
			
			if (info.fault.faultCode == 'Client.Authorization') {
				throw new Error('Błąd autoryzacji.');
			}
			
			if (obsluzNieznane) {
				Alert.show('<' +info.fault.faultCode +'> '+info.fault.faultString);
				return true;
			}

			return false;
		} 
	}
}