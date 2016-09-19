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
		case North: return MeasuresStrings.CompassDirection.Long.north
		case NE:    return MeasuresStrings.CompassDirection.Short.northEast
		case East:  return MeasuresStrings.CompassDirection.Long.east
		case SE:    return MeasuresStrings.CompassDirection.Short.southEast
		case South: return MeasuresStrings.CompassDirection.Long.south
		case SW:    return MeasuresStrings.CompassDirection.Short.southWest
		case West:  return MeasuresStrings.CompassDirection.Long.west
		case NW:    return MeasuresStrings.CompassDirection.Short.northWest
		}
	}


	public var shortName: String {
		switch self {
		case North: return MeasuresStrings.CompassDirection.Short.north
		case NE:    return MeasuresStrings.CompassDirection.Short.northWest
		case East:  return MeasuresStrings.CompassDirection.Short.east
		case SE:    return MeasuresStrings.CompassDirection.Short.southEast
		case South: return MeasuresStrings.CompassDirection.Short.south
		case SW:    return MeasuresStrings.CompassDirection.Short.southWest
		case West:  return MeasuresStrings.CompassDirection.Short.west
		case NW:    return MeasuresStrings.CompassDirection.Short.northWest
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
		case North: return MeasuresStrings.CompassDirection.Long.north
		case NNE:   return MeasuresStrings.CompassDirection.Short.northNorthEast
		case NE:    return MeasuresStrings.CompassDirection.Short.northEast
		case ENE:   return MeasuresStrings.CompassDirection.Short.eastNorthEast
		case East:  return MeasuresStrings.CompassDirection.Long.east
		case ESE:   return MeasuresStrings.CompassDirection.Short.eastSouthEast
		case SE:    return MeasuresStrings.CompassDirection.Short.southEast
		case SSE:   return MeasuresStrings.CompassDirection.Short.southSouthEast
		case South: return MeasuresStrings.CompassDirection.Long.south
		case SSW:   return MeasuresStrings.CompassDirection.Short.southSouthWest
		case SW:    return MeasuresStrings.CompassDirection.Short.southWest
		case WSW:   return MeasuresStrings.CompassDirection.Short.westSouthWest
		case West:  return MeasuresStrings.CompassDirection.Long.west
		case WNW:   return MeasuresStrings.CompassDirection.Short.westNorthWest
		case NW:    return MeasuresStrings.CompassDirection.Short.northWest
		case NNW:   return MeasuresStrings.CompassDirection.Short.northNorthWest
		}
	}


	public var shortName: String {
		switch self {
		case North: return MeasuresStrings.CompassDirection.Short.north
		case NNE:   return MeasuresStrings.CompassDirection.Short.northNorthEast
		case NE:    return MeasuresStrings.CompassDirection.Short.northEast
		case ENE:   return MeasuresStrings.CompassDirection.Short.eastNorthEast
		case East:  return MeasuresStrings.CompassDirection.Short.east
		case ESE:   return MeasuresStrings.CompassDirection.Short.eastSouthEast
		case SE:    return MeasuresStrings.CompassDirection.Short.southEast
		case SSE:   return MeasuresStrings.CompassDirection.Short.southSouthEast
		case South: return MeasuresStrings.CompassDirection.Short.south
		case SSW:   return MeasuresStrings.CompassDirection.Short.southSouthWest
		case SW:    return MeasuresStrings.CompassDirection.Short.southWest
		case WSW:   return MeasuresStrings.CompassDirection.Short.westSouthWest
		case West:  return MeasuresStrings.CompassDirection.Short.west
		case WNW:   return MeasuresStrings.CompassDirection.Short.westNorthWest
		case NW:    return MeasuresStrings.CompassDirection.Short.northWest
		case NNW:   return MeasuresStrings.CompassDirection.Short.northNorthWest
		}
	}
}



public extension Angle {

	public var compassDirection8: CompassDirection8 {
		var sector = Int((8 * degrees / 360).rounded) % 8
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
		var sector = Int((16 * degrees / 360).rounded) % 16
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
