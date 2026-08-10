//
//  DemoSupport.swift
//  TFYSwiftTabBarController
//
//  示范层共享：页面、属性字典、关闭按钮、组装工具
//

import SnapKit
import UIKit

@available(iOS 15.0, *)
enum DemoSupport {

    static let lottieResourceNames = [
        "gray_tabbar_home_animation",
        "gray_tabbar_message_animation",
        "gray_tabbar_me_animation",
        "green_lottie_tab_home",
        "green_lottie_tab_discover",
        "green_lottie_tab_news",
        "green_lottie_tab_mine",
        "tab_home_animate",
        "tab_search_animate",
        "tab_message_animate",
        "tab_me_animate"
    ]

    static let lottieImageResourceNames = [
        "img_tab_home_0", "img_tab_home_1", "img_tab_home_2",
        "img_tab_message_0", "img_tab_message_1",
        "img_tab_me_0", "img_tab_me_1"
    ]

    private static let tabLottieNames = [
        "green_lottie_tab_home",
        "green_lottie_tab_discover",
        "green_lottie_tab_news",
        "green_lottie_tab_mine"
    ]

    // MARK: - Attributes

    static func attrs(
        title: String,
        image: String,
        selectedImage: String,
        lottieName: String? = nil,
        lottieUsesURL: Bool = false,
        lottieSize: CGSize = CGSize(width: 28, height: 28)
    ) -> [AnyHashable: Any] {
        var dict: [AnyHashable: Any] = [
            TFYSwiftTabBarItemTitle: title,
            TFYSwiftTabBarItemImage: image,
            TFYSwiftTabBarItemSelectedImage: selectedImage
        ]
        if let lottieName,
           let path = Bundle.main.path(forResource: lottieName, ofType: "json") {
            if lottieUsesURL {
                dict[TFYSwiftTabBarLottieURL] = URL(fileURLWithPath: path)
            } else {
                dict[TFYSwiftTabBarLottieFilePath] = path
            }
            dict[TFYSwiftTabBarLottieSize] = NSValue(cgSize: lottieSize)
        }
        return dict
    }

    static func standardFourAttrs(lottie: Bool = false) -> [[AnyHashable: Any]] {
        let items = [
            ("首页", "home", "home_1"),
            ("发现", "find", "find_1"),
            ("消息", "message", "message_1"),
            ("我的", "me", "me_1")
        ]
        return items.enumerated().map { index, item in
            attrs(
                title: item.0,
                image: item.1,
                selectedImage: item.2,
                lottieName: lottie ? tabLottieNames[index] : nil
            )
        }
    }

    // MARK: - Controllers

    static func makeChild(
        title: String,
        detail: String,
        actions: [(String, () -> Void)] = []
    ) -> UIViewController {
        let page = DemoInfoViewController(titleText: title, detail: detail, actions: actions)
        return TFYSwiftBaseNavigationController(rootViewController: page)
    }

    static func makeFourChildren(
        titles: [String] = ["首页", "发现", "消息", "我的"],
        detail: String,
        configure: ((Int, UIViewController) -> Void)? = nil
    ) -> [UIViewController] {
        titles.enumerated().map { index, title in
            let child = makeChild(title: title, detail: detail)
            configure?(index, child)
            return child
        }
    }

    static func makeTab(
        style: TFYSwiftTabBarStyleType = .default,
        context: String? = nil,
        lottie: Bool = false,
        titles: [String] = ["首页", "发现", "消息", "我的"],
        attributes: [[AnyHashable: Any]]? = nil,
        detail: String,
        configureChildren: ((Int, UIViewController) -> Void)? = nil,
        configureTab: ((TFYSwiftTabBarController) -> Void)? = nil
    ) -> TFYSwiftTabBarController {
        let children = makeFourChildren(titles: titles, detail: detail, configure: configureChildren)
        let tab = TFYSwiftTabBarController(
            viewControllers: children,
            tabBarItemsAttributes: attributes ?? standardFourAttrs(lottie: lottie),
            styleType: style,
            context: context
        )
        configureTab?(tab)
        return tab
    }

    static func injectCloseButton(into root: UIViewController) {
        func closeButton() -> UIBarButtonItem {
            let item = UIBarButtonItem(
                systemItem: .close,
                primaryAction: UIAction { [weak root] _ in
                    root?.dismiss(animated: true) {
                        TFYSwiftPlusButton.removePlusButton()
                    }
                }
            )
            item.accessibilityIdentifier = "demo.close"
            return item
        }

        root.navigationItem.leftBarButtonItem = closeButton()
        if let tab = root as? UITabBarController {
            tab.viewControllers?.forEach { child in
                let host = (child as? UINavigationController)?.topViewController ?? child
                if host.navigationItem.leftBarButtonItem == nil {
                    host.navigationItem.leftBarButtonItem = closeButton()
                }
            }
        }
    }
}

// MARK: - Info Page

@available(iOS 15.0, *)
final class DemoInfoViewController: TFYSwiftBaseViewController {

    private let titleText: String
    private let detail: String
    private let actions: [(String, () -> Void)]

    init(titleText: String, detail: String, actions: [(String, () -> Void)] = []) {
        self.titleText = titleText
        self.detail = detail
        self.actions = actions
        super.init(nibName: nil, bundle: nil)
        title = titleText
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .fill
        scrollView.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.bottom.equalTo(scrollView.contentLayoutGuide).inset(24)
            make.leading.trailing.equalTo(scrollView.contentLayoutGuide).inset(20)
            make.width.equalTo(scrollView.frameLayoutGuide).offset(-40)
        }

        let titleLabel = UILabel()
        titleLabel.text = titleText
        titleLabel.font = .preferredFont(forTextStyle: .title2)
        titleLabel.numberOfLines = 0
        stack.addArrangedSubview(titleLabel)

        let detailLabel = UILabel()
        detailLabel.text = detail
        detailLabel.font = .preferredFont(forTextStyle: .body)
        detailLabel.textColor = .secondaryLabel
        detailLabel.numberOfLines = 0
        stack.addArrangedSubview(detailLabel)

        for (index, item) in actions.enumerated() {
            let button = UIButton(type: .system)
            button.configuration = {
                var config = UIButton.Configuration.gray()
                config.title = item.0
                config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
                return config
            }()
            button.tag = index
            button.addTarget(self, action: #selector(tapAction(_:)), for: .touchUpInside)
            stack.addArrangedSubview(button)
        }
    }

    @objc private func tapAction(_ sender: UIButton) {
        guard actions.indices.contains(sender.tag) else { return }
        actions[sender.tag].1()
    }
}
