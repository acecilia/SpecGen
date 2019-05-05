import Foundation
import Basic
import SPMUtility

let parser = ArgumentParser(usage: "<command> <options>", overview: "A command line utility for generating valid podspecs out of frameworks, so you can break out of the dependency hell")
let snapParser = SnapParser(Command.snap.subparser(parser))

do {
    let commandLineArguments = try parser.parse(Array(ProcessInfo.processInfo.arguments.dropFirst()))
    
    // If execution got to this point, means that the provided arguments are correct

    switch Command(parser, commandLineArguments) {
    case .snap:
        let snapArgs = SnapArguments(commandLineArguments, parser: snapParser)
        let snapConfig = SnapConfig(snapArgs)
        let snap = Snap(snapConfig)
        try snap.run()
    }

} catch  {
    switch error {
    case let error as ArgumentParserError:
        print(error.description)
    case let ProcessResult.Error.nonZeroExit(result):
        print(try result.utf8stderrOutput())
    default:
        print(error)
    }
    exit(1)
}
