//
//  DrawWaveform.swift
//  PodCatcher
//
//  Created by Christopher Webb-Orenstein on 1/16/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import UIKit
import Accelerate

class DrawWaveform: UIView {
    
    
    override func draw(_ rect: CGRect) {
        self.convertToPoints()
        var f = 0
        print("draw")
        
        let aPath = UIBezierPath()
        let aPath2 = UIBezierPath()
        
        aPath.lineWidth = 2.0
        aPath2.lineWidth = 2.0
        
        aPath.move(to: CGPoint(x:0.0 , y:rect.height/2 ))
        aPath2.move(to: CGPoint(x:0.0 , y:rect.height ))
        
        
        // print(readFile.points)
        for _ in readFile.points{
            //separation of points
            var x:CGFloat = 2.5
            aPath.move(to: CGPoint(x:aPath.currentPoint.x + x , y:aPath.currentPoint.y ))
            
            //Y is the amplitude
            aPath.addLine(to: CGPoint(x:aPath.currentPoint.x  , y:aPath.currentPoint.y - (readFile.points[f] * 70) - 1.0))
            
            aPath.close()
            
            //print(aPath.currentPoint.x)
            x += 1
            f += 1
        }
        
        //If you want to stroke it with a Orange color
        UIColor.orange.set()
        aPath.stroke()
        //If you want to fill it as well
        aPath.fill()
        
        
        f = 0
        aPath2.move(to: CGPoint(x:0.0 , y:rect.height/2 ))
        
        //Reflection of waveform
        for _ in readFile.points{
            var x:CGFloat = 2.5
            aPath2.move(to: CGPoint(x:aPath2.currentPoint.x + x , y:aPath2.currentPoint.y ))
            
            //Y is the amplitude
            aPath2.addLine(to: CGPoint(x:aPath2.currentPoint.x  , y:aPath2.currentPoint.y - ((-1.0 * readFile.points[f]) * 50)))
            
            // aPath.close()
            aPath2.close()
            
            //print(aPath.currentPoint.x)
            x += 1
            f += 1
        }
        
        //If you want to stroke it with a Orange color with alpha2
        UIColor.orange.set()
        aPath2.stroke(with: CGBlendMode.normal, alpha: 0.5)
        //   aPath.stroke()
        
        //If you want to fill it as well
        aPath2.fill()
    }
    
    
    
    
    func readArray( array:[Float]){
        readFile.arrayFloatValues = array
    }
    
    func convertToPoints() {
        var processingBuffer = [Float](repeating: 0.0,
                                       count: Int(readFile.arrayFloatValues.count))
        let sampleCount = vDSP_Length(readFile.arrayFloatValues.count)
        //print(sampleCount)
        vDSP_vabs(readFile.arrayFloatValues, 1, &processingBuffer, 1, sampleCount);
        // print(processingBuffer)
        
        var multiplier = 1.0
        print(multiplier)
        if multiplier < 1{
            multiplier = 1.0
            
        }
        
        let samplesPerPixel = Int(150 * multiplier)
        let filter = [Float](repeating: 1.0 / Float(samplesPerPixel),
                             count: Int(samplesPerPixel))
        let downSampledLength = Int(readFile.arrayFloatValues.count / samplesPerPixel)
        var downSampledData = [Float](repeating:0.0,
                                      count:downSampledLength)
        vDSP_desamp(processingBuffer,
                    vDSP_Stride(samplesPerPixel),
                    filter, &downSampledData,
                    vDSP_Length(downSampledLength),
                    vDSP_Length(samplesPerPixel))
        readFile.points = downSampledData.map{CGFloat($0)}
    }
}

struct readFile {
    static var arrayFloatValues:[Float] = []
    static var points:[CGFloat] = []
    
}

//let url = Bundle.main.url(forResource: "sample2", withExtension: "m4a")
//let file = try! AVAudioFile(forReading: url!)
//let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: file.fileFormat.sampleRate, channels: file.fileFormat.channelCount, interleaved: false)
//print(file.fileFormat.channelCount)
//let buf = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: UInt32(file.length))
//try! file.read(into: buf)
//
//// this makes a copy, you might not want that
//readFile.arrayFloatValues = Array(UnsafeBufferPointer(start: buf.floatChannelData?[0], count:Int(buf.frameLength)))
//
//struct readFile {
//    static var arrayFloatValues:[Float] = []
//    static var points:[CGFloat] = []
//
//}

