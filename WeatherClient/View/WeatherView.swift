//
//  WeatherView.swift
//  WeatherClient
//
//  Created by Piyush on 8/26/16.
//  Copyright © 2016 Piyush. All rights reserved.
//

import UIKit

protocol WeatherInfoDelegate: class {
    func getWeatherInfo(coordinate: Coordinate)
    func showInputError(message: String)
}

protocol InputValidator {}

extension InputValidator {
    
    func isValidInput(input: String) -> Bool {
        
        if input.isEmpty {
            return false
        }
        return true
    }
    
    func isNumeric(input: String) -> Bool {
        
        // Find out whether the new string is numeric
        let scanner: NSScanner = NSScanner(string: input)
        let isNumeric = scanner.scanDecimal(nil) && scanner.atEnd
        
        return isNumeric
    }
}

class WeatherView: UIView {
    
    private var customView: UIView!
    weak var delegate: WeatherInfoDelegate!
    var weather: Weather?
    
    //Top view
    @IBOutlet private weak var latitudeTextField: UITextField!
    @IBOutlet private weak var longitudeTextField: UITextField!
    
    //Bottom view
    @IBOutlet private var timeLabel: UILabel!
    @IBOutlet private var precipLabel: UILabel!
    @IBOutlet weak var amLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet private var weatherSummaryLabel: UILabel!
    
    @IBOutlet weak var tempBottom: NSLayoutConstraint!
    //Autolayout constraints
    @IBOutlet weak var summaryTop: NSLayoutConstraint!
    @IBOutlet weak var summaryLeading: NSLayoutConstraint!
    @IBOutlet weak var imageTop: NSLayoutConstraint!
    @IBOutlet weak var imageLeading: NSLayoutConstraint!
    @IBOutlet weak var seperatorViewBottom: NSLayoutConstraint!
    @IBOutlet weak var precipTop: NSLayoutConstraint!
    @IBOutlet weak var tempLabelTop: NSLayoutConstraint!
    @IBOutlet weak var timeLabelBottom: NSLayoutConstraint!
    @IBOutlet weak var timeLabelTop: NSLayoutConstraint!
    @IBOutlet weak var refreshBottom: NSLayoutConstraint!
    @IBOutlet weak var refreshWidth: NSLayoutConstraint!
    @IBOutlet weak var refreshHeight: NSLayoutConstraint!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
}

extension WeatherView: InputValidator {
    
    func showWeather() {
        let weatherTimeArray = self.weather!.time?.componentsSeparatedByString(" ")
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.timeLabel.text = weatherTimeArray![0]
            self.amLabel.text =  weatherTimeArray![1]
            self.temperatureLabel.text = self.weather!.temperatureString
            self.precipLabel.text = self.weather!.precipProbabilityString
            self.weatherSummaryLabel.text = self.weather!.weatherSummary!
        }
    }
    
    @IBAction func fetchWeatherInfo(sender: UIButton) {
        
        //Handle user input and get weather info
        let latLongValidator = (isValidInput(latitudeTextField.text!), isValidInput(longitudeTextField.text!))
        
        switch latLongValidator {
        case (false, true):
            delegate.showInputError(WeatherConstants.EmptyLatitudeDialogMessage)
        case (true, false):
            delegate.showInputError(WeatherConstants.EmptyLongitudeDialogMessage)
        case (false, false):
            delegate.showInputError(WeatherConstants.EmptyLatLongDialogMessage)
        default:
            let coordinate: Coordinate = (Double(latitudeTextField.text!)!,Double( longitudeTextField.text!)!)
            delegate?.getWeatherInfo(coordinate)
        }
    }
    
    //Customize latitude, longitude text fields
    override func layoutSubviews() {
      super.layoutSubviews()
        
        let textFieldColor = UIColor(red: 64/255.0, green: 157/255.0, blue: 220/255.0, alpha: 1.0)

        //Latitude
        let latitudeImageView = UIImageView()
        latitudeImageView.image = UIImage(named: "latitude.png")
        
        let latitudeView = UIView()
        latitudeView.addSubview(latitudeImageView)
        
        latitudeView.frame = CGRectMake(10, 0, 25, 20)
        latitudeImageView.frame = CGRectMake(5, 0, 20, 20)
        latitudeTextField.leftViewMode = .Always
        latitudeTextField.leftView = latitudeView
        latitudeTextField.attributedPlaceholder = NSAttributedString(string:"Latitude",
                                                  attributes:[NSForegroundColorAttributeName: textFieldColor])
        
        //Longitude
        let longitudeImageView = UIImageView()
        longitudeImageView.image = UIImage(named: "longitude.png")
        
        let longitudeView = UIView()
        longitudeView.addSubview(longitudeImageView)
        
        longitudeView.frame = CGRectMake(10, 0, 25, 20)
        longitudeImageView.frame = CGRectMake(5, 0, 20, 20)
        longitudeTextField.leftViewMode = .Always
        longitudeTextField.leftView = longitudeView
        longitudeTextField.attributedPlaceholder = NSAttributedString(string:"Longitude",
                                                   attributes:[NSForegroundColorAttributeName: textFieldColor])
    }
    
    func handleDifferentScreenSizeSpacing() {
        
        if DeviceType.IS_IPHONE_6 {
            adjustFont(timeLabel, fontName: "Arial", fontSize: 45)
            adjustFont(temperatureLabel, fontName: "Arial", fontSize: temperatureLabel.font.pointSize+20)
            adjustUIConstraints([seperatorViewBottom], offset: 20)
            adjustUIConstraints([imageLeading], offset: 13)
            adjustUIConstraints([imageTop], offset: -5)
            adjustUIConstraints([refreshBottom], offset: 15)
            adjustUIConstraints([tempBottom], offset: -9)
        }
        else if DeviceType.IS_IPHONE_6P {
            adjustFont(timeLabel, fontName: "Arial", fontSize: 55)
            adjustFont(temperatureLabel, fontName: "Arial", fontSize: temperatureLabel.font.pointSize+55)
            
            let constraintsArray: [NSLayoutConstraint] = [timeLabelTop,timeLabelBottom,precipTop]
            adjustUIConstraints(constraintsArray, offset: 5)
            adjustUIConstraints([imageLeading], offset: 22.5)
            adjustUIConstraints([summaryLeading], offset: 12)
            adjustUIConstraints([imageTop], offset: 23)
            adjustUIConstraints([refreshBottom,seperatorViewBottom], offset: 15)
            adjustUIConstraints([tempBottom], offset: -14)

        }
        else {
            adjustFont(timeLabel, fontName: "Arial", fontSize: 35)
            adjustFont(temperatureLabel, fontName: "Arial", fontSize: temperatureLabel.font.pointSize+18)
            
            adjustUIConstraints([tempLabelTop], offset: -4)
            adjustUIConstraints([tempBottom], offset: -14)
            adjustUIConstraints([imageTop], offset: -7)
            adjustUIConstraints([summaryTop], offset: -2)
            adjustUIConstraints([refreshHeight,refreshWidth], offset: -32)
            adjustUIConstraints([seperatorViewBottom], offset: -10)
            adjustUIConstraints([precipTop], offset: -2)

        }
    }

    private func adjustUIConstraints(constraints: [NSLayoutConstraint], offset: CGFloat) {
        for constraint: NSLayoutConstraint in constraints {
            constraint.constant = constraint.constant+offset
        }
    }
    
    private func adjustFont(label: UILabel,fontName: String, fontSize: CGFloat) {
        label.font = UIFont(name: fontName, size: fontSize)
        label.adjustsFontSizeToFitWidth = true
    }
}

extension WeatherView: UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let newString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        if newString.characters.count > 0 {
                return isNumeric(newString)
        }
        else {
            return true
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

private extension WeatherView {
   
    //Setup custom view
    func setup() {
        customView = loadViewFromNib()
        customView.frame = bounds
        
        //Stretch custom view in container view
        customView.autoresizingMask = [.FlexibleWidth,.FlexibleHeight]
        self.addSubview(customView)
    }
    
    func loadViewFromNib() -> UIView {
        
        //Get the bundle to load
        let bundle = NSBundle(forClass: self.dynamicType)
        //Get the view from nib file using above bundle
        let nib = UINib(nibName: WeatherConstants.NibNames.WeatherView.nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
}