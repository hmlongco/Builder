//
//  Builder+TableView.swift
//  ViewBuilder
//
//  Created by Michael Long on 7/2/21.
//

import UIKit

struct TableView: ModifiableView {

    struct CellContext: ViewBuilderContextProvider {
        var view: UITableViewCell
        let tableView: UITableView
        let indexPath: IndexPath
    }

    let modifiableView = ViewBuilderInternalTableView()
    
    public init(_ builder: AnyIndexableViewBuilder) {
        modifiableView.set(builder)
    }

}

class ViewBuilderInternalTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
     
    var builder: AnyIndexableViewBuilder!
    
    public init() {
        super.init(frame: .zero, style: .plain)
        self.dataSource = self
        self.delegate = self
        self.estimatedRowHeight = 44
        self.rowHeight = UITableView.automaticDimension
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    public func set(_ builder: AnyIndexableViewBuilder) {
        self.builder = builder
        builder.updated?
            .subscribe { [weak self] _ in
                self?.reloadData()
            }
            .disposed(by: rxDisposeBag)
    }
    
    // delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        builder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = builder.view(at: indexPath.row)?.asUIView() as? UITableViewCell else {
            return UITableViewCell(frame: tableView.bounds)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ViewBuilderInternalTableViewCell, let selectionHandler = cell.selectionHandler {
            let context = TableView.CellContext(view: cell, tableView: self, indexPath: indexPath)
            if selectionHandler(context) {
                return
            }
        }
        deselectRow(at: indexPath, animated: true)
    }
    
}

struct TableViewCell: ModifiableView {
    
    let modifiableView = ViewBuilderInternalTableViewCell(frame: .zero)
    
//    convenience public init(title: String) {
//        self.init(style: .default, reuseIdentifier: "bTitle")
//        self.textLabel?.text = title
//    }
//
//    convenience public init(title: String, subtitle: String) {
//        self.init(style: .subtitle, reuseIdentifier: "bSubtitle")
//        self.textLabel?.text = title
//        self.detailTextLabel?.text = subtitle
//    }
//
//    convenience public init(name: String, value: String) {
//        self.init(style: .value1, reuseIdentifier: "bValue1")
//        self.textLabel?.text = name
//        self.detailTextLabel?.text = value
//    }
//
//    convenience public init(field: String, value: String) {
//        self.init(style: .value2, reuseIdentifier: "bValue2")
//        self.textLabel?.text = field
//        self.detailTextLabel?.text = value
//    }

    public init(_ view: View, padding: UIEdgeInsets? = nil) {
        let padding = padding ?? UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        modifiableView.contentView.embed(view.asUIView(), padding: padding)
    }

    public init(padding: UIEdgeInsets? = nil, @ViewResultBuilder _ builder: () -> ViewConvertable) {
        let padding = padding ?? UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        builder().asViews().forEach { modifiableView.contentView.embed($0, padding: padding) }
    }
    
}

class ViewBuilderInternalTableViewCell: UITableViewCell {
    
    var selectionHandler: ((_ tableView: TableView.CellContext) -> Bool)?

}

extension ModifiableView where Base: ViewBuilderInternalTableViewCell {

    @discardableResult
    func accessoryType(_ type: UITableViewCell.AccessoryType) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.accessoryType, value: type)
    }

    @discardableResult
    func onSelect(_ handler: @escaping (_ context: TableView.CellContext) -> Bool) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { $0.selectionHandler = handler }
    }

}
