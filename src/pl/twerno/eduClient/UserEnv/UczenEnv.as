package pl.twerno.eduClient.UserEnv {
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class UczenEnv implements IUserEnv {
		
		public var zadaniaList:ArrayCollection = new ArrayCollection();
		
		
		
		public function UczenEnv() {
		}
		
		public function clean():void {
			zadaniaList.removeAll();
		}
	}
}