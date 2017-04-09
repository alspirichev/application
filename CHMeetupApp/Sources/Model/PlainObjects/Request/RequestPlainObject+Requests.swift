//
//  RequestPlainObject+Requests.swift
//  CHMeetupApp
//
//  Created by Sam Mejlumyan on 05/04/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

extension RequestPlainObject: PlainObjectType {

  enum RequestError: String {
    case accessForbidden
    case notFound
    case failedRequest
  }

  init?(json: JSONDictionary) {
    guard
      let code = json["code"] as? Int,
      let answer = json["answer"] as? String
      else { return nil }

    self.code = code
    self.answer = answer

    if let error = json["error"] as? String {
      self.error = RequestError(rawValue: error)
      self.success = false
    } else {
      self.success = true
      self.error = nil
    }
  }
}