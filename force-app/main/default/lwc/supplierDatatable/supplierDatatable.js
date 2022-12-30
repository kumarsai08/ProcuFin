import { LightningElement,api,track } from 'lwc';
import GetQuoteDetails from '@salesforce/apex/GetSuppleirDetails.GetQuoteDetails';
import GetQuoteDetailsdummy from '@salesforce/apex/GetSuppleirDetails.GetQuoteDetailsdummy';

export default class SupplierDatatable extends LightningElement {
    @api selectedsuppliersap;
    @api SupplierLIST=[];
    @track columns = [
    
        {
            label: 'Supplier Name',
            fieldName: 'Supplier__c',
            type: 'text',
            //typeAttributes: {label: { fieldName: 'ProdName' }, target: '_blank'},
            sortable: true
        },
        {
            label: 'Location',
            fieldName: 'locationName',
            type: 'text',
            sortable: true
        },
        
        {
            label: 'Quote Id',
            fieldName: 'QuoteName',
            type: 'text',
            sortable: true
        },
        {
            label: '',
            fieldName: 'openQuote',
            type: 'url',
            typeAttributes: {label: { fieldName: 'view' }, target: '_blank'},
            sortable: true
        }];
        connectedCallback(){
            GetQuoteDetails({})
            .then(result=>{
                
                
                console.log('line40')
                let templist=[];
               
                var newData = JSON.parse(JSON.stringify(result));
                console.log('line 44'+JSON.stringify(newData));
        
                
                newData.forEach(record => {
                   let tempRecs = Object.assign({},record);
                   
                   //tempRecs.SupplierName = record.supplier__c;
                   tempRecs.locationName = record.warehouse__c;
                   tempRecs.QuoteName= record.Name;
                   tempRecs.openQuote='/'+record.Id;
                   tempRecs.view='view';
                    //if(record.Warehouse__r.Name)tempRecs.WarehouseName=record.Warehouse__r.Name;
                   
                   templist.push(tempRecs);
                });
                this.SupplierLIST=templist;
                console.log('line 61')
                
                
            })
            .catch(error=>{
                console.log('error'+error);
            })
        }
}