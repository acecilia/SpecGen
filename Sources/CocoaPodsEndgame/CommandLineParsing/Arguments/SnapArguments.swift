import Foundation
import SPMUtility

struct SnapArguments: ArgumentsProtocol {
    let frameworksPath: String?
    let disableCarthage: Bool?
    let generatePodfile: Bool?

    init(_ rawArguments: ArgumentParser.Result, parser: SnapParser) {
        self.frameworksPath = rawArguments.get(parser.frameworksPath)
        self.disableCarthage = rawArguments.get(parser.disableCarthage)
        self.generatePodfile = rawArguments.get(parser.generatePodfile)
    }
}
