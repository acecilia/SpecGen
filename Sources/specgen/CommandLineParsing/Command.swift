import SPMUtility

enum Command: String, CaseIterable {
    case bootstrap

    init(_ parser: ArgumentParser, _ arguments: ArgumentParser.Result) throws {
        guard let subparser = arguments.subparser(parser) else {
            throw Error.subcommandNotProvided
        }

        guard let command = Command(rawValue: subparser) else {
            throw Error.subcommandProvidedIsUnknown(sucommand: subparser)
        }

        self = command
    }
}
