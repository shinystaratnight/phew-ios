//
//  SocketEcho.swift
//  Caberz
//
//  Created by Ahmed Elesawy on 12/17/20.
//

import Foundation

protocol SocketEchoProtocol: AnyObject {
    func newMessage(chat: ChatModel?)
}

class SocketEcho {
    private var echo: Echo?
    static var shared = SocketEcho()
    private var iChannel: IChannel?
    weak var deleget:SocketEchoProtocol?
    
    private init() {
        iniSocket()
    }
    
    private func iniSocket() {
        guard let token = AuthService.userData?.token?.accessToken else{return}
        echo = Echo(options: ["host": Constants.socketUrl, "auth": ["headers": ["Authorization": "Bearer " + token],"Accept": "Application/json"]])
        connect()
    }
    
    func connect(){
        if echo == nil {
            iniSocket()
        }else {
           let _ = echo?.connected {(data, ack) in
                print("Connected")
            }
        }
    }
    
    func chat(chatId: Int) {
        let _ =   echo?.privateChannel(channel: "phew-chat.\(chatId)").listen(event: ".ChatEvent", callback: { [weak self] data, ack in
            print(data)
            let model = data.filter({ !($0 is String) })
            let json  = SwiftyJSON(model)
            do {
                let model = try JSONDecoder.decodeFromData([ChatModel].self, data: json.rawData(options: .fragmentsAllowed))
                self?.deleget?.newMessage(chat: model.first)
                print(json)
            } catch {
                #if DEBUG
                self?.deleget?.newMessage(chat: nil)
                #endif
            }
        })
    }
    
    func disconect() {
        echo?.disconnect()
        echo = nil
    }
}
