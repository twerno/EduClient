package pl.twerno.eduClient.Zadanie {
	import mx.managers.PopUpManager;
	
	import net.twerno.eduClient.RO.sesja.SesjaOtwartaRO;
	import net.twerno.eduClient.consts.Const;
	
	import pl.twerno.eduClient.Env.Env;
	import pl.twerno.eduClient.Zadanie.Quiz.ZadaniePlayer_Quiz;

	public class ZadanieWindowBuilder {
		public function ZadanieWindowBuilder() {
		}

		public function noweOkno(sesjaOtwarta:SesjaOtwartaRO):void {
			if (sesjaOtwarta.zadanie.typZadania == Const.TYP_ZADANIA_QUIZ)
				nowyQuiz(sesjaOtwarta);
		}

		public function nowyQuiz(sesjaOtwarta:SesjaOtwartaRO):void {
			var content:IZadaniePlayer = new ZadaniePlayer_Quiz();
			var quiz:ZadanieWindow = PopUpManager.createPopUp(Env.get.masterPanel, ZadanieWindow, true) as ZadanieWindow;
			quiz.init(sesjaOtwarta, new ZadaniePlayer_Quiz());
			quiz.otworz();
		}
	}
}