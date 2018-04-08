
public extension UITableView {

    public func registerCell<T: UITableViewCell>(_: T.Type){
        register(T.self, forCellReuseIdentifier: T.identifier)
    }
}

