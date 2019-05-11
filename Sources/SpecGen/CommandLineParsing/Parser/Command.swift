import SPMUtility

enum Command: String, CaseIterable {
    case bootstrap
    
    init(_ parser: ArgumentParser, _ arguments: ArgumentParser.Result) {
        let subparser = arguments.subparser(parser)!
        self = Command(rawValue: subparser)!
    }
    
    var overview: String {
        switch self {
        case .bootstrap: return "Bootstrap overview"
        }
    }
    
    func subparser(_ parser: ArgumentParser) -> ArgumentParser {
        return parser.add(subparser: rawValue, overview: overview)
    }
}
