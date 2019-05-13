import Foundation
import SPMUtility

struct BootstrapArguments {
    let frameworksPath: String?
    let disableCarthage: Bool?
    let generatePodfile: Bool?

    init(_ rawArguments: ArgumentParser.Result, parser: BootstrapParser) {
        frameworksPath = rawArguments.get(parser.frameworksPath)
        disableCarthage = rawArguments.get(parser.disableCarthage)
        generatePodfile = rawArguments.get(parser.generatePodfile)
    }
}
