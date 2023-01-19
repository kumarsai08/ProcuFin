global class GetQuoteDetails implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, 
                                                           Messaging.InboundEnvelope envelope){
                                                               
                                                               // Create an InboundEmailResult object for returning the result of the 
                                                               // Apex Email Service
                                                               Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
                                                               try{
                                                                  system.debug('line 7');
                                                               
                                                               String plaintext= '';
                                                               // Add the email plain text into the local variable 
                                                               plaintext = email.plainTextBody;
                                                                   string quoteidd=plaintext.substringBetween('quoteid:','\n');
                                                                   system.debug('quote id:'+quoteidd);
                                                                   system.debug('plaintext:'+plaintext);
                                                               list<Quote> quote_records=[select id,Name,QuoteNumber from Quote];
                                                                   list<quote> quote_update_Records=new list<quote>();
                                                                   list<attachment>  atment=new list<attachment>();
                                                                   for(quote q:quote_records){
                                                                       if(q.id==quoteidd){
                                                                           if(email.binaryAttachments != null && email.binaryAttachments.size()>0){
                                                                               for(integer i=0;i<email.binaryAttachments.size();i++){
                                                                               attachment atc=new attachment();
                                                                               atc.ParentId=q.id;
                                                                               atc.Name=email.binaryAttachments[i].filename;
                                                                               atc.Body=email.binaryAttachments[i].body;
                                                                               atment.add(atc);
                                                                               }
                                                                           }
                                                                           }                                                                           
                                                                       }
                                                                   
                                                                   insert atment;
                                                                   result.success=true;
                                                                   }
                                                                   catch(exception e){
                                                                   result.success=false;
                                                               }
                                                                 return result;
                                                                 
                                                               }
   
}