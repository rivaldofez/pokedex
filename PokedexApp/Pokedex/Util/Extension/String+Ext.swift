//
//  File.swift
//  pokedex
//
//  Created by rivaldo on 02/04/24.
//

import Foundation

extension String {
    public func localized(bundle: Bundle = .main) -> String {
    return bundle.localizedString(forKey: self, value: nil, table: nil)
  }
}
