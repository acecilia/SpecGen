import Foundation

enum Error: LocalizedError {
    case frameworkDoesNotHaveInfoPlistFile(frameworkPath: URL)
    case frameworkInfoPlistFileDoesNotContainVersion(plistPath: URL)
    case cartfileCouldNotBeRed(cartfilePath: URL)
    case resolvedCartfileCouldNotBeRed(resolvedCartfilePath: URL)
    case explicitFrameworkInCartfileWasNotFoundAtFrameworksPath(explicitFramework: String)
    case frameworkFoundInCartfileNotFoundInResolvedCartfile(frameworkName: String)
    case carthageVersionCouldNotBeParsed(frameworkName: String, version: String)
    case subcommandNotProvided
    case subcommandProvidedIsUnknown(sucommand: String)

    var errorDescription: String? {
        switch self {
        case let .frameworkDoesNotHaveInfoPlistFile(frameworkPath):
            return "The framework at path '\(frameworkPath.path)' does not contain an 'Info.plist' file"
        case let .frameworkInfoPlistFileDoesNotContainVersion(plistPath):
            return "The plist at path '\(plistPath.path)' does not contain the version number"
        case let .cartfileCouldNotBeRed(cartfilePath):
            return "The cartfile at path '\(cartfilePath.path)' could not be red"
        case let .resolvedCartfileCouldNotBeRed(resolvedCartfilePath):
            return "The resolved cartfile at path '\(resolvedCartfilePath.path)' could not be red"
        case let .explicitFrameworkInCartfileWasNotFoundAtFrameworksPath(explicitFramework):
            return "The framework '\(explicitFramework)' specified in the cartfile was not found at the frameworks path"
        case let .frameworkFoundInCartfileNotFoundInResolvedCartfile(frameworkName):
            return "The framework '\(frameworkName)' specified in the cartfile was not found in the cartfile.resolved"
        case let .carthageVersionCouldNotBeParsed(frameworkName, version):
            return "The version '\(version)' of the framework '\(frameworkName)' could not be parsed as valid semantic versioning"
        case .subcommandNotProvided:
            let availableSucommands = Command.allCases.map { "'\($0.rawValue)'" }.joined(separator: ", ")
            return "A subcommand was not provided. Available options are: \(availableSucommands)"
        case let .subcommandProvidedIsUnknown(sucommand):
            let availableSucommands = Command.allCases.map { "'\($0.rawValue)'" }.joined(separator: ", ")
            return "The provided subcommand '\(sucommand)' is unknown. Available options are: \(availableSucommands)"
        }
    }
}
