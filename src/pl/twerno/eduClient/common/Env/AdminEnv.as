package pl.twerno.eduClient.common.Env {
	import mx.collections.ArrayCollection;
	
	import net.twerno.eduClient.RO.user.Account;
	
	public class AdminEnv implements IUserEnv {

		[Bindable]
		public var accounts : ArrayCollection = new ArrayCollection; 
		
		[Bindable]
		public var grupy : ArrayCollection = new ArrayCollection();

		[Bindable]
		public var selectedUser:Account;
		
		public function clean():void {
			accounts.removeAll();
			grupy.removeAll();
		}
	}
}