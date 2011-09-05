package pl.twerno.eduClient.Zadanie {
	import mx.managers.PopUpManager;
	
	import net.twerno.eduClient.RO.sesja.SesjaOtwartaRO;
	import net.twerno.eduClient.consts.Const;
	
	import pl.twerno.eduClient.Env.Env;
	import pl.twerno.eduClient.Zadanie.Posortuj.ZadaniePlayer_Posortuj;
	import pl.twerno.eduClient.Zadanie.Quiz.ZadaniePlayer_Quiz;

	public class ZadanieWindowBuilder {
		public function ZadanieWindowBuilder() {
		}

		public function noweOkno(sesjaOtwarta:SesjaOtwartaRO):void {
			if (sesjaOtwarta.zadanie.typZadania == Const.TYP_ZADANIA_QUIZ)
				nowyQuiz(sesjaOtwarta);
			else if (sesjaOtwarta.zadanie.typZadania == Const.TYP_ZADANIA_POSORTUJ)
				nowyPosortuj(sesjaOtwarta);
		}

		public function nowyQuiz(sesjaOtwarta:SesjaOtwartaRO):void {
			var zadanie:ZadanieWindow = PopUpManager.createPopUp(Env.get.masterPanel, ZadanieWindow, true) as ZadanieWindow;
			zadanie.init(sesjaOtwarta, new ZadaniePlayer_Quiz());
			zadanie.otworz();
		}
		
		public function nowyPosortuj(sesjaOtwarta:SesjaOtwartaRO):void {
			var zadanie:ZadanieWindow = PopUpManager.createPopUp(Env.get.masterPanel, ZadanieWindow, true) as ZadanieWindow;
			zadanie.init(sesjaOtwarta, new ZadaniePlayer_Posortuj());
			zadanie.otworz();
		}
	}
}