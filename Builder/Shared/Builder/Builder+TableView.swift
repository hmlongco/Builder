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

    let modifiableView = BuilderInternalTableView()
    
    public init(_ builder: AnyIndexableViewBuilder) {
        modifiableView.set(builder)
    }

}

class BuilderInternalTableView: UITableView, UITableViewDataSource, UITableViewDelegate, ViewBuilderEventHandling {
     
    public var builder: AnyIndexableViewBuilder!
    
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
    
    override public func didMoveToWindow() {
        optionalBuilderAttributes()?.commonDidMoveToWindow(self)
    }

    // delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        builder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let view = builder.view(at: indexPath.row) else {
            return UITableViewCell(frame: tableView.bounds)
        }
        if let cell = view.build() as? UITableViewCell {
            return cell
        }
        if let cell = TableViewCell({ view }).build() as? UITableViewCell {
            return cell
        }
        return UITableViewCell(frame: tableView.bounds)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? BuilderInternalTableViewCell, let selectionHandler = cell.selectionHandler {
            let context = TableView.CellContext(view: cell, tableView: self, indexPath: indexPath)
            if selectionHandler(context) {
                return
            }
        }
        deselectRow(at: indexPath, animated: true)
    }
    
}

struct TableViewCell: ModifiableView {
    
    let modifiableView: BuilderInternalTableViewCell
    
    public init(title: String) {
        modifiableView = BuilderInternalTableViewCell(style: .default, reuseIdentifier: "bTitle")
        modifiableView.textLabel?.text = title
    }

    public init(title: String, subtitle: String) {
        modifiableView = BuilderInternalTableViewCell(style: .subtitle, reuseIdentifier: "bSubtitle")
        modifiableView.textLabel?.text = title
        modifiableView.detailTextLabel?.text = subtitle
    }

    public init(name: String, value: String) {
        modifiableView = BuilderInternalTableViewCell(style: .value1, reuseIdentifier: "bValue1")
        modifiableView.textLabel?.text = name
        modifiableView.detailTextLabel?.text = value
    }

    public init(field: String, value: String) {
        modifiableView = BuilderInternalTableViewCell(style: .value2, reuseIdentifier: "bValue2")
        modifiableView.textLabel?.text = field
        modifiableView.detailTextLabel?.text = value
    }

    public init(_ view: View, padding: UIEdgeInsets? = nil) {
        self.modifiableView = BuilderInternalTableViewCell(frame: .zero)
        let padding = padding ?? UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        modifiableView.contentView.embed(view.build(), padding: padding)
    }

    public init(padding: UIEdgeInsets? = nil, @ViewResultBuilder _ builder: () -> ViewConvertable) {
        self.modifiableView = BuilderInternalTableViewCell(frame: .zero)
        let padding = padding ?? UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        builder().asViews().forEach { modifiableView.contentView.embed($0, padding: padding) }
    }
    
}

class BuilderInternalTableViewCell: UITableViewCell {
    
    var selectionHandler: ((_ tableView: TableView.CellContext) -> Bool)?

}

extension ModifiableView where Base: BuilderInternalTableViewCell {

    @discardableResult
    func accessoryType(_ type: UITableViewCell.AccessoryType) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.accessoryType, value: type)
    }

    @discardableResult
    func onSelect(_ handler: @escaping (_ context: TableView.CellContext) -> Bool) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { $0.selectionHandler = handler }
    }

}
