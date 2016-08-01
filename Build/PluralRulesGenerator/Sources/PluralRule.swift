internal struct PluralRule {

	internal var category: String
	internal var expression: Expression


	internal init(category: String, expression: Expression) {
		self.category = category
		self.expression = expression
	}



	internal enum BinaryOperator {

		case and
		case equal
		case modulus
		case notEqual
		case or
	}



	internal enum Expression {

		indirect case binaryOperation(left: Expression, op: BinaryOperator, right: Expression)
		case constant(Value)
		case multipleConstants([Value])
		case variable(String)
	}



	internal enum Value {

		case number(Int)
		case numberRange(ClosedInterval<Int>)
	}

}
