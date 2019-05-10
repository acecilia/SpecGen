import Foundation
import CarthageKit

class Snap {
    static let frameworkExtension = "framework"
    static let podspecExtension = "podspec"
    static let infoPlistName = "Info.plist"
    static let infoPlistVersionKey = "CFBundleShortVersionString"

    static let generatedPodfileName = "Podfile"
    static let generatedCocoapodsGroupName = "autogenerated_pods"

    private let config: SnapConfig
    
    init(_ config: SnapConfig) {
        self.config = config
    }

    func run() throws {
        var frameworksInfo = try getFrameworksInfo()
        if case let .yes(cartfilePath, resolvedCartfilePath) = config.useCarthage {
            let carthage = try Carthage(cartfilePath, resolvedCartfilePath)
            frameworksInfo = try carthage.filter(frameworksInfo)
            frameworksInfo = try carthage.fixversion(frameworksInfo)
        }
        try generatePodspecFiles(from: frameworksInfo)
        if config.generatePodfile {
            try generatePodfile(frameworksInfo)
        }
    }

    private func generatePodfile(_ frameworksInfo: [FrameworkInfo]) throws {
        let podfileLines: [String] = frameworksInfo.map {
            return "  pod '\($0.name)', :path => '\(config.frameworksPath.relativePath)'"
        }

        let generatedPodfilePath = config.frameworksPath.appendingPathComponent(Snap.generatedPodfileName)

        let podfileContent = """
        # In order to use this file, load it into your main Podfile and
        # add the '\(Snap.generatedCocoapodsGroupName)' pods to the desired target.
        #
        # Example:
        # load '\(generatedPodfilePath.relativePath)' # <==============
        # target 'MyApp' do
        #   \(Snap.generatedCocoapodsGroupName) # <==============
        #   pod 'Alamofire', '~> 3.0'
        # end
        #
        # For more information about this setup see the following links:
        # * https://www.natashatherobot.com/cocoapods-installing-same-pod-multiple-targets/
        # * https://stackoverflow.com/questions/39191258/include-file-in-podfile
        #

        def \(Snap.generatedCocoapodsGroupName)
        \(podfileLines.joined(separator: "\n"))
        end
        """

        try podfileContent.write(toFile: generatedPodfilePath.path, atomically: false, encoding: .utf8)
    }

    private func getFrameworksInfo() throws -> [FrameworkInfo] {
        let frameworkDirectoryContents = try FileManager.default.contentsOfDirectory(atPath: config.frameworksPath.path).map {
            return config.frameworksPath.appendingPathComponent($0)
        }
        let frameworkPaths = frameworkDirectoryContents.filter { $0.pathExtension == Snap.frameworkExtension }
        let frameworksInfo: [FrameworkInfo] = try frameworkPaths.map { frameworkPath in
            let plistPath = frameworkPath.appendingPathComponent(Snap.infoPlistName)
            guard let plistContent = NSDictionary(contentsOfFile: plistPath.path) else {
                throw Error.frameworkDoesNotHaveInfoPlistFile(frameworkPath: frameworkPath)
            }

            let frameworkName = frameworkPath.deletingPathExtension().lastPathComponent
            guard let frameworkVersion = plistContent[Snap.infoPlistVersionKey] as? String else {
                throw Error.frameworkInfoPlistFileDoesNotContainVersion(plistPath: plistPath)
            }

            return FrameworkInfo(name: frameworkName, version: frameworkVersion)
        }
        return frameworksInfo.sorted { $0.name < $1.name }
    }

    private func generatePodspecFiles(from frameworksInfo: [FrameworkInfo]) throws {
        if !FileManager.default.fileExists(atPath: config.frameworksPath.path) {
            try FileManager.default.createDirectory(at: config.frameworksPath, withIntermediateDirectories: true)
        }

        try frameworksInfo.forEach {
            let podspecContent = generatePodspec(from: $0)
            let podspecPath = config.frameworksPath.appendingPathComponent($0.name).appendingPathExtension(Snap.podspecExtension)
            try podspecContent.write(toFile: podspecPath.path, atomically: false, encoding: .utf8)
        }
    }

    private func generatePodspec(from frameworkInfo: FrameworkInfo) -> String {
        return """
        Pod::Spec.new do |s|
        s.name                   = '\(frameworkInfo.name)'
        s.version                = '\(frameworkInfo.version)'
        s.vendored_frameworks    = '\(frameworkInfo.name).\(Snap.frameworkExtension)'

        # Dummy data required by cocoapods
        s.authors                = 'dummy'
        s.summary                = 'dummy'
        s.homepage               = 'dummy'
        s.license                = { :type => 'MIT' }
        s.source                 = { :git => '' }
        end
        """
    }
}
