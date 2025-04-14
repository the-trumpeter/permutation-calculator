//
//  3*3puzzle_swift.swift
//  
//
//  Created by Gill Palmer on 11/4/2025.
//

//
//  Repeating: x^y
//  Non-repeating: y!/(y-x)!
//  multi-factor calculation: C(x,y) * C(z,y) * C(w,y) - and so on
//  y=characters; x=spaces; z,w,etc.=factors; C(x,y) = number of combinations for two nums, characters and spaces - repeats irrelevant
//

import Cocoa
import SwiftUI

extension CommandLine {
    static let input: String = { AnyIterator { readLine() }.joined() }()
}


struct Axis {
    let options: Int
    let allowRepeats: Bool
}

class WindowDelegate: NSObject, NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        NSApp.terminate(nil)
    }
}

// MARK: - homeView
struct homeView: View {
    
    @State private var spacesInCombo = 1
    
    @State private var axisOptions: Int = 1
    @State private var axisRepeats: Bool = true
    @State private var axisBounce: Bool = false
    
    @State private var axis1Options: Int = 1
    @State private var axis1Repeats: Bool = true
    @State private var axis1Bounce: Bool = false
    
    @State private var axis2Options: Int = 1
    @State private var axis2Repeats: Bool = true
    @State private var axis2Bounce: Bool = false
    
    private let listingPadding: CGFloat = 15
    
    @State var answer: [String] = ["", "", ""]
    @State var answerIsStale: Bool = true
    
    @State private var showMore: Bool = false
    
    @State private var moreButtonIcon: Bool = false
    @State private var calcButtonIcon: Bool = false
    
    
    
    // MARK: - Functions
    func factorial(_ n: Int) -> Int {
        guard n >= 0 else { return 0 } // or throw an error if you prefer
        return (1...max(n, 1)).reduce(1, *)
    }

    func multiAxisNoRepeat(positionCount x: Int, axes: [Axis]) -> [String] {
        guard x >= 0 else { return ["Invalid number of positions.", "", ""] }
        guard !axes.contains(where: { $0.options < 0 }) else {
            return ["Option counts cannot be negative.", "", ""]
        }

        var total: Int = 1

        for axis in axes {
            if axis.allowRepeats {
                total *= Int(pow(Double(axis.options), Double(x)))
            } else {
                if axis.options < x {
                    return ["\(axis.options) instance can't fill \(x) positions.", "", ""]
                }
                // Permutation: P(n, r) = n! / (n - r)!
                total *= factorial(axis.options) / factorial(axis.options - x)
            }
        }

        if total == 1 {
            return ["There is", "1", "possible combination."]
        } else {
            return ["There are", "\(total)", "possible combinations."]
        }
    }
    
    func axesMatch(_ a: [Axis], _ b: [Axis]) -> Bool {
        guard a.count == b.count else { return false }
        for (ax1, ax2) in zip(a, b) {
            if ax1.options != ax2.options || ax1.allowRepeats != ax2.allowRepeats {
                return false
            }
        }
        return true
    }
    // MARK: - Inputs
    var body: some View {
        
        VStack(alignment: .center) {

            // MARK: Main Inputs
            VStack() {
                
                VStack() {
                    HStack {
                        Image(systemName: "square.dashed")
                            .frame(width: 20)
                        Text("Spaces:")
                            .frame(width: 65, alignment: .leading)
                        TextField("Integer", value: $spacesInCombo, format: .number)
                            .multilineTextAlignment(.leading)
                            .textFieldStyle(.roundedBorder)
                            .onChange(of: spacesInCombo) {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    answerIsStale = true
                                }
                            }
                    }
                    Spacer().frame(height: 15)
                    HStack {
                        Image(systemName: "list.bullet.rectangle")
                            .frame(width: 20)
                        Text("Inputs:")
                            .frame(width: 65, alignment: .leading)
                        TextField("Integer", value: $axisOptions, format: .number)
                            .multilineTextAlignment(.leading)
                            .textFieldStyle(.roundedBorder)
                            .onChange(of: axisOptions) {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    answerIsStale = true
                                }
                            }
                        
                        
                        HStack() {
                            Toggle("", isOn: $axisRepeats)
                                .labelsHidden()
                                .scaleEffect(axisBounce ? 0.95 : 1.0)
                                .animation(.interpolatingSpring(stiffness: 500, damping: 6), value: axisBounce)
                                .frame(width: 15)
                                .onChange(of: axisRepeats) {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        answerIsStale = true
                                    }
                                    
                                    axisBounce = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        axisBounce = false
                                    }
                                }
                            Image(systemName: "repeat")
                        }
                        
                        
                        
                    }
                    
                    Spacer().frame(height: 10)
                    
                }.zIndex(1)
                    .background(.ultraThinMaterial)

                // MARK: Conditional Inputs
                Group {
                    if showMore {
                        VStack(spacing: 10) {
                            HStack {
                                Image(systemName: "puzzlepiece")
                                    .frame(width: 20)
                                Text("Factor 1:")
                                    .frame(width: 65, alignment: .leading)
                                TextField("Integer", value: $axis1Options, format: .number)
                                    .multilineTextAlignment(.leading)
                                    .textFieldStyle(.roundedBorder)
                                    .onChange(of: axis1Options) {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            answerIsStale = true
                                        }
                                    }

                                HStack() {
                                    Toggle("", isOn: $axis1Repeats)
                                        .labelsHidden()
                                        .scaleEffect(axis1Bounce ? 0.95 : 1.0)
                                        .animation(.interpolatingSpring(stiffness: 500, damping: 6), value: axis1Bounce)
                                        .frame(width: 15)
                                        .onChange(of: axis1Repeats) {
                                            
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                answerIsStale = true
                                            }
                                            
                                            axis1Bounce = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                                axis1Bounce = false
                                            }
                                        }
                                    Image(systemName: "repeat")
                                }
                            }
                            
                            HStack {
                                Image(systemName: "puzzlepiece")
                                    .frame(width: 20)
                                Text("Factor 2:")
                                    .frame(width: 65, alignment: .leading)
                                    
                                TextField("Integer", value: $axis2Options, format: .number)
                                    .multilineTextAlignment(.leading)
                                    .textFieldStyle(.roundedBorder)
                                    .onChange(of: axis2Options) {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            answerIsStale = true
                                        }
                                    }

                                HStack() {
                                    Toggle("", isOn: $axis2Repeats)
                                        .labelsHidden()
                                        .scaleEffect(axis2Bounce ? 0.95 : 1.0)
                                        .animation(.interpolatingSpring(stiffness: 500, damping: 6), value: axis2Bounce)
                                        .frame(width: 15)
                                        .onChange(of: axis2Repeats) {
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                answerIsStale = true
                                            }
                                            axis2Bounce = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                                axis2Bounce = false
                                            }
                                        }
                                    Image(systemName: "repeat")
                                }
                            }
                        }
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: showMore)
                .zIndex(0)
            }
            
            Spacer().frame(height: 10)
            
            // MARK: Calculate, More
            HStack {
                
                Button {
                    
                    var newAxes: [Axis] = []
                    
                    if showMore {
                        newAxes = [
                            Axis(options: axisOptions, allowRepeats: axisRepeats),
                            Axis(options: axis1Options, allowRepeats: axis1Repeats),
                            Axis(options: axis2Options, allowRepeats: axis2Repeats)
                        ]
                    } else {
                        newAxes = [Axis(options: axisOptions, allowRepeats: axisRepeats)]
                    }
                    
                    answer = multiAxisNoRepeat(positionCount: spacesInCombo, axes: newAxes)
                    
                    //symbol animation
                    if answer[1] != "" && answerIsStale {
                        withAnimation(.interpolatingSpring(stiffness: 400, damping: 4)) {
                            calcButtonIcon.toggle()
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        calcButtonIcon = false
                    }
                    
                    //calculation
                    withAnimation {
                        answerIsStale = false
                    }
                    
                    print("\n\nSuccess; Answer: \n\(answer). \nAnswerRelevant = \(!answerIsStale)\n\nAdvanced: \n\nnewAxes: \(newAxes)\n")
                    
                } label: {
                    Label("Calculate", systemImage: "sum")
                        .scaleEffect(calcButtonIcon ? 0.95 : 1.0)
                }
                .buttonStyle(.borderedProminent)
                .keyboardShortcut(.defaultAction)

                
                
                
                
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showMore.toggle()
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.38) {
                        moreButtonIcon = showMore
                    }
                } label: {
                    Image(systemName: moreButtonIcon ? "chevron.up" : "chevron.down")
                }
                .contentTransition(.symbolEffect(.replace))
                .buttonStyle(.bordered)
                .onChange(of: showMore) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        answerIsStale = true
                    }
                }
                
                
                
            }

            Spacer()
            
            // Output text
            if !answerIsStale {
                VStack(alignment: .center, spacing: 4) {
                    Text(answer[0])
                    Text(answer[1]).bold().foregroundStyle(.blue)
                    Text(answer[2])
                }
                .transition(.opacity)
            }
            
            Spacer()


        }
        .padding(10)
    }
}


                
// MARK: - Setup window and app


let titleParagraphStyle = NSMutableParagraphStyle()
titleParagraphStyle.alignment = .center

class AppDelegate: NSObject {
    @objc func showAboutPanel() {
        NSApp.orderFrontStandardAboutPanel(
            options: [
                .applicationName: "Combination Calculator",
                .applicationVersion: "Version 1",
                .credits: NSAttributedString(string: "Made by Gill Palmer, 2025.\nExample usage:\nSay you've got nine different squares.\nHow many different ways could they be ordered?\nCan each square be used more than once?\nWhat if each square could be rotated?",
                                             attributes: [
                                                .foregroundColor: NSColor.secondaryLabelColor,
                                                .font: NSFont.systemFont(ofSize: NSFont.smallSystemFontSize),
                                                .paragraphStyle: titleParagraphStyle
                                             ]
                                            )
            ]
        )
    }
}

let app = NSApplication.shared
app.setActivationPolicy(.regular)

let window = NSWindow(
    contentRect: NSMakeRect(0, 0, 250, 275),
    styleMask: [.titled, .closable, .miniaturizable],
    backing: .buffered,
    defer: false
)

let delegate = WindowDelegate()
window.delegate = delegate

// MARK: Menu Bar
let mainMenu = NSMenu()
let appMenuItem = NSMenuItem()
mainMenu.addItem(appMenuItem)

let appMenu = NSMenu()
appMenuItem.submenu = appMenu

let appDelegate = AppDelegate()

let aboutItem = NSMenuItem(
    title: "About Script",
    action: #selector(AppDelegate.showAboutPanel),
    keyEquivalent: ""
)



aboutItem.target = appDelegate
appMenu.addItem(aboutItem)

appMenu.addItem(NSMenuItem.separator())
appMenu.addItem(
    withTitle: "Quit Combination Calculator",
    action: #selector(NSApplication.terminate(_:)),
    keyEquivalent: "q"
)

app.mainMenu = mainMenu


//MARK: Final Setup & Launch
window.center()
window.title = "Combination Calculator"
window.contentView = NSHostingView(rootView: homeView())
window.makeKeyAndOrderFront(nil)

app.activate(ignoringOtherApps: true)
app.run()
