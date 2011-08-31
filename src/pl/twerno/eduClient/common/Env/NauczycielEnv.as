package pl.twerno.eduClient.common.Env {
	import mx.collections.ArrayCollection;
	
	import net.twerno.eduClient.RO.pytanie.PytanieZamkniete;
	import net.twerno.eduClient.RO.pytanie.ZbiorPytan;
	
	[Bindable]
	public class NauczycielEnv implements IUserEnv {

		public var zbioryPytanList:ArrayCollection = new ArrayCollection();

		public var pytaniaList:ArrayCollection = new ArrayCollection();

		public var wybranyZbiorPytan:ZbiorPytan;

//		public var wybranePytanie:PytanieZamkniete;

//		public var wybranePytanieIdx:int = -1;		
		
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
		
		public function usunZbior(id:String):void {
			zbioryPytanList.disableAutoUpdate();
			for each (var zbior:ZbiorPytan in zbioryPytanList)
				if (zbior.id == id)
					zbioryPytanList.removeItemAt(zbioryPytanList.getItemIndex(zbior));
			zbioryPytanList.enableAutoUpdate();
		}
		
		public function NauczycielEnv() {
		}
		
		public function clean():void {
			zbioryPytanList.removeAll();
			pytaniaList.removeAll();
			wybranyZbiorPytan = null;
//			wybranePytanie    = null;
//			wybranePytanieIdx = -1;
			
		}
	}
}