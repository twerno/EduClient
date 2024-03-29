package pl.twerno.eduClient.supportClasses.passwordValidator {
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	
	public class PasswordValidator extends Validator {
		public function PasswordValidator() {
			super();
		}

		public var confirmationSource: Object;
		public var confirmationProperty: String;

		override protected function doValidation(value:Object):Array {
			var info:PasswordValidatorInfo = value as PasswordValidatorInfo;
			
			var results:Array = super.doValidation(info.password);
			
			if (info.password != info.confirmation) {
				results.push(new ValidationResult(true, null, "Niezgodność",
					"Wpisane hasła różnią się!"));
			}
			return results;
		}       
		
		/**
		 *  @private
		 *  Grabs the data for the confirmation password from its different sources
		 *  if its there and bundles it to be processed by the doValidation routine.
		 */
		override protected function getValueFromSource():Object {
			var value:PasswordValidatorInfo = new PasswordValidatorInfo();
			
			value.password = super.getValueFromSource().toString();
			
			if (confirmationSource && confirmationProperty) {
				value.confirmation = confirmationSource[confirmationProperty];
			}
			
			return  value;
		}  
	}
}