
public class TappableButton: UIButton {

    override public func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let event = event, event.type == .touches else { return false }

        let newFrame = CGRect(x: bounds.minX - 10, y: bounds.minY - 10, width: bounds.maxX + 30, height: bounds.maxY + 30)
        return newFrame.contains(point)
    }
}
