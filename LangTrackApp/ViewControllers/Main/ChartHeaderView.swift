//
//  ChartHeaderView.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-06-15.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import UIKit
import Charts

@IBDesignable
class ChartHeaderView: UIView {

    @IBOutlet weak var chartView: PieChartView!
    @IBOutlet var contentView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit(){
        Bundle.main.loadNibNamed("ChartHeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        setUserCharts()
    }

    func setUserCharts(){
        let totalNumberOfSurveys = SurveyRepository.assignmentList.count
        let numberOfAnswered = SurveyRepository.assignmentList.filter({$0.dataset != nil}).count
        if numberOfAnswered != 0{
            let percent = 100 * (Double(numberOfAnswered)/Double(totalNumberOfSurveys))
            let percentRounded = Double(round(10*percent)/10)
            
            let centerText = NSMutableAttributedString(string: "\(percentRounded)%")
            let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            paragraphStyle.lineBreakMode = .byTruncatingTail
            paragraphStyle.alignment = .center
            centerText.setAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 18)!,
                                      .paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: centerText.length))
            chartView.centerAttributedText = centerText
        }
        setChart(answered: Double(numberOfAnswered), unanswered: Double(totalNumberOfSurveys - numberOfAnswered), total: totalNumberOfSurveys)
        
        chartView.drawHoleEnabled = true
        chartView.rotationAngle = -90
        chartView.rotationEnabled = false
        chartView.chartDescription?.enabled = false
        chartView.isUserInteractionEnabled = false
    }
    
    func setChart(answered: Double, unanswered: Double, total: Int) {
        
        var dataEntries: [ChartDataEntry] = []
        
        let dataEntry1 = ChartDataEntry(x: answered, y: answered)
        let dataEntry2 = ChartDataEntry(x: unanswered, y: unanswered)
        dataEntries.append(dataEntry1)
        dataEntries.append(dataEntry2)
        
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "\(Int(answered)) av \(total) besvarade")
        pieChartDataSet.drawValuesEnabled = false
        pieChartDataSet.valueTextColor = UIColor.init(named: "lta_lightGrey") ?? UIColor.lightGray
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        chartView.data = pieChartData
        
        let colors: [UIColor] = [UIColor.green, UIColor.lightGray]
        
        pieChartDataSet.colors = colors
        
    }
}
