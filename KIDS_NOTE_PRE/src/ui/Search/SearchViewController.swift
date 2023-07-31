//
//  SearchViewController.swift
//  KIDS_NOTE_PRE
//
//  Created by 박종열 on 2023/07/28.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources

class SearchViewController: BaseViewController, View {
    
    private let backButton = UIButton().then {
        $0.clipsToBounds = true
        $0.tintAdjustmentMode = .dimmed
        $0.setImage(.init(systemName: "chevron.backward"), for: .normal)
        $0.tintColor = .black
        $0.setBackgroundColor(UIColor.lightGray, for: .highlighted)
        $0.layer.cornerRadius = 24
    }
    
    private let searchField = UITextField().then {
        $0.font = .systemFont(ofSize: 18, weight: .regular)
        $0.textColor = .darkGray
        $0.clearButtonMode = .never
        $0.returnKeyType = .search
        $0.keyboardType = .default
        $0.placeholder = "Play 북에서 검색"
    }
    
    private let clearButton = UIButton().then {
        $0.clipsToBounds = true
        $0.tintAdjustmentMode = .dimmed
        $0.setImage(.init(systemName: "xmark"), for: .normal)
        $0.tintColor = .black
        $0.setBackgroundColor(UIColor.lightGray, for: .highlighted)
        $0.layer.cornerRadius = 24
    }
    
    private lazy var searchContainer = UIView().then {
        $0.addSubview(backButton)
        $0.addSubview(searchField)
        $0.addSubview(clearButton)
        $0.backgroundColor = .white
        
        backButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(48)
            make.leading.equalToSuperview().inset(16)
        }
        clearButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(48)
            make.trailing.equalToSuperview().inset(16)
            make.leading.lessThanOrEqualTo(searchField.snp.trailing)
        }
        searchField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(backButton.snp.trailing)
            make.trailing.lessThanOrEqualTo(clearButton.snp.leading)
        }
    }
    
    private lazy var ebookListView: UICollectionView = {
        let layout = CommonFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.contentInsetAdjustmentBehavior = .always

        view.register(SearchListBookCell.self, forCellWithReuseIdentifier: SearchListBookCell.reuseIdentifier)
        view.register(SearchListEmptyCell.self, forCellWithReuseIdentifier: SearchListEmptyCell.reuseIdentifier)
        view.register(SearchListHeader.self,
                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                      withReuseIdentifier: SearchListHeader.reuseIdentifier)
        view.register(SearchListFooter.self,
                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                      withReuseIdentifier: SearchListFooter.reuseIdentifier)

        view.backgroundColor = .clear
        view.allowsMultipleSelection = false
        view.allowsSelection = true
        return view
    }()

    private let searchDataSources = RxCollectionViewSectionedReloadDataSource<SearchBookSectionModel>(configureCell: { dataSource, view, indexPath, sectionItem in
        switch sectionItem {
        case .bookCell(let reactor):
            guard let cell = view.dequeueReusableCell(withReuseIdentifier: SearchListBookCell.reuseIdentifier, for: indexPath) as? SearchListBookCell else {
                return UICollectionViewCell()
            }
            cell.reactor = reactor
            return cell
        case .emptyCell:
            guard let cell = view.dequeueReusableCell(withReuseIdentifier: SearchListEmptyCell.reuseIdentifier, for: indexPath) as? SearchListEmptyCell else {
                return UICollectionViewCell()
            }
            return cell
        }
    }) { dataSource, view, kind, indexPath in
        if kind == UICollectionView.elementKindSectionHeader {
            if let header = view.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                  withReuseIdentifier: SearchListHeader.reuseIdentifier,
                                                                  for: indexPath) as? SearchListHeader {
                return header
            }
        }
        if kind == UICollectionView.elementKindSectionFooter {
            let item = dataSource[indexPath]
            switch item {
            case .emptyCell:
                return UICollectionReusableView()
            case .bookCell(let reactor):
                if let footer = view.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                                                      withReuseIdentifier: SearchListFooter.reuseIdentifier,
                                                                      for: indexPath) as? SearchListFooter {
                    return footer
                }
            }
        }
        return UICollectionReusableView()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 
    
    override func snapKitView() -> [UIView] {
        [searchContainer, ebookListView]
    }
    
    override func snapKitMakeConstraints() {
        searchContainer.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().inset(0)
            make.height.equalTo(48)
        }
        ebookListView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(searchContainer.snp.bottom)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ebookListView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewSafeAreaInsetsDidChange() {
        searchContainer.snp.updateConstraints { make in
            make.top.equalToSuperview().inset(self.view.safeAreaInsets.top)
        }
    }
    
    func bind(reactor: SearchViewReactor) {
        
        let searchTextEmptyObservable = searchField.rx.text.orEmpty
            .asDriver(onErrorJustReturn: "")
            .map { $0.isEmpty }
        
        searchTextEmptyObservable
            .drive(clearButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        clearButton.rx.tap
            .map { "" }
            .bind(to: searchField.rx.text)
            .disposed(by: disposeBag)
        
        searchField.rx.controlEvent(.editingDidEnd)
            .withLatestFrom(searchField.rx.text.orEmpty)
            .map { SearchViewReactor.Action.searchQuery($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        ebookListView.rx.itemSelected
            .map { Reactor.Action.itemSelected($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        ebookListView.rx.modelSelected(TableViewCellSections.self)
            .compactMap { section in
                switch section {
                case let .bookCell(reactor):
                    return reactor.currentState
                case .emptyCell:
                    return nil
                }
            }
            .map { Reactor.Action.modelSelected($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        ebookListView.rx.contentOffset
            .map { $0.y }
            .filter { $0 > 0 }
            .distinctUntilChanged()
            .withUnretained(self)
            .flatMap { owner, offset in
                let contentHeight = owner.ebookListView.contentSize.height
                let scrollViewHeight = owner.ebookListView.frame.height
                let distanceToBottom = contentHeight - (offset + scrollViewHeight)
                if distanceToBottom < 200 {
                    return Observable.just(())
                } else {
                    return Observable.empty()
                }
            }
            .map { Reactor.Action.loadMore }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchField.becomeFirstResponder()
        
        //FIXME: 실시간 검색이 없음.
//        searchField.rx.text.orEmpty
//            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
//            .filter { !$0.isEmpty }
//            .map { SearchViewReactor.Action.searchQuery($0) }
//            .bind(to: reactor.action)
//            .disposed(by: disposeBag)
        
        // MARK: -
        
        reactor.state.compactMap { $0.selectedIndexPath }
            .withUnretained(self)
            .bind { owner, indexPath in
                owner.ebookListView.deselectItem(at: indexPath, animated: true)
            }.disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.selectedModel }
            .withUnretained(self)
            .bind { owner, book in
                let vc = DetailViewController()
                vc.reactor = DetailViewReactor(book: book)
                owner.navigationController?.pushViewController(vc, animated: true)
            }.disposed(by: disposeBag)
        
        reactor.state.map { $0.sections }
            .asDriver(onErrorJustReturn: [])
            .drive(ebookListView.rx.items(dataSource: searchDataSources))
            .disposed(by: disposeBag)
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 48)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 48)
    }
}
