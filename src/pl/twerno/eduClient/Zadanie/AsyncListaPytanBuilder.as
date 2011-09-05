package pl.twerno.eduClient.Zadanie {
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	import net.twerno.eduClient.RO.pytanie.PytanieZamkniete;
	import net.twerno.eduClient.RO.sesja.OpanowaniePytaniaRO;
	import net.twerno.eduClient.RO.sesja.SesjaOtwartaRO;
	import net.twerno.eduClient.RO.zadanie.ZadaneZadanie_ZbiorPytan;
	import net.twerno.eduClient.consts.Const;
	
	import pl.twerno.eduClient.panels.uczen.ZamknijZadanieEvent;

	public class AsyncListaPytanBuilder extends EventDispatcher {
		
		private const ZNAJOMOSC_NISKA   : String = 'ZNAJOMOSC_NISKA';
		private const ZNAJOMOSC_SREDNIA : String = 'ZNAJOMOSC_SREDNIA';
		private const ZNAJOMOSC_WYSOKA  : String = 'ZNAJOMOSC_WYSOKA';

		private const DP_ZNAJOMOSC_SREDNIA : Number = .6;
		private const DP_ZNAJOMOSC_WYSOKA  : Number = .84;
		
		public function AsyncListaPytanBuilder() {
		}
		
		public function budujListePytan(sesjaOtwarta:SesjaOtwartaRO):void {
			if (sesjaOtwarta.zadanie.typWyboruPytan == Const.TYP_WYBORU_PYTAN_LOSOWO) {
				wyborLosowy(sesjaOtwarta);
			} else if (sesjaOtwarta.zadanie.typWyboruPytan == Const.TYP_WYBORU_PYTAN_INTELIGENTNIE) {
				
				// jeśli mamy jeszcze za mało danych to losujemy
				if (sesjaOtwarta.opanowanePytania.length < sesjaOtwarta.zadanie.iloscPytan)
					wyborLosowy(sesjaOtwarta);
				else
					wyborLosowy(sesjaOtwarta);	
			}
		}
		
		private function wyborInteligentny(sesjaOtwarta:SesjaOtwartaRO):void {
			//zbiory<FLAGA_ZNAJOMOSC, ArrayCollection<PytanieZamkniete>>
			var zbiory:Dictionary = pogrupujPytaniaWgZnajomosci(sesjaOtwarta);

			//liczbaPytan<String, int>
			var liczbaPytan:Dictionary = okresLiczbePytanPerZbior(zbiory, sesjaOtwarta.zadanie.iloscPytan);
			var result:ArrayCollection = new ArrayCollection();
			var zzzp:ZadaneZadanie_ZbiorPytan;

			for (var o:Object in zbiory) {
				zzzp = o as ZadaneZadanie_ZbiorPytan;
				result.addAll(
					wybierzPytaniaZeZbioru(zbiory[zzzp], liczbaPytan[zzzp.zbiorPytanId]));
			}
			
			// poinformuj o zmianach
			var event:ListaPytanEvent = new ListaPytanEvent(ListaPytanEvent.UTWORZONA);
			event.result = result;
			this.dispatchEvent(event);
		}

		private function wyborLosowy(sesjaOtwarta:SesjaOtwartaRO):void {
			//zbiory<ZadaneZadanie_ZbiorPytan, ArrayCollection<PytanieZamkniete>>
			var zbiory:Dictionary      = pogrupujPytania(sesjaOtwarta);
			//liczbaPytan<String, int>
			var liczbaPytan:Dictionary = okresLiczbePytanPerZbior(zbiory, sesjaOtwarta.zadanie.iloscPytan);
			var result:ArrayCollection = new ArrayCollection();
			var zzzp:ZadaneZadanie_ZbiorPytan;
			
			for (var o:Object in zbiory) {
				zzzp = o as ZadaneZadanie_ZbiorPytan;
				result.addAll(
					wybierzPytaniaZeZbioru(zbiory[zzzp], liczbaPytan[zzzp.zbiorPytanId]));
			}

			// poinformuj o zmianach
			var event:ListaPytanEvent = new ListaPytanEvent(ListaPytanEvent.UTWORZONA);
			event.result = result;
			this.dispatchEvent(event);
		}
		
		private function okresLiczbePytanPerZbior(zbiory:Dictionary, maxIlosc:int):Dictionary {
			var result:Dictionary  = new Dictionary();
			var brakLimitu:Boolean = maxIlosc == 0;
			var o:Object;
			var zzzp:ZadaneZadanie_ZbiorPytan;
			
			if (brakLimitu) {

				for (o in zbiory) {
					zzzp = o as ZadaneZadanie_ZbiorPytan;
//					result[zzzp.zbiorPytanId] = 
//						Math.min((zbiory[zzzp] as ArrayCollection).length, zzzp.nieWiecejNiz);
				}
			} else {
				var pozostalo:int = maxIlosc;
				var wybierz:int;
				for (o in zbiory) {
					zzzp = o as ZadaneZadanie_ZbiorPytan;
//					wybierz = Math.max(0, Math.min(pozostalo, zzzp.coNajmniej, (zbiory[zzzp] as ArrayCollection).length)); 
					result[zzzp.zbiorPytanId] = wybierz;
					pozostalo -= wybierz;
				}

				// musimy wybrac wiecej elementów
				var osiagnietyLimit:Boolean = pozostalo <= 0;
				while (!osiagnietyLimit) {
					osiagnietyLimit = true;
					for (o in zbiory) {
						if (pozostalo > 0) {
							zzzp = o as ZadaneZadanie_ZbiorPytan;
//							if (result[zzzp.zbiorPytanId] < zzzp.nieWiecejNiz &&
//								result[zzzp.zbiorPytanId] < (zbiory[zzzp] as ArrayCollection).length) {
//								result[zzzp.zbiorPytanId] = result[zzzp.zbiorPytanId] +1;
//								osiagnietyLimit = false;
//								pozostalo -= 1;								
//							}								
						}
					}
				}
			}

			return result;
		}
		
		private function zliczWszystkieLimity(zbiory:Dictionary):int {
			var result:int = 0;
			var zzzp:ZadaneZadanie_ZbiorPytan;
			for (var o:Object in zbiory) {
				zzzp = o as ZadaneZadanie_ZbiorPytan;
//				result += zzzp.nieWiecejNiz;
			}
			return result;
		}
		
		private function zliczWszystkiePytania(zbiory:Dictionary):int {
			var result:int = 0;
			var zzzp:ZadaneZadanie_ZbiorPytan;
			for (var o:Object in zbiory) {
				zzzp = o as ZadaneZadanie_ZbiorPytan;
				result += (zbiory[zzzp] as ArrayCollection).length;
			}
			return result;
		}

		private function dajPytaniaZeZbioru(pytania:ArrayCollection, zbiorPytanId:String):ArrayCollection {
			var result:ArrayCollection = new ArrayCollection();
			
			for each(var pytanie:PytanieZamkniete in pytania)
				if (pytanie.zbiorPytanId == zbiorPytanId)
					result.addItem(pytanie);

			return result;
		}
		
		private function pogrupujPytania(sesjaOtwarta:SesjaOtwartaRO):Dictionary {
			var zbiory:Dictionary = new Dictionary();
			for each (var zzzp:ZadaneZadanie_ZbiorPytan in sesjaOtwarta.zadanie.zadanie_zbioryPytan)
				zbiory[zzzp] = dajPytaniaZeZbioru(sesjaOtwarta.pytania, zzzp.zbiorPytanId);
			return zbiory;	
		}
		
		private function pogrupujPytaniaWgZnajomosci(sesjaOtwarta:SesjaOtwartaRO):Dictionary {
			var zbiory:Dictionary    = new Dictionary();
			var pytania:Dictionary   = new Dictionary();
			var znajomosc:Dictionary = new Dictionary();
			
			zbiory[ZNAJOMOSC_NISKA]   = new ArrayCollection();
			zbiory[ZNAJOMOSC_SREDNIA] = new ArrayCollection();
			zbiory[ZNAJOMOSC_WYSOKA]  = new ArrayCollection();

			// init
			// kazdemu pytaniu przydzielamy flage niskiej znajomosci
			for each (var pytanie:PytanieZamkniete in sesjaOtwarta.pytania) {
				pytania[pytanie.id] = pytanie;
				znajomosc[pytanie]  = ZNAJOMOSC_NISKA;
			}	

			// przydzielamy flage kazdemu pytaniu na podstawie danych
			var procent:Number;
			var pyt:PytanieZamkniete;
			for each (var opanowane:OpanowaniePytaniaRO in sesjaOtwarta.opanowanePytania) {
				procent = opanowane.correctAnswers/opanowane.iloscPodejsc;
				pyt = pytanie[opanowane.pytanieId];
				if (procent > DP_ZNAJOMOSC_WYSOKA)
					znajomosc[pyt] = ZNAJOMOSC_WYSOKA;
				else if (procent > DP_ZNAJOMOSC_SREDNIA)
					znajomosc[pyt] = ZNAJOMOSC_SREDNIA;
			}
			
			var kat:String;
			for (var o:Object in znajomosc) {
				pyt = o as PytanieZamkniete;
				kat = znajomosc[o];
				zbiory[kat] = o;
			}

			return zbiory;
		}
		
		private function wybierzPytaniaZeZbioru(pytania:ArrayCollection, iloscPytan:int):ArrayCollection {
			if (pytania.length == iloscPytan)
				return pytania;
			if (pytania.length < iloscPytan)
				throw new Error("ilość pytań w zbiorze: " +pytania.length.toString() +" oczekiwano co najmniej: " +iloscPytan.toString());
			if (iloscPytan < 0) 
				throw new Error("ilośc pytań nie może być mniejsza niż 0");
			
			var result:ArrayCollection = new ArrayCollection();
			var pozostalo:int = iloscPytan;
			var wylosowaneIndexy:Dictionary = new Dictionary();
			var szansa:Number;
			
			while (pozostalo > 0) {
				szansa = pytania.length/(pytania.length -pozostalo);
				for each (var pytanie:PytanieZamkniete in pytania) {
					if (pozostalo > 0 &&
						wylosowaneIndexy[pytanie.id] != 'T' &&
					    szansa >= Math.random()) {
						result.addItem(pytanie);
						pozostalo -= 1;
						wylosowaneIndexy[pytanie.id] == 'T';
					}
				}
			}
			return result;
		}

//		public function
	}
}