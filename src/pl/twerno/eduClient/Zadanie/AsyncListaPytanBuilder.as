package pl.twerno.eduClient.Zadanie {
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	import net.twerno.eduClient.RO.pytanie.PytanieZamkniete;
	import net.twerno.eduClient.RO.sesja.OpanowaniePytaniaRO;
	import net.twerno.eduClient.RO.sesja.SesjaOtwartaRO;
	import net.twerno.eduClient.RO.zadanie.ZadaneZadanie_ZbiorPytan;
	import net.twerno.eduClient.consts.Const;
	
	import pl.twerno.commLib.helpers.MathHelper;
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
			if (sesjaOtwarta.zadanie.typWyboruPytan == Const.TYP_WYBORU_PYTAN_LOSOWO)
				wyborLosowy(sesjaOtwarta);
			else if (sesjaOtwarta.zadanie.typWyboruPytan == Const.TYP_WYBORU_PYTAN_INTELIGENTNIE)
				wyborInteligentny(sesjaOtwarta);
		}

		private function wyborInteligentny(sesjaOtwarta:SesjaOtwartaRO):void {
			//zbiory<FLAGA_ZNAJOMOSC, ArrayCollection<PytanieZamkniete>>
			var zbiory:Dictionary = pogrupujPytaniaWgZnajomosci(sesjaOtwarta);
			var result:ArrayCollection = new ArrayCollection();
			var zzzp:ZadaneZadanie_ZbiorPytan;

			var pytania_nieznane_count:int  = Math.min( (zbiory[ZNAJOMOSC_NISKA]   as ArrayCollection).length,
				                                         Math.floor(sesjaOtwarta.zadanie.iloscPytan /3));
			var pytania_znane_count:int     = Math.min( (zbiory[ZNAJOMOSC_SREDNIA] as ArrayCollection).length, 
				                                         Math.floor(sesjaOtwarta.zadanie.iloscPytan /3));
			var pytania_opanowane_count:int = Math.min( (zbiory[ZNAJOMOSC_WYSOKA]  as ArrayCollection).length, 
			                                             Math.floor(sesjaOtwarta.zadanie.iloscPytan /3));
			var pytanie_pozostale : int = sesjaOtwarta.zadanie.iloscPytan 
				                         -pytania_nieznane_count 
										 -pytania_znane_count 
										 -pytania_opanowane_count;

			result.addAll(wylosujPytania(zbiory[ZNAJOMOSC_NISKA],   pytania_nieznane_count));
			result.addAll(wylosujPytania(zbiory[ZNAJOMOSC_SREDNIA], pytania_znane_count));
			result.addAll(wylosujPytania(zbiory[ZNAJOMOSC_WYSOKA],  pytania_opanowane_count));
			result.addAll(wylosujPytania(sesjaOtwarta.pytania,      pytanie_pozostale));

			// poinformuj o zmianach
			var event:ListaPytanEvent = new ListaPytanEvent(ListaPytanEvent.UTWORZONA);
			event.result = result;
			this.dispatchEvent(event);
		}

		private function wyborLosowy(sesjaOtwarta:SesjaOtwartaRO):void {
			//zbiory<ZadaneZadanie_ZbiorPytan, ArrayCollection<PytanieZamkniete>>
			var zbiory:Dictionary      = pogrupujPytania(sesjaOtwarta);
			var result:ArrayCollection = new ArrayCollection();
			var zzzp:ZadaneZadanie_ZbiorPytan;
			
			for (var o:Object in zbiory) {
				zzzp = o as ZadaneZadanie_ZbiorPytan;
				result.addAll(
					wylosujPytania(zbiory[zzzp], zzzp.iloscPytan));
			}

			// poinformuj o zmianach
			var event:ListaPytanEvent = new ListaPytanEvent(ListaPytanEvent.UTWORZONA);
			event.result = result;
			this.dispatchEvent(event);
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

		private function wylosujPytania(pytania:ArrayCollection, iloscPytan:int):ArrayCollection {
			if (pytania.length < iloscPytan)
				throw new Error("ilość pytań w zbiorze: " +pytania.length.toString() +" oczekiwano co najmniej: " +iloscPytan.toString());
			if (iloscPytan < 0)
				throw new Error("ilośc pytań nie może być mniejsza niż 0");
			if (pytania.length == 0)
				throw new Error('zbiór pytań jest pusty');

			var result:ArrayCollection = new ArrayCollection();
			var idx:int;
			for (var i:int = 0; i < iloscPytan; i++) {
				idx = MathHelper.nextInt(pytania.length -1);
				result.addItem(pytania.getItemAt(idx));
				pytania.removeItemAt(idx);
			}

			return result;
		}
	}
}