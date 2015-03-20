public enum CompassDirection {
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
}


extension CompassDirection {

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

	public var compassDirection: CompassDirection {
		var normalizedDegrees = degrees % 360  // -360 ..< 360
		if normalizedDegrees < 0 {
			normalizedDegrees += 360  // 0 ..< 360
		}

		// half sector before, half sector after needle point
		let sector = Int(round(normalizedDegrees / 16) - 0.5) // 0 ..< 16

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
		default: return .North
		}
	}
}
