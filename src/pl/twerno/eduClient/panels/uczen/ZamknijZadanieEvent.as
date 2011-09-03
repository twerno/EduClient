package pl.twerno.eduClient.panels.uczen {
	import flash.events.Event;
	
	public class ZamknijZadanieEvent extends Event {

		public static const ZAMKNIJ_ZADANIE : String = 'ZAMKNIJ_ZADANIE';

		public function ZamknijZadanieEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
	}
}