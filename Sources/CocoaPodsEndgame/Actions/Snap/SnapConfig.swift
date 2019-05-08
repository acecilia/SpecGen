import Foundation
import CarthageKit

struct SnapConfig {
    static let defaultFrameworksPath = "Carthage/Build/iOS"
    static let defaultValueForGeneratePodfile = true

    let frameworksPath: URL
    let useCarthage: UseCarthage
    let generatePodfile: Bool

    init(_ args: SnapArguments) {
        self.frameworksPath = URL(fileURLWithPath: args.frameworksPath ?? SnapConfig.defaultFrameworksPath)
        if args.disableCarthage == true {
            self.useCarthage = .no
        } else {
            let currentDirectory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
            let cartfilePath = Cartfile.url(in: currentDirectory)
            let resolvedCartfilePath = ResolvedCartfile.url(in: currentDirectory)

            if FileManager.default.fileExists(atPath: cartfilePath.path), FileManager.default.fileExists(atPath: resolvedCartfilePath.path) {
                self.useCarthage = .yes(cartfilePath: cartfilePath, resolvedCartfilePath: resolvedCartfilePath)
            } else {
                self.useCarthage = .no
            }
        }
        self.generatePodfile = args.generatePodfile ?? SnapConfig.defaultValueForGeneratePodfile
    }
}

enum UseCarthage {
    case yes(cartfilePath: URL, resolvedCartfilePath: URL)
    case no
}
