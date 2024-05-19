//
//  ContentView.swift
//  Geronimo
//
//  Created by Will Hess on 5/18/24.
//

import SwiftUI

struct ContentView: View {
    @State private var timer1Running = false
    @State private var timer2Running = false
    @State private var timer1Count: Int = Constants().defaultTime
    @State private var timer2Count: Int = Constants().defaultTime
    @State private var showTimer1Picker = false
    @State private var showTimer2Picker = false
    @State private var button1ClickCount = 0
    @State private var button2ClickCount = 0
    @State private var lastTimerRunning: Int = 0
    @State private var pauseText = Constants().pause
    
    private var timer1 = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private var timer2 = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Button(action: {
                if !timer1Running && !timer2Running {
                    timer2Running = true
                    pauseText = Constants().pause
                } else if timer1Running {
                    timer1Running = false
                    timer2Running = true
                    button1ClickCount += 1
                } else if timer2Running {
                    timer1Running = true
                    timer2Running = false
                    button2ClickCount += 1
                }
            }) {
                VStack {
                    Text("\(timeString(time: timer1Count))")
                        .font(.largeTitle)
                    Text("\(Constants().moveCount) \(button1ClickCount)")
                        .font(.subheadline)
                    if !timer1Running && !timer2Running {
                        Button(action: {
                            showTimer1Picker.toggle()
                        }) {
                            Text(Constants().setTime)
                                .font(.subheadline)
                                .padding(5)
                                .background(Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(5)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(timer1Running ? Color.green : Color.gray)
                .foregroundColor(.white)
                .rotationEffect(.degrees(180))
            }
            .disabled(timer2Running)
            .onReceive(timer1) { _ in
                if timer1Running && timer1Count > 0 {
                    timer1Count -= 1
                }
            }
            .sheet(isPresented: $showTimer1Picker) {
                TimerPicker(time: $timer1Count)
            }
            
            HStack {
                Button(action: {
                    timer1Count = 600
                    timer2Count = 600
                    timer1Running = false
                    timer2Running = false
                    button1ClickCount = 0
                    button2ClickCount = 0
                }) {
                    Text(Constants().reset)
                        .font(.headline)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Button(action: {
                    if timer1Running {
                        lastTimerRunning = 1
                        timer1Running = false
                        timer2Running = false
                        pauseText = Constants().resume
                    } else if timer2Running {
                        lastTimerRunning = 2
                        timer1Running = false
                        timer2Running = false
                        pauseText = Constants().resume
                    } else if lastTimerRunning == 1 {
                        timer1Running = true
                        pauseText = Constants().pause
                    } else if lastTimerRunning == 2 {
                        timer2Running = true
                        pauseText = Constants().pause
                    }
                }) {
                    Text(pauseText)
                        .font(.headline)
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
            }
            .frame(height: 50)
            
            Button(action: {
                if !timer1Running && !timer2Running {
                    timer1Running = true
                    pauseText = Constants().pause
                } else if timer1Running {
                    timer1Running = false
                    timer2Running = true
                    button1ClickCount += 1
                } else if timer2Running {
                    timer1Running = true
                    timer2Running = false
                    button2ClickCount += 1
                }
            }) {
                VStack {
                    Text("\(timeString(time: timer2Count))")
                        .font(.largeTitle)
                    Text("\(Constants().moveCount) \(button2ClickCount)")
                        .font(.subheadline)
                    if !timer2Running && !timer1Running {
                        Button(action: {
                            showTimer2Picker.toggle()
                        }) {
                            Text(Constants().setTime)
                                .font(.subheadline)
                                .padding(5)
                                .background(Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(5)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(timer2Running ? Color.blue : Color.gray)
                .foregroundColor(.white)
            }
            .disabled(timer1Running)
            .onReceive(timer2) { _ in
                if timer2Running && timer2Count > 0 {
                    timer2Count -= 1
                }
            }
            .sheet(isPresented: $showTimer2Picker) {
                TimerPicker(time: $timer2Count)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    func timeString(time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct TimerPicker: View {
    @Binding var time: Int
    @State private var minutes = 0
    @State private var seconds = 0
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text(Constants().setTime)
                .font(.headline)
            HStack {
                Picker(Constants().minutes, selection: $minutes) {
                    ForEach(0..<60) { minute in
                        Text("\(minute) min").tag(minute)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100)
                
                Picker(Constants().seconds, selection: $seconds) {
                    ForEach(0..<60) { second in
                        Text("\(second) sec").tag(second)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100)
            }
            Button("\(Constants().set)") {
                time = (minutes * 60) + seconds
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}

struct TimerButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Constants {
    var defaultTime: Int = 600
    var pause: String = "Pause"
    var resume: String = "Resume"
    var reset: String = "Reset"
    var moveCount: String = "Move Count:"
    var setTime: String = "Set Time"
    var set: String = "Set"
    var minutes: String = "Minutes"
    var seconds: String = "Seconds"
}
