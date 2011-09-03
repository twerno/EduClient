package pl.twerno.eduClient.Zadanie {
	import mx.core.IVisualElement;
	
	import net.twerno.eduClient.RO.pytanie.PytanieZamkniete;

	public interface IZadaniePlayer extends IVisualElement {
		
		function init(owner:ZadanieWindow):void;
		
		function initPytanie(pytanie:PytanieZamkniete):void;
		
		function sprawdz():Boolean;
	}
}