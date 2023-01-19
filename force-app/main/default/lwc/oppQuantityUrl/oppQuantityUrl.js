import { LightningElement,track } from 'lwc';
import opprecords from '@salesforce/apex/GetSuppleirDetails.opprecords';
export default class OppQuantityUrl extends LightningElement {
    @track columns = [
    
        {
            label: 'Opportunity Name',
            fieldName: 'OppnameUrl',
            type: 'url',
            typeAttributes: {label: { fieldName: 'Oppname' }, target: '_blank'},
            sortable: true
        },
        
        {
            label: 'Close Date',
            fieldName: 'Cdate',
            type: 'Date',
            sortable: true
        },
        {
            label: 'Quantity',
            fieldName: 'quantityvalue',
            type: 'Number',
            sortable: true
        },
        {
            label: 'Order Number',
            fieldName: 'Onumber',
            type: 'Text',
            sortable: true
    
        },
        {
            label: 'Stage',
            fieldName: 'Sname',
            type: 'text',
            sortable: true
    
        }
        
    ];
    
    @track OppquantityList ;
    connectedCallback(){
        opprecords({})
        .then(result=>{
            
            this.OppquantityList=result;
            
            let templist=[];
           
            var newData = JSON.parse(JSON.stringify(result));
    
            
            newData.forEach(record => {
               let tempRecs = Object.assign({},record);
               
              // tempRecs.NameUrl = '/'+tempRecs.Product__c;
               //tempRecs.ProdName = record.Product__r.Name;
               console.log('line 67'+ JSON.stringify(record));
               tempRecs.OppnameUrl= '/'+record.OpportunityId;
               if(record.Opportunity.name){tempRecs.Oppname=record.Opportunity.name};
               console.log('line 63'+ JSON.stringify(tempRecs));
              tempRecs.Cdate=record.Opportunity.CloseDate;
              tempRecs.quantityvalue=record.Opportunity.TotalOpportunityQuantity;
              if(record.Opportunity.OrderNumber__c){tempRecs.Onumber=record.Opportunity.OrderNumber__c};
              if(record.Opportunity.StageName){tempRecs.Sname=record.Opportunity.StageName};
               
               templist.push(tempRecs);
            });
    
            this.OppquantityList=templist;
        })
        .catch(error=>{
            console.log('error in Oppquantityurl_Records'+JSON.stringify(error));
        })
    }
}