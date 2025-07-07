//
//  TableViewCell.swift
//  TestTaskShift
//
//  Created by Кирилл Софрин on 07.07.2025.
//

import UIKit
import SnapKit

// MARK: - TableViewCell
final class TableViewCell: UITableViewCell {
    // MARK: - Constants
    private enum Constants {
        static let containerCornerRadius: CGFloat = 16
        static let titleFontSize: CGFloat = 20
        static let authorFontSize: CGFloat = 14
        static let containerTopBottomInset: CGFloat = 8
        static let containerSideInset: CGFloat = 16
        static let labelSideInset: CGFloat = 12
        static let titleTopInset: CGFloat = 16
        static let labelSpacing: CGFloat = 4
        static let authorBottomInset: CGFloat = 16
    }

    // MARK: - Properties
    private let backgroundContainerView = UIView()
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupLayout()
    }
}

// MARK: - UI Setup
private extension TableViewCell {
    func setupUI() {
        setupBaseUI()
        setupBackgroundContainerView()
        setupTitleLabel()
        setupAuthorLabel()
    }

    func setupBaseUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

    func setupBackgroundContainerView() {
        backgroundContainerView.backgroundColor = .black
        backgroundContainerView.layer.cornerRadius = Constants.containerCornerRadius
        backgroundContainerView.layer.masksToBounds = true
        contentView.addSubview(backgroundContainerView)
    }

    func setupTitleLabel() {
        titleLabel.font = .boldSystemFont(ofSize: Constants.titleFontSize)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        backgroundContainerView.addSubview(titleLabel)
    }

    func setupAuthorLabel() {
        authorLabel.font = .systemFont(ofSize: Constants.authorFontSize)
        authorLabel.textColor = .white
        authorLabel.textAlignment = .center
        authorLabel.numberOfLines = 0
        backgroundContainerView.addSubview(authorLabel)
    }
}

// MARK: - Constraints
private extension TableViewCell {
    func setupLayout() {
        backgroundContainerView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(Constants.containerTopBottomInset)
            make.bottom.equalTo(contentView).inset(Constants.containerTopBottomInset)
            make.left.equalTo(contentView).offset(Constants.containerSideInset)
            make.right.equalTo(contentView).inset(Constants.containerSideInset)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.titleTopInset)
            make.left.right.equalToSuperview().inset(Constants.labelSideInset)
        }
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.labelSpacing)
            make.left.right.equalToSuperview().inset(Constants.labelSideInset)
            make.bottom.equalToSuperview().inset(Constants.authorBottomInset)
        }
    }
}

// MARK: - Configure
extension TableViewCell {
    func configure(title: String, author: String) {
        titleLabel.text = title
        authorLabel.text = author
    }
}

