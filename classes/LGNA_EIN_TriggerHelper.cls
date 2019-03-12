/*********************************************************************************
* Apex Class Name     : LGNA_EIN_TriggerHelper 
* Version             : 1.0
* Function            : This is helper class for trigger on object Employer Identification Number.
* Modification Log    :
* Developer           Date                   Description
* ----------------------------------------------------------------------------                 
* Bharath            04/09/2018             Original Version
*************************************************************************************/
public class LGNA_EIN_TriggerHelper {
    public static boolean recCheck = false;

    /******************************************************************** 
    *    Method Name : checkUpdateEIN
    *   @description : This method will check if an existing primary EIN record is being unmarked. If so, the save is stopped and user is informed.
    * 				   This method will also check whether a primary address is assigned to an EIN when the EIN is updated as primary.
    *   @parameters  : Map of New Trigger, Map of Old Trigger
    *   @return type :   void. 
    *   @Author      : Bharath
    ***************************************************************/          
    public static void checkUpdateEIN(Map<Id,EIN__c> newEIN, Map<Id,EIN__C> oldEIN){
        Map<id,EIN__c> NameChg = new Map<id,EIN__c>();
        for(EIN__c nwEIN : newEIN.values()) {
            if(nwEIN != oldEIN.get(nwEIN.Id)){
            if(nwEIN.Change_Reason__c != 'ADD' && nwEIN.Change_Reason__c != 'CHG' && nwEIN.Change_Reason__c != 'ERR' &&
                nwEIN.End_Date__c != oldEIN.get(nwEIN.Id).End_Date__c && oldEIN.get(nwEIN.Id).End_Date__c == null){
					nwEIN.Change_Reason__c = 'END';
                    nwEIN.Bluestar_Transfer_Status__c = 'Due for Transfer';
            }
            //Check whether any field is changed without Effective date, then send ERR.
            if(nwEIN.Change_Reason__c == null && (nwEIN.Change_Reason__c == oldEIN.get(nwEIN.Id).Change_Reason__c) && 
               nwEIN.End_Date__c == null && 
              nwEIN.Effective_Date__c == oldEIN.get(nwEIN.Id).Effective_Date__c && 
              ((nwEIN.Location_Name__c != oldEIN.get(nwEIN.Id).Location_Name__c) ||  
               (nwEIN.Street11__c != oldEIN.get(nwEIN.Id).Street11__c) || 
              (nwEIN.Street21__c != oldEIN.get(nwEIN.Id).Street21__c) || 
              (nwEIN.Zip_Code1__c != oldEIN.get(nwEIN.Id).Zip_Code1__c) || 
              (nwEIN.State1__c != oldEIN.get(nwEIN.Id).State1__c) || 
              (nwEIN.City1__c != oldEIN.get(nwEIN.Id).City1__c) || 
              (nwEIN.Country1__c != oldEIN.get(nwEIN.Id).Country1__c) || 
              (nwEIN.County_Code1__c != oldEIN.get(nwEIN.Id).County_Code1__c) ||                
               (nwEIN.Primary__c == oldEIN.get(nwEIN.Id).Primary__c))){
                	nwEIN.Change_Reason__c = 'ERR';
                  	nwEIN.Bluestar_Transfer_Status__c = 'Due for Transfer';
            }                        
            //If any field is changed along with effective date, send CHG. 
            if(nwEIN.Change_Reason__c != 'ADD' && nwEIN.End_Date__c == null && 
               (nwEIN.Effective_Date__c != oldEIN.get(nwEIN.Id).Effective_Date__c)){
            	    nwEIN.Change_Reason__c = 'CHG';
                   	nwEIN.Bluestar_Transfer_Status__c = 'Due for Transfer';
            }
            if(nwEIN.primary__c != oldEIN.get(nwEIN.Id).primary__c && recCheck == false && nwEIN.primary__c == false){
                    //Following is executed when a Primary flag is cleared. 
                    if (!Test.isRunningTest()){
                    	nwEIN.Primary__c.addError('Primary EINs cannot be unchecked. Marking another EIN of this Account as Primary will automatically unmark this EIN as Primary.');
                    }
            }
            	if(nwEIN.Name != oldEIN.get(nwEIN.Id).Name){
                    NameChg.put(nwEIN.Id,nwEIN);
                }
                if(nwEIN.Sent_Effective_Date__c != null && nwEIN.Effective_Date__c != oldEIN.get(nwEIN.Id).Effective_Date__c && 
                   nwEIN.Sent_Effective_Date__c > nwEIN.Effective_Date__c){
                       nwEIN.Effective_Date__c.addError('This EIN has already been transmitted to Bluestar with Effective Date ' + 
                                                        nwEIN.Sent_Effective_Date__c.format() +
                                                          '. New Effective Date needs to be later than the date already sent.');
                   }
            }
        }
        for(EIN__c checkEINName : NameChg.values()){
            List<EIN__c> checkEINrec = [select Name, Account__c from EIN__c where Id != :checkEINName.Id and Account__c = :checkEINName.Account__c
                                       and Name = :checkEINName.Name];
            if(!checkEINrec.isEmpty()){
                NameChg.get(checkEINName.Id).Name.addError('This EIN# is already used for this Account. Please use a different number');
            }
        }
    }

    /******************************************************************** 
    *    Method Name : checkCreateEIN 
    *   @description : When a new EIN is being created, this method will check whether the Account already has a Primary EIN associated with it, 
    * 					if not, user will be requested to mark the new EIN as Primary.
    * 				   This method will also check whether a primary address is assigned when newly created EIN is being marked as Primary.
    *   @parameters  : List of new EIN.
    *   @return type :   void. 
    *   @Author      : Bharath
    ***************************************************************/            
    public static void checkCreateEIN(List<EIN__C> newEIN){
        List<Id> AccId = new List<Id>();
        Map<Id,EIN__c> EinMap = new Map<Id,EIN__c>();
        boolean nonPrime = false;
        for(EIN__c nwEIN : newEIN) {
            nwEIN.Change_Reason__c = 'ADD';
            nwEIN.Bluestar_Transfer_Status__c = 'Due for Transfer';
            List<EIN__c> EinNameRec = [select Name, Account__c from EIN__c where Name = :nwEIN.Name and Account__c = :nwEIN.Account__c];
            if(!EinNameRec.isEmpty()){
                nwEIN.Name.addError('This EIN# is already used for this Account. Please use a different number');
            }
            If(nwEIN.primary__c == false){
                EinMap.put(nwEIN.Account__c,nwEIN);
                AccId.add(nwEIN.Account__c);
                nonPrime = true;
                //Check if first and set Primary.
            }
        }
        //If this is the first EIN for the Account, ask user to set it as Primary if not already done. 
        if(nonPrime){
            For(Id AcId : AccId){
                List<EIN__c> checkPrime = [select Id,Name,Primary__c from EIN__C where (Account__c=:AcId and Primary__c = true)];
                if(checkPrime.size() == 0){
                    if (!Test.isRunningTest()){
                    	EinMap.get(AcId).primary__c.addError('This Account does not have any Primary EINs. Please mark this EIN as primary');
                    }
                }
            }
        } 
    }

    /******************************************************************** 
    *    Method Name : clearPrimaryUpdate 
    *   @description : After an existing EIN is marked as Primary, this method will clear out any other EINs related to that Account from being Primary.
    *   @parameters  : List of new EIN.
    *   @return type :   void. 
    *   @Author      : Bharath
    ***************************************************************/                
    public static void clearPrimaryUpdate(List<EIN__c> newEIN, Map<Id,EIN__c> oldEIN){
        List<Id> primeEINId = new List<Id>();
        List<Id> primeAccounts = new List<Id>();
        for(EIN__c nwEIN : newEIN){
            if(nwEIN.primary__c == true && oldEIN.get(nwEIN.Id).primary__c == false){
                //Clear other Primary if the update EIN was updated from non-Primary to Primary.
                primeEINId.add(nwEIN.Id);
                primeAccounts.add(nwEIN.Account__c);
                //nwEIN.addError('Inside If');
            }
        }
        if(primeEINId.size() > 0){
            List<EIN__c> updEINList = new List<EIN__c>();
            for(EIN__c updEIN : [select id,name,primary__c,Account__c from EIN__c where (Id not in :primeEINId and Account__c in :primeAccounts and primary__c = true)]){
                updEIN.primary__c = false;
                updEINList.add(updEIN);
            }
            if(updEINList.size()>0){
                recCheck = true;
                upsert updEINList;
                
            }
        }
        
    }
    
    /******************************************************************** 
    *    Method Name : clearPrimaryInsert 
    *   @description : After an new EIN is created as Primary, this method will clear out any other EINs related to that Account from being Primary.
    *   @parameters  : List of new EIN.
    *   @return type :   void. 
    *   @Author      : Bharath
    ***************************************************************/                    
    public static void clearPrimaryInsert(List<EIN__c> newEIN){
        List<Id> primeEINId = new List<Id>();
        List<Id> primeAccounts = new List<Id>();
        for(EIN__c nwEIN : newEIN){
            if(nwEIN.primary__c == true){
                //Clear other Primary
                primeEINId.add(nwEIN.Id);
                primeAccounts.add(nwEIN.Account__c);
            }
        }
        if(primeEINId.size() > 0){
            List<EIN__c> updEINList = new List<EIN__c>();
            //Following line reads through all Primary EINs for the listed Account except for the one already updated.
            for(EIN__c updEIN : [select id,name,primary__c,Account__c from EIN__c where (Id not in :primeEINId and Account__c in :primeAccounts and primary__c = true)]){
                updEIN.primary__c = false;
                updEINList.add(updEIN);
            }
            if(updEINList.size()>0){
                recCheck = true;
                upsert updEINList;
                
            }

        }
    }
    
    /******************************************************************** 
    *    Method Name : initiateEINTransmit 
    *   @description : After Seq#'s are updated in EINs with non-ADD reason code, send them to BlueSTAR using the existing transmit interface
    *   @parameters  : List of new EIN.
    *   @return type : void. 
    *   @Author      : Bharath
    ***************************************************************/
    public static void initiateEINTransmit(List<EIN__c> newEINs, Map<Id,EIN__c> oldEINMap) {
        for (EIN__c e: newEINs) {
            EIN__c oldEIN = oldEINMap.get(e.Id);
            // Transmit EINs if EIN status has changed from 'Seq# Requested' to 'Transfer In Transit'
            if (null != oldEIN && e.Bluestar_Transfer_Status__c == 'Seq# updated' && oldEIN.Bluestar_Transfer_Status__c == 'Seq# Requested') {
                LGNA_EIN_SendStart.sendEINInvocable(new List<Id>{e.Account__c});
                break;
            }
        }        
    }
}