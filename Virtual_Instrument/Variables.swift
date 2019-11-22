//
//  VariG#les.swift
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
    
    let C = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C3.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C4.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C5.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/Silence.wav"]
    
    let CStrings = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C1 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C2 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C3 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C4 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C5 - Strings.wav"]
    
    let CHorns = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C1 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C2 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C3 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C4 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C5 - Horns.wav",]
    
    let CSynth1 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C1 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C2 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C3 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C4 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C5 - Synth1.wav"]
    
     let CSynth2 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C1 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C2 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C3 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C4 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C5 - Synth2.wav"]
    
    let CPad1 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C1 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C2 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C3 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C4 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C5 - Pad1.wav",]
    
    let CPad2 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C1 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C2 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C3 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C4 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C5 - Pad2.wav"]
    
    let CS = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C#1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C#2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C#3.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C#4.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C#5.wav"]

    let CSStrings = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C#1 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C#2 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C#3 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C#4 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C#5 - Strings.wav"]

    let CSHorns = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C#1 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C#2 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C#3 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C#4 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C#5 - Horns.wav",]

    let CSSynth1 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C#1 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C#2 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C#3 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C#4 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C#5 - Synth1.wav"]

     let CSSynth2 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C#1 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C#2 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C#3 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C#4 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C#5 - Synth2.wav"]

    let CSPad1 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C#1 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C#2 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C#3 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C#4 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C#5 - Pad1.wav",]

    let CSPad2 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C#1 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C#2 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C#3 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C#4 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/C#5 - Pad2.wav"]
    
    let D = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D3.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D4.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D5.wav"]

    let DStrings = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D1 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D2 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D3 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D4 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D5 - Strings.wav"]

    let DHorns = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D1 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D2 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D3 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D4 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D5 - Horns.wav",]

    let DSynth1 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D1 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D2 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D3 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D4 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D5 - Synth1.wav"]

     let DSynth2 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D1 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D2 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D3 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D4 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D5 - Synth2.wav"]

    let DPad1 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D1 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D2 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D3 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D4 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D5 - Pad1.wav",]

    let DPad2 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D1 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D2 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D3 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D4 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D5 - Pad2.wav"]
    
    let DS = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D#1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D#2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D#3.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D#4.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D#5.wav"]

    let DSStrings = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D#1 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D#2 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D#3 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D#4 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D#5 - Strings.wav"]

    let DSHorns = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D#1 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D#2 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D#3 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D#4 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D#5 - Horns.wav",]

    let DSSynth1 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D#1 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D#2 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D#3 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D#4 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D#5 - Synth1.wav"]

     let DSSynth2 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D#1 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D#2 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D#3 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D#4 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D#5 - Synth2.wav"]

    let DSPad1 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D#1 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D#2 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D#3 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D#4 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D#5 - Pad1.wav",]

    let DSPad2 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D#1 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D#2 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D#3 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D#4 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/D#5 - Pad2.wav"]

    
    let E = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/E1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/E2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/E3.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/E4.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/E5.wav"]

    let EStrings = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/E1 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/E2 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/E3 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/E4 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/E5 - Strings.wav"]

    let EHorns = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/E1 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/E2 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/E3 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/E4 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/E5 - Horns.wav",]

    let ESynth1 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/E1 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/E2 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/E3 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/E4 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/E5 - Synth1.wav"]

     let ESynth2 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/E1 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/E2 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/E3 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/E4 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/E5 - Synth2.wav"]

    let EPad1 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/E1 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/E2 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/E3 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/E4 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/E5 - Pad1.wav",]

    let EPad2 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/E1 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/E2 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/E3 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/E4 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/E5 - Pad2.wav"]

    
   let F = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F3.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F4.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F5.wav"]

    let FStrings = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F1 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F2 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F3 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F4 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F5 - Strings.wav"]

    let FHorns = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F1 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F2 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F3 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F4 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F5 - Horns.wav",]

    let FSynth1 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F1 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F2 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F3 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F4 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F5 - Synth1.wav"]

     let FSynth2 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F1 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F2 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F3 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F4 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F5 - Synth2.wav"]

    let FPad1 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F1 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F2 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F3 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F4 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F5 - Pad1.wav",]

    let FPad2 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F1 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F2 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F3 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F4 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F5 - Pad2.wav"]

    
    let FS = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F#1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F#2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F#3.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F#4.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F#5.wav"]

    let FSStrings = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F#1 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F#2 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F#3 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F#4 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F#5 - Strings.wav"]

    let FSHorns = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F#1 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F#2 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F#3 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F#4 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F#5 - Horns.wav",]

    let FSSynth1 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F#1 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F#2 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F#3 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F#4 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F#5 - Synth1.wav"]

     let FSSynth2 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F#1 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F#2 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F#3 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F#4 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F#5 - Synth2.wav"]

    let FSPad1 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F#1 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F#2 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F#3 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F#4 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F#5 - Pad1.wav",]

    let FSPad2 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F#1 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F#2 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F#3 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F#4 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/F#5 - Pad2.wav"]

    
    let G = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G3.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G4.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G5.wav"]

    let GStrings = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G1 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G2 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G3 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G4 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G5 - Strings.wav"]

    let GHorns = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G1 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G2 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G3 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G4 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G5 - Horns.wav",]

    let GSynth1 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G1 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G2 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G3 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G4 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G5 - Synth1.wav"]

     let GSynth2 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G1 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G2 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G3 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G4 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G5 - Synth2.wav"]

    let GPad1 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G1 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G2 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G3 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G4 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G5 - Pad1.wav",]

    let GPad2 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G1 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G2 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G3 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G4 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G5 - Pad2.wav"]

    
    let GS = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G#1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G#2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G#3.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G#4.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G#5.wav"]

    let GSStrings = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G#1 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G#2 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G#3 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G#4 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G#5 - Strings.wav"]

    let GSHorns = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G#1 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G#2 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G#3 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G#4 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G#5 - Horns.wav",]

    let GSSynth1 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G#1 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G#2 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G#3 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G#4 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G#5 - Synth1.wav"]

     let GSSynth2 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G#1 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G#2 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G#3 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G#4 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G#5 - Synth2.wav"]

    let GSPad1 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G#1 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G#2 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G#3 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G#4 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G#5 - Pad1.wav",]

    let GSPad2 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G#1 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G#2 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G#3 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G#4 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/G#5 - Pad2.wav"]

    
    let A = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A3.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A4.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A5.wav"]

    let AStrings = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A1 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A2 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A3 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A4 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A5 - Strings.wav"]

    let AHorns = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A1 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A2 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A3 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A4 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A5 - Horns.wav",]

    let ASynth1 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A1 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A2 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A3 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A4 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A5 - Synth1.wav"]

     let ASynth2 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A1 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A2 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A3 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A4 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A5 - Synth2.wav"]

    let APad1 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A1 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A2 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A3 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A4 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A5 - Pad1.wav",]

    let APad2 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A1 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A2 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A3 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A4 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A5 - Pad2.wav"]

    
    let AS = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A#1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A#2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A#3.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A#4.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A#5.wav"]

    let ASStrings = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A#1 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A#2 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A#3 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A#4 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A#5 - Strings.wav"]

    let ASHorns = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A#1 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A#2 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A#3 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A#4 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A#5 - Horns.wav",]

    let ASSynth1 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A#1 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A#2 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A#3 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A#4 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A#5 - Synth1.wav"]

     let ASSynth2 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A#1 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A#2 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A#3 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A#4 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A#5 - Synth2.wav"]

    let ASPad1 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A#1 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A#2 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A#3 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A#4 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A#5 - Pad1.wav",]

    let ASPad2 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A#1 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A#2 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A#3 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A#4 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/A#5 - Pad2.wav"]

    
    let B = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/B1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/B2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/B3.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/B4.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/B5.wav"]

    let BStrings = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/B1 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/B2 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/B3 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/B4 - Strings.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/B5 - Strings.wav"]

    let BHorns = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/B1 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/B2 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/B3 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/B4 - Horns.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/B5 - Horns.wav",]

    let BSynth1 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/B1 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/B2 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/B3 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/B4 - Synth1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/B5 - Synth1.wav"]

     let BSynth2 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/B1 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/B2 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/B3 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/B4 - Synth2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/B5 - Synth2.wav"]

    let BPad1 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/B1 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/B2 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/B3 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/B4 - Pad1.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/B5 - Pad1.wav",]

    let BPad2 = [NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/B1 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/B2 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/B3 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/B4 - Pad2.wav", NSHomeDirectory() + "/Desktop/Virtual_Instrument/AudioFiles/B5 - Pad2.wav"]

    
    
    let outLocation = NSHomeDirectory() + "/Desktop/Virtual_Instrument/Recordings/out.wav"    
}
