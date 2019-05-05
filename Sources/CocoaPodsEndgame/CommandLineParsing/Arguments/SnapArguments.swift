import Foundation
import SPMUtility

struct SnapArguments: ArgumentsProtocol {
    let frameworksPath: String?
    let useCarthage: Bool?
    let generatePodfile: Bool?

    init(_ rawArguments: ArgumentParser.Result, parser: SnapParser) {
        self.frameworksPath = rawArguments.get(parser.frameworksPath)
        self.useCarthage = rawArguments.get(parser.useCarthage)
        self.generatePodfile = rawArguments.get(parser.generatePodfile)
    }
}
