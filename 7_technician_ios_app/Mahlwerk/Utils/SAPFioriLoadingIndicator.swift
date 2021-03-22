//
// Mahlwerk
//
// Created by SAP Cloud Platform SDK for iOS Assistant application on 06/08/19
//

import Foundation
import SAPFiori

protocol SAPFioriLoadingIndicator: class {
    var loadingIndicator: FUILoadingIndicatorView? { get set }
}

extension SAPFioriLoadingIndicator where Self: UIViewController {
    func showFioriLoadingIndicator(_ message: String = "") {
        DispatchQueue.main.async {
            let indicator = FUILoadingIndicatorView(frame: self.view.frame)
            indicator.text = message
            indicator.show()
            self.loadingIndicator = indicator
            if let frontWindow = UIApplication.shared.keyWindow {
                self.loadingIndicator!.center = frontWindow.center
                frontWindow.addSubview(self.loadingIndicator!)
            }
        }
    }

    func hideFioriLoadingIndicator() {
        DispatchQueue.main.async {
            guard let loadingIndicator = self.loadingIndicator else {
                return
            }
            loadingIndicator.dismiss()
        }
    }
}
