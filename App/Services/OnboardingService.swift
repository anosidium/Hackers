//
//  OnboardingService.swift
//  Hackers
//
//  Created by Weiran Zhang on 15/06/2019.
//  Copyright © 2019 Weiran Zhang. All rights reserved.
//

import SwiftUI
import WhatsNewKit

enum OnboardingService {
    static func onboardingViewController(forceShow: Bool = false) -> UIViewController? {
        if ProcessInfo.processInfo.arguments.contains("disableOnboarding"), forceShow == false {
            return nil
        }

        let whatsNew = WhatsNew(
            title: "What's New in Hackers",
            items: items()
        )

        let keyValueVersionStore = KeyValueWhatsNewVersionStore(
            keyValueable: UserDefaults.standard
        )

        let viewController: WhatsNewViewController?

        if forceShow {
            viewController = WhatsNewViewController(
                whatsNew: whatsNew,
                configuration: configuration()
            )
        } else {
            viewController = WhatsNewViewController(
                whatsNew: whatsNew,
                configuration: configuration(),
                versionStore: keyValueVersionStore
            )
        }

        let theme = AppThemeProvider.shared.currentTheme
        viewController?.overrideUserInterfaceStyle = theme.userInterfaceStyle

        return viewController
    }

    private static func configuration() -> WhatsNewViewController.Configuration {
        let appTheme = AppThemeProvider.shared.currentTheme
        let theme = WhatsNewViewController.Theme { theme in
            theme.backgroundColor = appTheme.backgroundColor
            theme.titleView.titleColor = appTheme.titleTextColor
            theme.completionButton.backgroundColor = appTheme.appTintColor
            theme.completionButton.titleColor = .white
            theme.itemsView.titleColor = appTheme.titleTextColor
            theme.itemsView.subtitleColor = appTheme.textColor
        }
        var configuration = WhatsNewViewController.Configuration(theme: theme)
        configuration.titleView.titleMode = .scrolls
        return configuration
    }

    private static func items() -> [WhatsNew.Item] {
        let defaultBrowserItem = WhatsNew.Item(
            title: "Faster Thumbnails",
            subtitle: "Thumbnail images now load way faster than before.",
            image: UIImage(systemName: "bolt.fill")
        )
        return [defaultBrowserItem]
    }
}

struct OnboardingViewControllerWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = WhatsNewViewController

    func makeUIViewController(
        context: UIViewControllerRepresentableContext<OnboardingViewControllerWrapper>
    ) -> UIViewControllerType {
        let onboardingViewController = OnboardingService.onboardingViewController(forceShow: true)!
        // swiftlint:disable force_cast
        return onboardingViewController as! UIViewControllerType
    }

    func updateUIViewController(
        _ uiViewController: UIViewControllerType,
        context: UIViewControllerRepresentableContext<OnboardingViewControllerWrapper>
    ) {}
}
