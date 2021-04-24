//
//  File.swift
//  
//
//  Created by Ariel Demarco on 24/04/2021.
//

import Foundation

/// Returns path to the built products directory.
var productsDirectory: URL {
  #if os(macOS)
    for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
        return bundle.bundleURL.deletingLastPathComponent()
    }
    fatalError("couldn't find the products directory")
  #else
    return Bundle.main.bundleURL
  #endif
}
