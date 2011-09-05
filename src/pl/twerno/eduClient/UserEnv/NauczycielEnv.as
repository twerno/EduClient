package pl.twerno.eduClient.UserEnv {
	import mx.collections.ArrayCollection;
	
	import net.twerno.eduClient.RO.pytanie.PytanieZamkniete;
	import net.twerno.eduClient.RO.pytanie.ZbiorPytan;
	import net.twerno.eduClient.RO.zadanie.Zadanie;
	
	[Bindable]
	public class NauczycielEnv implements IUserEnv {

		public var zbioryPytanList:ArrayCollection = new ArrayCollection();

		public var pytaniaList:ArrayCollection = new ArrayCollection();

		public var wybranyZbiorPytan:ZbiorPytan;

		public var zadaniaList:ArrayCollection = new ArrayCollection();
		
		public var wybraneZadanie:Zadanie;	
		
		public var dostepneZbioryPytanTypu:ArrayCollection = new ArrayCollection();
		
		public var wybraneGrupyDoZadania:ArrayCollection = new ArrayCollection();
		
		public var zadaneZadaniaList:ArrayCollection = new ArrayCollection();
		
		public var maxIloscPytan:int = 0;
		
		
		public function clean():void {
			zbioryPytanList.removeAll();
			pytaniaList.removeAll();
			wybranyZbiorPytan = null;
			wybraneZadanie = null;
			zadaniaList.removeAll();
			dostepneZbioryPytanTypu.removeAll();
			wybraneGrupyDoZadania.removeAll();
			zadaneZadaniaList.removeAll();
			maxIloscPytan = 0;
		}

		
		public function zapiszZbior(zbiorPytan:ZbiorPytan):void {
			zbioryPytanList.disableAutoUpdate();
			
			var nowyZbior:Boolean = true;
			
			for each (var zbior:ZbiorPytan in zbioryPytanList) {
				if (zbiorPytan.id == zbior.id) {
					var idx:int = zbioryPytanList.getItemIndex(zbior);
					zbioryPytanList.addItemAt(zbiorPytan, idx);
					zbioryPytanList.removeItemAt(idx+1);
					nowyZbior = false;
					break;
				}
			}

			if (nowyZbior)
				zbioryPytanList.addItem(zbiorPytan);

			zbioryPytanList.enableAutoUpdate();
		}

		public function zapisz_Zadanie(zadanie:Zadanie):void {
			zadaniaList.disableAutoUpdate();

			var old_Zadanie_idx:int = zadaniaList.length;

			for (var i:int = 0; i < zadaniaList.length; i++)
				if ((zadaniaList.getItemAt(i) as Zadanie).id == zadanie.id) {
					old_Zadanie_idx = i;
					zadaniaList.removeItemAt(old_Zadanie_idx);
					break;
				}

			zadaniaList.addItemAt(zadanie, old_Zadanie_idx);
			zadaniaList.enableAutoUpdate();
		}

		public function usunZbior(id:String):void {
			zbioryPytanList.disableAutoUpdate();
			for each (var zbior:ZbiorPytan in zbioryPytanList)
				if (zbior.id == id)
					zbioryPytanList.removeItemAt(zbioryPytanList.getItemIndex(zbior));
			zbioryPytanList.enableAutoUpdate();
		}
		
		public function NauczycielEnv() {
		}
	}
}