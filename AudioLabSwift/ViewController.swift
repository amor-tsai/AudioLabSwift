//
//  ViewController.swift
//  AudioLabSwift
//
//  Created by Eric Larson 
//  Copyright © 2020 Eric Larson. All rights reserved.
//

import UIKit
import Metal





class ViewController: UIViewController {

    struct AudioConstants{
        static let AUDIO_BUFFER_SIZE = 1024*5
        static let AUDIO_TWENTY = 20
    }
    
    // setup audio model
    let audio = AudioModel(buffer_size: AudioConstants.AUDIO_BUFFER_SIZE,fft20: AudioConstants.AUDIO_TWENTY)
    lazy var graph:MetalGraph? = {
        return MetalGraph(mainView: self.view)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // add in graphs for display
        graph?.addGraph(withName: "fft",
                        shouldNormalize: true,
                        numPointsInGraph: AudioConstants.AUDIO_BUFFER_SIZE/2)
        
        graph?.addGraph(withName: "fft_20",
                        shouldNormalize: true,
                        numPointsInGraph: AudioConstants.AUDIO_TWENTY)
        
        graph?.addGraph(withName: "time",
            shouldNormalize: false,
            numPointsInGraph: AudioConstants.AUDIO_BUFFER_SIZE)
        
        // start up the audio model here, querying microphone
        audio.startMicrophoneProcessing(withFps: 10)
        
        //load the audio file
        audio.startAudioPlayProcessing()
        
        //play the audio
        audio.play()
        
        // run the loop for updating the graph peridocially
        Timer.scheduledTimer(timeInterval: 0.05, target: self,
            selector: #selector(self.updateGraph),
            userInfo: nil,
            repeats: true)
        
        
        //test
//        let arr = [2,-3,4,11,7,-1]
//        print(arr[2...3])
    }
    
    //when view will disappeare, call this
    // I think use this function is more appropriate than viewWillDisappear because it stops when I abosultely leave the view instead of trying to .
    override func viewDidDisappear(_ animated: Bool) {
        audio.pause()
    }
    

    // periodically, update the graph with refreshed FFT Data
    @objc
    func updateGraph(){
        self.graph?.updateGraph(
            data: self.audio.fftData,
            forKey: "fft"
        )
        
        self.graph?.updateGraph(
            data: self.audio.fft20MaximumData,
            forKey: "fft_20"
        )
        
        self.graph?.updateGraph(
            data: self.audio.timeData,
            forKey: "time"
        )
        

        
    }
    
    

}

