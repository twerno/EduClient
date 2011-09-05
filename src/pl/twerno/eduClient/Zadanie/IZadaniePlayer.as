package pl.twerno.eduClient.Zadanie {
	import mx.collections.ArrayCollection;
	import mx.core.IVisualElement;
	
	import net.twerno.eduClient.RO.pytanie.PytanieZamkniete;
	import net.twerno.eduClient.RO.sesja.SesjaOtwartaRO;

	public interface IZadaniePlayer extends IVisualElement {
		
		function init(owner:ZadanieWindow, sesja:SesjaOtwartaRO, listaPytan:ArrayCollection):void;
		
		function initPytanie(pytanie:PytanieZamkniete):void;
		
		function sprawdz():Boolean;
	}
}