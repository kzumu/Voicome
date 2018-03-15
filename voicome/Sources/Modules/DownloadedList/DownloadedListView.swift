//
//  DownloadedListView.swift
//  voicome
//
//  Created by 下村一将 on 2018/03/11.
//  Copyright © 2018年 kazu. All rights reserved.
//

import UIKit

class DownloadedListView: UIView {

    let tableView: UITableView = {
        let v = UITableView(frame: .zero)
        return v
    }()

    let playAllButton: UIBarButtonItem = {
        let b = UIBarButtonItem(title: "▶", style: .plain, target: nil, action: nil)
        return b
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        setupLayout()
    }

    private func setupLayout() {
        self.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}
