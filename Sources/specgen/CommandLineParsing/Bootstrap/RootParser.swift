//
//  RootParser.swift
//  Basic
//
//  Created by Andres on 13/05/2019.
//

import Foundation
import SPMUtility

class RootParser {
    let argumentParser: ArgumentParser

    init() {
        argumentParser = ArgumentParser(
            usage: "<subcommand> <options>\nRun '\(ProcessInfo.processInfo.processName) <subcommand> --help' for information about each subcommand",
            overview: "A command line tool for generating podspec files from frameworks, so they can be used in a CocoaPods setup"
        )
    }
}
