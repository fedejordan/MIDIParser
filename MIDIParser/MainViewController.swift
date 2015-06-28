//
//  MainViewController.swift
//  MIDIParser
//
//  Created by Federico Jordán on 27/6/15.
//  Copyright (c) 2015 Federico Jordán. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
    
    @IBOutlet weak var sqlScrollView: NSScrollView!
    @IBOutlet weak var midiPathTextField: NSTextField!
    @IBOutlet weak var notesCountLabel: NSTextField!
    @IBOutlet var sqlTextView: NSTextView!
    @IBOutlet weak var songIdTextField: NSTextField!
    
    var midiFile: AnyObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
    }
    // 30 -> 50
    // x  -> x*5/3
    func loadFile(path: String?) {
        midiFile = MIDIFile.fileWithPath(path)
        self.notesCountLabel.stringValue = "Notes count: \(midiFile.notes().count)"
    }
    
    func analyzeMidi(){
        var allOutput = "INSERT INTO songnote (start_time, frequency, duration, song_id) VALUES "
        for note in midiFile.notes() {
            var timestamp = (note[MIDINoteTimestampKey] as! Float)
            timestamp = (timestamp * 3) / 5
            var pitch = (note[MIDINotePitchKey] as! Double) //-36 cover only 4 octaves
            var duration = (note[MIDINoteDurationKey] as! Float)
            var trackIndex = note[MIDINoteTrackIndexKey]
            var frequency = roundToPlaces(pow(2 as Double, Double((pitch-69)/12)) * 440, places: 2)
            println("(pitch - 69) / 12: \((pitch-69)/12)")
            var strToAdd = "(\(timestamp), \(frequency), \(duration), \(self.songIdTextField.stringValue)), "
            allOutput+=strToAdd
        }
        allOutput = allOutput.substringToIndex(advance(allOutput.endIndex, -2))
        self.sqlTextView.string = allOutput
    }
    
    func roundToPlaces(value:Double, places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(value * divisor) / divisor
    }
    
    @IBAction func didSelectShowNotes(sender: AnyObject) {
        if !self.midiPathTextField.stringValue.isEmpty && self.songIdTextField.stringValue != ""{
            loadFile(self.midiPathTextField.stringValue)
            analyzeMidi()
        }
    }
    
    @IBAction func didSelectOpenMIDI(sender: AnyObject) {
        var openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        openPanel.allowedFileTypes = ["mid", "midi"]
        openPanel.beginWithCompletionHandler { (result) -> Void in
            if result == NSFileHandlingPanelOKButton {
                if let path = openPanel.URL?.path {
                    self.midiPathTextField.stringValue = path
                }
            }
        }
    }
}
