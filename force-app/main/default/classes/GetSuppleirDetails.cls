public with sharing class GetSuppleirDetails {
    @AuraEnabled(cacheable=true)
    public static  Map<String,String>  GetSuppleirDetails(String Productid) {
        list<Product_Supplier__c> PSList= [Select Account__c,Account__r.Name From Product_Supplier__c Where Product__r.id=:Productid];
        Map<String,String> NamesList = new  Map<String,String> ();
        for (Product_Supplier__c PS : PSList) {
            NamesList.put(PS.Account__c,PS.Account__r.Name);
        }
        return NamesList;

    }
    @AuraEnabled
    public static list<Quote> SendAnEmail(String productid,list<String> supplierids,string productname,String Orderquantity,String WarehouseName,String productcode){
        system.debug('LINE 15'+ productid + supplierids);
        list<Product_Supplier__c> PSList1= [Select Account__c,Account__r.Email__c,Account__r.Name,Product__r.Name,Product__r.ProductCode From Product_Supplier__c Where Product__r.id=:Productid and Account__c in :supplierids ];
        //string q1='QT'+'-'+'{ '+productname+' }'+ '-'+p.account__r.Name+'-%';
        //List<Quote> Quoteslist=[ SELECT Name,Id FROM QUOTE WHERE Name Like q1];
        //EmailTemplate tempID = [SELECT Id,HTMLValue,Name FROM EmailTemplate WHERE Id =: System.Label.TEMPLATEID];
        //String emailBody = tempID.HTMLValue;
        /*if (Quoteslist.isEmpty()) {
            Integer num=0;
        } else {
            Integer num = Integer.ValueOf(Quoteslist[0].Name.substringAfter('-'));
        }*/
        Integer num;
        String oppID;
        
        system.debug('LINE 15'+ productid + supplierids);
        string s1= productname+' '+WarehouseName;
        list<Opportunity> opplist=[SELECT Name,Id FROM Opportunity WHERE Name = : s1];
        Opportunity opp=new Opportunity();
        if (opplist.isEmpty()) {
            
            opp.Name=productname+' '+WarehouseName;
            opp.StageName='Prospecting';
            opp.CloseDate=System.today() + 90;
            insert opp;
            oppID=opp.Id;

            
        }else {
            oppID=opplist[0].Id;
        }
        string string1='';
        string s2='';
        string s3;
        list<Quote> Quoteslist= [SELECT Name,Id,OpportunityId,Opportunity.Name FROM Quote WHERE OpportunityId =: oppID];
        integer listsize=Quoteslist.size();
        if(Quoteslist.isEmpty()){
             num=0;
        } else {
            system.debug('line 50');
            string1=Quoteslist[listsize-1].Name.substringAfter('-');
            s2=string1.substringAfter('-');
            s3=s2.substringAfter('-');
            system.debug('line 53'+s3);

             num=integer.valueOf(s3);
             system.debug('line 56'+ num);
            
        }
        
        
        List<String> address = new List<String>(); 
        list<Quote> Qlist = new list<Quote>();    
        for(Product_supplier__c p:PSList1){
            address.add(p.account__r.Email__c);
            Quote q = new Quote();
            system.debug(productcode);
            q.Name= 'QT'+'-'+'{ '+p.Product__r.ProductCode+' }'+ '-'+string.valueof(num+=1);
            q.OpportunityId= Id.valueOf(oppID);
            q.Order_Quantity__c=decimal.valueOf(Orderquantity);
            q.Supplier__c=p.account__r.Name;
            q.Inventory_Manager__c=userinfo.getuserId();
            q.warehouse__c= WarehouseName;
            
            Qlist.add(q);
                   
        }
        insert Qlist;
        System.debug('line33'+address);
        System.debug('line 34'+Qlist);
        
        //String messageBody = '<html><body>Hi, welcome to &nbsp;&nbsp;&nbsp;Our World</body>  </html>';

        

        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        mail.setSubject('Requirement for Products');
        mail.setplaintextbody('PLease check for the availability of '+productname +'of the quantity '+ Orderquantity);
        mail.setToAddresses(address);
       
        String BodyHtml='';
        for(Quote q:Qlist){
            system.debug('line 34');
            BodyHtml+='<p> Hello  ' + q.Name +'</p>'
                +'<p>Greetings!</p>'
              +'<p>I am from Procufine DevOrg and I am an inventory manager with Pro.Inc, a pharmaceutical retailer based in Hyderabad.Our company is interested in procuring some of the products that you have to offer.'
              +'More details of our requirements are as follows:!</p>' +
              '<table style="width:100%;border-collapse:collapse;text-align:left;"> <tr> <th style="border: 1px solid #dddddd;padding: 5px;">Product Name</th> <th style="border: 1px solid #dddddd;padding: 5px;">Order Quantity</th> <th style="border: 1px solid #dddddd;padding: 5px;">Location</th></tr> <tr> <td style="border: 1px solid #dddddd;padding: 5px;">'+productname+'</td> <td>'+Orderquantity+'</td> <td style="border: 1px solid #dddddd;padding: 5px;">'+WarehouseName+'</td> </tr>  </table>'+
              '<p>Could you please share current availability, best prices and delivery details (lead time, delivery schedule etc.) so that we can take this conversation forward?</p>'+
              '<p>Looking forward to your reply.</p>'+ 
              '<p>Thanks,<br>Procufine DevOrg<br>Inventory Manager <br> Pro.Inc., Hyderabad <br> (+91)-1234567890!</p>'+
              'P.S. Please Reply All on this email with the details and do not change the subject.'+
              '<p style="display:none"> quoteid:'+ q.id +'</p>'
              
              ;
            system.debug(BodyHtml);
            // mail.setReplyTo('quote_automation@k-cqjr5k147upssfvf9zommipivpinhx2wjv2prh9oj5jqyqnk.5g-i1ljoea3.ap24.apex.salesforce.com');
            mail.setHtmlBody(BodyHtml);
            emailList.add(mail);  

        }
        
        
        system.debug('line 26');
        //Messaging.SendEmailResult[] result= new Messaging.SendEmailResult();
        if(!emailList.isEmpty()){
            Messaging.SendEmailResult[] result= Messaging.sendEmail(emailList);
            System.debug('result:'+ result);
        }
      
        return Qlist;    
        
        
        
    }
    @AuraEnabled
    public static list<Quote> GetQuoteDetails(){
        system.debug('line 89'+[select Id,Name,supplier__c,warehouse__c,Inventory_Manager__c FROM Quote WHERE Inventory_Manager__c =: userinfo.getuserId()  ]);
        return [select Id,Name,supplier__c,warehouse__c,Inventory_Manager__c FROM Quote WHERE Inventory_Manager__c =: userinfo.getuserId()  ];
    }
    @AuraEnabled
    public static list<Quote> GetQuoteDetailsdummy(){
        return [select Id,Name,supplier__c,warehouse__c FROM Quote   ];
    }


    @AuraEnabled
    public static list<Order> OrderRecords(list<string> supplierNamesList, List<String> WarehouseNamesList,List<Quote> SelectedQuoteRows){
        system.debug('line 112');
        List<Order> ordlist= new list<Order>();
        list<account> lstacc = [select id,name from account where name in : supplierNamesList];
        list<Schema.Location> lstloc = [select id,name from Location where name in : WarehouseNamesList];
        map<string ,id> mapsupp = new map<string,id>();
        map<string,id> maploc = new map<string,id>();
        for(account acc : lstacc){
           mapsupp.put(acc.name,acc.id); 
        }
        for(Schema.Location loc : lstloc){
            maploc.put(loc.name,loc.id);
        }
        for (Quote q : SelectedQuoteRows) {
            order orr = new order();
            orr.AccountId = mapsupp.get(q.supplier__c);
            orr.Status='Draft';
            orr.EffectiveDate= System.today();
            orr.Warehouse__c= maploc.get(q.warehouse__c);
            ordlist.add(orr);
            
        }
        insert ordlist;
        return ordlist;

    }
    @AuraEnabled
    public static list<Order> OrderRecordsDatatable(){
        return [SELECT Name,Id,EffectiveDate,Account.Name,Warehouse__r.Name,OrderNumber,Status FROM Order WHERE Warehouse__r.Name='Dilsukhnagar' ];

    }
    @AuraEnabled
    public static void sendemailtosuppliers(list<string> suppliernames){
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        list<account> ac=[select id,name,Email__c from account where name in:suppliernames];
        list<string> emailsaddress=new list<String>();
        for(account acc:ac){
            emailsaddress.add(acc.Email__c);                
        }
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject('Products Required ');
        mail.sethtmlbody('productss');
        mail.setToAddresses(emailsaddress);
        emailList.add(mail);
         if(!emailList.isEmpty()){
            Messaging.sendEmail(emailList);
        }        
    }

}

    

