//
//  SaveService.swift
//  97RaidAlert
//
//  Created by Xeova Nuoc on 28.02.2026.
//

import Foundation

struct ExternalURLBookmark {
    private static let lastUrlCipher: [UInt8] = [
        0xEB, 0xC6, 0xD4, 0xD3, 0xF2, 0xD5, 0xCB
    ]

    private static var resolvedLastUrlKey: String {
        PeakFlowCipherKit.utf8(fromMasked: lastUrlCipher)
    }

    static var lastUrl: URL? {
        get { UserDefaults.standard.url(forKey: resolvedLastUrlKey) }
        set { UserDefaults.standard.set(newValue, forKey: resolvedLastUrlKey) }
    }
}
