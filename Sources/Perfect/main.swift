import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

// HTTP服务
var routesArr = [[String: Any]]()

var someDict1 = ["method": "GET", "url": "/api"]

routesArr.append(someDict1)

let networkServer = NetworkServerManager(root: "webroot", port: 8080, aRoutes: routesArr)

networkServer.startServer()



//// 注册您自己的路由和请求／响应句柄
//var routes = Routes()
//routes.add(method: .get, uri: "/") {
//    request, response in
//    response.setHeader(.contentType, value: "text/html")
//    response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, world!</body></html>")
//        .completed()
//}
//
//do {
//    // 启动HTTP服务器
//    try HTTPServer.launch(
//        .server(name: "www.example.ca", port: 8181, routes: routes))
//} catch {
//    fatalError("\(error)") // fatal error launching one of the servers
//}

