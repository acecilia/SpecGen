import Foundation
import SPMUtility
import CarthageKit

struct SnapParser: ParserProtocol {
    let frameworksPath: OptionArgument<String>
    let disableCarthage: OptionArgument<Bool>
    let generatePodfile: OptionArgument<Bool>

    init(_ parser: ArgumentParser) {        
        self.frameworksPath = parser.add(option: "--frameworksPath", shortName: "-f", kind: String.self, usage: "The path containing the frameworks. Defaults to \(SnapConfig.defaultFrameworksPath)", completion: nil)
        self.disableCarthage = parser.add(option: "--disableCarthage", shortName: "-d", kind: Bool.self, usage: "If this flag is present, the '\(Cartfile.url(in: URL(fileURLWithPath: ".")).relativePath)' and '\(ResolvedCartfile.url(in: URL(fileURLWithPath: ".")).relativePath)' files will NOT be used to set the framework versions", completion: nil)
        self.generatePodfile = parser.add(option: "--generatePodfile", shortName: "-p", kind: Bool.self, usage: "Generates an example podfile pointing to the created podspecs", completion: nil)
    }
}
