
extension UIButton {

    public func rotate(by degrees: CGFloat = 45) {
        UIView.animate(withDuration: 0.4) {
            let radians = degrees * CGFloat(Double.pi / 180)
            self.transform = self.transform.rotated(by: CGFloat(radians))
        }
    }
}
