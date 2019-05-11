import Foundation

enum Error: LocalizedError {
    case frameworkDoesNotHaveInfoPlistFile(frameworkPath: URL)
    case frameworkInfoPlistFileDoesNotContainVersion(plistPath: URL)
    case cartfileCouldNotBeRed(cartfilePath: URL)
    case resolvedCartfileCouldNotBeRed(resolvedCartfilePath: URL)
    case explicitFrameworkInCartfileWasNotFoundAtFrameworksPath(explicitFramework: String)

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
        }
    }
}
