//import PerfectHTTP
//import PerfectHTTPServer

//HTTP服务
var routesArr = [[String: Any]]()

var someDict1 : [String:String] = ["method":"GET","url":"/api"]

routesArr.append(someDict1)
let networkServer = NetworkServerManager(root: "webroot", port: 8080, aRoutes: routesArr)
networkServer.startServer()

