package pl.twerno.eduClient.UserEnv {
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.ResultEvent;
	import mx.utils.OnDemandEventDispatcher;
	
	import net.twerno.eduClient.RO.sesja.SesjaOtwartaRO;
	import net.twerno.eduClient.rpc.tokens.RpcToken;
	
	import pl.twerno.eduClient.Env.Env;
	
	[Bindable]
	public class UczenEnv extends EventDispatcher implements IUserEnv {
		
		public var zadaniaList:ArrayCollection = new ArrayCollection();
		
		public var sesjaOtwarta:SesjaOtwartaRO;		


		
		
		
		public function otworzSesje(zadaneZadanieId:String):void {
			var token:RpcToken = Env.get.eduClient.sesjaService.otworzSesje(zadaneZadanieId);
			token.newResponder(otworzSesjeHandler, Env.get.FaultHandler);
		}

		private function otworzSesjeHandler(event:ResultEvent, token:RpcToken):void {
			Env.get.zadanieBuilder.noweOkno(event.result as SesjaOtwartaRO);
		}

		public function zamknijSesje():void {
			if (!sesjaOtwarta) return;

			var token:RpcToken = Env.get.eduClient.sesjaService.zamknijSesje(sesjaOtwarta.sesjaId);
			token.newResponder(null, Env.get.FaultHandler);
			sesjaOtwarta = null;
		}
		
		
		public function UczenEnv() {
			
		}
		
		public function clean():void {
			zadaniaList.removeAll();
		}
	}
}