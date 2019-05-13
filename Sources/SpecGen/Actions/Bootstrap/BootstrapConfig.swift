import CarthageKit
import Foundation

struct BootstrapConfig {
    static let defaultFrameworksPath = "Carthage/Build/iOS"
    static let defaultValueForGeneratePodfile = true

    let frameworksPath: URL
    let useCarthage: UseCarthage
    let generatePodfile: Bool

    init(_ args: BootstrapArguments) {
        frameworksPath = URL(fileURLWithPath: args.frameworksPath ?? BootstrapConfig.defaultFrameworksPath)
        if args.disableCarthage == true {
            useCarthage = .no
        } else {
            let currentDirectory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
            let cartfilePath = Cartfile.url(in: currentDirectory)
            let resolvedCartfilePath = ResolvedCartfile.url(in: currentDirectory)

            if FileManager.default.fileExists(atPath: cartfilePath.path), FileManager.default.fileExists(atPath: resolvedCartfilePath.path) {
                useCarthage = .yes(cartfilePath: cartfilePath, resolvedCartfilePath: resolvedCartfilePath)
            } else {
                useCarthage = .no
            }
        }
        generatePodfile = args.generatePodfile ?? BootstrapConfig.defaultValueForGeneratePodfile
    }
}

enum UseCarthage {
    case yes(cartfilePath: URL, resolvedCartfilePath: URL)
    case no
}
