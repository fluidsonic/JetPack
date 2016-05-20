public extension SignedNumberType {
  var sign: Self {
    if self == 0 {
      return 0
    }
    else if self < 0 {
      return -1
    }
    return 1
  }
}