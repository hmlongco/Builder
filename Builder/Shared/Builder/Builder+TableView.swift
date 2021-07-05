//
//  Builder+TableView.swift
//  Builder
//
//  Created by Michael Long on 7/2/21.
//

import UIKit

class TableView<Item>: UITableView, UITableViewDataSource, UITableViewDelegate {
 
    var builder: AnyIndexableViewBuilder
    var provider: AnyIndexableDataProvider?
    
    var selectHandler: ((_ tableView: UITableView, _ item: Item) -> Bool)?
    
    public init(_ builder: AnyIndexableViewBuilder) {
        self.builder = builder
        self.provider = builder as? AnyIndexableDataProvider
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
         if let provider = builder as? AnyUpdatableDataProvider {
            provider.updated
                .subscribe { [weak self] _ in
                    self?.reloadData()
                }
                .disposed(by: rxDisposeBag)
        }
    }
    
    // properties
    
    @discardableResult
    func onSelect(_ handler: @escaping (_ tableView: UITableView, _ item: Item) -> Bool) -> Self {
        self.selectHandler = handler
        return self
    }

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
        let cell = UITableViewCell(frame: tableView.bounds)
        if let view = builder.view(at: indexPath.row) {
            cell.contentView.embed(view)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = provider?.data(at: indexPath.row) as? Item else {
            return
        }
        if let selected = selectHandler?(self, item), selected {
            return
        }
        deselectRow(at: indexPath, animated: true)
    }
    
}
