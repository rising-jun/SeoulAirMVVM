//
//  MainViewController.swift
//  TodayAirMVVM
//
//  Created by 김동준 on 2020/10/19.
//

import Foundation
import UIKit
import SnapKit
import ReactorKit
import RxViewController

class MainViewController: UIViewController, View{
    
    var disposeBag = DisposeBag()
    var airInfo = AirInfo()
    var address: String = ""
    
    lazy var dateStempLabel = UILabel()
    lazy var timeStempLabel = UILabel()
    lazy var locationLabel = UILabel()
    lazy var stateStempLabel = UILabel()
    lazy var commentStempLabel = UILabel()
    lazy var emoticonView = UIImageView()
    var emoticon: UIImage?
    lazy var scrollView = UIScrollView()
    
    func bind(reactor: MainReactor) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentedViewController?.dismiss(animated: true, completion: nil)
        var stateValue: StateValue? = StateValue(grade: airInfo.pm25Grade)
        
        view.backgroundColor = stateValue?.backGroundColor
        
        view.addSubview(dateStempLabel)
        view.addSubview(timeStempLabel)
        view.addSubview(locationLabel)
        view.addSubview(emoticonView)
        view.addSubview(stateStempLabel)
        view.addSubview(commentStempLabel)
        view.addSubview(scrollView)
        
        let timeArray: [String] = ConvertData().convertDate(date: airInfo.dataTime)
        dateStempLabel.text = timeArray[0] + "년 " + timeArray[1] + "월 " + timeArray[2] + "일"
        timeStempLabel.text = ConvertData().convertTime(time: timeArray[3])
        locationLabel.text = airInfo.stationName
        stateStempLabel.text = stateValue?.stateText
        commentStempLabel.text = stateValue?.commentText
        emoticon = stateValue?.emoticon
        emoticonView.image = emoticon
        
        stateValue = nil
        
        dateStempLabel.font = UIFont.boldSystemFont(ofSize: 18)
        timeStempLabel.font = UIFont.boldSystemFont(ofSize: 22)
        locationLabel.font = UIFont.boldSystemFont(ofSize: 42)
        stateStempLabel.font = UIFont.boldSystemFont(ofSize: 61)
        commentStempLabel.font = UIFont.boldSystemFont(ofSize: 22)
        
        dateStempLabel.defaultSetting()
        timeStempLabel.defaultSetting()
        locationLabel.defaultSetting()
        stateStempLabel.defaultSetting()
        commentStempLabel.defaultSetting()
        
        dateStempLabel.snp.makeConstraints { (make) in
            make.width.equalTo(144 * view.frame.width / 375)
            make.height.equalTo(20 * view.frame.height / 812)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.frame.width).offset(66 * view.frame.height / 812)
            
        }
        
        timeStempLabel.snp.makeConstraints { (make) in
            make.width.equalTo(144 * view.frame.width / 375)
            make.height.equalTo(25 * view.frame.height / 812)
            make.top.equalTo(dateStempLabel.snp.bottom).offset(53 * view.frame.height / 812)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(115 * view.frame.width / 375)
        }
        
        locationLabel.snp.makeConstraints { (make) in
            make.width.equalTo(114 * view.frame.width / 375)
            make.height.equalTo(47 * view.frame.height / 812)
            make.top.equalTo(timeStempLabel.snp.bottom).offset(10 * view.frame.height / 812)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(130 * view.frame.width / 375)
        }
        
        emoticonView.snp.makeConstraints { (make) in
            make.width.equalTo(114 * view.frame.width / 375)
            make.height.equalTo(108 * view.frame.height / 812)
            make.top.equalTo(locationLabel.snp.bottom).offset(33 * view.frame.height / 812)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(130 * view.frame.width / 375)
        }
        
        stateStempLabel.snp.makeConstraints { (make) in
            make.width.equalTo(110 * view.frame.width / 375)
            make.height.equalTo(68 * view.frame.height / 812)
            make.top.equalTo(emoticonView.snp.bottom).offset(33 * view.frame.height / 812)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(132 * view.frame.width / 375)
        }
        
        commentStempLabel.snp.makeConstraints { (make) in
            make.width.equalTo(200 * view.frame.width / 375)
            make.height.equalTo(25 * view.frame.height / 812)
            make.top.equalTo(stateStempLabel.snp.bottom).offset(22 * view.frame.height / 812)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(87 * view.frame.width / 375)
        }
        
        scrollView.snp.makeConstraints { (make) in
            make.width.equalTo(355 * view.frame.width / 375)
            make.height.equalTo(189 * view.frame.height / 812)
            make.top.equalTo(commentStempLabel.snp.bottom).offset(66 * view.frame.height / 812)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10 * view.frame.width / 375)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10 * view.frame.width / 375)
        }
        settingScrollViewData()
    }
    
    private func settingScrollViewData(){
        scrollView.contentSize.width = (130 * view.frame.width / 375) * 6
        scrollView.contentSize.height = (180 * view.frame.height / 812)
        scrollView.isScrollEnabled = true
        //scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = false
        //scrollView.showsVerticalScrollIndicator = false
        
        var factorViewArray: [UIView] = []
        factorViewArray.append(returnFactorView(name: "미세먼지", grade: airInfo.pm25Grade, value: airInfo.pm25Value))
        factorViewArray.append(returnFactorView(name: "초미세먼지", grade: airInfo.pm10Grade, value: airInfo.pm10Value))
        factorViewArray.append(returnFactorView(name: "오존", grade: airInfo.o3Grade, value: airInfo.o3Value))
        factorViewArray.append(returnFactorView(name: "아황산가스", grade: airInfo.so2Grade, value: airInfo.so2Value))
        factorViewArray.append(returnFactorView(name: "일산화탄소", grade: airInfo.coGrade, value: airInfo.coValue))
        factorViewArray.append(returnFactorView(name: "이산화질소", grade: airInfo.no2Grade, value: airInfo.no2Value))
        
        for i in 0...factorViewArray.count-1{
            scrollView.addSubview(factorViewArray[i])
            factorViewArray[i].snp.makeConstraints { (make) in
                make.width.equalTo(120 * view.frame.width / 375)
                make.height.equalTo(180 * view.frame.height / 812)
                if i == 0 {
                    make.leading.equalTo(scrollView).offset(10 * view.frame.width / 375)
                }else{
                    make.leading.equalTo(factorViewArray[i-1].snp.trailing).offset(10 * view.frame.width / 375)
                }
            }
            
        }
        
        
    }
    
    private func returnFactorView(name: String, grade: String, value: String) -> UIView{
        let factorView = UIView()
        let factorNameLabel = UILabel()
        let factorEmoticon = UIImageView()
        let factorStateLabel = UILabel()
        let factorValueLabel = UILabel()
        factorView.backgroundColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 0.3)
        
        factorView.addSubview(factorNameLabel)
        factorView.addSubview(factorEmoticon)
        factorView.addSubview(factorStateLabel)
        factorView.addSubview(factorValueLabel)
        
        var stateValue: StateValue? = StateValue(grade: grade)
        
        factorNameLabel.text = name
        factorEmoticon.image = stateValue?.emoticon
        factorStateLabel.text = stateValue?.stateText
        factorValueLabel.text = value + "㎍/m³"
        
        factorNameLabel.defaultSetting()
        factorStateLabel.defaultSetting()
        factorValueLabel.defaultSetting()
        
        factorNameLabel.font.withSize(16)
        factorStateLabel.font.withSize(18)
        factorValueLabel.font.withSize(14)
        
        
        stateValue = nil
        factorNameLabel.snp.makeConstraints { (make) in
            make.width.equalTo(76 * view.frame.width / 375)
            make.height.equalTo(18 * view.frame.height / 812)
            make.top.equalTo(factorView).offset(22 * view.frame.height / 812)
            make.leading.equalTo(factorView).offset(22 * view.frame.width / 375)
        }
        
        factorEmoticon.snp.makeConstraints { (make) in
            make.width.equalTo(58 * view.frame.width / 375)
            make.height.equalTo(55 * view.frame.height / 812)
            make.top.equalTo(factorNameLabel.snp.bottom).offset(15 * view.frame.height / 812)
            make.leading.equalTo(factorView).offset(31 * view.frame.width / 375)
        }
        
        factorStateLabel.snp.makeConstraints { (make) in
            make.width.equalTo(32 * view.frame.width / 375)
            make.height.equalTo(20 * view.frame.height / 812)
            make.top.equalTo(factorEmoticon.snp.bottom).offset(17 * view.frame.height / 812)
            make.leading.equalTo(factorView).offset(44 * view.frame.width / 375)
        }
        
        factorValueLabel.snp.makeConstraints { (make) in
            make.width.equalTo(50 * view.frame.width / 375)
            make.height.equalTo(16 * view.frame.height / 812)
            make.top.equalTo(factorStateLabel.snp.bottom).offset(4 * view.frame.height / 812)
            make.leading.equalTo(factorView).offset(35 * view.frame.width / 375)
        }
        return factorView
    }
    
}

extension UILabel{
    
    func defaultSetting(){
        textAlignment = .center
        textColor = .white
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.1
        numberOfLines = 1
    }
    
    
}
