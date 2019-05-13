import Foundation
import CarthageKit

class Carthage {
    static let carthageVersionRegex = try! NSRegularExpression(pattern: "\\d+(\\.\\d+){0,2}")
    static let carthageSpecGenKey = "specgen"
    static let carthageSpecGenStart = "# \(carthageSpecGenKey):start"
    static let carthageSpecGenFrameworksRegex = try! NSRegularExpression(pattern: "# \(carthageSpecGenKey):frameworks(.*)")

    private let carthageDependencies: [FrameworkInfo]

    init(_ cartfilePath: URL, _ resolvedCartfilePath: URL) throws {
        let frameworkMappings = try Carthage.getFrameworks(cartfilePath)
        self.carthageDependencies = try Carthage.setVersion(resolvedCartfilePath, frameworkMappings)
    }

    func filterAndFixVersion(_ frameworksInfo: [FrameworkInfo]) throws -> [FrameworkInfo] {
        let fixedFrameworksInfo: [FrameworkInfo] = frameworksInfo.compactMap { frameworkInfo in
            if let match = carthageDependencies.first(where: { $0.name == frameworkInfo.name }) {
                return FrameworkInfo(name: frameworkInfo.name, version: match.version)
            } else {
                // The framework is not found in the cartfile
                return nil
            }
        }
        return fixedFrameworksInfo
    }

    private static func getFrameworks(_ cartfilePath: URL) throws -> [FrameworkMapping] {
        let cartfileContent = try String(contentsOf: cartfilePath)
        let splitCartfile = cartfileContent.spm_split(around: Carthage.carthageSpecGenStart)
        let cartfileFilteredContent = splitCartfile.1 ?? cartfileContent

        let cartfileLines = cartfileFilteredContent.components(separatedBy: .newlines)
        let frameworks: [FrameworkMapping] = try cartfileLines.compactMap { line in
            guard let cartfile = Cartfile.from(string: line).value else {
                throw Error.cartfileCouldNotBeRed(cartfilePath: cartfilePath)
            }
            guard let dependency = cartfile.dependencies.first else {
                // This is not a line containing a dependency
                return nil
            }

            let explicitFrameworks = Carthage.carthageSpecGenFrameworksRegex
                .groupMatches(in: line)
                .flatMap { $0.flatMap { $0.components(separatedBy: .whitespaces) } }
                .filter { !$0.isEmpty }

            if explicitFrameworks.isEmpty {
                return FrameworkMapping(name: dependency.key.name, frameworks: [dependency.key.name])
            } else {
                return FrameworkMapping(name: dependency.key.name, frameworks: explicitFrameworks)
            }
        }
        return frameworks
    }

    private static func setVersion(_ resolvedCartfilePath: URL, _ frameworkMappings: [FrameworkMapping]) throws -> [FrameworkInfo] {
        let resolvedCartfileContent = try String(contentsOf: resolvedCartfilePath)
        guard let resolvedCartfile = ResolvedCartfile.from(string: resolvedCartfileContent).value else {
            throw Error.resolvedCartfileCouldNotBeRed(resolvedCartfilePath: resolvedCartfilePath)
        }

        let carthageInfo: [FrameworkInfo] = try frameworkMappings.compactMap { frameworkMapping -> [FrameworkInfo] in
            guard let dependency = resolvedCartfile.dependencies.first(where: { $0.key.name == frameworkMapping.name }) else {
                throw Error.frameworkFoundInCartfileNotFoundInResolvedCartfile(frameworkName: frameworkMapping.name)
            }

            let carthageVersionString = dependency.value.description
            // Carthage versions return the tag name, which in some cases is not exacly following semantic versioning,
            // and may follow the pattern 'v1.2.3'. A simple regex should fix this issue
            guard let parsedVersion = Carthage.carthageVersionRegex.firstMatch(in: carthageVersionString) else {
                throw Error.carthageVersionCouldNotBeParsed(frameworkName: dependency.key.name, version: dependency.value.description)
            }

            return frameworkMapping.frameworks.map {
                FrameworkInfo(name: $0, version: parsedVersion)
            }
        }.flatMap { $0 }

        return carthageInfo
    }
}
