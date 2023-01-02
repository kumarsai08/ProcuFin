import { LightningElement ,api,track} from 'lwc';

export default class Pathparentcomponent extends LightningElement {
    
    @track steps = [
        { label: 'Inventory Summary', value: 'Inventory Summary' },
        { label: 'Order Inventory', value: 'Order Inventory' },
        { label: 'Supplier Selection', value: 'Supplier Selection' },
        { label: 'Order Summary', value: 'Order Summary' }
    ];
    @track currentStep="Inventory Summary";
    @track isInvSummary =true;
    @track isOrderInv=false;
    @track isSupplierSelection=false;
    @track isOrderSummary=false;
    @track sendOrderData =[];
    // connectedCallback(){
    //     this.isInvSummary =true;
    //     this.isOrderInv =false;
    //     this.isSupplierSelection=false;
    //     this.isOrderSummary=false;
    // }
    moveToCmp(event){
        if(event.target.value==='Inventory Summary') {
            this.currentStep="Inventory Summary";
            this.isInvSummary =true;
            this.isOrderInv =false;
            this.isSupplierSelection=false;
            this.isOrderSummary=false;
        }
        else if(event.target.value==='Order Inventory') {
            this.currentStep="Order Inventory";
            this.isInvSummary =false;
            this.isOrderInv =false;
            this.isSupplierSelection=false;
            this.isOrderSummary=false;
        }
        else if(event.target.value==='Supplier Selection') {
            this.currentStep="Supplier Selection";
            this.isInvSummary =false;
            this.isOrderInv =false;
            this.isSupplierSelection=true;
            this.isOrderSummary=false;
        }
        else if(event.target.value==='Order Summary'){
            this.currentStep="Order Summary";

            this.isInvSummary =false;
            this.isOrderInv =false;
            this.isSupplierSelection=false;
            this.isOrderSummary=true;
        }
    }
    handleAnswer(event){
       
        this.currentStep="Order Inventory";
        this.isInvSummary =false;
        this.isOrderInv =true;
        this.isSupplierSelection=false;
        this.isOrderSummary=false;
        this.selectedRow=event.detail.row;
    }

}