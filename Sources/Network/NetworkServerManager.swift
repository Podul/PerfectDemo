//
//  NetworkServerManager.swift
//  Perfect
//
//  Created by Xtraln on 2018/3/24.
//  连接管理

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

open class NetworkServerManager {
    fileprivate var server: HTTPServer
    internal init(root: String, port: UInt16, aRoutes:[[String: Any]]) {
        // 创建HTTPServer服务器
        server = HTTPServer.init()
        for route in aRoutes {
            // 根地址
            let baseUri = route["url"] as! String
            // 方法
            let method = route["method"] as! String
            // 创建路由
            var routes = Routes.init(baseUri: baseUri)
            let httpMethod = HTTPMethod.from(string: method)
            // 注册路由
            configure(routes: &routes, method: httpMethod)
            // 将路由添加进服务
            server.addRoutes(routes)
        }
        
        // 服务器名称
        server.serverName = "localhost"
        // 端口
        server.serverPort = port
        // 根目录
        server.documentRoot = root
        // 404过滤
        server.setResponseFilters([(Filter404(), .high)])
    }
    
    
    // MARK: - 开启服务
    open func startServer() {
        do {
            print("启动HTTP服务器")
            try server.start()
        } catch PerfectError.networkError(let err, let msg) {
            print("网络出现错误：\(err) \(msg)")
        } catch {
            print("网络未知错误")
        }
    }
}

extension NetworkServerManager {
    // MARK: - 注册路由
    fileprivate func configure(routes: inout Routes, method: HTTPMethod) {
        routes.add(method: .get, uri: "/selectUserInfor") { (request, response) in
            let path = request.path
            print(path)
            let queryParams = request.queryParams
            if queryParams.count == 0{
                let result = DataBaseManager().mysqlGetHomeDataResult()
                let jsonString = self.baseResponseBodyJSONData(code: 200, message: "成功", data: result)
                response.setBody(string: jsonString)
                response.completed()
            }else{
                // 有参数
                // let value : String
                for i in 0...queryParams.count - 1 {
                    let partArr = queryParams[i]
                    print(partArr)
                }
                let jsonString = self.baseResponseBodyJSONData(code: 200, message: "成功", data: nil)
                response.setBody(string: jsonString)
                response.completed()
            }
        }
    }
    
    // MARK: - 通用响应格式
    func baseResponseBodyJSONData(code: Int, message: String, data: Any!) -> String {
        var result = [String: Any]()
        result.updateValue(code, forKey: "code")
        result.updateValue(message, forKey: "message")
        if (data != nil) {
            result.updateValue(data, forKey: "data")
        }else{
            result.updateValue("", forKey: "data")
        }
        guard let jsonString = try? result.jsonEncodedString() else {
            return ""
        }
        return jsonString
    }
    
    // MARK: - 404过滤
    struct Filter404: HTTPResponseFilter {
        func filterBody(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
            callback(.continue)
        }
        func filterHeaders(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
            if case .notFound = response.status {
                response.setBody(string: "404 文件\(response.request.path)不存在。")
                response.setHeader(.contentLength, value: "\(response.bodyBytes.count)")
                callback(.done)
            } else {
                callback(.continue)
            }
        }
    }
}
