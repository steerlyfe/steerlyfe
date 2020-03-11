//
//  DatabaseMethods.swift
//  Steerlyfe
//
//  Created by nap on 25/09/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import SQLite3
import Foundation

class DatabaseMethods {
    
    let TAG = "DatabaseMethods"
    let DATABASE_VERSION = 2
    let userDefaults = UserDefaults.standard
    
    let COUNTRIES_TABLE = "countries"
    let CATEGORIES_TABLE = "categories"
    let CART_TABLE = "cart"
    let FAVORITE_TABLE = "favorite"
    let QUIZ_QUESTIONS_TABLE = "quiz_questions"
    let QUIZ_QUESTIONS_OPTION_TABLE = "quiz_questions_option"
    
    let COUNTRY_ID = "country_id"
    let COUNTRY_NAME = "countryName"
    let SHORT_CODE = "shortCode"
    let LONG_CODE = "longCode"
    let CALLING_CODE = "callingCode"
    let TIME_ZONE = "timeZone"
    
    let CATEGORY_ID = "category_id"
    let CATEGORY_NAME = "category_name"
    let CATEGORY_URL = "category_url"
    
    let CART_PRODUCT_ID = "cart_product_id"
    let PRODUCT_ID = "product_id"
    let PRODUCT_NAME = "product_name"
    let STORE_ID = "store_id"
    let STORE_NAME = "store_name"
    let PRODUCT_DESCRIPTION = "product_description"
    let ACTUAL_PRICE = "actual_price"
    let SALE_PRICE = "sale_price"
    let IMAGE_URL = "image_url"
    let QUANTITY = "quantity"
    let ADDITIONAL_FEATURE = "additional_feature"
    let ADDITIONAL_FEATURE_PRICE = "additional_feature_price"
    let AVAILABLE_TYPE = "available_type"
    let SUB_STORE_ID = "sub_store_id"
    let ADDITIONAL_CHARGES = "additional_charges"
    let SUB_STORE_ADDRESS = "sub_store_address"
    
    let QUESTION_ID = "question_id"
    let QUESTION_PUBLIC_ID = "question_public_id"
    let QUESTION = "question"
    let QUESTION_OPTION_ID = "question_option_id"
    let QUESTION_OPTION = "option"
    
    var db: OpaquePointer?
    
    
    init() {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("Steerlyfe.sqlite")
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
            CommonMethods.showLog(tag: TAG, message: "Database opened")
            let lastSavedVersion = userDefaults.integer(forKey: MyConstants.DATABASE_VERSION) 
            CommonMethods.showLog(tag: TAG, message: "DATABASE_VERSION : \(DATABASE_VERSION)")
            CommonMethods.showLog(tag: TAG, message: "SAVED DATABASE_VERSION : \(lastSavedVersion)")
            if DATABASE_VERSION > lastSavedVersion{
                upgradeTable()
            }
        }else{
            CommonMethods.showLog(tag: TAG, message: "error opening database")
        }
    }
    
    private func createTable() {
        let countriesTableQuery = "CREATE TABLE IF NOT EXISTS \(COUNTRIES_TABLE)(\(COUNTRY_ID) TEXT PRIMARY KEY, \(COUNTRY_NAME) TEXT, \(SHORT_CODE) TEXT, \(LONG_CODE) TEXT, \(CALLING_CODE) TEXT, \(TIME_ZONE) TEXT)"
        if sqlite3_exec(db, countriesTableQuery, nil, nil, nil) == SQLITE_OK {
            CommonMethods.showLog(tag: TAG, message: "COUNTRIES TABLE created")
        }else{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            CommonMethods.showLog(tag: TAG, message: "error creating table: \(errmsg)")
        }
        
        let categoriesTableQuery = "CREATE TABLE IF NOT EXISTS \(CATEGORIES_TABLE)(\(CATEGORY_ID) TEXT PRIMARY KEY, \(CATEGORY_NAME) TEXT, \(CATEGORY_URL) TEXT)"
        if sqlite3_exec(db, categoriesTableQuery, nil, nil, nil) == SQLITE_OK {
            CommonMethods.showLog(tag: TAG, message: "CATEGORIES TABLE created")
        }else{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            CommonMethods.showLog(tag: TAG, message: "error creating CATEGORIES table: \(errmsg)")
        }
        
        let cartTableQuery = "CREATE TABLE IF NOT EXISTS \(CART_TABLE)(\(CART_PRODUCT_ID) INTEGER PRIMARY KEY AUTOINCREMENT, \(PRODUCT_ID) TEXT, \(PRODUCT_NAME) TEXT, \(STORE_ID) TEXT, \(STORE_NAME) TEXT, \(PRODUCT_DESCRIPTION) TEXT, \(ACTUAL_PRICE) DOUBLE, \(SALE_PRICE) DOUBLE, \(IMAGE_URL) TEXT, \(QUANTITY) INT, \(ADDITIONAL_FEATURE) TEXT, \(ADDITIONAL_FEATURE_PRICE) DOUBLE, \(AVAILABLE_TYPE) TEXT, \(SUB_STORE_ID) TEXT, \(ADDITIONAL_CHARGES) DOUBLE, \(SUB_STORE_ADDRESS) TEXT)"
        if sqlite3_exec(db, cartTableQuery, nil, nil, nil) == SQLITE_OK {
            CommonMethods.showLog(tag: TAG, message: "CART TABLE created : \(cartTableQuery)")
        }else{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            CommonMethods.showLog(tag: TAG, message: "error creating CART table: \(errmsg)")
        }
        
        let favoriteTableQuery = "CREATE TABLE IF NOT EXISTS \(FAVORITE_TABLE)(\(PRODUCT_ID) TEXT PRIMARY KEY, \(PRODUCT_NAME) TEXT, \(STORE_ID) TEXT, \(PRODUCT_DESCRIPTION) TEXT, \(ACTUAL_PRICE) DOUBLE, \(SALE_PRICE) DOUBLE, \(IMAGE_URL) TEXT)"
        if sqlite3_exec(db, favoriteTableQuery, nil, nil, nil) == SQLITE_OK {
            CommonMethods.showLog(tag: TAG, message: "FAVORITE TABLE created")
        }else{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            CommonMethods.showLog(tag: TAG, message: "error creating FAVORITE table: \(errmsg)")
        }
        
        let questionTableQuery = "CREATE TABLE IF NOT EXISTS \(QUIZ_QUESTIONS_TABLE)(\(QUESTION_ID) TEXT PRIMARY KEY, \(QUESTION_PUBLIC_ID) TEXT, \(QUESTION) TEXT)"
        if sqlite3_exec(db, questionTableQuery, nil, nil, nil) == SQLITE_OK {
            CommonMethods.showLog(tag: TAG, message: "QUIZ_QUESTIONS TABLE created")
        }else{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            CommonMethods.showLog(tag: TAG, message: "error creating QUIZ_QUESTIONS table: \(errmsg)")
        }
        
        let questionOptionTableQuery = "CREATE TABLE IF NOT EXISTS \(QUIZ_QUESTIONS_OPTION_TABLE)(\(QUESTION_OPTION_ID) INTEGER PRIMARY KEY AUTOINCREMENT, \(QUESTION_ID) TEXT, \(QUESTION_OPTION) TEXT)"
        if sqlite3_exec(db, questionOptionTableQuery, nil, nil, nil) == SQLITE_OK {
            CommonMethods.showLog(tag: TAG, message: "QUIZ_QUESTIONS_OPTION TABLE created")
        }else{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            CommonMethods.showLog(tag: TAG, message: "error creating QUIZ_QUESTIONS_OPTION table: \(errmsg)")
        }
        userDefaults.set(DATABASE_VERSION, forKey: MyConstants.DATABASE_VERSION)
    }
    
    func upgradeTable() {
        dropTable(tableName: CART_TABLE)
        createTable()
    }
    
    func dropTable(tableName : String) {
        let query = "DROP TABLE \(tableName)"
        if sqlite3_exec(db, query, nil, nil, nil) == SQLITE_OK {
            CommonMethods.showLog(tag: TAG, message: "query : \(query) executed")
        }else{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            CommonMethods.showLog(tag: TAG, message: "error creating QUIZ_QUESTIONS_OPTION table: \(errmsg)")
        }
    }
    
    func bindStringData(statement:OpaquePointer?, stringData : String, position : Int) {
        if sqlite3_bind_text(statement, Int32(position), (stringData as NSString).utf8String , -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            CommonMethods.showLog(tag: TAG, message: "bindStringData error binding : \(errmsg)")
            return
        }
    }
    
    func bindIntegerData(statement:OpaquePointer?, intData : Int, position : Int) {
        if sqlite3_bind_int(statement, Int32(position), Int32(intData)) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            CommonMethods.showLog(tag: TAG, message: "bindStringData error binding : \(errmsg)")
            return
        }
    }
    
    func bindDoubleData(statement:OpaquePointer?, doubleData : Double, position : Int) {
        if sqlite3_bind_double(statement, Int32(position), doubleData) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            CommonMethods.showLog(tag: TAG, message: "bindStringData error binding : \(errmsg)")
            return
        }
    }
    
    func prepareDatabaseStatement(queryString : String)->OpaquePointer? {
        var statement:OpaquePointer?
        if sqlite3_prepare(db, queryString, -1, &statement, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            CommonMethods.showLog(tag: TAG, message: "prepareDatabaseStatement Error preparing statement: \(errmsg)")
        }
        return statement
    }
    
    
    //TODO: Category DATA
    func addNewCategory(categoryDetail : CategoryDetail)->Bool{
        let queryString = "INSERT INTO \(CATEGORIES_TABLE) (\(CATEGORY_ID), \(CATEGORY_NAME), \(CATEGORY_URL)) VALUES (?,?,?)"
        if let statement = prepareDatabaseStatement(queryString: queryString){
            bindStringData(statement: statement, stringData: categoryDetail.categoryId ?? "", position: 1)
            bindStringData(statement: statement, stringData: categoryDetail.categoryName ?? "", position: 2)
            bindStringData(statement: statement, stringData: categoryDetail.categoryUrl ?? "", position: 3)
            if sqlite3_step(statement) == SQLITE_DONE {
                CommonMethods.showLog(tag: TAG, message: "addNewCategory CATEGORY ADDED")
                return true
            }else{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                CommonMethods.showLog(tag: TAG, message: "addNewCategory failure inserting CATEGORY : \(errmsg)")
                return false
            }
        }else{
            return false
        }
    }
    
    func getCategoriesCount() -> Int {
        var count = 0
        let queryString = "SELECT COUNT(*) FROM \(CATEGORIES_TABLE)"
        if let statement = prepareDatabaseStatement(queryString: queryString){
            while(sqlite3_step(statement) == SQLITE_ROW){
                count = Int(sqlite3_column_int(statement, 0))
            }
        }
        CommonMethods.showLog(tag: TAG, message: "getCategoriesCount count : \(count)")
        return count
    }
    
    func getAllCategories() -> [CategoryDetail] {
        var list : [CategoryDetail] = []
        let queryString = "SELECT * FROM \(CATEGORIES_TABLE)"
        if let statement = prepareDatabaseStatement(queryString: queryString){
            while(sqlite3_step(statement) == SQLITE_ROW){
                let categoryId = String(cString: sqlite3_column_text(statement, 0))
                let categoryName = String(cString: sqlite3_column_text(statement, 1))
                let categoryUrl = String(cString: sqlite3_column_text(statement, 2))
                list.append(CategoryDetail(categoryId: categoryId, categoryName: categoryName, categoryUrl: categoryUrl))
                CommonMethods.showLog(tag: TAG, message: "getAllCategories categoryId : \(categoryId)")
                CommonMethods.showLog(tag: TAG, message: "getAllCategories categoryUrl : \(categoryUrl)")
            }
        }
        return list
    }
    
    func deleteAllCategories()->Bool{
        let queryString = "DELETE FROM \(COUNTRIES_TABLE);"
        if let statement = prepareDatabaseStatement(queryString: queryString){
            var deleted = false
            if sqlite3_step(statement) == SQLITE_DONE {
                CommonMethods.showLog(tag: TAG, message: "deleteAllCategories DELETED")
                deleted = true
            } else {
                CommonMethods.showLog(tag: TAG, message: "deleteAllCategories Could not delete row.")
                deleted = false
            }
            sqlite3_finalize(statement)
            return deleted
        }else{
            return false
        }
    }
    
    //TODO: Country DATA
    func addNewCountry(countryDetail : CountryDetail)->Bool{
        let queryString = "INSERT INTO \(COUNTRIES_TABLE) (\(COUNTRY_ID), \(COUNTRY_NAME), \(SHORT_CODE), \(LONG_CODE), \(CALLING_CODE), \(TIME_ZONE)) VALUES (?,?,?,?,?,?)"
        if let statement = prepareDatabaseStatement(queryString: queryString){
            bindStringData(statement: statement, stringData: countryDetail.countryId ?? "", position: 1)
            bindStringData(statement: statement, stringData: countryDetail.countryName ?? "", position: 2)
            bindStringData(statement: statement, stringData: countryDetail.shortCode ?? "", position: 3)
            bindStringData(statement: statement, stringData: countryDetail.longCode ?? "", position: 4)
            bindStringData(statement: statement, stringData: countryDetail.callingCode ?? "", position: 5)
            bindStringData(statement: statement, stringData: countryDetail.timeZone ?? "", position: 6)
            if sqlite3_step(statement) == SQLITE_DONE {
                CommonMethods.showLog(tag: TAG, message: "COUNTRY ADDED")
                return true
            }else{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                CommonMethods.showLog(tag: TAG, message: "failure inserting COUNTRY : \(errmsg)")
                return false
            }
        }else{
            return false
        }
    }
    
    
    func getCountriesCount() -> Int {
        var count = 0
        let queryString = "SELECT COUNT(*) FROM \(COUNTRIES_TABLE)"
        if let statement = prepareDatabaseStatement(queryString: queryString){
            while(sqlite3_step(statement) == SQLITE_ROW){
                count = Int(sqlite3_column_int(statement, 0))
            }
        }
        CommonMethods.showLog(tag: TAG, message: "getCountriesCount count : \(count)")
        return count
    }
    
    func getAllCountries() -> [CountryDetail] {
        var list : [CountryDetail] = []
        let queryString = "SELECT * FROM \(COUNTRIES_TABLE)"
        if let statement = prepareDatabaseStatement(queryString: queryString){
            while(sqlite3_step(statement) == SQLITE_ROW){
                let countryId = String(cString: sqlite3_column_text(statement, 0))
                let countryName = String(cString: sqlite3_column_text(statement, 1))
                let shortCode = String(cString: sqlite3_column_text(statement, 2))
                let longCode = String(cString: sqlite3_column_text(statement, 3))
                let callingCode = String(cString: sqlite3_column_text(statement, 4))
                let timeZone = String(cString: sqlite3_column_text(statement, 5))
                list.append(CountryDetail(countryId: countryId, countryName: countryName, shortCode: shortCode, longCode: longCode, callingCode: callingCode, timeZone: timeZone))
                CommonMethods.showLog(tag: TAG, message: "getAllCountries countryId : \(countryId)")
            }
        }
        return list
    }
    
    func getCurrentCountry(shortCode : String) -> CountryDetail? {
        var countryDetail : CountryDetail?
        let queryString = "SELECT * FROM \(COUNTRIES_TABLE) where \(SHORT_CODE) = ?"
        if let statement = prepareDatabaseStatement(queryString: queryString){
            bindStringData(statement: statement, stringData: shortCode, position: 1)
            while(sqlite3_step(statement) == SQLITE_ROW){
                let countryId = String(cString: sqlite3_column_text(statement, 0))
                let countryName = String(cString: sqlite3_column_text(statement, 1))
                let shortCode = String(cString: sqlite3_column_text(statement, 2))
                let longCode = String(cString: sqlite3_column_text(statement, 3))
                let callingCode = String(cString: sqlite3_column_text(statement, 4))
                let timeZone = String(cString: sqlite3_column_text(statement, 5))
                countryDetail = CountryDetail(countryId: countryId, countryName: countryName, shortCode: shortCode, longCode: longCode, callingCode: callingCode, timeZone: timeZone)
                CommonMethods.showLog(tag: TAG, message: "getCurrentCountry countryId : \(countryId)")
            }
        }
        return countryDetail
    }
    
    func deleteAllCountries()->Bool{
        let queryString = "DELETE FROM \(COUNTRIES_TABLE);"
        if let statement = prepareDatabaseStatement(queryString: queryString){
            var deleted = false
            if sqlite3_step(statement) == SQLITE_DONE {
                CommonMethods.showLog(tag: TAG, message: "deleteAllCountries DELETED")
                deleted = true
            } else {
                CommonMethods.showLog(tag: TAG, message: "Could not delete row.")
                deleted = false
            }
            sqlite3_finalize(statement)
            return deleted
        }else{
            return false
        }
    }
    
    //TODO: Cart DATA
    func addProductInCart(productDetail : CartProductDetail?)-> Bool{
        let queryString = "INSERT INTO \(CART_TABLE) (\(PRODUCT_ID), \(PRODUCT_NAME), \(STORE_ID), \(STORE_NAME), \(PRODUCT_DESCRIPTION), \(ACTUAL_PRICE), \(SALE_PRICE), \(IMAGE_URL), \(QUANTITY), \(ADDITIONAL_FEATURE), \(AVAILABLE_TYPE),\(SUB_STORE_ID),\(ADDITIONAL_CHARGES), \(ADDITIONAL_FEATURE_PRICE), \(SUB_STORE_ADDRESS)) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
        if let statement = prepareDatabaseStatement(queryString: queryString){
            bindStringData(statement: statement, stringData: productDetail?.product_id ?? "", position: 1)
            bindStringData(statement: statement, stringData: productDetail?.product_name ?? "", position: 2)
            bindStringData(statement: statement, stringData: productDetail?.store_id ?? "", position: 3)
            bindStringData(statement: statement, stringData: productDetail?.store_name ?? "", position: 4)
            bindStringData(statement: statement, stringData: productDetail?.description ?? "", position: 5)
            bindDoubleData(statement: statement, doubleData: productDetail?.actual_price ?? 0.0, position: 6)
            bindDoubleData(statement: statement, doubleData: productDetail?.sale_price ?? 0.0, position: 7)
            bindStringData(statement: statement, stringData: productDetail?.image_url ?? "", position: 8)
            bindIntegerData(statement: statement, intData: 1, position: 9)
            bindStringData(statement: statement, stringData: productDetail?.additional_feature ?? "", position: 10)
            bindStringData(statement: statement, stringData: productDetail?.available_type ?? "", position: 11)
            bindStringData(statement: statement, stringData: productDetail?.sub_store_id ?? "", position: 12)
            bindDoubleData(statement: statement, doubleData: productDetail?.additional_charges ?? 0.0, position: 13)
            bindDoubleData(statement: statement, doubleData: productDetail?.additional_feature_price ?? 0.0, position: 14)
            bindStringData(statement: statement, stringData: productDetail?.sub_store_address ?? "", position: 15)
            if sqlite3_step(statement) == SQLITE_DONE {
                CommonMethods.showLog(tag: TAG, message: "addProductInCart ADDED")
                return true
            }else{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                CommonMethods.showLog(tag: TAG, message: "addProductInCart failure inserting : \(errmsg)")
                return false
            }
        }else{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            CommonMethods.showLog(tag: TAG, message: "addProductInCart failure inserting : \(errmsg)")
            return false
        }
    }
    
    func updateProductQuantity(productCartId : Int, quantity : Int)-> Bool{
        let queryString = "UPDATE \(CART_TABLE) set \(QUANTITY) = ? WHERE \(CART_PRODUCT_ID) = ?"
        if let statement = prepareDatabaseStatement(queryString: queryString){
            bindIntegerData(statement: statement, intData: quantity, position: 1)
            bindIntegerData(statement: statement, intData: productCartId, position: 2)
            if sqlite3_step(statement) == SQLITE_DONE {
                CommonMethods.showLog(tag: TAG, message: "updateProductQuantity UPDATED")
                return true
            }else{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                CommonMethods.showLog(tag: TAG, message: "updateProductQuantity failure inserting : \(errmsg)")
                return false
            }
        }else{
            return false
        }
    }
    
//    func updateProductInCart(productDetail : ProductDetail?)-> Bool{
//        let queryString = "UPDATE \(CART_TABLE) set \(PRODUCT_NAME) = ?, \(STORE_ID) = ?, \(PRODUCT_DESCRIPTION) = ?, \(ACTUAL_PRICE) = ?, \(SALE_PRICE) = ?, \(IMAGE_URL) = ?, \(QUANTITY) = ? WHERE \(PRODUCT_ID) = ?"
//        if let statement = prepareDatabaseStatement(queryString: queryString){
//            bindStringData(statement: statement, stringData: productDetail?.product_name ?? "", position: 1)
//            bindStringData(statement: statement, stringData: productDetail?.store_id ?? "", position: 2)
//            bindStringData(statement: statement, stringData: productDetail?.description ?? "", position: 3)
//            bindDoubleData(statement: statement, doubleData: productDetail?.actual_price ?? 0.0, position: 4)
//            bindDoubleData(statement: statement, doubleData: productDetail?.sale_price ?? 0.0, position: 5)
//            bindStringData(statement: statement, stringData: productDetail?.image_url ?? "", position: 6)
//            bindIntegerData(statement: statement, intData: productDetail?.quantity ?? 1, position: 7)
//            bindStringData(statement: statement, stringData: productDetail?.product_id ?? "", position: 8)
//            if sqlite3_step(statement) == SQLITE_DONE {
//                CommonMethods.showLog(tag: TAG, message: "updateProductInCart UPDATED")
//                return true
//            }else{
//                let errmsg = String(cString: sqlite3_errmsg(db)!)
//                CommonMethods.showLog(tag: TAG, message: "updateProductInCart failure inserting : \(errmsg)")
//                return false
//            }
//        }else{
//            return false
//        }
//    }
    
    func getAllCartProducts() -> [CartProductDetail] {
        var list : [CartProductDetail] = []
        let queryString = "SELECT \(CART_PRODUCT_ID), \(PRODUCT_ID), \(PRODUCT_NAME), \(STORE_ID), \(STORE_NAME), \(PRODUCT_DESCRIPTION), \(ACTUAL_PRICE), \(SALE_PRICE), \(IMAGE_URL), \(QUANTITY), \(ADDITIONAL_FEATURE), \(AVAILABLE_TYPE), \(SUB_STORE_ID), \(ADDITIONAL_CHARGES), \(ADDITIONAL_FEATURE_PRICE), \(SUB_STORE_ADDRESS) FROM \(CART_TABLE) where \(QUANTITY) != 0"
        if let statement = prepareDatabaseStatement(queryString: queryString){
            while(sqlite3_step(statement) == SQLITE_ROW){
                list.append(getCartDataFromStatement(statement: statement))
            }
        }
        return list
    }
    
    func getCartItemsCount() -> Int {
        var count = 0
        let queryString = "SELECT COUNT(*) FROM \(CART_TABLE) where \(QUANTITY) != 0"
        if let statement = prepareDatabaseStatement(queryString: queryString){
            while(sqlite3_step(statement) == SQLITE_ROW){
                count = Int(sqlite3_column_int(statement, 0))
            }
        }
        CommonMethods.showLog(tag: TAG, message: "getCartItemsCount count : \(count)")
        return count
    }
        
    func getCartProductDetail(productId : String?)->CartProductDetail? {
        var productDetail : CartProductDetail?
        let queryString = "SELECT \(CART_PRODUCT_ID), \(PRODUCT_ID), \(PRODUCT_NAME), \(STORE_ID), \(STORE_NAME), \(PRODUCT_DESCRIPTION), \(ACTUAL_PRICE), \(SALE_PRICE), \(IMAGE_URL), \(QUANTITY), \(ADDITIONAL_FEATURE), \(AVAILABLE_TYPE), \(SUB_STORE_ID), \(ADDITIONAL_CHARGES), \(ADDITIONAL_FEATURE_PRICE), \(SUB_STORE_ADDRESS) FROM \(CART_TABLE) where \(PRODUCT_ID) = ?"
        if let statement = prepareDatabaseStatement(queryString: queryString){
            bindStringData(statement: statement, stringData: productId ?? "", position: 1)
            while(sqlite3_step(statement) == SQLITE_ROW){
                productDetail = getCartDataFromStatement(statement: statement)
            }
        }
        return productDetail
    }
    
    private func getCartDataFromStatement(statement : OpaquePointer)->CartProductDetail{
        let cart_product_id = sqlite3_column_int(statement, 0)
        let product_id = String(cString: sqlite3_column_text(statement, 1))
        let product_name = String(cString: sqlite3_column_text(statement, 2))
        let store_id = String(cString: sqlite3_column_text(statement, 3))
        let store_name = String(cString: sqlite3_column_text(statement, 4))
        let description = String(cString: sqlite3_column_text(statement, 5))
        let actual_price = sqlite3_column_double(statement, 6)
        let sale_price = sqlite3_column_double(statement, 7)
        let image_url = String(cString: sqlite3_column_text(statement, 8))
        let quantity = sqlite3_column_int(statement, 9)
        let additional_feature = String(cString: sqlite3_column_text(statement, 10))
        let available_type = String(cString: sqlite3_column_text(statement, 11))
        let sub_store_id = String(cString: sqlite3_column_text(statement, 12))
        let additional_charges = sqlite3_column_double(statement, 13)
        let additional_feature_price = sqlite3_column_double(statement, 14)
        let sub_store_address = String(cString: sqlite3_column_text(statement, 15))
        return CartProductDetail(cart_product_id: Int(cart_product_id), product_id: product_id, product_name: product_name, store_id: store_id, store_name: store_name, description: description, actual_price: actual_price, sale_price: sale_price, image_url: image_url, quantity: Int(quantity), additional_feature: additional_feature, available_type: available_type, sub_store_id: sub_store_id, additional_charges: additional_charges, additional_feature_price: additional_feature_price, sub_store_address: sub_store_address)
    }
    
    func getCartProductQuantity(productId : String?) -> Int? {
        var quantity = 0
        let queryString = "SELECT \(QUANTITY) FROM \(CART_TABLE) where \(PRODUCT_ID) = ?"
        if let statement = prepareDatabaseStatement(queryString: queryString){
            bindStringData(statement: statement, stringData: productId ?? "", position: 1)
            while(sqlite3_step(statement) == SQLITE_ROW){
                quantity = quantity + Int(sqlite3_column_int(statement, 0))
            }
        }
        CommonMethods.showLog(tag: TAG, message: "getCartProductQuantity quantity : \(quantity)")
        return quantity
    }
    
    func getCartProductQuantity(cartProductId : Int?) -> Int? {
        var quantity = 0
        let queryString = "SELECT \(QUANTITY) FROM \(CART_TABLE) where \(CART_PRODUCT_ID) = ?"
        if let statement = prepareDatabaseStatement(queryString: queryString){
            bindIntegerData(statement: statement, intData: cartProductId ?? 0, position: 1)
            while(sqlite3_step(statement) == SQLITE_ROW){
                quantity = Int(sqlite3_column_int(statement, 0))
            }
        }
        CommonMethods.showLog(tag: TAG, message: "getCartProductQuantity quantity : \(quantity)")
        return quantity
    }
    
    func getCartProductId(productId : String?) -> Int? {
        var cartProductId = 0
        let queryString = "SELECT \(CART_PRODUCT_ID) FROM \(CART_TABLE) where \(PRODUCT_ID) = ? LIMIT 1"
        if let statement = prepareDatabaseStatement(queryString: queryString){
            bindStringData(statement: statement, stringData: productId ?? "", position: 1)
            while(sqlite3_step(statement) == SQLITE_ROW){
                cartProductId = Int(sqlite3_column_int(statement, 0))
            }
        }
        CommonMethods.showLog(tag: TAG, message: "getCartProductId cartProductId : \(cartProductId)")
        return cartProductId
    }
    
    func getCartProductQuantity(productId : String?, additional_feature : String?, sub_store_id : String?, available_type : String?) -> Int? {
        var quantity = 0
        let queryString = "SELECT \(QUANTITY) FROM \(CART_TABLE) where \(PRODUCT_ID) = ? AND \(ADDITIONAL_FEATURE) = ? AND \(SUB_STORE_ID) = ? AND \(AVAILABLE_TYPE) = ?"
        if let statement = prepareDatabaseStatement(queryString: queryString){
            bindStringData(statement: statement, stringData: productId ?? "", position: 1)
            bindStringData(statement: statement, stringData: additional_feature ?? "", position: 2)
            bindStringData(statement: statement, stringData: sub_store_id ?? "", position: 3)
            bindStringData(statement: statement, stringData: available_type ?? "", position: 4)
            while(sqlite3_step(statement) == SQLITE_ROW){
                quantity = Int(sqlite3_column_int(statement, 0))
            }
        }
        CommonMethods.showLog(tag: TAG, message: "getCartProductQuantity quantity : \(quantity)")
        return quantity
    }
    
    func getCartProductId(productId : String?, additional_feature : String?, sub_store_id : String?, available_type : String?) -> Int? {
        var cartProductId = 0
        let queryString = "SELECT \(CART_PRODUCT_ID) FROM \(CART_TABLE) where \(PRODUCT_ID) = ? AND \(ADDITIONAL_FEATURE) = ? AND \(SUB_STORE_ID) = ? AND \(AVAILABLE_TYPE) = ?"
        if let statement = prepareDatabaseStatement(queryString: queryString){
            bindStringData(statement: statement, stringData: productId ?? "", position: 1)
            bindStringData(statement: statement, stringData: additional_feature ?? "", position: 2)
            bindStringData(statement: statement, stringData: sub_store_id ?? "", position: 3)
            bindStringData(statement: statement, stringData: available_type ?? "", position: 4)
            while(sqlite3_step(statement) == SQLITE_ROW){
                cartProductId = Int(sqlite3_column_int(statement, 0))
            }
        }
        CommonMethods.showLog(tag: TAG, message: "getCartProductQuantity cartProductId : \(cartProductId)")
        return cartProductId
    }
    
    func deleteAllCartItems()->Bool{
        let queryString = "DELETE FROM \(CART_TABLE);"
        if let statement = prepareDatabaseStatement(queryString: queryString){
            var deleted = false
            if sqlite3_step(statement) == SQLITE_DONE {
                CommonMethods.showLog(tag: TAG, message: "deleteAllCartItems DELETED")
                deleted = true
            } else {
                CommonMethods.showLog(tag: TAG, message: "deleteAllCartItems could not delete row.")
                deleted = false
            }
            sqlite3_finalize(statement)
            return deleted
        }else{
            return false
        }
    }
        
    func deleteCartProduct(cartProductId : Int)->Bool{
        let queryString = "DELETE FROM \(CART_TABLE) WHERE \(CART_PRODUCT_ID) = ?"
        if let statement = prepareDatabaseStatement(queryString: queryString){
            bindIntegerData(statement: statement, intData: cartProductId, position: 1)
            var deleted = false
            if sqlite3_step(statement) == SQLITE_DONE {
                CommonMethods.showLog(tag: TAG, message: "deleteCartProduct DELETED")
                deleted = true
            } else {
                CommonMethods.showLog(tag: TAG, message: "deleteCartProduct could not delete row.")
                deleted = false
            }
            sqlite3_finalize(statement)
            return deleted
        }else{
            return false
        }
    }
    
    //TODO: Favourites DATA
    func isProductFavourite(productId : String) -> Bool? {
        var count = 0
        let queryString = "SELECT COUNT(*) FROM \(FAVORITE_TABLE) where \(PRODUCT_ID) = ?"
        if let statement = prepareDatabaseStatement(queryString: queryString){
            bindStringData(statement: statement, stringData: productId, position: 1)
            while(sqlite3_step(statement) == SQLITE_ROW){
                count = Int(sqlite3_column_int(statement, 0))
            }
        }
        CommonMethods.showLog(tag: TAG, message: "isProductFavourite count : \(count)")
        if count > 0{
            CommonMethods.showLog(tag: TAG, message: "isProductFavourite EXISTS")
            return true
        }else{
            CommonMethods.showLog(tag: TAG, message: "isProductFavourite NOT EXISTS")
            return false
        }
    }
    
    func addProductInFavourite(productDetail : ProductDetail?)-> Bool{
        let queryString = "INSERT INTO \(FAVORITE_TABLE) (\(PRODUCT_ID), \(PRODUCT_NAME), \(STORE_ID), \(PRODUCT_DESCRIPTION), \(ACTUAL_PRICE), \(SALE_PRICE), \(IMAGE_URL)) VALUES (?,?,?,?,?,?,?)"
        if let statement = prepareDatabaseStatement(queryString: queryString){
            bindStringData(statement: statement, stringData: productDetail?.product_id ?? "", position: 1)
            bindStringData(statement: statement, stringData: productDetail?.product_name ?? "", position: 2)
            bindStringData(statement: statement, stringData: productDetail?.store_id ?? "", position: 3)
            bindStringData(statement: statement, stringData: productDetail?.description ?? "", position: 4)
            bindDoubleData(statement: statement, doubleData: productDetail?.actual_price ?? 0.0, position: 5)
            bindDoubleData(statement: statement, doubleData: productDetail?.sale_price ?? 0.0, position: 6)
            bindStringData(statement: statement, stringData: productDetail?.image_url ?? "", position: 7)
            if sqlite3_step(statement) == SQLITE_DONE {
                CommonMethods.showLog(tag: TAG, message: "addProductInFavourite ADDED")
                return true
            }else{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                CommonMethods.showLog(tag: TAG, message: "addProductInFavourite failure inserting : \(errmsg)")
                return false
            }
        }else{
            return false
        }
    }
    
    func getAllFavouriteProducts() -> [ProductDetail] {
        var list : [ProductDetail] = []
        let queryString = "SELECT * FROM \(FAVORITE_TABLE)"
        if let statement = prepareDatabaseStatement(queryString: queryString){
            while(sqlite3_step(statement) == SQLITE_ROW){
                let product_id = String(cString: sqlite3_column_text(statement, 0))
                let product_name = String(cString: sqlite3_column_text(statement, 1))
                let store_id = String(cString: sqlite3_column_text(statement, 2))
                let description = String(cString: sqlite3_column_text(statement, 3))
                let actual_price = sqlite3_column_double(statement, 4)
                let sale_price = sqlite3_column_double(statement, 5)
                let image_url = String(cString: sqlite3_column_text(statement, 6))
                let quantity = sqlite3_column_int(statement, 7)
                list.append(ProductDetail(product_id: product_id, product_name: product_name, store_id: store_id, description: description, actual_price: actual_price, sale_price: sale_price, image_url: image_url, quantity: Int(quantity)))
            }
        }
        return list
    }
    
    func deleteFavouriteProduct(productId : String)->Bool{
        let queryString = "DELETE FROM \(FAVORITE_TABLE) WHERE \(PRODUCT_ID) = ?"
        if let statement = prepareDatabaseStatement(queryString: queryString){
            bindStringData(statement: statement, stringData: productId, position: 1)
            var deleted = false
            if sqlite3_step(statement) == SQLITE_DONE {
                CommonMethods.showLog(tag: TAG, message: "deleteFavouriteProduct DELETED")
                deleted = true
            } else {
                CommonMethods.showLog(tag: TAG, message: "deleteFavouriteProduct could not delete row.")
                deleted = false
            }
            sqlite3_finalize(statement)
            return deleted
        }else{
            return false
        }
    }
    
    //    Quiz Questions
    func addNewQuizQuestion(data : QuizQuestionDetail)->Bool{
        let queryString = "INSERT INTO \(QUIZ_QUESTIONS_TABLE) (\(QUESTION_ID), \(QUESTION_PUBLIC_ID), \(QUESTION)) VALUES (?,?,?)"
        if let statement = prepareDatabaseStatement(queryString: queryString){
            bindStringData(statement: statement, stringData: data.question_id ?? "", position: 1)
            bindStringData(statement: statement, stringData: data.question_public_id ?? "", position: 2)
            bindStringData(statement: statement, stringData: data.question ?? "", position: 3)
            if sqlite3_step(statement) == SQLITE_DONE {
                CommonMethods.showLog(tag: TAG, message: "addNewQuizQuestion ADDED")
                if let questionId = data.question_id{
                    data.options_list.forEach { (option) in
                        addQuizQuestionOption(questionId: questionId, option: option)
                    }
                }
                return true
            }else{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                CommonMethods.showLog(tag: TAG, message: "addNewQuizQuestion failure inserting : \(errmsg)")
                return false
            }
        }else{
            return false
        }
    }
    
    func addQuizQuestionOption(questionId : String, option : String){
        let queryString = "INSERT INTO \(QUIZ_QUESTIONS_OPTION_TABLE) (\(QUESTION_ID), \(QUESTION_OPTION)) VALUES (?,?)"
        if let statement = prepareDatabaseStatement(queryString: queryString){
            bindStringData(statement: statement, stringData: questionId, position: 1)
            bindStringData(statement: statement, stringData: option, position: 2)
            if sqlite3_step(statement) == SQLITE_DONE {
                CommonMethods.showLog(tag: TAG, message: "addQuizQuestionOption ADDED")
            }else{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                CommonMethods.showLog(tag: TAG, message: "addQuizQuestionOption failure inserting : \(errmsg)")
            }
        }
    }
    
    func getQuizQuestionCount() -> Int {
        var count = 0
        let queryString = "SELECT COUNT(*) FROM \(QUIZ_QUESTIONS_TABLE)"
        if let statement = prepareDatabaseStatement(queryString: queryString){
            while(sqlite3_step(statement) == SQLITE_ROW){
                count = Int(sqlite3_column_int(statement, 0))
            }
        }
        CommonMethods.showLog(tag: TAG, message: "getQuizQuestionCount count : \(count)")
        return count
    }
    
    func deleteAllQuizQuestions(){
        let queryString = "DELETE FROM \(QUIZ_QUESTIONS_TABLE)"
        if let statement = prepareDatabaseStatement(queryString: queryString){
            if sqlite3_step(statement) == SQLITE_DONE {
                CommonMethods.showLog(tag: TAG, message: "deleteAllQuizQuestions DELETED")
            } else {
                CommonMethods.showLog(tag: TAG, message: "deleteAllQuizQuestions could not delete row.")
            }
            sqlite3_finalize(statement)
            deleteAllQuizOptions()
        }
    }
    
    func deleteAllQuizOptions(){
        let queryString = "DELETE FROM \(QUIZ_QUESTIONS_OPTION_TABLE)"
        if let statement = prepareDatabaseStatement(queryString: queryString){
            if sqlite3_step(statement) == SQLITE_DONE {
                CommonMethods.showLog(tag: TAG, message: "deleteAllQuizOptions DELETED")
            } else {
                CommonMethods.showLog(tag: TAG, message: "deleteAllQuizOptions could not delete row.")
            }
            sqlite3_finalize(statement)
        }
    }
    
    func getAllQuizQuestions() -> [QuizQuestionDetail] {
       var list : [QuizQuestionDetail] = []
        let queryString = "SELECT * FROM \(QUIZ_QUESTIONS_TABLE)"
        if let statement = prepareDatabaseStatement(queryString: queryString){
            while(sqlite3_step(statement) == SQLITE_ROW){
                let question_id = String(cString: sqlite3_column_text(statement, 0))
                let question_public_id = String(cString: sqlite3_column_text(statement, 1))
                let question = String(cString: sqlite3_column_text(statement, 2))
                list.append(QuizQuestionDetail(question_id: question_id, question_public_id: question_public_id, question: question, options_list: getQuizQuestionOptions(questionId: question_id)))
            }
        }
        return list
    }
    
    func getQuizQuestionOptions(questionId : String) -> [String] {
        var list : [String] = []
        let queryString = "SELECT \(QUESTION_OPTION) FROM \(QUIZ_QUESTIONS_OPTION_TABLE) where \(QUESTION_ID) = ?"
        if let statement = prepareDatabaseStatement(queryString: queryString){
            bindStringData(statement: statement, stringData: questionId, position: 1)
            while(sqlite3_step(statement) == SQLITE_ROW){
                let option = String(cString: sqlite3_column_text(statement, 0))
                list.append(option)
            }
        }
        return list
    }
}
