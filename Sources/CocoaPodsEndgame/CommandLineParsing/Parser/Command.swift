import SPMUtility

enum Command: String, CaseIterable {
    case snap
    
    init(_ parser: ArgumentParser, _ arguments: ArgumentParser.Result) {
        let subparser = arguments.subparser(parser)!
        self = Command(rawValue: subparser)!
    }
    
    var overview: String {
        switch self {
        case .snap: return "Snap overview"
        }
    }
    
    func subparser(_ parser: ArgumentParser) -> ArgumentParser {
        return parser.add(subparser: rawValue, overview: overview)
    }
}
