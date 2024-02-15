import UIKit

class TapableView: UIView {
    private var tapAction: (() -> Void)?
    
    func onTap(_ action: @escaping () -> Void) {
        tapAction = action
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        tapAction?()
    }
}
