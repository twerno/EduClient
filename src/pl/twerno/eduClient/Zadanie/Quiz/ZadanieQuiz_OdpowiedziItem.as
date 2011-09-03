package pl.twerno.eduClient.Zadanie.Quiz {
	[Bindable]
	public class ZadanieQuiz_OdpowiedziItem {
		
		public var tresc:String;
		
		public var zaznaczone:Boolean = false;
		
		public var pytanieId:String;
		
		public var odpPytanieId:String;
		
		public var sprawdzone:Boolean = false;
		
		public var poprawne:Boolean;
		
		public function ZadanieQuiz_OdpowiedziItem(tresc:String, odpPytanieId:String) {
			this.tresc        = tresc;
			this.odpPytanieId = odpPytanieId;
		}
	}
}