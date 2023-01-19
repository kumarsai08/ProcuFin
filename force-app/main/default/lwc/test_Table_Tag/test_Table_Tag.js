import { LightningElement, wire, track,api } from 'lwc';
import fetchInventory from '@salesforce/apex/ExampleController.fetchInventory';
export default class Test_Table_Tag extends LightningElement {
    @api Inventory;
    @api productname;

   
    @wire( fetchInventory ) 
    caseRecord({ error, data }) { 
 
        if ( data ) { 
            console.log('LINE 11');
 
            //this.Inventory = data; 
            var newData = JSON.parse(JSON.stringify(data));
            console.log('line 15');
            let templist=[];
            console.log('line 17');

        
        newData.forEach(record => {
           let tempRecs = Object.assign({},record);
           console.log('line 19'+tempRecs);
           console.log('line 20'+JSON.stringify(tempRecs));
           if (record.Shortfall__c > 0) {
            tempRecs.check = true;
           }
           
           
           
           
           templist.push(tempRecs);
        });
        this.Inventory = templist;
 
        } else if ( error )
            console.log( 'Error is ' + JSON.stringify( error ) );
         
    }
    getProductName(event){
        this.productname=event.currentTarget.dataset.prod;
        
    }

}