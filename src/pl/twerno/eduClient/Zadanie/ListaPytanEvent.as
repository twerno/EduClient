package pl.twerno.eduClient.Zadanie {
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	public class ListaPytanEvent extends Event {
		
		public static const UTWORZONA : String = 'UTWORZONA_LISTA_PYTAN_EVENT';
		
		public var result:ArrayCollection;
		
		public function ListaPytanEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
	}
}