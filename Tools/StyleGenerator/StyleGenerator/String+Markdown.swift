//
//  String+Markdown.swift
//  StyleGenerator
//
//  Created by Denis on 10.03.17.
//  Copyright © 2017 DenRee. All rights reserved.
//
import Foundation

typealias SwitchCase = (case: String, code: String)
private let defaultIndentation = 2

extension String {

  // MARK: - Nested 

  enum CodeSymbols {
    case header
    case newLine
    case line(string: String)
    case mark(title: String)
    case `extension`(for: String, nestedTypes: [CodeSymbols])
    case `enum`(name: String, cases: [String])
    case `switch`(value: String, cases: [SwitchCase])
    case function(title: String, body: [CodeSymbols])
  }

  static func += (lhs: inout String, rhs: CodeSymbols) {
    lhs += rhs.value
  }

  static var space: String {
    return " "
  }

  fileprivate func addIndentation(_ count: Int = defaultIndentation) -> String {
    var indent = ""
    for _ in 0..<count {
      indent += String.space
    }

    var result = self.replacingOccurrences(of: "\n", with: "\n" + indent)
    if result.hasSuffix(indent) {
      let startIndex = result.index(result.startIndex, offsetBy: result.characters.count - count)
      let endIndex = result.index(result.startIndex, offsetBy: result.characters.count)
      result.replaceSubrange(startIndex..<endIndex, with: "")
    }
    result.insert(contentsOf: indent.characters, at: result.startIndex)
    return result
  }
}

extension String.CodeSymbols {

  // MARK: - Public 

  var value: String {
    switch self {
      //Header
    case .header:
      var result = ""
      result += "//\n"
      result += "// Autogenerated by StyleGenerator - Generator\n"
      result += "// by CocoaHeads Team https://github.com/azimin/CocoaHeadsMeetupApp\n"
      result += "//\n\n"
      return result

      //New line symbol
    case .newLine:
      return "\n"

      //Line symbol
    case .line(let string):
      return string + "\n"

      //Mark symbol
    case .mark(let title):
      return "// MARK: - \(title)\n\n"

      //Extension symbol
    case .extension(let type, let nested):
      var result = "extension \(type) {\n"
      for nestedSymbol in nested {
        if nestedSymbol.value == String.CodeSymbols.newLine.value {
          result += nestedSymbol
        } else {
          result += nestedSymbol.addIndentation()
        }
      }
      result += .line(string: "}")
      return result

      //Enum symbol
    case .enum(let name, let cases):
      var result = "enum \(name) {\n"

      var casesString = ""
      for caseName in cases {
        casesString += "case \(caseName)\n"
      }

      result += casesString.addIndentation()
      result += .line(string: "}")
      return result

      //Switch symbol
    case .switch(let value, let cases):
      var result = ""
      result += .line(string: "switch \(value) {")
      for caseValue in cases {
        result += .line(string: "case .\(caseValue.case):")
        result += .line(string: caseValue.code.addIndentation())
      }
      result += .line(string: "}")
      return result

      //Function symbol
    case .function(let title, let body):
      var result = ""
      result += .line(string: title + " {")
      for item in body {
        result += item.addIndentation()
      }
      result += .line(string: "}")
      return result
    }
  }

  func addIndentation(_ count: Int = defaultIndentation) -> String {
    return self.value.addIndentation(count)
  }
}
