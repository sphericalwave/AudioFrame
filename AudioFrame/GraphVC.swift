//
//  GraphVC.swift
//  AudioWave
//
//  Created by Aaron Anthony on 2017-06-26.
//  Copyright © 2017 SphericalWave. All rights reserved.
//

import UIKit
import Charts
import CoreData

class GraphVC: UIViewController {
    
    var months: [String]!
    var idea: Idea!
    var dataDictionary = [Date:Double]()
    
    @IBOutlet weak var graphView: BarChartView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBAction func segmentControlChanged(_ sender: Any) {
        print("Segmented Control")
    }
    let context = CoreDataStack.sharedInstance.context
    
    static let dateForTitle: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        //        formatter.dateStyle = .medium
        //        formatter.timeStyle = .none
        formatter.dateFormat = "EEEE, MMM d"
        
        return formatter
    }()
    
    
    func testIdea() {
       // let context = CoreDataStack.sharedInstance.context
        
        self.idea = Idea(context: context)
        self.idea.title = "New Recording"
        
        let rep1 = Rep(context: context)
        rep1.date = Date()
        idea.addToReps(rep1)
        //rep1.idea = idea
        
        let date2 = Date().addingTimeInterval(3600)
        
        let rep2 = Rep(context: context)
        rep2.date = date2
        //idea.reps?.adding(rep2)
        idea.addToReps(rep2)
        
        
        let rep3 = Rep(context: context)
        let date3 = date2.addingTimeInterval(3600*36)
        rep3.date = date3
       // idea.reps?.adding(rep3)
        idea.addToReps(rep3)
        
        let rep4 = Rep(context: context)
        let date4 = date2.addingTimeInterval(3600*36*2)
        rep4.date = date4
        // idea.reps?.adding(rep3)
        idea.addToReps(rep4)
        
        
        //print(idea.reps?.count)
        
        CoreDataStack.sharedInstance.saveContext()
    }
    
    func setupDataSource() {
        guard let idea = self.idea else {
            return
        }
        self.dataDictionary = sortDates(idea: idea)
        var dataPoints = [String]()
        let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        //formatter.dateFormat = "EEEE, MMM d @ HH:mm:ss"
        formatter.dateFormat = "MMM, d"
        
        var values = [Double]()
        for value in dataDictionary {
            let stringDate = formatter.string(from: value.key)
            dataPoints.append(stringDate)
            values.append(value.value)
        }
        
        //Cumulative Numbers
        for i in 1 ..< values.count {
            values[i] = values[i - 1] + values[i]
        }
        print(dataPoints)
        print(values)
        
        
        graphView.noDataText = "You need to provide data for the chart."
        //months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        //let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        
        //setChart(dataPoints: months, values: unitsSold)
        setChart(dataPoints: dataPoints, values: values)
    }
    
    func testChart() {
        graphView.noDataText = "You need to provide data for the chart."
        months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        
        setChart(dataPoints: months, values: unitsSold)
    }
    
    func incrementPlays(date: Date) {
//        guard let dataSource = self.dataDictionary else {
//            return
//        }
        
//        guard let reps = idea.reps as? Set<Rep> else {
//            //return []
//            fatalError("Reps failed")
//        }
//        print(reps.count)
        
        // Get the current calendar with local time zone
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        //var counts: [Date:Double] = [:]
        
        let dateFrom = calendar.startOfDay(for: date) // eg. 2016-10-10 00:00:00
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute],from: dateFrom)
        components.day! += 1
        let dateTo = calendar.date(from: components)! // eg. 2016-10-11 00:00:00
        
        if (date > dateFrom ) && ( date < dateTo ) {
            dataDictionary[dateFrom] = (dataDictionary[dateFrom] ?? 0) + 1
            setupDataSource()
        }
        
//        for rep in reps {
//            // Get today's beginning & end
//            guard let date = rep.date else {
//                fatalError("No Date on Rep")
//            }
//
//        }
//        print(counts)
//        return counts
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //testIdea()
        //setupDataSource()
        testChart()
        //graphView.col
        
    }
    
//    func cumulativeData(dictionary: [Date:Double]) -> [Date:Double] {
//
//    }
    
    func sortDates(idea: Idea) -> [Date : Double] {
        guard let reps = idea.reps as? Set<Rep> else {
            //return []
            fatalError("Reps failed")
        }
        print(reps.count)
        
        // Get the current calendar with local time zone
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        var counts: [Date:Double] = [:]
        for rep in reps {
            // Get today's beginning & end
            guard let date = rep.date else {
                fatalError("No Date on Rep")
            }
            let dateFrom = calendar.startOfDay(for: date) // eg. 2016-10-10 00:00:00
            var components = calendar.dateComponents([.year, .month, .day, .hour, .minute],from: dateFrom)
            components.day! += 1
            let dateTo = calendar.date(from: components)! // eg. 2016-10-11 00:00:00
            
            if (date > dateFrom ) && ( date < dateTo ) {
                counts[dateFrom] = (counts[dateFrom] ?? 0) + 1
            }
        }
        print(counts)
        return counts
    }
    
    func filter(array: [Rep], date: Date) {
        // Get the current calendar with local time zone
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        // Get today's beginning & end
        let dateFrom = calendar.startOfDay(for: date) // eg. 2016-10-10 00:00:00
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute],from: dateFrom)
        components.day! += 1
        let dateTo = calendar.date(from: components)! // eg. 2016-10-11 00:00:00
        // Note: Times are printed in UTC. Depending on where you live it won't print 00:00:00 but it will work with UTC times which can be converted to local time
        
        // Set predicate as date being today's date
        //let datePredicate = NSPredicate(format: "(%@ <= date) AND (date < %@)", argumentArray: [dateFrom, dateTo])
        //fetchRequest.predicate = datePredicate
        
        let new = array.filter({ ( $0.date! > dateFrom ) && ( $0.date! < dateTo ) })
        
        let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        //        formatter.dateStyle = .medium
        //        formatter.timeStyle = .none
        formatter.dateFormat = "EEEE, MMM d @ HH:mm:ss"
        
        for item in new {
            //print()
            print(formatter.string(from: item.date!))
            print(item.idea?.title)
            
        }
    }
    
    func generateDataSource() {
        //Get All the Reps for the Idea
        //Determine All Unique Days
        //Generate a Count for for Each Unique Day by Filter the Array over and over.
    }
    
    
    func setChart(dataPoints: [String], values: [Double]) {
        graphView.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Units Sold")
        chartDataSet.colors = [.blue]
        
        //let chartData = BarChartData( //(dataSets: chartDataSet) //BarChartData(xVals: months, dataSet: chartDataSet)
        graphView.data = BarChartData(dataSet: chartDataSet)
        graphView.chartDescription?.text = "Repetitions"
        //graphView.legend.description = "Repetitions"
        
//        var dataEntries: [BarChartDataEntry] = []
//
//        for i in 0..<dataPoints.count {
//            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
//            dataEntries.append(dataEntry)
//        }
//
//        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Units Sold")
//        let chartData = BarChartData(xVals: months, dataSet: chartDataSet)
//        barChartView.data = chartData
//
    }
}
