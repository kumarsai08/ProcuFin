import { LightningElement ,api,track} from 'lwc';
import OrderRecords from '@salesforce/apex/GetSuppleirDetails.OrderRecords';
import OrderRecordsDatatable from '@salesforce/apex/GetSuppleirDetails.OrderRecordsDatatable';
export default class OrdersDatatable extends LightningElement {
    @api OrderList=[];
    @api OrdersLIST=[];
    @track columns=[
    
    {
        label: 'Order Id',
        fieldName: 'OrderUrl',
        type : 'url',
        typeAttributes: {label: { fieldName: 'OrderNumber' }, target: '_blank'},
        sortable: true
    },
    {
        label: 'Order Status',
        fieldName: 'Status',
        type: 'text',
        sortable: true
    },
    
    {
        label:  'Supplier Name',
        fieldName: 'suppliername',
        type: 'text',
        sortable: true
    },
    /*{
        label: 'Warehouse',
        fieldName: 'warehousename',
        type: 'text',
        //typeAttributes: {label: { fieldName: 'WarehouseName' }, target: '_blank'},
        sortable: true
    },*/
    {
        label:  'Order Date',
        fieldName: 'EffectiveDate',
        type: 'date',
        sortable: true
    }
    /*{
        label:  'Order Products',
        fieldName: 'Productname',
        type: 'text',
        sortable: true
    },*/
];
connectedCallback(){
    OrderRecordsDatatable({})
    .then(result=>{
        console.log('line 52'+result);
        
        console.log('line40')
        let templist=[];
       
        var newData = JSON.parse(JSON.stringify(result));
        console.log('line 44'+JSON.stringify(newData));

        
        newData.forEach(record => {
           let tempRecs = Object.assign({},record);
           console.log('LINE 1'+JSON.stringify(tempRecs));
           
           //tempRecs.SupplierName = record.supplier__c;
           tempRecs.suppliername = record.Account.Name;
           console.log('LINE 2'+record.Account.Name);
           
           tempRecs.OrderUrl='/'+record.Id;
           console.log('LINE 3'+record.Id);
           //tempRecs.ordername= record.OrderNumber;
           console.log('LINE 4'+record.OrderNumber);
           //tempRecs.warehousename=record.Warehouse__r.Name;
           
           //if(record.Warehouse__r.Name)tempRecs.warehousename=record.Warehouse__r.Name;
            //Console.log('LINE 5');
           
           templist.push(tempRecs);
           console.log('LINE 6'+templist);
        });
        this.OrdersLIST=templist;
        console.log('line 61')
        
        
    })
    .catch(error=>{
        console.log('line 80-error'+JSON.stringify(error));
    })
}
}