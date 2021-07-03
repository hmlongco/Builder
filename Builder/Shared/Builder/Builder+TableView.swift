//
//  Builder+TableView.swift
//  Builder
//
//  Created by Michael Long on 7/2/21.
//

import UIKit

class TableView<Item>: UITableView, UITableViewDataSource, UITableViewDelegate {
 
    var builder: DynamicViewBuilder<Item>
    
    var selectHandler: ((_ tableView: UITableView, _ item: Item) -> Bool)?
    
    public init(_ builder: DynamicViewBuilder<Item>) {
        self.builder = builder
        super.init(frame: .zero, style: .plain)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTableView() {
        self.dataSource = self
        self.delegate = self
        
        self.estimatedRowHeight = 44
        self.rowHeight = UITableView.automaticDimension
        
        builder.onChange { [weak self] in
            self?.reloadData()
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
        if let view = builder.build(at: indexPath.row) {
            cell.contentView.embed(view)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = builder.item(at: indexPath.row) else {
            return
        }
        if let selected = selectHandler?(self, item), selected {
            return
        }
        deselectRow(at: indexPath, animated: true)
    }
    
}
