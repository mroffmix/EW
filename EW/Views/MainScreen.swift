//
//  mainScreen.swift
//  EW
//
//  Created by Ilya on 27.10.20.
//

import SwiftUI
//import SwiftUICharts

struct MainScreen: View {
    private let width =  UIScreen.main.bounds.width
    private let height =  UIScreen.main.bounds.height
    var surfersCounter = SurfersCounterVM()
    private let color1 = Color(red: 21 / 255, green: 46 / 255, blue: 84 / 255)
    private let color2 = Color(red: 35 / 255, green: 70 / 255, blue: 117 / 255)
    private let bgColor = Color.black 
    
    @State var scale: CGFloat = 0
    @State var opacity: CGFloat = 0
    @State private var segment = 0

    
    
    @ObservedObject var vm: DashboardVM
    
    private func shortDate(date: Date = Date()) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        
        return formatter.string(from: date)
    }
    
    private func shortDateTime(_ date: Date = Date()) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func strValue(_ value: Double) -> String {
        return String(format: "%.1f", value)
    }
    
    var body: some View {
        
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(color1)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.lightGray], for: .normal)
        
        return ZStack {
            
            
            Circle()
                .fill(RadialGradient(gradient: Gradient(colors: [color2, color1]), center: .center, startRadius: width/8, endRadius: width))
                .frame(width: width*2)
                .scaleEffect(scale)
                .offset(CGSize(width: width/4, height: -height/1.9))
                .onAppear {
                    let baseAnimation = Animation.easeInOut(duration: 1)
                    let repeated = baseAnimation.speed(1)
                    return withAnimation(repeated) {
                        self.scale = 1
                    }
                }
            
            VStack (alignment: .leading) {
                // Main title
                HStack {
                    VStack (alignment: .leading) {
                        Text("\(shortDate())")
                            .foregroundColor(Color.white.opacity(0.5))
                            .bold()
                            .font(.callout)
                        Text("E2 Eisbachwelle")
                            .foregroundColor(.white)
                            .bold()
                            .font(.largeTitle)
                        
                        
                        Text("\(shortDateTime(vm.currentLegend.start)) - \(shortDateTime(vm.currentLegend.end))")
                            .foregroundColor(.white)
                            .font(.callout)
                            //.padding(.horizontal)
                            .redacted(reason: vm.isLoading ? .placeholder : [])
                    }.padding()
                    
                    Spacer()
                    
                    Button(action: {
                        vm.onAppear()
                    }, label: {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 25))
                            .foregroundColor(.white)
                    }).padding()
                    
                }.frame(width: width)
                .opacity(Double(opacity))
                .onAppear {
                    let baseAnimation = Animation.easeInOut(duration: 1)
                    let repeated = baseAnimation.delay(0.3)
                    return withAnimation(repeated) {
                        self.opacity = 1
                    }
                }
                
                HStack {
                    CardView(title: "Air:", value: "\(vm.air.stringValue) °C", trend: vm.air.trend, action: {
                        vm.showData(with: vm.airData, type: .air)
                        //vm.showedData = vm.airData
                    })
                    
                    CardView(title: "Water:", value: "\(vm.water.stringValue) °C", trend: vm.water.trend, action: {
                        withAnimation {
                            vm.showData(with: vm.waterData, type: .water)
                            //vm.showedData = vm.waterData
                        }
                    })
                }.frame(width: width)
                .redacted(reason: vm.isLoading ? .placeholder : [])
                
                HStack {
                    CardView(title: "Water level:", value: "\(vm.level.stringValue) cm", trend: vm.level.trend, action: {
                        vm.showData(with: vm.waterLevelData, type: .level)
                        //vm.showedData = vm.waterLevelData
                    })
                    CardView(title: "Pressure:", value: "\(vm.pressure.stringValue) m³/s", trend: vm.pressure.trend, action: {
                        vm.showData(with: vm.pressureData, type: .pressure)
                        //vm.showedData = vm.preasureData
                    })
                }.frame(width: width)
                .redacted(reason: vm.isLoading ? .placeholder : [])
                
                HStack {
                    SurfersCounter(vm: surfersCounter, action: {
                        
                    })
//                    CardView(title: "Surfers:", value: "\(position)", trend: vm.level.trend, action: {
//
//                    })
                    
                }.frame(width: width)
                .redacted(reason: vm.isLoading ? .placeholder : [])
                
                HStack {
                    Spacer()
                }.frame(width: width)
                //.padding(.top, 15)
                
                Spacer()
                if !vm.isLoading {
//                    Picker(selection: $segment, label: Text("")) {
//                                    Text("1 Day").tag(0)
//                                    Text("7 Days").tag(1)
//                                    Text("30 Days").tag(2)
//                    }.onChange(of: segment) { value in
//                        print(value)
//                    }
//                    .pickerStyle(SegmentedPickerStyle())
//
//                    .padding(.horizontal, 8)
//                    .frame(width: width)
                    
                    VStack (alignment: .trailing, spacing: 2) {
                        Text("Max: \(strValue(vm.currentLegend.max)) \(vm.currentLegend.measure)")
                            .font(.callout)
                            .foregroundColor(Color.white.opacity(0.5))
                            .padding(.horizontal)
                            .padding(.bottom)
                        
                        
                        Divider().frame(width: width)
                        GeometryReader { geometry in
                            Line(data: ChartData(points: vm.showedData), frame: .constant(geometry.frame(in: .local)), showIndicator: .constant(false), minDataValue: .constant(nil), maxDataValue: .constant(nil))
                                .padding(.vertical)
                                //.opacity(0.9)
                                .transition(.identity)
                                .animation(Animation.easeOut(duration: 2))
                            
                        }.frame(width: width, height: 170)
                        Divider().frame(width: width)
                        Text("Min: \(strValue(vm.currentLegend.min)) \(vm.currentLegend.measure)")
                            .font(.callout)
                            .foregroundColor(Color.white.opacity(0.5))
                            .padding()
                            .padding(.bottom, 20)
                    }
                    
                }
                
            }.padding(.top, 60)
        }
        .onAppear {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                vm.onAppear()
            }
            
            
        }
        .background(bgColor)
        .edgesIgnoringSafeArea(.all)
    }
}

struct mainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen(vm: DashboardVM(handler: HttpGetter(service: DataService())))
    }
}
