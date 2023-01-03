import { LightningElement,api,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import GetQuoteDetails from '@salesforce/apex/GetSuppleirDetails.GetQuoteDetails';
import OrderRecords from '@salesforce/apex/GetSuppleirDetails.OrderRecords';
import sendemailtosuppliers from '@salesforce/apex/GetSuppleirDetails.sendemailtosuppliers';
import GetQuoteDetailsdummy from '@salesforce/apex/GetSuppleirDetails.GetQuoteDetailsdummy';

export default class SupplierDatatable extends LightningElement {
    @api OrdersListDispatch=[];
    @api selectedsuppliersap;
    @api SupplierLIST=[];
    @api selectedOrders=[];
    //supplier names list
    @api sendmailtoselected=[];
    @api WarehouseNames=[];
    @api mapsupplierandwarehouse={};
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

        handlePlaceOrder(){
            //selected rows to send orders
            this.selectedOrders=this.template.querySelector('lightning-datatable').getSelectedRows();
            this.sendmailtoselected=[];
            console.log('line 81'+ typeof this.selectedOrders);
           // console.log('line 75'+ JSON.stringify(this.selectedOrders));
            console.log("getSelectedRows => ", 
            JSON.stringify(this.template.querySelector('lightning-datatable').getSelectedRows()));
            this.selectedOrders.forEach(element => {
                console.log(element.Supplier__c);
                console.log(typeof element.Supplier__c);
                this.sendmailtoselected.push(element.Supplier__c);

                this.WarehouseNames.push(element.warehouse__c);
                //console.log('line 82'+ this.sendmailtoselected);

                
                
            });
            console.log('line 99');
            OrderRecords({supplierNamesList: this.sendmailtoselected, WarehouseNamesList: this.WarehouseNames,SelectedQuoteRows: this.selectedOrders}).then(result=>{
                console.log('line 101'+JSON.stringify(result));
                this.OrdersListDispatch=JSON.stringify(result);
                console.log('LINE 107'+this.OrdersListDispatch);


            });
            sendemailtosuppliers({suppliernames : this.sendmailtoselected});
            console.log('LINE 107'+OrdersListDispatch);
            const evt = new ShowToastEvent({
                title: 'ORDERS SENT !!!',
                message: 'The Order Has been sent to the supplier',
                variant: 'success'
            });
            this.dispatchEvent(evt);
        }
           
        
}