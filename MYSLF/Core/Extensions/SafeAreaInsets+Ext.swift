//
//  SafeAreaInsets+Ext.swift
//  MYSLF
//
//  Created by Vitald3 on 18.10.2025.
//

import UIKit

extension UIApplication {
    var safeAreaInsets: UIEdgeInsets {
        guard let window = connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
            .first else { return .zero }
        return window.safeAreaInsets
    }
}
