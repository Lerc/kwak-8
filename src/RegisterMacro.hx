package  ;

/**
 * ...
 * @author Lerc
 */
import haxe.macro.Context;
import haxe.macro.Expr;

class RegisterMacro
{
	macro static public function memoryMappedRegister(fieldName:String,index :Int):Array<Field> {
    var fields = Context.getBuildFields();
	
	var getterName = "get_" + fieldName;
	var setterName = "set_" + fieldName;
	var getterFunction = macro : {
		public var $fieldName(get, set) : Int;
		inline function $getterName() : Int {
			return ram[ $v{index} ];
         }
		 inline function $setterName(value:Int) : Int {
                return ram[$v{index}]=value;
         }
	};
	switch (getterFunction) {
		case TAnonymous(getterFields):
			fields=fields.concat(getterFields);
		default:
			throw 'unreachable';
	}
	
    return fields;
	}
}