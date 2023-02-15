public  class ExampleController {
    @AuraEnabled
    public static List < Inventory__c > fetchInventory() {

            return [ select id, Warehouse__r.Name, Product__r.name, Quantity__c, Stock_On_Hand__c, On_Order__c, Product__r.Rejected_Quantity__c, Order__c, Under_QA__c, Shortfall__c from Inventory__c];
       
    }

    @AuraEnabled(cacheable=true)
    public static List < Opportunity > fetchOpportunity() {
        return [select name, (select Product2Id from Opportunitylineitems) from opportunity];   
    }

    // @AuraEnabled(cacheable=true)
    // public static List<string> getwarehousenamerecords() {
    //      List<string> warehouselist=new List<string>();
    //      List<Inventory__c> returnlist=[Select Id, Warehouse__r.Name From Inventory__c];
    //     for (Inventory__c invn : returnlist) {
    //         warehouselist.add(invn.Warehouse__r.Name);  
    //     }
    //     return warehouselist;     

    // }

    @AuraEnabled(cacheable=true)
    public static List<string> getwarehousenamerecords() {
         List<string> warehouselist=new List<string>();
         List<Schema.Location> returnlist=[Select Id,Name From Location];
        for (Schema.Location loc : returnlist) {
            warehouselist.add(loc.Name);  
        }
        return warehouselist;     

    }

    @AuraEnabled(cacheable=true)
    public static List < Inventory__c > retrieveWarehouseRecords(String searchsname) {
        
        return [ select id, Warehouse__r.Name, Product__r.name, Quantity__c, Stock_On_Hand__c, On_Order__c, Product__r.Rejected_Quantity__c, Order__c, Under_QA__c, Shortfall__c from Inventory__c where Warehouse__r.Name LIKE:searchsname];
    }
}