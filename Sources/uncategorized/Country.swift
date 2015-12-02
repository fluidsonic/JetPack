public struct Country {

	public let callingCodes: Set<PhoneNumber.Digits>
	public let isoCode2: String
	public let isoCode3: String
	public let englishName: String


	public init?(callingCode: PhoneNumber.Digits) {
		guard let country = Country.allByCallingCode[callingCode.count]?[callingCode] else {
			return nil
		}

		self = country
	}


	public init?(phoneNumber: PhoneNumber.Digits) {
		let digitsExcludingPrefix: PhoneNumber.Digits
		if phoneNumber.count >= 2 && phoneNumber[0] == .Plus {
			digitsExcludingPrefix = PhoneNumber.Digits(phoneNumber.suffixFrom(1))
		}
		else if phoneNumber.count >= 3 && phoneNumber[0] == ._0 && phoneNumber[1] == ._0 {
			digitsExcludingPrefix = PhoneNumber.Digits(phoneNumber.suffixFrom(2))
		}
		else {
			return nil
		}

		var callingCodes = PhoneNumber.Digits(digitsExcludingPrefix[0 ..< min(digitsExcludingPrefix.count, Country.maximumCallingCodeLength)])
		var bestCountry: Country?

		while !callingCodes.isEmpty {
			if let matchingCountry = Country(callingCode: callingCodes) {
				bestCountry = matchingCountry
				break
			}

			callingCodes.removeLast()
		}

		guard let country = bestCountry else {
			return nil
		}

		self = country
	}


	public init?(isoCode2: String) {
		guard let country = Country.allByIsoCode2[isoCode2.uppercaseString] else {
			return nil
		}

		self = country
	}


	public init?(isoCode3: String) {
		guard let country = Country.allByIsoCode3[isoCode3.uppercaseString] else {
			return nil
		}

		self = country
	}


	public init(isoCode2: String, isoCode3: String, englishName: String, callingCodes: Set<PhoneNumber.Digits> = []) {
		self.callingCodes = callingCodes
		self.isoCode2 = isoCode2.uppercaseString
		self.isoCode3 = isoCode3.uppercaseString
		self.englishName = englishName
	}
}


extension Country: CustomDebugStringConvertible {

	public var debugDescription: String {
		return "Country(isoCode2: \"\(isoCode2)\", isoCode3: \"\(isoCode3)\", englishName: \"\(englishName)\", callingCodes: \(callingCodes))"
	}
}


extension Country: CustomStringConvertible {

	public var description: String {
		return englishName
	}
}


extension Country: Hashable {

	public var hashValue: Int {
		var hashValue = isoCode2.hashValue

		if isoCode2.isEmpty {
			hashValue ^= isoCode3.hashValue

			if isoCode3.isEmpty {
				hashValue ^= englishName.hashValue
			}
		}

		return hashValue
	}
}


public extension Country {

	// from https://github.com/datasets/country-codes/blob/master/data/country-codes.csv w/ several fixed calling codes
	public static let all: [Country] = [
		Country(isoCode2: "AF", isoCode3: "AFG", englishName: "Afghanistan", callingCodes: ["93"]),
		Country(isoCode2: "AX", isoCode3: "ALA", englishName: "Åland Islands", callingCodes: ["358-18"]),
		Country(isoCode2: "AL", isoCode3: "ALB", englishName: "Albania", callingCodes: ["355"]),
		Country(isoCode2: "DZ", isoCode3: "DZA", englishName: "Algeria", callingCodes: ["213"]),
		Country(isoCode2: "AS", isoCode3: "ASM", englishName: "American Samoa", callingCodes: ["1-684"]),
		Country(isoCode2: "AD", isoCode3: "AND", englishName: "Andorra", callingCodes: ["376"]),
		Country(isoCode2: "AO", isoCode3: "AGO", englishName: "Angola", callingCodes: ["244"]),
		Country(isoCode2: "AI", isoCode3: "AIA", englishName: "Anguilla", callingCodes: ["1-264"]),
		Country(isoCode2: "AQ", isoCode3: "ATA", englishName: "Antarctica", callingCodes: ["672-1"]),
		Country(isoCode2: "AG", isoCode3: "ATG", englishName: "Antigua and Barbuda", callingCodes: ["1-268"]),
		Country(isoCode2: "AR", isoCode3: "ARG", englishName: "Argentina", callingCodes: ["54"]),
		Country(isoCode2: "AM", isoCode3: "ARM", englishName: "Armenia", callingCodes: ["374"]),
		Country(isoCode2: "AW", isoCode3: "ABW", englishName: "Aruba", callingCodes: ["297"]),
		Country(isoCode2: "AU", isoCode3: "AUS", englishName: "Australia", callingCodes: ["61"]),
		Country(isoCode2: "AT", isoCode3: "AUT", englishName: "Austria", callingCodes: ["43"]),
		Country(isoCode2: "AZ", isoCode3: "AZE", englishName: "Azerbaijan", callingCodes: ["994"]),
		Country(isoCode2: "BS", isoCode3: "BHS", englishName: "Bahamas", callingCodes: ["1-242"]),
		Country(isoCode2: "BH", isoCode3: "BHR", englishName: "Bahrain", callingCodes: ["973"]),
		Country(isoCode2: "BD", isoCode3: "BGD", englishName: "Bangladesh", callingCodes: ["880"]),
		Country(isoCode2: "BB", isoCode3: "BRB", englishName: "Barbados", callingCodes: ["1-246"]),
		Country(isoCode2: "BY", isoCode3: "BLR", englishName: "Belarus", callingCodes: ["375"]),
		Country(isoCode2: "BE", isoCode3: "BEL", englishName: "Belgium", callingCodes: ["32"]),
		Country(isoCode2: "BZ", isoCode3: "BLZ", englishName: "Belize", callingCodes: ["501"]),
		Country(isoCode2: "BJ", isoCode3: "BEN", englishName: "Benin", callingCodes: ["229"]),
		Country(isoCode2: "BM", isoCode3: "BMU", englishName: "Bermuda", callingCodes: ["1-441"]),
		Country(isoCode2: "BT", isoCode3: "BTN", englishName: "Bhutan", callingCodes: ["975"]),
		Country(isoCode2: "BO", isoCode3: "BOL", englishName: "Bolivia, Plurinational State of", callingCodes: ["591"]),
		Country(isoCode2: "BQ", isoCode3: "BES", englishName: "Bonaire, Sint Eustatius and Saba", callingCodes: ["599-7"]),
		Country(isoCode2: "BA", isoCode3: "BIH", englishName: "Bosnia and Herzegovina", callingCodes: ["387"]),
		Country(isoCode2: "BW", isoCode3: "BWA", englishName: "Botswana", callingCodes: ["267"]),
		Country(isoCode2: "BV", isoCode3: "BVT", englishName: "Bouvet Island", callingCodes: ["47"]),
		Country(isoCode2: "BR", isoCode3: "BRA", englishName: "Brazil", callingCodes: ["55"]),
		Country(isoCode2: "IO", isoCode3: "IOT", englishName: "British Indian Ocean Territory", callingCodes: ["246"]),
		Country(isoCode2: "BN", isoCode3: "BRN", englishName: "Brunei Darussalam", callingCodes: ["673"]),
		Country(isoCode2: "BG", isoCode3: "BGR", englishName: "Bulgaria", callingCodes: ["359"]),
		Country(isoCode2: "BF", isoCode3: "BFA", englishName: "Burkina Faso", callingCodes: ["226"]),
		Country(isoCode2: "BI", isoCode3: "BDI", englishName: "Burundi", callingCodes: ["257"]),
		Country(isoCode2: "KH", isoCode3: "KHM", englishName: "Cambodia", callingCodes: ["855"]),
		Country(isoCode2: "CM", isoCode3: "CMR", englishName: "Cameroon", callingCodes: ["237"]),
		Country(isoCode2: "CA", isoCode3: "CAN", englishName: "Canada", callingCodes: ["1-403", "1-587", "1-780", "1-825", "1-236", "1-250", "1-604", "1-672", "1-778", "1-204", "1-431", "1-506", "1-709", "1-782", "1-902", "1-226", "1-249", "1-289", "1-343", "1-365", "1-387", "1-416", "1-437", "1-519", "1-548", "1-613", "1-647", "1-705", "1-742", "1-807", "1-905", "1-902", "1-418", "1-438", "1-450", "1-514", "1-579", "1-581", "1-819", "1-873", "1-306", "1-639", "1-867"]),
		Country(isoCode2: "CV", isoCode3: "CPV", englishName: "Cape Verde", callingCodes: ["238"]),
		Country(isoCode2: "KY", isoCode3: "CYM", englishName: "Cayman Islands", callingCodes: ["1-345"]),
		Country(isoCode2: "CF", isoCode3: "CAF", englishName: "Central African Republic", callingCodes: ["236"]),
		Country(isoCode2: "TD", isoCode3: "TCD", englishName: "Chad", callingCodes: ["235"]),
		Country(isoCode2: "CL", isoCode3: "CHL", englishName: "Chile", callingCodes: ["56"]),
		Country(isoCode2: "CN", isoCode3: "CHN", englishName: "China", callingCodes: ["86"]),
		Country(isoCode2: "CX", isoCode3: "CXR", englishName: "Christmas Island", callingCodes: ["61-8-9164"]),
		Country(isoCode2: "CC", isoCode3: "CCK", englishName: "Cocos (Keeling) Islands", callingCodes: ["61-8-9162"]),
		Country(isoCode2: "CO", isoCode3: "COL", englishName: "Colombia", callingCodes: ["57"]),
		Country(isoCode2: "KM", isoCode3: "COM", englishName: "Comoros", callingCodes: ["269"]),
		Country(isoCode2: "CG", isoCode3: "COG", englishName: "Congo", callingCodes: ["242"]),
		Country(isoCode2: "CD", isoCode3: "COD", englishName: "Congo, the Democratic Republic of the", callingCodes: ["243"]),
		Country(isoCode2: "CK", isoCode3: "COK", englishName: "Cook Islands", callingCodes: ["682"]),
		Country(isoCode2: "CR", isoCode3: "CRI", englishName: "Costa Rica", callingCodes: ["506"]),
		Country(isoCode2: "HR", isoCode3: "HRV", englishName: "Croatia", callingCodes: ["385"]),
		Country(isoCode2: "CU", isoCode3: "CUB", englishName: "Cuba", callingCodes: ["53"]),
		Country(isoCode2: "CW", isoCode3: "CUW", englishName: "Curaçao", callingCodes: ["599-9"]),
		Country(isoCode2: "CY", isoCode3: "CYP", englishName: "Cyprus", callingCodes: ["357"]),
		Country(isoCode2: "CZ", isoCode3: "CZE", englishName: "Czech Republic", callingCodes: ["420"]),
		Country(isoCode2: "CI", isoCode3: "CIV", englishName: "Côte d'Ivoire", callingCodes: ["225"]),
		Country(isoCode2: "DK", isoCode3: "DNK", englishName: "Denmark", callingCodes: ["45"]),
		Country(isoCode2: "DJ", isoCode3: "DJI", englishName: "Djibouti", callingCodes: ["253"]),
		Country(isoCode2: "DM", isoCode3: "DMA", englishName: "Dominica", callingCodes: ["1-767"]),
		Country(isoCode2: "DO", isoCode3: "DOM", englishName: "Dominican Republic", callingCodes: ["1-809", "1-829", "1-849"]),
		Country(isoCode2: "EC", isoCode3: "ECU", englishName: "Ecuador", callingCodes: ["593"]),
		Country(isoCode2: "EG", isoCode3: "EGY", englishName: "Egypt", callingCodes: ["20"]),
		Country(isoCode2: "SV", isoCode3: "SLV", englishName: "El Salvador", callingCodes: ["503"]),
		Country(isoCode2: "GQ", isoCode3: "GNQ", englishName: "Equatorial Guinea", callingCodes: ["240"]),
		Country(isoCode2: "ER", isoCode3: "ERI", englishName: "Eritrea", callingCodes: ["291"]),
		Country(isoCode2: "EE", isoCode3: "EST", englishName: "Estonia", callingCodes: ["372"]),
		Country(isoCode2: "ET", isoCode3: "ETH", englishName: "Ethiopia", callingCodes: ["251"]),
		Country(isoCode2: "FK", isoCode3: "FLK", englishName: "Falkland Islands (Malvinas)", callingCodes: ["500"]),
		Country(isoCode2: "FO", isoCode3: "FRO", englishName: "Faroe Islands", callingCodes: ["298"]),
		Country(isoCode2: "FJ", isoCode3: "FJI", englishName: "Fiji", callingCodes: ["679"]),
		Country(isoCode2: "FI", isoCode3: "FIN", englishName: "Finland", callingCodes: ["358"]),
		Country(isoCode2: "FR", isoCode3: "FRA", englishName: "France", callingCodes: ["33"]),
		Country(isoCode2: "GF", isoCode3: "GUF", englishName: "French Guiana", callingCodes: ["594"]),
		Country(isoCode2: "PF", isoCode3: "PYF", englishName: "French Polynesia", callingCodes: ["689"]),
		Country(isoCode2: "TF", isoCode3: "ATF", englishName: "French Southern Territories", callingCodes: ["262"]),
		Country(isoCode2: "GA", isoCode3: "GAB", englishName: "Gabon", callingCodes: ["241"]),
		Country(isoCode2: "GM", isoCode3: "GMB", englishName: "Gambia", callingCodes: ["220"]),
		Country(isoCode2: "GE", isoCode3: "GEO", englishName: "Georgia", callingCodes: ["995"]),
		Country(isoCode2: "DE", isoCode3: "DEU", englishName: "Germany", callingCodes: ["49"]),
		Country(isoCode2: "GH", isoCode3: "GHA", englishName: "Ghana", callingCodes: ["233"]),
		Country(isoCode2: "GI", isoCode3: "GIB", englishName: "Gibraltar", callingCodes: ["350"]),
		Country(isoCode2: "GR", isoCode3: "GRC", englishName: "Greece", callingCodes: ["30"]),
		Country(isoCode2: "GL", isoCode3: "GRL", englishName: "Greenland", callingCodes: ["299"]),
		Country(isoCode2: "GD", isoCode3: "GRD", englishName: "Grenada", callingCodes: ["1-473"]),
		Country(isoCode2: "GP", isoCode3: "GLP", englishName: "Guadeloupe", callingCodes: ["590"]),
		Country(isoCode2: "GU", isoCode3: "GUM", englishName: "Guam", callingCodes: ["1-671"]),
		Country(isoCode2: "GT", isoCode3: "GTM", englishName: "Guatemala", callingCodes: ["502"]),
		Country(isoCode2: "GG", isoCode3: "GGY", englishName: "Guernsey", callingCodes: ["44-1481"]),
		Country(isoCode2: "GN", isoCode3: "GIN", englishName: "Guinea", callingCodes: ["224"]),
		Country(isoCode2: "GW", isoCode3: "GNB", englishName: "Guinea-Bissau", callingCodes: ["245"]),
		Country(isoCode2: "GY", isoCode3: "GUY", englishName: "Guyana", callingCodes: ["592"]),
		Country(isoCode2: "HT", isoCode3: "HTI", englishName: "Haiti", callingCodes: ["509"]),
		Country(isoCode2: "HM", isoCode3: "HMD", englishName: "Heard Island and McDonald Islands", callingCodes: ["672"]),
		Country(isoCode2: "VA", isoCode3: "VAT", englishName: "Holy See (Vatican City State)", callingCodes: ["39-06"]),
		Country(isoCode2: "HN", isoCode3: "HND", englishName: "Honduras", callingCodes: ["504"]),
		Country(isoCode2: "HK", isoCode3: "HKG", englishName: "Hong Kong", callingCodes: ["852"]),
		Country(isoCode2: "HU", isoCode3: "HUN", englishName: "Hungary", callingCodes: ["36"]),
		Country(isoCode2: "IS", isoCode3: "ISL", englishName: "Iceland", callingCodes: ["354"]),
		Country(isoCode2: "IN", isoCode3: "IND", englishName: "India", callingCodes: ["91"]),
		Country(isoCode2: "ID", isoCode3: "IDN", englishName: "Indonesia", callingCodes: ["62"]),
		Country(isoCode2: "IR", isoCode3: "IRN", englishName: "Iran, Islamic Republic of", callingCodes: ["98"]),
		Country(isoCode2: "IQ", isoCode3: "IRQ", englishName: "Iraq", callingCodes: ["964"]),
		Country(isoCode2: "IE", isoCode3: "IRL", englishName: "Ireland", callingCodes: ["353"]),
		Country(isoCode2: "IM", isoCode3: "IMN", englishName: "Isle of Man", callingCodes: ["44-1624"]),
		Country(isoCode2: "IL", isoCode3: "ISR", englishName: "Israel", callingCodes: ["972"]),
		Country(isoCode2: "IT", isoCode3: "ITA", englishName: "Italy", callingCodes: ["39"]),
		Country(isoCode2: "JM", isoCode3: "JAM", englishName: "Jamaica", callingCodes: ["1-876"]),
		Country(isoCode2: "JP", isoCode3: "JPN", englishName: "Japan", callingCodes: ["81"]),
		Country(isoCode2: "JE", isoCode3: "JEY", englishName: "Jersey", callingCodes: ["44-1534"]),
		Country(isoCode2: "JO", isoCode3: "JOR", englishName: "Jordan", callingCodes: ["962"]),
		Country(isoCode2: "KZ", isoCode3: "KAZ", englishName: "Kazakhstan", callingCodes: ["7"]),
		Country(isoCode2: "KE", isoCode3: "KEN", englishName: "Kenya", callingCodes: ["254"]),
		Country(isoCode2: "KI", isoCode3: "KIR", englishName: "Kiribati", callingCodes: ["686"]),
		Country(isoCode2: "KP", isoCode3: "PRK", englishName: "Korea, Democratic People's Republic of", callingCodes: ["850"]),
		Country(isoCode2: "KR", isoCode3: "KOR", englishName: "Korea, Republic of", callingCodes: ["82"]),
		Country(isoCode2: "KW", isoCode3: "KWT", englishName: "Kuwait", callingCodes: ["965"]),
		Country(isoCode2: "KG", isoCode3: "KGZ", englishName: "Kyrgyzstan", callingCodes: ["996"]),
		Country(isoCode2: "LA", isoCode3: "LAO", englishName: "Lao People's Democratic Republic", callingCodes: ["856"]),
		Country(isoCode2: "LV", isoCode3: "LVA", englishName: "Latvia", callingCodes: ["371"]),
		Country(isoCode2: "LB", isoCode3: "LBN", englishName: "Lebanon", callingCodes: ["961"]),
		Country(isoCode2: "LS", isoCode3: "LSO", englishName: "Lesotho", callingCodes: ["266"]),
		Country(isoCode2: "LR", isoCode3: "LBR", englishName: "Liberia", callingCodes: ["231"]),
		Country(isoCode2: "LY", isoCode3: "LBY", englishName: "Libya", callingCodes: ["218"]),
		Country(isoCode2: "LI", isoCode3: "LIE", englishName: "Liechtenstein", callingCodes: ["423"]),
		Country(isoCode2: "LT", isoCode3: "LTU", englishName: "Lithuania", callingCodes: ["370"]),
		Country(isoCode2: "LU", isoCode3: "LUX", englishName: "Luxembourg", callingCodes: ["352"]),
		Country(isoCode2: "MO", isoCode3: "MAC", englishName: "Macao", callingCodes: ["853"]),
		Country(isoCode2: "MK", isoCode3: "MKD", englishName: "Macedonia, the Former Yugoslav Republic of", callingCodes: ["389"]),
		Country(isoCode2: "MG", isoCode3: "MDG", englishName: "Madagascar", callingCodes: ["261"]),
		Country(isoCode2: "MW", isoCode3: "MWI", englishName: "Malawi", callingCodes: ["265"]),
		Country(isoCode2: "MY", isoCode3: "MYS", englishName: "Malaysia", callingCodes: ["60"]),
		Country(isoCode2: "MV", isoCode3: "MDV", englishName: "Maldives", callingCodes: ["960"]),
		Country(isoCode2: "ML", isoCode3: "MLI", englishName: "Mali", callingCodes: ["223"]),
		Country(isoCode2: "MT", isoCode3: "MLT", englishName: "Malta", callingCodes: ["356"]),
		Country(isoCode2: "MH", isoCode3: "MHL", englishName: "Marshall Islands", callingCodes: ["692"]),
		Country(isoCode2: "MQ", isoCode3: "MTQ", englishName: "Martinique", callingCodes: ["596"]),
		Country(isoCode2: "MR", isoCode3: "MRT", englishName: "Mauritania", callingCodes: ["222"]),
		Country(isoCode2: "MU", isoCode3: "MUS", englishName: "Mauritius", callingCodes: ["230"]),
		Country(isoCode2: "YT", isoCode3: "MYT", englishName: "Mayotte", callingCodes: ["262-269", "262-639"]),
		Country(isoCode2: "MX", isoCode3: "MEX", englishName: "Mexico", callingCodes: ["52"]),
		Country(isoCode2: "FM", isoCode3: "FSM", englishName: "Micronesia, Federated States of", callingCodes: ["691"]),
		Country(isoCode2: "MD", isoCode3: "MDA", englishName: "Moldova, Republic of", callingCodes: ["373"]),
		Country(isoCode2: "MC", isoCode3: "MCO", englishName: "Monaco", callingCodes: ["377"]),
		Country(isoCode2: "MN", isoCode3: "MNG", englishName: "Mongolia", callingCodes: ["976"]),
		Country(isoCode2: "ME", isoCode3: "MNE", englishName: "Montenegro", callingCodes: ["382"]),
		Country(isoCode2: "MS", isoCode3: "MSR", englishName: "Montserrat", callingCodes: ["1-664"]),
		Country(isoCode2: "MA", isoCode3: "MAR", englishName: "Morocco", callingCodes: ["212"]),
		Country(isoCode2: "MZ", isoCode3: "MOZ", englishName: "Mozambique", callingCodes: ["258"]),
		Country(isoCode2: "MM", isoCode3: "MMR", englishName: "Myanmar", callingCodes: ["95"]),
		Country(isoCode2: "NA", isoCode3: "NAM", englishName: "Namibia", callingCodes: ["264"]),
		Country(isoCode2: "NR", isoCode3: "NRU", englishName: "Nauru", callingCodes: ["674"]),
		Country(isoCode2: "NP", isoCode3: "NPL", englishName: "Nepal", callingCodes: ["977"]),
		Country(isoCode2: "NL", isoCode3: "NLD", englishName: "Netherlands", callingCodes: ["31"]),
		Country(isoCode2: "NC", isoCode3: "NCL", englishName: "New Caledonia", callingCodes: ["687"]),
		Country(isoCode2: "NZ", isoCode3: "NZL", englishName: "New Zealand", callingCodes: ["64"]),
		Country(isoCode2: "NI", isoCode3: "NIC", englishName: "Nicaragua", callingCodes: ["505"]),
		Country(isoCode2: "NE", isoCode3: "NER", englishName: "Niger", callingCodes: ["227"]),
		Country(isoCode2: "NG", isoCode3: "NGA", englishName: "Nigeria", callingCodes: ["234"]),
		Country(isoCode2: "NU", isoCode3: "NIU", englishName: "Niue", callingCodes: ["683"]),
		Country(isoCode2: "NF", isoCode3: "NFK", englishName: "Norfolk Island", callingCodes: ["672-3"]),
		Country(isoCode2: "MP", isoCode3: "MNP", englishName: "Northern Mariana Islands", callingCodes: ["1-670"]),
		Country(isoCode2: "NO", isoCode3: "NOR", englishName: "Norway", callingCodes: ["47"]),
		Country(isoCode2: "OM", isoCode3: "OMN", englishName: "Oman", callingCodes: ["968"]),
		Country(isoCode2: "PK", isoCode3: "PAK", englishName: "Pakistan", callingCodes: ["92"]),
		Country(isoCode2: "PW", isoCode3: "PLW", englishName: "Palau", callingCodes: ["680"]),
		Country(isoCode2: "PS", isoCode3: "PSE", englishName: "Palestine, State of", callingCodes: ["970"]),
		Country(isoCode2: "PA", isoCode3: "PAN", englishName: "Panama", callingCodes: ["507"]),
		Country(isoCode2: "PG", isoCode3: "PNG", englishName: "Papua New Guinea", callingCodes: ["675"]),
		Country(isoCode2: "PY", isoCode3: "PRY", englishName: "Paraguay", callingCodes: ["595"]),
		Country(isoCode2: "PE", isoCode3: "PER", englishName: "Peru", callingCodes: ["51"]),
		Country(isoCode2: "PH", isoCode3: "PHL", englishName: "Philippines", callingCodes: ["63"]),
		Country(isoCode2: "PN", isoCode3: "PCN", englishName: "Pitcairn", callingCodes: ["870"]),
		Country(isoCode2: "PL", isoCode3: "POL", englishName: "Poland", callingCodes: ["48"]),
		Country(isoCode2: "PT", isoCode3: "PRT", englishName: "Portugal", callingCodes: ["351"]),
		Country(isoCode2: "PR", isoCode3: "PRI", englishName: "Puerto Rico", callingCodes: ["1-787", "1-939"]),
		Country(isoCode2: "QA", isoCode3: "QAT", englishName: "Qatar", callingCodes: ["974"]),
		Country(isoCode2: "RO", isoCode3: "ROU", englishName: "Romania", callingCodes: ["40"]),
		Country(isoCode2: "RU", isoCode3: "RUS", englishName: "Russian Federation", callingCodes: ["7"]),
		Country(isoCode2: "RW", isoCode3: "RWA", englishName: "Rwanda", callingCodes: ["250"]),
		Country(isoCode2: "RE", isoCode3: "REU", englishName: "Réunion", callingCodes: ["262"]),
		Country(isoCode2: "BL", isoCode3: "BLM", englishName: "Saint Barthélemy", callingCodes: ["590"]),
		Country(isoCode2: "SH", isoCode3: "SHN", englishName: "Saint Helena, Ascension and Tristan da Cunha", callingCodes: ["290"]),
		Country(isoCode2: "KN", isoCode3: "KNA", englishName: "Saint Kitts and Nevis", callingCodes: ["1-869"]),
		Country(isoCode2: "LC", isoCode3: "LCA", englishName: "Saint Lucia", callingCodes: ["1-758"]),
		Country(isoCode2: "MF", isoCode3: "MAF", englishName: "Saint Martin (French part)", callingCodes: ["590"]),
		Country(isoCode2: "PM", isoCode3: "SPM", englishName: "Saint Pierre and Miquelon", callingCodes: ["508"]),
		Country(isoCode2: "VC", isoCode3: "VCT", englishName: "Saint Vincent and the Grenadines", callingCodes: ["1-784"]),
		Country(isoCode2: "WS", isoCode3: "WSM", englishName: "Samoa", callingCodes: ["685"]),
		Country(isoCode2: "SM", isoCode3: "SMR", englishName: "San Marino", callingCodes: ["378"]),
		Country(isoCode2: "ST", isoCode3: "STP", englishName: "Sao Tome and Principe", callingCodes: ["239"]),
		Country(isoCode2: "SA", isoCode3: "SAU", englishName: "Saudi Arabia", callingCodes: ["966"]),
		Country(isoCode2: "SN", isoCode3: "SEN", englishName: "Senegal", callingCodes: ["221"]),
		Country(isoCode2: "RS", isoCode3: "SRB", englishName: "Serbia", callingCodes: ["381 p"]),
		Country(isoCode2: "SC", isoCode3: "SYC", englishName: "Seychelles", callingCodes: ["248"]),
		Country(isoCode2: "SL", isoCode3: "SLE", englishName: "Sierra Leone", callingCodes: ["232"]),
		Country(isoCode2: "SG", isoCode3: "SGP", englishName: "Singapore", callingCodes: ["65"]),
		Country(isoCode2: "SX", isoCode3: "SXM", englishName: "Sint Maarten (Dutch part)", callingCodes: ["1-721"]),
		Country(isoCode2: "SK", isoCode3: "SVK", englishName: "Slovakia", callingCodes: ["421"]),
		Country(isoCode2: "SI", isoCode3: "SVN", englishName: "Slovenia", callingCodes: ["386"]),
		Country(isoCode2: "SB", isoCode3: "SLB", englishName: "Solomon Islands", callingCodes: ["677"]),
		Country(isoCode2: "SO", isoCode3: "SOM", englishName: "Somalia", callingCodes: ["252"]),
		Country(isoCode2: "ZA", isoCode3: "ZAF", englishName: "South Africa", callingCodes: ["27"]),
		Country(isoCode2: "GS", isoCode3: "SGS", englishName: "South Georgia and the South Sandwich Islands", callingCodes: ["500"]),
		Country(isoCode2: "SS", isoCode3: "SSD", englishName: "South Sudan", callingCodes: ["211"]),
		Country(isoCode2: "ES", isoCode3: "ESP", englishName: "Spain", callingCodes: ["34"]),
		Country(isoCode2: "LK", isoCode3: "LKA", englishName: "Sri Lanka", callingCodes: ["94"]),
		Country(isoCode2: "SD", isoCode3: "SDN", englishName: "Sudan", callingCodes: ["249"]),
		Country(isoCode2: "SR", isoCode3: "SUR", englishName: "Suriname", callingCodes: ["597"]),
		Country(isoCode2: "SJ", isoCode3: "SJM", englishName: "Svalbard and Jan Mayen", callingCodes: ["47-79"]),
		Country(isoCode2: "SZ", isoCode3: "SWZ", englishName: "Swaziland", callingCodes: ["268"]),
		Country(isoCode2: "SE", isoCode3: "SWE", englishName: "Sweden", callingCodes: ["46"]),
		Country(isoCode2: "CH", isoCode3: "CHE", englishName: "Switzerland", callingCodes: ["41"]),
		Country(isoCode2: "SY", isoCode3: "SYR", englishName: "Syrian Arab Republic", callingCodes: ["963"]),
		Country(isoCode2: "TW", isoCode3: "TWN", englishName: "Taiwan, Province of China", callingCodes: ["886"]),
		Country(isoCode2: "TJ", isoCode3: "TJK", englishName: "Tajikistan", callingCodes: ["992"]),
		Country(isoCode2: "TZ", isoCode3: "TZA", englishName: "Tanzania, United Republic of", callingCodes: ["255"]),
		Country(isoCode2: "TH", isoCode3: "THA", englishName: "Thailand", callingCodes: ["66"]),
		Country(isoCode2: "TL", isoCode3: "TLS", englishName: "Timor-Leste", callingCodes: ["670"]),
		Country(isoCode2: "TG", isoCode3: "TGO", englishName: "Togo", callingCodes: ["228"]),
		Country(isoCode2: "TK", isoCode3: "TKL", englishName: "Tokelau", callingCodes: ["690"]),
		Country(isoCode2: "TO", isoCode3: "TON", englishName: "Tonga", callingCodes: ["676"]),
		Country(isoCode2: "TT", isoCode3: "TTO", englishName: "Trinidad and Tobago", callingCodes: ["1-868"]),
		Country(isoCode2: "TN", isoCode3: "TUN", englishName: "Tunisia", callingCodes: ["216"]),
		Country(isoCode2: "TR", isoCode3: "TUR", englishName: "Turkey", callingCodes: ["90"]),
		Country(isoCode2: "TM", isoCode3: "TKM", englishName: "Turkmenistan", callingCodes: ["993"]),
		Country(isoCode2: "TC", isoCode3: "TCA", englishName: "Turks and Caicos Islands", callingCodes: ["1-649"]),
		Country(isoCode2: "TV", isoCode3: "TUV", englishName: "Tuvalu", callingCodes: ["688"]),
		Country(isoCode2: "UG", isoCode3: "UGA", englishName: "Uganda", callingCodes: ["256"]),
		Country(isoCode2: "UA", isoCode3: "UKR", englishName: "Ukraine", callingCodes: ["380"]),
		Country(isoCode2: "AE", isoCode3: "ARE", englishName: "United Arab Emirates", callingCodes: ["971"]),
		Country(isoCode2: "GB", isoCode3: "GBR", englishName: "United Kingdom", callingCodes: ["44"]),
		Country(isoCode2: "US", isoCode3: "USA", englishName: "United States", callingCodes: ["1"]),
		Country(isoCode2: "UM", isoCode3: "UMI", englishName: "United States Minor Outlying Islands", callingCodes: []),
		Country(isoCode2: "UY", isoCode3: "URY", englishName: "Uruguay", callingCodes: ["598"]),
		Country(isoCode2: "UZ", isoCode3: "UZB", englishName: "Uzbekistan", callingCodes: ["998"]),
		Country(isoCode2: "VU", isoCode3: "VUT", englishName: "Vanuatu", callingCodes: ["678"]),
		Country(isoCode2: "VE", isoCode3: "VEN", englishName: "Venezuela, Bolivarian Republic of", callingCodes: ["58"]),
		Country(isoCode2: "VN", isoCode3: "VNM", englishName: "Viet Nam", callingCodes: ["84"]),
		Country(isoCode2: "VG", isoCode3: "VGB", englishName: "Virgin Islands, British", callingCodes: ["1-284"]),
		Country(isoCode2: "VI", isoCode3: "VIR", englishName: "Virgin Islands, U.S.", callingCodes: ["1-340"]),
		Country(isoCode2: "WF", isoCode3: "WLF", englishName: "Wallis and Futuna", callingCodes: ["681"]),
		Country(isoCode2: "EH", isoCode3: "ESH", englishName: "Western Sahara", callingCodes: ["212"]),
		Country(isoCode2: "YE", isoCode3: "YEM", englishName: "Yemen", callingCodes: ["967"]),
		Country(isoCode2: "ZM", isoCode3: "ZMB", englishName: "Zambia", callingCodes: ["260"]),
		Country(isoCode2: "ZW", isoCode3: "ZWE", englishName: "Zimbabwe", callingCodes: ["263"])
	]


	private static let allByCallingCode: [Int : [PhoneNumber.Digits : Country]] = {
		var values = Dictionary<Int, StrongReference<Dictionary<PhoneNumber.Digits, Country>>>()

		for country in all {
			for callingCode in country.callingCodes {
				let length = callingCode.count
				guard length > 0 else {
					log("Country '\(country)' has zero-length calling code")
					continue
				}

				var valuesForLength = values[length] ?? {
					let valuesForLength = StrongReference(Dictionary<PhoneNumber.Digits, Country>())
					values[length] = valuesForLength
					return valuesForLength
				}()

				if valuesForLength.target.updateValue(country, forKey: callingCode) != nil {
					log("Multiple countries share the same calling code '\(callingCode)'")
				}
			}
		}

		return values.mapAsDictionary { ($0, $1.target) }
	}()


	private static let allByIsoCode2: [String : Country] = {
		var values = [String : Country]()
		for country in all {
			values[country.isoCode2] = country
		}
		return values
	}()


	private static let allByIsoCode3: [String : Country] = {
		var values = [String : Country]()
		for country in all {
			values[country.isoCode3] = country
		}
		return values
	}()


	private static let maximumCallingCodeLength: Int = allByCallingCode.keys.reduce(0, combine: max)
}


public func == (a: Country, b: Country) -> Bool {
	if a.isoCode2 != b.isoCode2 {
		return false
	}
	if !a.isoCode2.isEmpty {
		return true
	}
	if a.isoCode3 != b.isoCode3 {
		return false
	}
	if !a.isoCode3.isEmpty {
		return true
	}

	return a.englishName != b.englishName
}
