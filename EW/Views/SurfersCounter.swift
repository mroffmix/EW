//
//  SurfersCounter.swift
//  EW
//
//  Created by Ilya on 18.11.20.
//

import SwiftUI
import Combine

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        // 2020-11-18T15:26:03.732Z
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        //formatter.timeZone = TimeZone(secondsFromGMT: 0)
        //formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

class SurfersCounterVM: ObservableObject {
    @Published var amount: Int
    @Published var modified: Date?
    
    private var publisher: AnyPublisher<Surfers, Error>?
    private var subscriptions = Set<AnyCancellable>()
    private let decoder = JSONDecoder()
    
    init() {
        let url = URL.init(string: "https://surferelephant.azurewebsites.net/api/SurferStat")
        var request: URLRequest = URLRequest(url: url!)
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        
        publisher = URLSession.shared.dataTaskPublisher(for: request)
            .map {
                $0.data
            }
            .decode(type: Surfers.self, decoder: decoder)
            .catch { error in
                Fail(error: error).eraseToAnyPublisher()
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
        amount = 0
    }
    
    func onAppear() {
        publisher?.sink(receiveCompletion: { (erorr) in
            print(erorr)
        }, receiveValue: { (surfers) in
            self.amount = surfers.amount!
            self.modified = surfers.modified!
        }).store(in: &subscriptions)
    }
    func update() {
        var url = URL.init(string: "https://surferelephant.azurewebsites.net/api/SurferStat/")
        url?.appendPathComponent("\(amount)")
        var request: URLRequest = URLRequest(url: url!)
        request.httpMethod = "POST"
        URLSession.shared.dataTask(with: request).resume()
        
        modified = Date()
    }
    
    func getDateStr() -> String {
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        if let date = modified {
            let str = formatter.string(from: date)
            return str
        } else {
            return ""
        }
    }
}

struct SurfersCounter: View {
    
    @ObservedObject var vm: SurfersCounterVM
    
    @State var isEditing: Bool = false
    @State var opacity: CGFloat = 0
    //@State private var position = 0
    
    let action: () -> ()?
    
    var body: some View {
        
        
        return Button(action: {
            isEditing = true
        }, label: {
            GroupBox{
                HStack {
                    HStack {
                        HStack {
                            VStack (alignment: .leading){
                                Text("Surfers on E2:")
                                    .bold()
                                    .font(.title2)
                                Text("Updated at \(vm.getDateStr())")
                                    .font(.callout)
                            }
                        }
                        Spacer()
                        if !isEditing {
                            
                            Text("\(vm.amount)")
                                .bold()
                                .font(.title)
                                .frame(width: 50)
                                .padding(.trailing, 45)
                                
                        }
                    }.frame(height: 60)
                    
                    Spacer()
                    
                    if isEditing {
                        Picker(selection: $vm.amount, label: Text("")){
                            ForEach(0..<50){ i in
                                Text("\(i)")
                                    .bold()
                                    .font(.system(size: 25))
                            }
                        }
                        .frame(width: 80, height: 60, alignment: .center)
                        .clipped()
                        
                        Button(action: {
                            isEditing.toggle()
                            vm.update()
                        }, label: {
                            Image(systemName: "checkmark.square")
                                .resizable()
                                .foregroundColor(.yellow)
                                .frame(width:30, height:30)
                                .saturation(0.8)
                        })
                    }
                }
                
            }
            .onAppear(perform: {
                vm.onAppear()
            })
        }).buttonStyle(PlainButtonStyle())
        
        .padding(5)
        .onAppear {
            let baseAnimation = Animation.easeInOut(duration: 1)
            let repeated = baseAnimation.delay(0.5)
            return withAnimation(repeated) {
                self.opacity = 1
            }
        }
        .opacity(Double(opacity))
    }
}

struct SurfersCounter_Previews: PreviewProvider {
    static var previews: some View {
        SurfersCounter(vm: SurfersCounterVM(), action: {})
    }
}
