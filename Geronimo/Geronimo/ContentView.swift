//
//  ContentView.swift
//  Geronimo
//
//  Created by Will Hess on 5/18/24.
//

import SwiftUI
import UIKit

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
    @State private var pauseImage = "play.fill"
    @State private var isPaused = false

    private var timer1 = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private var timer2 = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                if !timer1Running && !timer2Running {
                    if isPaused == false {
                        timer2Running = true
                        pauseText = Constants().pause
                        pauseImage = "pause.fill"
                        self.generateHapticFeedback()
                    }
                } else if timer1Running {
                    timer1Running = false
                    timer2Running = true
                    button1ClickCount += 1
                    self.generateHapticFeedback()
                } else if timer2Running {
                    timer1Running = true
                    timer2Running = false
                    button2ClickCount += 1
                    self.generateHapticFeedback()
                }
            }) {
                VStack(spacing: 0) {
                    Spacer()

                    Text("\(timeString(time: timer1Count))")
                        .font(.system(size: 72, weight: .semibold, design: .default))

                    Text("\(Constants().moveCount) \(button1ClickCount)")
                        .font(.system(size: 16, weight: .semibold))

                    Spacer()

                    if !timer1Running && !timer2Running {
                        Button(action: {
                            showTimer1Picker.toggle()
                        }) {
                            Text(Constants().setTime)
                                .font(.system(size: 17, weight: .semibold))
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(10)
                        }
                    }

                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: timer1Running ? UIScreen.main.bounds.height * 2 / 3 : (timer2Running ? UIScreen.main.bounds.height * 1 / 3 : UIScreen.main.bounds.height / 2))
                .background(timer1Running ? Color.green : Color.black)
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
                if timer1Running || timer2Running {
                    Spacer()

                    Button(action: {
                        if timer1Running {
                            lastTimerRunning = 1
                            timer1Running = false
                            timer2Running = false
                            pauseText = Constants().resume
                            pauseImage = "play.fill"
                            isPaused = true
                            self.generateHapticFeedback()
                        } else if timer2Running {
                            lastTimerRunning = 2
                            timer1Running = false
                            timer2Running = false
                            pauseText = Constants().resume
                            pauseImage = "play.fill"
                            isPaused = true
                            self.generateHapticFeedback()
                        } else if lastTimerRunning == 1 {
                            timer1Running = true
                            pauseText = Constants().pause
                            pauseImage = "pause.fill"
                            isPaused = false
                            self.generateHapticFeedback()
                        } else if lastTimerRunning == 2 {
                            timer2Running = true
                            pauseText = Constants().pause
                            pauseImage = "pause.fill"
                            isPaused = false
                            self.generateHapticFeedback()
                        }
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 80, height: 80)
                            Image(systemName: pauseImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .tint(Color.black)
                        }
                    }

                    Spacer()
                } else if isPaused {
                    Spacer(minLength: 16)

                    Button(action: {
                        timer1Count = 600
                        timer2Count = 600
                        timer1Running = false
                        timer2Running = false
                        button1ClickCount = 0
                        button2ClickCount = 0
                        pauseText = Constants().pause
                        pauseImage = "play.fill"
                        isPaused = false
                        self.generateHapticFeedback()
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 80, height: 80)
                            Image(systemName: "arrow.circlepath")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .tint(Color.black)
                        }
                    }

                    Spacer()

                    Button(action: {
                        if lastTimerRunning == 1 {
                            timer1Running = true
                            pauseText = Constants().pause
                            pauseImage = "pause.fill"
                            isPaused = false
                            self.generateHapticFeedback()
                        } else if lastTimerRunning == 2 {
                            timer2Running = true
                            pauseText = Constants().pause
                            pauseImage = "pause.fill"
                            isPaused = false
                            self.generateHapticFeedback()
                        }
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 80, height: 80)
                            Image(systemName: pauseImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .tint(Color.black)
                        }
                    }

                    Spacer(minLength: 16)
                }
            }
            .frame(height: 80)

            Button(action: {
                if !timer1Running && !timer2Running {
                    if isPaused == false {
                        timer1Running = true
                        pauseText = Constants().pause
                        pauseImage = "pause.fill"
                        self.generateHapticFeedback()
                    }
                } else if timer1Running {
                    timer1Running = false
                    timer2Running = true
                    button1ClickCount += 1
                    self.generateHapticFeedback()
                } else if timer2Running {
                    timer1Running = true
                    timer2Running = false
                    button2ClickCount += 1
                    self.generateHapticFeedback()
                }
            }) {
                VStack(spacing: 0) {
                    Spacer()

                    Text("\(timeString(time: timer2Count))")
                        .font(.system(size: 72, weight: .semibold, design: .default))

                    Text("\(Constants().moveCount) \(button2ClickCount)")
                        .font(.system(size: 16, weight: .semibold))

                    Spacer()

                    if (!timer2Running && !timer1Running) {
                        Button(action: {
                            showTimer2Picker.toggle()
                        }) {
                            Text(Constants().setTime)
                                .font(.system(size: 17, weight: .semibold))
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(10)
                        }
                    }

                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: timer2Running ? UIScreen.main.bounds.height * 2 / 3 : (timer1Running ? UIScreen.main.bounds.height * 1 / 3 : UIScreen.main.bounds.height / 2))
                .background(timer2Running ? Color.blue : Color.black)
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
        .background(Color.black)
    }

    private func generateHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
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
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(colorScheme == .light ? Color.black : Color.white)
                        .font(.title)
                        .padding()
                }
                Spacer()
            }

            Spacer()

            Text(Constants().setTime)
                .font(.system(size: 64, weight: .semibold, design: .default))
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
            .font(.system(size: 17, weight: .semibold, design: .default))
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            Spacer()
        }
        .padding()
    }
}

private func generateHapticFeedback() {
    let generator = UIImpactFeedbackGenerator(style: .medium)
    generator.prepare()
    generator.impactOccurred()
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
    var moveCount: String = "Move:"
    var setTime: String = "Set Time"
    var set: String = "Set"
    var minutes: String = "Minutes"
    var seconds: String = "Seconds"
}
