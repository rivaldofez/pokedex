//
//  BaseStatSubViewController.swift
//  pokedex
//
//  Created by rivaldo on 02/04/24.
//

import UIKit
import DGCharts
import Common
import GeneralPokemon

class BaseStatSubViewController: UIViewController {
    
    var pokemon: PokemonDomainModel? {
        didSet {
            DispatchQueue.main.async {
                self.progressTableView.reloadData()
                self.setDataRadarChartView()
            }
        }
    }
    
    private let progressTableView: UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.register(BaseStatTableViewCell.self, forCellReuseIdentifier: BaseStatTableViewCell.identifier)
        tableview.isHidden = true
        return tableview
    }()
    
    let marker: RadarMarkerView = {
        let marker = RadarMarkerView()
        marker.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        return marker
    }()
    
    private lazy var radarChartView: RadarChartView = {
        let chartView = RadarChartView()
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.webLineWidth = 1
        chartView.webColor = .lightGray
        chartView.innerWebColor = .darkGray
        
        return chartView
    }()
    
    private lazy var chartSwitch: UISwitch = {
        let uiswitch = UISwitch()
        uiswitch.translatesAutoresizingMaskIntoConstraints = false
        uiswitch.setOn(true, animated: true)
        uiswitch.isEnabled = true
        uiswitch.translatesAutoresizingMaskIntoConstraints = false
        uiswitch.isUserInteractionEnabled = true
        uiswitch.onTintColor = UIColor(named: ViewDataConverter.typeStringToColorName(type: (pokemon?.type.first!)!))
        
        return uiswitch
    }()
    
    private let chartSwitchLabel: UILabel = {
        let label = UILabel()
        label.text = "title.radar.view".localized()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func setDataRadarChartView() {
        guard let pokemon = self.pokemon else { return }
        var entries = [RadarChartDataEntry]()
        
        pokemon.baseStat.forEach { stat in
            entries.append(RadarChartDataEntry(value: Double(stat.value)))
        }
        
        let dataset = RadarChartDataSet(entries: entries)
        let colorType = NSUIColor(cgColor: UIColor(named: ViewDataConverter.typeStringToColorName(type: pokemon.type.first!))!.cgColor)
        
        dataset.colors = [colorType]
        dataset.fillColor = colorType
        dataset.drawFilledEnabled = true
        
        radarChartView.data = RadarChartData(dataSets: [dataset])
        
        dataset.valueFormatter = DataSetValueFormatter()
        
        let xAxis = radarChartView.xAxis
        xAxis.labelFont = .systemFont(ofSize: 16, weight: .bold)
        xAxis.labelTextColor = .label
        xAxis.valueFormatter = self
        xAxis.labelCount = 5
        
        let yAxis = radarChartView.yAxis
        yAxis.labelCount = 0
        yAxis.drawLabelsEnabled = false
        yAxis.drawTopYLabelEntryEnabled = false
        yAxis.axisMinimum = 0
        yAxis.axisMaximum = 255
        yAxis.valueFormatter = self
        
        radarChartView.rotationEnabled = true
        radarChartView.legend.enabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(chartSwitch)
        view.addSubview(chartSwitchLabel)
        view.addSubview(radarChartView)
        view.addSubview(progressTableView)
        configureConstraints()
        
        progressTableView.dataSource = self
        progressTableView.delegate = self
        chartSwitch.addTarget(self, action: #selector(updateSwitch), for: .valueChanged)
        radarChartView.animate(xAxisDuration: 1.4, yAxisDuration: 1.4, easingOption: .easeOutBack)
        
        marker.chartView = radarChartView
        radarChartView.marker = marker
    }
    
    @objc func updateSwitch(sender: UISwitch) {
        progressTableView.isHidden = sender.isOn
        radarChartView.isHidden = !sender.isOn
    }
    
    private func configureConstraints() {
        
        let chartSwitchConstraints = [
            chartSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            chartSwitch.topAnchor.constraint(equalTo: view.topAnchor, constant: 15)
        ]
        
        let chartSwitchLabelConstraints = [
            chartSwitchLabel.trailingAnchor.constraint(equalTo: chartSwitch.leadingAnchor, constant: -10),
            chartSwitchLabel.centerYAnchor.constraint(equalTo: chartSwitch.centerYAnchor)
        ]
        
        let progressTableViewConstraints = [
            progressTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressTableView.topAnchor.constraint(equalTo: chartSwitch.bottomAnchor, constant: 15),
            progressTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        let radarChartViewConstraints = [
            radarChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            radarChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            radarChartView.topAnchor.constraint(equalTo: chartSwitch.bottomAnchor, constant: 15),
            radarChartView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(chartSwitchConstraints)
        NSLayoutConstraint.activate(progressTableViewConstraints)
        NSLayoutConstraint.activate(radarChartViewConstraints)
        NSLayoutConstraint.activate(chartSwitchLabelConstraints)
    }
}

extension BaseStatSubViewController: AxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard let pokemon = pokemon else { return "" }
        
        let titles = pokemon.baseStat.map { stat in
            return ViewDataConverter.typeStringToStatName(type: stat.name)
        }
        
        return "\(titles[Int(value) % titles.count])"
    }
}

extension BaseStatSubViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemon?.baseStat.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BaseStatTableViewCell.identifier, for: indexPath) as? BaseStatTableViewCell else { return UITableViewCell() }
        
        if let baseStat = pokemon?.baseStat[indexPath.row] {
            cell.configure(with: baseStat, type: pokemon!.type.first!)
        }
        return cell
    }
}

class DataSetValueFormatter: ValueFormatter {
    
    func stringForValue(_ value: Double,
                        entry: ChartDataEntry,
                        dataSetIndex: Int,
                        viewPortHandler: ViewPortHandler?) -> String {""}
}

class XAxisFormatter: AxisValueFormatter {
    
    let titles = ["HP", "Attack", "Defense", "Speed", "Sp.Def", "Sp.Atk"]
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return titles[Int(value) % titles.count]
    }
}

class YAxisFormatter: AxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return "\(Int(value)) $"
    }
}

class RadarMarkerView: MarkerView {
    
    private var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "aa"
        label.textColor = .label
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        label.text = String(Int(round(entry.y)))
        layoutIfNeeded()
    }
    
}
