package pl.twerno.eduClient.panels {
	
	[Bindable]
	public class MenuItem {
		
		public var label : String;
		public var glyph : Object;
		public var panel : AbstractPanel;
		
		public function MenuItem(label: String, glyph: Object, panel:AbstractPanel) {
			this.label = label;
			this.glyph = glyph;
			this.panel = panel;
		}
	}
}