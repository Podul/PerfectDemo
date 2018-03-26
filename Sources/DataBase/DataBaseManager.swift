//
//  DataBaseManager.swift
//  Perfect
//
//  Created by Xtraln on 2018/3/24.
//  数据库管理

import PerfectMySQL

// MARK: - 数据库信息
let mysql_host = "127.0.0.1"
let mysql_user = "root"
let mysql_password = "123456789"
let mysql_database = "userInforsTable"

// MARK: - 表信息
/// 用户信息表
let userTable = "userTable"

open class DataBaseManager {
    fileprivate var mysql: MySQL
    init() {
        // 创建 mysql 对象
        mysql = MySQL()
        // 开启 mysql 连接
        guard connectDataBase() else {
            return
        }
    }
    
    // 连接数据库
    private func connectDataBase() -> Bool {
        let connected = mysql.connect(host: mysql_host, user: mysql_user, password: mysql_password, db: mysql_database)
        guard connected else {
            print("mysql 连接失败" + mysql.errorMessage())
            return false;
        }
        print("mysql 连接成功")
        return true
    }
}

// MARK: - 增删改查
extension DataBaseManager {
    /// 执行SQL语句
    ///
    /// - Parameter sql: sql语句
    /// - Returns: 返回元组(success:是否成功 result:结果)
    @discardableResult
    func mysqlQuery(_ sql: String) -> (success: Bool, mysqlResult: MySQL.Results?, errorMsg: String) {
        guard mysql.selectDatabase(named: mysql_database) else {
            // 指定操作的数据库
            let message = "未找到\(mysql_database)数据库"
            print(message)
            return (false, nil, message)
        }
        // sql 语句
        let successQuery = mysql.query(statement: sql)
        guard successQuery else {
            let message = "SQL 失败：\(sql)"
            print(message)
            return (false, nil, message)
        }
        let message = "SQL 成功：\(sql)"
        print(message)
        // 执行成功
        return (true, mysql.storeResults(), message)
    }
    
    /// 增
    ///
    /// - Parameters:
    ///   - tableName: 表名
    ///   - keyValueDict: 键值对字典
    /// - Returns: 执行结果
    func insertDataBaseSQL(tableName:String, keyValueDict:Dictionary<String, Any>) -> (success: Bool, mysqlResult: MySQL.Results?, errorMsg: String) {
        var keys = [String]()
        var values = [String]()
        for (key, value) in keyValueDict {
            if let str = value as? String {
                keys.append(key)
                values.append(str)
            }
        }
        let fieldNameAll = keys.joined(separator: ",")
        let valueAll = values.joined(separator: ",")
        let sql = "INSERT INTO \(tableName)(\(fieldNameAll) VALUES(\(valueAll))"
        return mysqlQuery(sql)
    }
    
    /// 删
    ///
    /// - Parameters:
    ///   - tableName: 表
    ///   - key: 键
    ///   - value: 值
    func deleteDatabaseSQL(tableName: String, key: String, value: String) -> (success: Bool, mysqlResult: MySQL.Results?, errorMsg: String) {
        let sql = "DELETE FROM \(tableName) WHERE \(key) = '\(value)'"
        return mysqlQuery(sql)
    }
    
    /// 改
    ///
    /// - Parameters:
    ///   - tableName: 表
    ///   - keyValue: 键值对( 键='值', 键='值', 键='值' )
    ///   - whereKey: 查找key
    ///   - whereValue: 查找value
    func updateDatabaseSQL(tableName: String, keyValue: String, whereKey: String, whereValue: String) -> (success: Bool, mysqlResult: MySQL.Results?, errorMsg: String) {
        let sql = "UPDATE \(tableName) SET \(keyValue) WHERE \(whereKey) = '\(whereValue)'"
        return mysqlQuery(sql)
    }
    
    /// 查所有
    ///
    /// - Parameters:
    ///   - tableName: 表
    ///   - key: 键
    func selectAllDatabaseSQL(tableName: String) -> (success: Bool, mysqlResult: MySQL.Results?, errorMsg: String) {
        let sql = "SELECT * FROM \(tableName)"
        return mysqlQuery(sql)
    }
    
    /// 查
    ///
    /// - Parameters:
    ///   - tableName: 表
    ///   - keyValue: 键值对
    func selectAllDataBaseSQLwhere(tableName: String, keyValue: String) -> (success: Bool, mysqlResult: MySQL.Results?, errorMsg: String) {
        let sql = "SELECT * FROM \(tableName) WHERE \(keyValue)"
        return mysqlQuery(sql)
    }
}


extension DataBaseManager {
    /// 获取表中所有数据
    func mysqlGetHomeDataResult() -> [Dictionary<String, String>]? {
        let result = selectAllDatabaseSQL(tableName: userTable)
        var resultArray = [Dictionary<String, String>]()
        var dic = [String:String]()
        result.mysqlResult?.forEachRow(callback: { (row) in
            dic["userid"] = row[0]
            dic["userNumber"] = row[1]
            dic["userName"] = row[2]
            dic["userSex"] = row[3]
            dic["userBirthday"] = row[4]
            resultArray.append(dic)
        })
        return resultArray
    }
}
