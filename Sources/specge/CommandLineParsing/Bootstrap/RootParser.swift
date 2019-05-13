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
            overview: "A command line utility for generating podspecs out of frameworks, so you can break out of the CocoaPods dependency hell"
        )
    }
}
