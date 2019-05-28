public enum CompassDirection8 {
	case north
	case ne
	case east
	case se
	case south
	case sw
	case west
	case nw


	public static let all: [CompassDirection8] = [
		.north,
		.ne,
		.east,
		.se,
		.south,
		.sw,
		.west,
		.nw,
	]
}


extension CompassDirection8 {

	public var mediumName: String {
		switch self {
		case .north: return MeasuresStrings.CompassDirection.Long.north
		case .ne:    return MeasuresStrings.CompassDirection.Short.northEast
		case .east:  return MeasuresStrings.CompassDirection.Long.east
		case .se:    return MeasuresStrings.CompassDirection.Short.southEast
		case .south: return MeasuresStrings.CompassDirection.Long.south
		case .sw:    return MeasuresStrings.CompassDirection.Short.southWest
		case .west:  return MeasuresStrings.CompassDirection.Long.west
		case .nw:    return MeasuresStrings.CompassDirection.Short.northWest
		}
	}


	public var shortName: String {
		switch self {
		case .north: return MeasuresStrings.CompassDirection.Short.north
		case .ne:    return MeasuresStrings.CompassDirection.Short.northWest
		case .east:  return MeasuresStrings.CompassDirection.Short.east
		case .se:    return MeasuresStrings.CompassDirection.Short.southEast
		case .south: return MeasuresStrings.CompassDirection.Short.south
		case .sw:    return MeasuresStrings.CompassDirection.Short.southWest
		case .west:  return MeasuresStrings.CompassDirection.Short.west
		case .nw:    return MeasuresStrings.CompassDirection.Short.northWest
		}
	}


	public var to16: CompassDirection16 {
		switch self {
		case .north: return .north
		case .ne:    return .ne
		case .east:  return .east
		case .se:    return .se
		case .south: return .south
		case .sw:    return .sw
		case .west:  return .west
		case .nw:    return .nw
		}
	}
}


public enum CompassDirection16 {
	case north
	case nne
	case ne
	case ene
	case east
	case ese
	case se
	case sse
	case south
	case ssw
	case sw
	case wsw
	case west
	case wnw
	case nw
	case nnw


	public static let all: [CompassDirection16] = [
		.north,
		.nne,
		.ne,
		.ene,
		.east,
		.ese,
		.se,
		.sse,
		.south,
		.ssw,
		.sw,
		.wsw,
		.west,
		.wnw,
		.nw,
		.nnw,
	]
}


extension CompassDirection16 {

	public var mediumName: String {
		switch self {
		case .north: return MeasuresStrings.CompassDirection.Long.north
		case .nne:   return MeasuresStrings.CompassDirection.Short.northNorthEast
		case .ne:    return MeasuresStrings.CompassDirection.Short.northEast
		case .ene:   return MeasuresStrings.CompassDirection.Short.eastNorthEast
		case .east:  return MeasuresStrings.CompassDirection.Long.east
		case .ese:   return MeasuresStrings.CompassDirection.Short.eastSouthEast
		case .se:    return MeasuresStrings.CompassDirection.Short.southEast
		case .sse:   return MeasuresStrings.CompassDirection.Short.southSouthEast
		case .south: return MeasuresStrings.CompassDirection.Long.south
		case .ssw:   return MeasuresStrings.CompassDirection.Short.southSouthWest
		case .sw:    return MeasuresStrings.CompassDirection.Short.southWest
		case .wsw:   return MeasuresStrings.CompassDirection.Short.westSouthWest
		case .west:  return MeasuresStrings.CompassDirection.Long.west
		case .wnw:   return MeasuresStrings.CompassDirection.Short.westNorthWest
		case .nw:    return MeasuresStrings.CompassDirection.Short.northWest
		case .nnw:   return MeasuresStrings.CompassDirection.Short.northNorthWest
		}
	}


	public var shortName: String {
		switch self {
		case .north: return MeasuresStrings.CompassDirection.Short.north
		case .nne:   return MeasuresStrings.CompassDirection.Short.northNorthEast
		case .ne:    return MeasuresStrings.CompassDirection.Short.northEast
		case .ene:   return MeasuresStrings.CompassDirection.Short.eastNorthEast
		case .east:  return MeasuresStrings.CompassDirection.Short.east
		case .ese:   return MeasuresStrings.CompassDirection.Short.eastSouthEast
		case .se:    return MeasuresStrings.CompassDirection.Short.southEast
		case .sse:   return MeasuresStrings.CompassDirection.Short.southSouthEast
		case .south: return MeasuresStrings.CompassDirection.Short.south
		case .ssw:   return MeasuresStrings.CompassDirection.Short.southSouthWest
		case .sw:    return MeasuresStrings.CompassDirection.Short.southWest
		case .wsw:   return MeasuresStrings.CompassDirection.Short.westSouthWest
		case .west:  return MeasuresStrings.CompassDirection.Short.west
		case .wnw:   return MeasuresStrings.CompassDirection.Short.westNorthWest
		case .nw:    return MeasuresStrings.CompassDirection.Short.northWest
		case .nnw:   return MeasuresStrings.CompassDirection.Short.northNorthWest
		}
	}
}



public extension Angle {

	var compassDirection8: CompassDirection8 {
		var sector = Int((8 * degrees / 360).rounded()) % 8
		if sector < 0 {
			sector += 8
		}

		switch sector {
		case 0:  return .north
		case 1:  return .ne
		case 2:  return .east
		case 3:  return .se
		case 4:  return .south
		case 5:  return .sw
		case 6:  return .west
		case 7:  return .nw
		default: fatalError("\(self) resulted in invalid compass sector \(sector)")
		}
	}


	var compassDirection16: CompassDirection16 {
		var sector = Int((16 * degrees / 360).rounded()) % 16
		if sector < 0 {
			sector += 16
		}

		switch sector {
		case 0:  return .north
		case 1:  return .nne
		case 2:  return .ne
		case 3:  return .ene
		case 4:  return .east
		case 5:  return .ese
		case 6:  return .se
		case 7:  return .sse
		case 8:  return .south
		case 9:  return .ssw
		case 10: return .sw
		case 11: return .wsw
		case 12: return .west
		case 13: return .wnw
		case 14: return .nw
		case 15: return .nnw
		default: fatalError("\(self) resulted in invalid compass sector \(sector)")
		}
	}
}
