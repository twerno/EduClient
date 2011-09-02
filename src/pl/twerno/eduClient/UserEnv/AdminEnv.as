package pl.twerno.eduClient.UserEnv {
	import mx.collections.ArrayCollection;
	
	import net.twerno.eduClient.RO.user.Account;
	import net.twerno.eduClient.RO.user.Grupa;
	
	public class AdminEnv implements IUserEnv {

		[Bindable]
		public var accounts : ArrayCollection = new ArrayCollection; 
		
		[Bindable]
		public var grupy : ArrayCollection = new ArrayCollection();

		[Bindable]
		public var selectedUser:Account;
		
		public var selectedAccountIdx : int = -1;
		public var selectedGroupIdx   : int = -1;
		
		public function getGrupa(grupaName:String):Grupa {
			for each (var grupa:Grupa in grupy)
				if (grupa.nazwa == grupaName)
					return grupa;
			return null;
		}
		
		public function delGrupa(grupaName:String):void {
			grupy.disableAutoUpdate();
			accounts.disableAutoUpdate();
			
			for (var i:int = grupy.length -1; i >= 0; i--)
				if ((grupy.getItemAt(i) as Grupa).nazwa == grupaName)
					grupy.removeItemAt(i);

			for each (var acc:Account in accounts)
				acc.usunGrupe(grupaName);
				
			grupy.enableAutoUpdate();
			accounts.enableAutoUpdate();
		}
		
		public function clean():void {
			accounts.removeAll();
			grupy.removeAll();
		}
	}
}