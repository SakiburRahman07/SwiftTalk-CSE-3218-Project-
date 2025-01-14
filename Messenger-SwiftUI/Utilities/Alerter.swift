

import SwiftUI

class Alerter: ObservableObject {
    static var shared = Alerter()
    @Published var alert: Alert? {
        didSet { isShowingAlert = alert != nil }
    }
    @Published var isShowingAlert = false
}
