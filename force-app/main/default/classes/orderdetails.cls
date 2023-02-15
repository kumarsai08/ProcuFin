public  class orderdetails {
    @AuraEnabled
    public static List < OrderItem > fetchOrderProduct() {

        return[Select id,Product2.Name,Product2Id,OrderId, Order.OrderNumber,Order.Under_QA__c,Order.Account.Name, Order.Quantity__c,Order.Received_Quantity__c,Order.Pending_Quantityy1__c, Order.Status from OrderItem];    
    }
    @AuraEnabled
    public static List<Order> updateOrder(string ordervalue,integer valueRquantity) {
        System.debug('ordervalue :: ' + ordervalue + 'valueee'+ valueRquantity );
        List<Order> ordlistquery = [Select id,Quantity__c,Received_Quantity__c,Order.On_Hand_Recieved__c,Under_QA__c,Pending_Quantityy1__c,Status,Product__c from Order where id=:ordervalue];
        List<Inventory__c> invlist = [SELECT Id,Product__c,On_Order__c,Order__c FROM Inventory__c WHERE Product__c = : ordlistquery[0].Product__c ];
        list<Inventory__c> newinvlist = new list<Inventory__c>();
        system.debug('ordlistquery :: ' + ordlistquery);
        for (Inventory__c inv : invlist) {
            inv.On_Order__c=inv.On_Order__c-valueRquantity;
            inv.Order__c=inv.Order__c+valueRquantity;
            newinvlist.add(inv);
        } 
        update newinvlist; 
        List<Order> updateOrderList = new List<Order>();
        for(Order ord:ordlistquery){
            ord.On_Hand_Recieved__c=ord.On_Hand_Recieved__c+valueRquantity;
            ord.Under_QA__c= ord.Under_QA__c   + valueRquantity;
            ord.Received_Quantity__c = 0;
            ord.Pending_Quantityy1__c = ord.Pending_Quantityy1__c - valueRquantity;
            updateOrderList.add(ord);


        } 
        system.debug('line 20');
        update  updateOrderList;
        system.debug('line 22');  
        return   updateOrderList;  
    }

    /*@AuraEnabled
    public static List<Order> updatePendingQuantity(integer recquantity){
        System.debug('Line 25');
        List<Order> ordrList = [select id,Received_Quantity__c,Pending_Quantityy1__c from Order];
        System.debug('Line 27' + ordrList);
        List<Order> orderPendingList = new List<Order>();
        for(Order ords:ordrList){
            
            System.debug('Line 30'+ords);
            orderPendingList.add(ords);
        }
        System.debug('Line 33'+orderPendingList);

        update orderPendingList;
        return orderPendingList;
    }*/

    @AuraEnabled
    public static void createAsset(String prodId,List<Object> batchNumbers,string orderid) {
        System.debug('Returmnmed cdata'+prodId+''+batchNumbers);
        OrderItem ordObj =[select id,Product2Id,Order.AccountId,Order.Id from OrderItem  where Product2Id=:prodId LIMIT 1];
        List<Asset> assetObjList = new List<asset>();
        integer len = batchNumbers.size();
        for(integer i=0;i<len;i++){
            Asset astObj = new Asset();
            astObj.Product2Id = prodId;
            astObj.Name = 'Asset Delivery'+i;
            astObj.AccountId=ordObj.Order.AccountId;
            astObj.Quantity=1.00;
            astObj.Order_Id__c=Id.valueOf(orderid);
            astObj.Batch_Number__c = (String)batchNumbers[i];
            assetObjList.add(astObj);
        }
        System.debug('list'+assetObjList);
        insert assetObjList;
        System.debug('inserted');
        
    }

    @AuraEnabled
    public static List<string> getproductnamerecords() {
         List<string> productlist=new List<string>();
         List<Product2> returnlist=[Select Id, Name From Product2];
        for (Product2 product : returnlist) {
            productlist.add(product.Name);  
        }
        return productlist;     

    }
    @AuraEnabled
    public static List < OrderItem > retrieveProductRecords(String searchsname) {
        

        return[Select id,Product2.Name,Product2Id,OrderId, Order.OrderNumber,Order.Under_QA__c, Order.Quantity__c,Order.Received_Quantity__c,Order.Pending_Quantityy1__c, Order.Status from OrderItem where Product2.Name LIKE:searchsname];    
    }

    @AuraEnabled
    public static List < Inventory__c > retrieveProductNameRecords(String searchsproductname) {
        

        return [ select id, Warehouse__r.Name, Product__r.name, Quantity__c, Stock_On_Hand__c, On_Order__c, Product__r.Rejected_Quantity__c, Order__c, Under_QA__c, Shortfall__c from Inventory__c where Product__r.name LIKE:searchsproductname];
    }
    
    // @AuraEnabled(cacheable=true)
    // public static List<string> getStatusRecords() {
    //      List<string> orderlist=new List<string>();
    //      List<Order> returnlist=[Select Id, Status From Order];
    //     for (Order odrs : returnlist) {
    //         orderlist.add(odrs.status);     
    //     }
    //     return orderlist;     

    // }
    @AuraEnabled   
    public static List < OrderItem > statusRecords(String searchstatus, String searchsname) {
        if(searchstatus=='All'){
            return[Select id,Product2.Name,Product2Id,OrderId, Order.OrderNumber,Order.Under_QA__c, Order.Quantity__c,Order.Received_Quantity__c,Order.Pending_Quantityy1__c, Order.Status from OrderItem where Product2.Name LIKE:searchsname];        }
            



            else if (searchstatus=='All' && searchsname=='All') {

        return[Select id,Product2.Name,Product2Id,OrderId, Order.OrderNumber, Order.Quantity__c,Order.Under_QA__c,Order.Received_Quantity__c,Order.Pending_Quantityy1__c, Order.Status from OrderItem];
    }else if(searchsname=='All'){
        return[Select id,Product2.Name,Product2Id,OrderId, Order.OrderNumber,Order.Under_QA__c, Order.Quantity__c,Order.Received_Quantity__c,Order.Pending_Quantityy1__c, Order.Status from OrderItem where Order.Status LIKE:searchstatus ];    

    }else {
        return[Select id,Product2.Name,Product2Id,OrderId, Order.OrderNumber,Order.Under_QA__c, Order.Quantity__c,Order.Received_Quantity__c,Order.Pending_Quantityy1__c, Order.Status from OrderItem where Order.Status LIKE:searchstatus AND Product2.Name LIKE:searchsname];    

    }
        
            

    }

    // @AuraEnabled   
    // public static List < Inventory__c > productRecords(String searchstatus) {
    //     if(searchstatus=='All'){
    //         return [ select id, Warehouse__r.Name, Product__r.name, Quantity__c, Stock_On_Hand__c, On_Order__c, Product__r.Rejected_Quantity__c, Order__c, Under_QA__c, Shortfall__c from Inventory__c where Product__r.name LIKE:searchstatus];      
    //     }   
    // }

    @AuraEnabled   
        public static List<OrderItem> getOrderId(String searchKey) {
            String key = '%' + searchKey + '%';
            return[Select id,Product2.Name,Product2Id,OrderId, Order.OrderNumber,Order.Under_QA__c, Order.Quantity__c,Order.Received_Quantity__c,Order.Pending_Quantityy1__c, Order.Status,Order.Approved_Quantity__c,Order.On_Hand_Recieved__c,Order.Reject_Quantity__c from OrderItem where Order.OrderNumber LIKE :key];
        }


        @AuraEnabled    
        public static List < OrderItem > statusRecordsWithoutProduct(String searchstatus) {
            //if(searchstatus=='All'){
               // return[Select id,Product2.Name,Product2Id,OrderId, Order.OrderNumber, Order.Quantity__c,Order.Received_Quantity__c,Order.Pending_Quantityy1__c, Order.Status from OrderItem where Product2.Name LIKE:searchsname];        }
               // else{
                if(searchstatus=='All'){
                    return[Select id,Product2.Name,Product2Id,OrderId, Order.OrderNumber,Order.Under_QA__c, Order.Quantity__c,Order.Received_Quantity__c,Order.Pending_Quantityy1__c, Order.Status from OrderItem];    


                }else{
                    return[Select id,Product2.Name,Product2Id,OrderId, Order.OrderNumber,Order.Under_QA__c, Order.Quantity__c,Order.Received_Quantity__c,Order.Pending_Quantityy1__c, Order.Status from OrderItem where Order.Status LIKE:searchstatus];    

                }
    
    
    
               // }
    
        }
    
        @AuraEnabled
    public static List < OrderItem > QAManagerOrderProduct() {

        return[SELECT Order.OrderNumber, Product2.Name,Order.Pending_Quantityy1__c,Order.Id,Order.Under_QA__c, Product2.Approved_Quantity__c, Product2.Rejected_Quantity__c from OrderItem WHERE Product2.Name='Calculator' ];    
    }

    @AuraEnabled   
        public static integer getAssetRecords(String assetRecs) {
        integer AssetListSize=0;
        list<Asset> assetlist=[SELECT Id,Order_Id__c from Asset Where Order_Id__c =: assetRecs];
        AssetListSize=assetlist.size();
        return AssetListSize;

        }

}