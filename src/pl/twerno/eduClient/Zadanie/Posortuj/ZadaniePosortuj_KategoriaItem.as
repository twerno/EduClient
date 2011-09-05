package pl.twerno.eduClient.Zadanie.Posortuj {
	[Bindable]
	public class ZadaniePosortuj_KategoriaItem {
		public var poprawne:Boolean;
		
		public var kategoria:String;
		
		public function ZadaniePosortuj_KategoriaItem(kategoria:String):void {
			this.poprawne  = true;
			this.kategoria = kategoria;
		}
	}
}