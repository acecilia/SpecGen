import SPMUtility

protocol ArgumentsProtocol {
    associatedtype T
    init(_ rawArguments: ArgumentParser.Result, parser: T)
}
