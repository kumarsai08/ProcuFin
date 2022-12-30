trigger AccountUpdateTrigger on Account (before insert,before update){
    if(trigger.isInsert || trigger.isUpdate){
        list<Account> acclist = new list<Account>();
        for(Account a: Trigger.new){
            if (a.Industry=='Agriculture'){
                a.Rating='Hot';
                acclist.add(a);
            }else if(a.Industry=='Consulting'){
                a.Rating='Warm';
                acclist.add(a);
            }else if(a.Industry=='Electronics'){
                a.Rating='Cold';
                acclist.add(a);
            }else{
                a.Rating='Null';
                acclist.add(a);
            }
        }
    }
}