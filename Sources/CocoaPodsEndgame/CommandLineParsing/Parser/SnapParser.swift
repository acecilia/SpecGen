import Foundation
import SPMUtility
import CarthageKit

struct SnapParser: ParserProtocol {
    let frameworksPath: OptionArgument<String>
    let useCarthage: OptionArgument<Bool>
    let generatePodfile: OptionArgument<Bool>

    init(_ parser: ArgumentParser) {        
        self.frameworksPath = parser.add(option: "--frameworksPath", shortName: "-f", kind: String.self, usage: "The path containing the frameworks. Defaults to \(SnapConfig.defaultFrameworksPath)", completion: nil)
        self.useCarthage = parser.add(option: "--useCarthage", shortName: "-c", kind: Bool.self, usage: "If this flag is present, the '\(Cartfile.url(in: URL(fileURLWithPath: ".")).relativePath)' and '\(ResolvedCartfile.url(in: URL(fileURLWithPath: ".")).relativePath)' will be used to set the framework versions. Also, you can use the '\(Carthage.carthageCocoaPodsEndgameKey)' comments in the '\(Cartfile.url(in: URL(fileURLWithPath: ".")).relativePath)' to customize how the podspecs are generated", completion: nil)
        self.generatePodfile = parser.add(option: "--generatePodfile", shortName: "-p", kind: Bool.self, usage: "Generates an example podfile pointing to the created podspecs", completion: nil)
    }
}
