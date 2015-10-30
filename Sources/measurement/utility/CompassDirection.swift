import Darwin


public enum CompassDirection8 {
	case North
	case NE
	case East
	case SE
	case South
	case SW
	case West
	case NW


	public static let all: [CompassDirection8] = [
		.North,
		.NE,
		.East,
		.SE,
		.South,
		.SW,
		.West,
		.NW,
	]
}


extension CompassDirection8 {

	public var mediumName: String {
		switch self {
		case North: return "North"
		case NE:    return "NE"
		case East:  return "East"
		case SE:    return "SE"
		case South: return "South"
		case SW:    return "SW"
		case West:  return "West"
		case NW:    return "NW"
		}
	}


	public var shortName: String {
		switch self {
		case North: return "N"
		case NE:    return "NE"
		case East:  return "E"
		case SE:    return "SE"
		case South: return "S"
		case SW:    return "SW"
		case West:  return "W"
		case NW:    return "NW"
		}
	}


	public var to16: CompassDirection16 {
		switch self {
		case North: return .North
		case NE:    return .NE
		case East:  return .East
		case SE:    return .SE
		case South: return .South
		case SW:    return .SW
		case West:  return .West
		case NW:    return .NW
		}
	}
}


public enum CompassDirection16 {
	case North
	case NNE
	case NE
	case ENE
	case East
	case ESE
	case SE
	case SSE
	case South
	case SSW
	case SW
	case WSW
	case West
	case WNW
	case NW
	case NNW


	public static let all: [CompassDirection16] = [
		.North,
		.NNE,
		.NE,
		.ENE,
		.East,
		.ESE,
		.SE,
		.SSE,
		.South,
		.SSW,
		.SW,
		.WSW,
		.West,
		.WNW,
		.NW,
		.NNW,
	]
}


extension CompassDirection16 {

	public var mediumName: String {
		switch self {
		case North: return "North"
		case NNE:   return "NNE"
		case NE:    return "NE"
		case ENE:   return "ENE"
		case East:  return "East"
		case ESE:   return "ESE"
		case SE:    return "SE"
		case SSE:   return "SSE"
		case South: return "South"
		case SSW:   return "SSW"
		case SW:    return "SW"
		case WSW:   return "WSW"
		case West:  return "West"
		case WNW:   return "WNW"
		case NW:    return "NW"
		case NNW:   return "NNW"
		}
	}


	public var shortName: String {
		switch self {
		case North: return "N"
		case NNE:   return "NNE"
		case NE:    return "NE"
		case ENE:   return "ENE"
		case East:  return "E"
		case ESE:   return "ESE"
		case SE:    return "SE"
		case SSE:   return "SSE"
		case South: return "S"
		case SSW:   return "SSW"
		case SW:    return "SW"
		case WSW:   return "WSW"
		case West:  return "W"
		case WNW:   return "WNW"
		case NW:    return "NW"
		case NNW:   return "NNW"
		}
	}
}



public extension Angle {

	public var compassDirection8: CompassDirection8 {
		var sector = Int(round(8 * degrees / 360)) % 8
		if sector < 0 {
			sector += 8
		}

		switch sector {
		case 0:  return .North
		case 1:  return .NE
		case 2:  return .East
		case 3:  return .SE
		case 4:  return .South
		case 5:  return .SW
		case 6:  return .West
		case 7:  return .NW
		default: fatalError("\(self) resulted in invalid compass sector \(sector)")
		}
	}


	public var compassDirection16: CompassDirection16 {
		var sector = Int(round(16 * degrees / 360)) % 16
		if sector < 0 {
			sector += 16
		}

		switch sector {
		case 0:  return .North
		case 1:  return .NNE
		case 2:  return .NE
		case 3:  return .ENE
		case 4:  return .East
		case 5:  return .ESE
		case 6:  return .SE
		case 7:  return .SSE
		case 8:  return .South
		case 9:  return .SSW
		case 10: return .SW
		case 11: return .WSW
		case 12: return .West
		case 13: return .WNW
		case 14: return .NW
		case 15: return .NNW
		default: fatalError("\(self) resulted in invalid compass sector \(sector)")
		}
	}
}
