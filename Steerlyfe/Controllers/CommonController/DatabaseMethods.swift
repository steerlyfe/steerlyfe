//
//  DatabaseMethods.swift
//  Steerlyfe
//
//  Created by nap on 25/09/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import RealmSwift

class DatabaseMethods {
    let TAG = "DatabaseMethods"
    let realm = try! Realm()
    
    init() {
        
    }
    
    //TODO: Category DATA
    func addNewCategory(databaseCategoryDetail : DatabaseCategoryDetail){
        do{
            try realm.write {
                realm.add(databaseCategoryDetail)
                CommonMethods.common.showLog(tag: self.TAG, message: "addNewCategory Category ADDED")
            }
        }catch{
            CommonMethods.common.showLog(tag: self.TAG, message: "addNewCategory Error \(error)")
        }
    }
    
    func getAllCategories() -> [CategoryDetail] {
        let innerData = realm.objects(DatabaseCategoryDetail.self)
        var data = [CategoryDetail] ()
        innerData.forEach { (loopValue : DatabaseCategoryDetail) in
            data.append(CategoryDetail(categoryId: loopValue.categoryId, categoryName: loopValue.categoryName, categoryUrl: loopValue.categoryUrl))
        }
        return data
    }
    
    func deleteAllCategories(){
        let data = realm.objects(DatabaseCategoryDetail.self)
        do{
            try realm.write {
                realm.delete(data)
                CommonMethods.common.showLog(tag: self.TAG, message: "deleteAllCategories DELETED")
            }
        }catch{
            CommonMethods.common.showLog(tag: self.TAG, message: "deleteAllCategories Error \(error)")
        }
    }
    
    //TODO: Country DATA
    func addNewCountry(databaseCountryDetail : DatabaseCountryDetail){
        do{
            try realm.write {
                realm.add(databaseCountryDetail)
                CommonMethods.common.showLog(tag: self.TAG, message: "addNewCountry ADDED")
            }
        }catch{
            CommonMethods.common.showLog(tag: self.TAG, message: "addNewCountry Error \(error)")
        }
    }
    
    
    func getCountriesCount() -> Int {
        let innerData = realm.objects(DatabaseCountryDetail.self)
        return innerData.count
    }
    
    func getAllCountries() -> [CountryDetail] {
        let innerData = realm.objects(DatabaseCountryDetail.self).sorted(byKeyPath: "countryName", ascending: true)
        var data = [CountryDetail] ()
        innerData.forEach { (loopValue : DatabaseCountryDetail) in
            data.append(CountryDetail(countryId: loopValue.countryId, countryName: loopValue.countryName, shortCode: loopValue.shortCode, longCode: loopValue.longCode, callingCode: loopValue.callingCode, timeZone: loopValue.timeZone))
        }
        return data
    }
    
    func getCurrentCountry(shortCode : String) -> CountryDetail? {
        let innerData = realm.objects(DatabaseCountryDetail.self).filter("shortCode = %@",shortCode)
        if innerData.count>0 {
            let countryDetail : DatabaseCountryDetail = innerData[0]
            return CountryDetail(countryId: countryDetail.countryId, countryName: countryDetail.countryName, shortCode: countryDetail.shortCode, longCode: countryDetail.longCode, callingCode: countryDetail.callingCode, timeZone: countryDetail.timeZone)
        }else{
            return nil
        }
    }
    
    func deleteAllCountries(){
        let data = realm.objects(DatabaseCountryDetail.self)
        do{
            try realm.write {
                realm.delete(data)
                CommonMethods.common.showLog(tag: self.TAG, message: "deleteAllCountries DELETED")
            }
        }catch{
            CommonMethods.common.showLog(tag: self.TAG, message: "deleteAllCountries Error \(error)")
        }
    }
    
    //TODO: Cart DATA
    func addProductInCart(productDetail : ProductDetail?)-> Bool{
        productDetail?.quantity = 1        
        let databaseProductDetail = DatabaseProductDetail()
        databaseProductDetail.product_id = productDetail?.product_id ?? ""
        databaseProductDetail.category_id = productDetail?.category_id ?? ""
        databaseProductDetail.product_name = productDetail?.product_name ?? ""
        databaseProductDetail.store_id = productDetail?.store_id ?? ""
        databaseProductDetail.product_description = productDetail?.description ?? ""
        databaseProductDetail.actual_price = productDetail?.actual_price ?? 0.0
        databaseProductDetail.sale_price = productDetail?.sale_price ?? 0.0
        databaseProductDetail.image_url = productDetail?.image_url ?? ""
        databaseProductDetail.quantity = productDetail?.quantity ?? 1
        do{
            try realm.write {
                realm.add(databaseProductDetail)
                CommonMethods.common.showLog(tag: self.TAG, message: "addProductInCart ADDED")
            }
            return true
        }catch{
            CommonMethods.common.showLog(tag: self.TAG, message: "addProductInCart Error \(error)")
            return false
        }
    }
    
    func updateProductInCart(productDetail : ProductDetail?)-> Bool{
        let databaseProductDetail = DatabaseProductDetail()
        databaseProductDetail.product_id = productDetail?.product_id ?? ""
        databaseProductDetail.category_id = productDetail?.category_id ?? ""
        databaseProductDetail.product_name = productDetail?.product_name ?? ""
        databaseProductDetail.store_id = productDetail?.store_id ?? ""
        databaseProductDetail.product_description = productDetail?.description ?? ""
        databaseProductDetail.actual_price = productDetail?.actual_price ?? 0.0
        databaseProductDetail.sale_price = productDetail?.sale_price ?? 0.0
        databaseProductDetail.image_url = productDetail?.image_url ?? ""
        databaseProductDetail.quantity = productDetail?.quantity ?? 1
        do{
            try realm.write {
                realm.add(databaseProductDetail, update: true)
                CommonMethods.common.showLog(tag: self.TAG, message: "updateProductInCart ADDED")
            }
            return true
        }catch{
            CommonMethods.common.showLog(tag: self.TAG, message: "updateProductInCart Error \(error)")
            return false
        }
    }
    
    func getAllCartProducts() -> [ProductDetail] {
        let innerData = realm.objects(DatabaseProductDetail.self).filter("quantity != %@",0)
        var data = [ProductDetail] ()
        innerData.forEach { (loopValue : DatabaseProductDetail) in
            data.append(ProductDetail(product_id: loopValue.product_id, category_id: loopValue.category_id, product_name: loopValue.product_name, store_id: loopValue.store_id, description: loopValue.product_description, actual_price: loopValue.actual_price, sale_price: loopValue.sale_price, image_url: loopValue.image_url, quantity : loopValue.quantity))
        }
        return data
    }
    
    func checkAndUpdateCartProduct(productDetail : ProductDetail?, calledForAdd : Bool) -> Bool? {
        CommonMethods.common.showLog(tag: TAG, message: "CUrrent Quantity \(productDetail?.quantity ?? 0)")
        let innerData = realm.objects(DatabaseProductDetail.self).filter("product_id = %@",productDetail?.product_id ?? "")
        if innerData.count>0 {
            CommonMethods.common.showLog(tag: TAG, message: "EXISTS")
            if let data = innerData.first{
                productDetail?.quantity = data.quantity
                if calledForAdd{
                    productDetail?.quantity = (productDetail?.quantity ?? 0) + 1
                }else{
                    productDetail?.quantity = (productDetail?.quantity ?? 1) - 1
                }
                return updateProductInCart(productDetail: productDetail)
            }else{
                return addProductInCart(productDetail: productDetail)
            }
        }else{
            CommonMethods.common.showLog(tag: TAG, message: "NOT EXISTS")
            return addProductInCart(productDetail: productDetail)
        }
    }
    
    func getProductQuantity(productId : String?) -> Int? {
        let innerData = realm.objects(DatabaseProductDetail.self).filter("product_id = %@",productId ?? "")
        if innerData.count>0 {
            if let data = innerData.first{
                return data.quantity
            }else{
                return 0
            }
        }else{
            return 0
        }
    }
    
    func deleteAllCartItems(){
        let data = realm.objects(DatabaseProductDetail.self)
        do{
            try realm.write {
                realm.delete(data)
                CommonMethods.common.showLog(tag: self.TAG, message: "deleteAllCartItems DELETED")
            }
        }catch{
            CommonMethods.common.showLog(tag: self.TAG, message: "deleteAllCartItems Error \(error)")
        }
    }
}
