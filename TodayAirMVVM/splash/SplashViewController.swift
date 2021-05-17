//
//  ViewController.swift
//  TodayAirMVVM
//
//  Created by 김동준 on 2020/10/19.
//

import UIKit
import RxCocoa
import ReactorKit
import RxViewController
import SnapKit
import CoreData
class SplashViewController: UIViewController, View {
    
    lazy var disposeBag = DisposeBag()
    lazy var mainView = MainViewController()
    lazy var behaivor = PublishSubject<CommonResource.LocationBehaivor>()
    lazy var location = PublishSubject<CLLocation>()
    lazy var locationManager = CLLocationManager()
    weak var delegate: CLLocationManagerDelegate?
    lazy var mainReactor = MainReactor()
    
    lazy var mainIcon = UIImageView(image: UIImage(named: "main_icon"))
    lazy var appNameLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(displayP3Red: 0/255, green: 102/255, blue: 255/255, alpha: 1)
        delegate = self
        locationManager.delegate = delegate
        
        
        view.addSubview(mainIcon)
        view.addSubview(appNameLabel)
        
        mainIcon.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-420 * view.frame.height / 812)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(150 * view.frame.width / 375)
            make.width.equalTo(76.9 * view.frame.width / 375)
            make.height.equalTo(42.8 * view.frame.height / 812)
        }
        
        appNameLabel.text = "지금, 공기 어때?"
        appNameLabel.font = appNameLabel.font.withSize(28)
        appNameLabel.textColor = .white
        appNameLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-349 * view.frame.height / 812)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(104 * view.frame.width / 375)
            make.width.equalTo(184 * view.frame.width / 375)
            make.height.equalTo(31 * view.frame.height / 812)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainView.modalPresentationStyle = .fullScreen
        mainView.reactor = self.mainReactor
        sleep(2)
       
        
        
        behaivor.bind { [unowned self] (behaivor) in
            self.locPermissionBehaivor(behaiveor: behaivor)
        }.disposed(by: disposeBag)
        
        location.on(.next((locationManager.location) ?? CLLocation()))
        
    }
   
    func bind(reactor: SplashReactor) {
    
        self.rx.viewDidLoad.asSignal().map{_ in
            return Reactor.Action.checkLocPermission(status: CLLocationManager.authorizationStatus())
        }.emit(to: reactor.action).disposed(by: disposeBag)
        

        location.map{return Reactor.Action.requestMyLocation(findlocation: CLLocation(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude))}.bind(to: reactor.action).disposed(by: disposeBag)
        
        reactor.state.map{$0.airInfo}.filter{$0.stationName != ""}.bind { [unowned self] (airInfo) in
            self.mainView.airInfo = airInfo
            present(mainView, animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        reactor.state.map{$0.behaivor}.filter{$0 == .alreadyHave}.take(2).subscribe { [unowned self] (behaivor) in
            self.behaivor.on(.next(behaivor))
        }.disposed(by: disposeBag)
        
        reactor.state.map{$0.address}.distinctUntilChanged().filter{$0 != ""}
            .map{Reactor.Action.requestGetData(add: $0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
    }
    

    private func locPermissionBehaivor(behaiveor: CommonResource.LocationBehaivor){
        switch behaiveor {
        case .alreadyHave:
            locationManager.startUpdatingLocation()
            break
        case .getPermissionScreen:
            print("request")
            locationManager.requestWhenInUseAuthorization()
            break
        case .moveSetting:
            moveSetting()
            break
        case .errorPrint:
            print("permission error")
            break
        }
    }
    
    private func moveSetting(){
        let alter = UIAlertController(title: "위치권한 설정이 '안함'으로 되어있습니다.", message: "앱 설정 화면으로 가시겠습니까? \n '아니오'를 선택하시면 앱이 종료됩니다.", preferredStyle: UIAlertController.Style.alert)
        let logOkAction = UIAlertAction(title: "네", style: UIAlertAction.Style.default){
            (action: UIAlertAction) in
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(NSURL(string:UIApplication.openSettingsURLString)! as URL)
            } else {
                UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
            }
        }
        let logNoAction = UIAlertAction(title: "아니오", style: UIAlertAction.Style.destructive){
            (action: UIAlertAction) in
            exit(0)
        }
        
        alter.addAction(logNoAction)
        alter.addAction(logOkAction)
        self.present(alter, animated: true, completion: nil)
    }
    
    deinit {
        reactor = nil
    }
}

extension SplashViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
       
        if status == .authorizedWhenInUse{
            //okay
            print("i got a permission")
            locationManager.startUpdatingLocation()
        }else if status == .denied || status == .restricted{
            //deniend
            print("denied permission")
            moveSetting()
        }else if status == .notDetermined{
            locationManager.requestWhenInUseAuthorization()
        }
        
    }
}
