//
//  Variables.swift
//  Virtual_Instrument
//
//  Created by Sean on 8/16/19.
//  Copyright © 2019 Sean. All rights reserved.
//

import Foundation
import CoreMIDI

class vari{

    //Note Arrays
    let cArray:[Float] = [32.70, 65.41, 130.81, 261.63, 523.25, 1046.50] //24, 36, 48, 60, 72, 84 --> corresponding MIDI values
    let csArray:[Float] = [34.65, 69.30, 138.59, 277.18, 554.37] //25, 37, 49, 61, 73, 85
    let dArray:[Float] = [36.71, 73.42, 146.83, 293.66, 587.33] //26, 38, 50, 62, 74, 86
    let efArray:[Float] = [38.89, 77.78, 155.56, 311.13, 622.25] //27, 39, 51, 63, 75, 87
    let eArray:[Float] = [41.20, 82.41, 164.81, 329.63, 659.25] //28, 40, 52, 64, 76, 88
    let fArray:[Float] = [43.65, 87.31, 174.61, 349.23, 698.46] //29, 41, 53, 65, 77, 89
    let fsArray:[Float] = [46.25, 92.5, 185, 369.99, 739.99] //30, 42, 54, 66, 78, 90
    let gArray:[Float] = [49.00, 98.0, 196, 392, 783.99] //31, 43, 55, 67, 79, 91
    let gsArray:[Float] = [51.91, 103.83, 207.65, 415.3, 830.61] //32, 44, 56, 68, 80, 92
    let aArray:[Float] = [55.00, 110, 220, 440, 880] //33, 45, 57, 69, 81, 93
    let asArray:[Float] = [58.27, 116.54, 233.08, 466.16, 932.33] //34, 46, 58, 70, 82, 94
    let bArray:[Float] = [61.47, 123.47, 246.94, 493.88, 987.77] //35, 47, 59, 71, 83, 95
    
    let C = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C1.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C2.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C3.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C4.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C5.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C6.mp3"]
    
    let Db = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/Db1.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/Db2.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/Db3.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/Db4.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/Db5.mp3"]
    
    let D = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D1.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D2.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D3.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D4.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D5.mp3"]
    
    let Eb = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/Eb1.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/Eb2.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/Eb3.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/Eb4.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/Eb5.mp3"]
    
    let E = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/E1.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/E2.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/E3.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/E4.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/E5.mp3"]
    
    let F = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F1.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F2.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F3.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F4.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F5.mp3"]
    
    let Gb = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/Gb1.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/Gb2.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/Gb3.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/Gb4.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/Gb5.mp3"]
    
    let G = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G1.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G2.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G3.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G4.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G5.mp3"]
    
    let Ab = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/Ab1.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/Ab2.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/Ab3.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/Ab4.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/Ab5.mp3"]
    
    let A = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A1.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A2.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A3.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A4.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A5.mp3"]
    
    let Bb = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/Bb1.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/Bb2.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/Bb3.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/Bb4.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/Bb5.mp3"]
    
    let B = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/B1.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/B2.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/B3.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/B4.mp3", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/B5.mp3"]
    
    
    
    let mC = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/C1.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/C2.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/C3.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/C4.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/C5.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/C6.mid"]
    
    let mDb = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/Db1.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/Db2.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/Db3.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/Db4.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/Db5.mid"]
    
    let mD = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/D1.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/D2.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/D3.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/D4.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/D5.mid"]
    
    let mEb = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/Eb1.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/Eb2.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/Eb3.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/Eb4.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/Eb5.mid"]
    
    let mE = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/E1.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/E2.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/E3.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/E4.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/E5.mid"]
    
    let mF = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/F1.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/F2.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/F3.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/F4.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/F5.mid"]
    
    let mGb = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/Gb1.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/Gb2.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/Gb3.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/Gb4.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/Gb5.mid"]
    
    let mG = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/G1.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/G2.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/G3.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/G4.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/G5.mid"]
    
    let mAb = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/Ab1.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/Ab2.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/Ab3.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/Ab4.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/Ab5.mid"]
    
    let mA = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/A1.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/A2.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/A3.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/A4.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/A5.mid"]
    
    let mBb = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/Bb1.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/Bb2.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/Bb3.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/Bb4.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/Bb5.mid"]
    
    let mB = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/B1.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/B2.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/B3.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/B4.mid", NSHomeDirectory() + "/Desktop/Virtual_Instrument/.midiFiles/B5.mid"]
    
    let outLocation = NSHomeDirectory() + "/Desktop/Virtual_Instrument/Recordings/out.wav"
    
}
