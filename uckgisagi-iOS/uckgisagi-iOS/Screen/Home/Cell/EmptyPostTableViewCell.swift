//
//  EmptyPostTableViewCell.swift
//  uckgisagi-iOS
//
//  Created by Sojin Lee on 2022/11/07.
//

import UIKit
import ReactorKit
import SnapKit

class EmptyPostTableViewCell: UITableViewCell, View {
    typealias Reactor = EmptyPostTableViewCellReactor
    
    var disposeBag = DisposeBag()
    
    static let identifier = "EmptyPostTableViewCell"
    let icHuk: UIImageView = .init()
    let noticeLabel: UILabel = .init()
    let pushButton: UIButton = .init()
    let stackView: UIStackView = .init()

    // MARK: - Initailize
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setProperties()
        setLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    private func setProperties() {
        stackView.addArrangedSubviews(icHuk, noticeLabel, pushButton)
        addSubview(stackView)
        
        icHuk.image = Image.icHuk
        pushButton.setImage(Image.btnPush, for: .normal)
        noticeLabel.text = "아직 작성된 인증글이 없어요"
        noticeLabel.textColor = Color.mediumGray
        noticeLabel.font = .systemFont(ofSize: 15, weight: .regular)
        
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
    }
    
    private func setLayouts() {
        icHuk.snp.makeConstraints {
            $0.width.height.equalTo(160)
        }
        
        pushButton.snp.makeConstraints {
            $0.width.equalTo(96)
            $0.height.equalTo(40)
        }
        
        stackView.snp.makeConstraints {
            $0.width.height.equalTo(250)
            $0.centerX.centerY.equalToSuperview()
            
        }
    }
    
    func bind(reactor: Reactor) {
        switch reactor.currentState.type {
        case .my:
            pushButton.isHidden = true
            
            stackView.snp.updateConstraints {
                $0.height.equalTo(200)
            }
        case .friend:
            pushButton.isHidden = false
            
            stackView.snp.updateConstraints {
                $0.height.equalTo(250)
            }
        }
    }
}
