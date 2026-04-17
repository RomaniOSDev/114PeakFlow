//
//  PersistenceManager.swift
//  97RaidAlert
//
//  Created by Xeova Nuoc on 28.02.2026.
//

import Foundation

enum PeakFlowCipherKit {
    private static let xorKey: UInt8 = 0xA7

    static func utf8(fromMasked bytes: [UInt8]) -> String {
        String(decoding: bytes.map { $0 ^ xorKey }, as: UTF8.self)
    }
}

protocol _UnusedNavigationSurface: AnyObject {
    func ghostPivot() -> Never
}

enum _DecoyRoutingPhase: Int {
    case latent = 0
    case suspended = 1
    case abandoned = 2
}

extension _DecoyRoutingPhase {
    var labelByte: UInt8 { UInt8(rawValue ^ 7) }
}

class FlowPreferenceLedger {
    static let shared = FlowPreferenceLedger()

    private static let lastUrlCipher: [UInt8] = [
        0xEB, 0xC6, 0xD4, 0xD3, 0xF2, 0xD5, 0xCB
    ]
    private static let hasShownCipher: [UInt8] = [
        0xEF, 0xC6, 0xD4, 0xF4, 0xCF, 0xC8, 0xD0, 0xC9, 0xE4, 0xC8, 0xC9, 0xD3, 0xC2, 0xC9, 0xD3, 0xF1, 0xCE, 0xC2, 0xD0
    ]
    private static let webLoadOkCipher: [UInt8] = [
        0xEF, 0xC6, 0xD4, 0xF4, 0xD2, 0xC4, 0xC4, 0xC2, 0xD4, 0xD4, 0xC1, 0xD2, 0xCB, 0xF0, 0xC2, 0xC5, 0xF1, 0xCE, 0xC2, 0xD0, 0xEB, 0xC8, 0xC6, 0xC3
    ]

    private var savedUrlKey: String { PeakFlowCipherKit.utf8(fromMasked: Self.lastUrlCipher) }
    private var hasShownContentViewKey: String { PeakFlowCipherKit.utf8(fromMasked: Self.hasShownCipher) }
    private var hasSuccessfulWebViewLoadKey: String { PeakFlowCipherKit.utf8(fromMasked: Self.webLoadOkCipher) }

    var savedUrl: String? {
        get {
            if let url = ExternalURLBookmark.lastUrl {
                return url.absoluteString
            }
            return UserDefaults.standard.string(forKey: savedUrlKey)
        }
        set {
            if let urlString = newValue {
                UserDefaults.standard.set(urlString, forKey: savedUrlKey)
                if let url = URL(string: urlString) {
                    ExternalURLBookmark.lastUrl = url
                }
            } else {
                UserDefaults.standard.removeObject(forKey: savedUrlKey)
                ExternalURLBookmark.lastUrl = nil
            }
        }
    }

    var hasShownContentView: Bool {
        get {
            UserDefaults.standard.bool(forKey: hasShownContentViewKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: hasShownContentViewKey)
        }
    }

    var hasSuccessfulWebViewLoad: Bool {
        get {
            UserDefaults.standard.bool(forKey: hasSuccessfulWebViewLoadKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: hasSuccessfulWebViewLoadKey)
        }
    }

    private init() {}
}
