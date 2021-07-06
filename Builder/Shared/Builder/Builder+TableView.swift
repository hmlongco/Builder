//
//  Builder+TableView.swift
//  Builder
//
//  Created by Michael Long on 7/2/21.
//

import UIKit


class TableView: UITableView, UITableViewDataSource, UITableViewDelegate {
 
    var builder: AnyIndexableViewBuilder
    
    public init(_ builder: AnyIndexableViewBuilder) {
        self.builder = builder
        super.init(frame: .zero, style: .plain)
        setupTableView()
        setupSubscriptions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTableView() {
        self.dataSource = self
        self.delegate = self
        
        self.estimatedRowHeight = 44
        self.rowHeight = UITableView.automaticDimension
    }
    
    func setupSubscriptions() {
        builder.updated?
            .subscribe { [weak self] _ in
                self?.reloadData()
            }
            .disposed(by: rxDisposeBag)
    }
    
    // properties
    
    @discardableResult
    public func reference(_ reference: inout TableView?) -> Self {
        reference = self
        return self
    }

    @discardableResult
    public func with(_ configuration: (_ view: TableView) -> Void) -> Self {
        configuration(self)
        return self
    }

    // delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        builder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let view = builder.view(at: indexPath.row) else {
            return UITableViewCell(frame: tableView.bounds)
        }
        if let cell = view as? TableViewCell {
            return cell
        }
        let cell = UITableViewCell(frame: tableView.bounds)
        cell.contentView.embed(view)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TableViewCell, let selected = cell.selectionHandler?(self), selected {
            return
        }
        deselectRow(at: indexPath, animated: true)
    }
    
}


class TableViewCell: UITableViewCell {
    
    var selectionHandler: ((_ tableView: UITableView) -> Bool)?

    convenience public init(title: String) {
        self.init(style: .default, reuseIdentifier: "bTitle")
        self.textLabel?.text = title
    }

    convenience public init(title: String, subtitle: String) {
        self.init(style: .subtitle, reuseIdentifier: "bSubtitle")
        self.textLabel?.text = title
        self.detailTextLabel?.text = subtitle
    }

    convenience public init(name: String, value: String) {
        self.init(style: .value1, reuseIdentifier: "bValue1")
        self.textLabel?.text = name
        self.detailTextLabel?.text = value
    }

    convenience public init(field: String, value: String) {
        self.init(style: .value2, reuseIdentifier: "bValue2")
        self.textLabel?.text = field
        self.detailTextLabel?.text = value
    }

    convenience public init(_ builder: ViewBuilder, padding: UIEdgeInsets? = UIEdgeInsets(h: 16, v: 8)) {
        self.init(frame: .zero)
        builder.build().embed(in: self.contentView, padding: padding, safeArea: false)
    }

    convenience public init(padding: UIEdgeInsets? = UIEdgeInsets(h: 16, v: 8), @ViewResultBuilder _ builder: () -> ViewConvertable) {
        self.init(frame: .zero)
        builder().asViews().forEach { self.contentView.embed($0, padding: padding) }
    }
    
    @discardableResult
    func accessoryType(_ type: AccessoryType) -> Self {
        self.accessoryType = type
        return self
    }

    @discardableResult
    func onSelect(_ handler: @escaping (_ tableView: UITableView) -> Bool) -> Self {
        self.selectionHandler = handler
        return self
    }

    @discardableResult
    public func reference(_ reference: inout TableViewCell?) -> Self {
        reference = self
        return self
    }

    @discardableResult
    public func with(_ configuration: (_ view: TableViewCell) -> Void) -> Self {
        configuration(self)
        return self
    }

}
