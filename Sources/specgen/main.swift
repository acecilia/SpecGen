import Basic
import Foundation
import SPMUtility

let version = Version("0.0.1")

let rootParser = RootParser()
let bootstrapSubparser = BootstrapParser(rootParser.argumentParser)
let arguments = Array(ProcessInfo.processInfo.arguments.dropFirst())

do {
    let commandLineArguments = try rootParser.argumentParser.parse(arguments)

    // If execution got to this point, means that the provided arguments are correct

    switch try Command(rootParser.argumentParser, commandLineArguments) {
    case .bootstrap:
        let boostrapArgs = BootstrapArguments(commandLineArguments, parser: bootstrapSubparser)
        let boostrapConfig = BootstrapConfig(boostrapArgs)
        let boostrap = Bootstrap(boostrapConfig)
        try boostrap.run()
    }

} catch {
    switch error {
    case let error as ArgumentParserError:
        print(error.description)
    default:
        print(error.localizedDescription)
    }
    exit(1)
}
