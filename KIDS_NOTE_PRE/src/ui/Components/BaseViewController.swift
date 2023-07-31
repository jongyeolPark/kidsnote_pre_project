//
//  BaseViewController.swift
//  KIDS_NOTE_PRE
//
//  Created by 박종열 on 2023/07/28.
//

import UIKit
import SnapKit
import RxSwift

open class BaseViewController: UIViewController {
    
    var disposeBag = DisposeBag()

    //MARK: -
    
    private var loadingView: LoadingView?
    
    //MARK: -
    
    open func snapKitView() -> [UIView] {
        [UIView]()
    }

    open func snapKitMakeConstraints() {}

    //MARK: -
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        for view in snapKitView() {
            self.view.addSubview(view)
        }
        snapKitMakeConstraints()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension BaseViewController {

    func showLoadingDialog(_ show: Bool = true) {
        if show {
            if loadingView != nil {
                return
            }
        
            let loadingView = LoadingView()
            UIApplication.shared.current?.addSubview(loadingView)
            loadingView.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            self.loadingView = loadingView
            self.loadingView?.show()
        
        } else {
            self.loadingView?.hide()
            self.loadingView?.removeFromSuperview()
            self.loadingView = nil
        }
    }
}
