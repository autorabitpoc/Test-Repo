/**************************************************************************************
  Apex Class Name     : GEMS_BenefitAgreementController
  Version             : 1.0
  Function            : This is a controller for adding Benefit aggrement section on Account Submission case
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------  
* Malathi.K           09/22/2017              SFDC-5584 Need to capture MHA if BCC is selected in Product.
* Malathi.K           09/27/2017              SFDC-6190 Include Health Advocacy Solutions (HAS) to the Product.   
* Ranjit Gandhi       5/29/2017               SFDC-2776 Shared Accums - Need to capture behavioral vendor information if behavioral health is selected in Products field in Benefit agreement section of Account submission process               
* Capgemini                 05/30/2016                Original Version
*************************************************************************************/

public with sharing class GEMS_BenefitAgreementController {
    public case caseRec {set;get;}
    public Boolean integrated {set;get;}
    public Boolean bank {set;get;}
    public Boolean vendor {set;get;}
    public Boolean rxVendor {set;get;}
    public Boolean BehavioralHealthVendor {set;get;}
    public Boolean BCC_Product {set;get;}
    public Boolean MHA_Product {set;get;} 
    public Boolean FSA_Product {set;get;}
    public Boolean displayCobra{get;set;}
    public Boolean displaySharedAcc{get;set;}
    public String productCategory;
    public boolean isError{get;set;}
    public Boolean BPAASOCheck{get;set;}
    public Boolean BPAASACheck{get;set;}
    public Boolean ILBPAAttach{get;set;}
    public GEMS_BenefitAgreementController(ApexPages.StandardController controller) {
        try {
            ID caseID = apexpages.currentpage().getparameters().get('id');
            System.debug('+caseID+++'+caseID);
            caseRec = [select id,Funding_Type_Multiselect__c,GEMS_Products__c,HCSC_Division__c,GEMS_X2017_IL_Unified_BPA_attached__c,GEMS_XSigned_2017_ASA_prior_BPA_attached__c ,GEMS_X2017_ASO_BPA_wRx_Benefits_attached__c,GEMS_Is_HCSC_Administering_COBRA__c,GEMS_Integrated__c,GEMS_BCC_Products__c,GEMS_MHA__c,GEMS_Behavioral_Health_Vendor__c,GEMS_Bank__c,GEMS_Private_Exchange__c,GEMS_Private_Exchange_Values__c,GEMS_Rx_Vendor__c,GEMS_Vendor__c, GEMS_Shared_Accums_Shared_With__c, GEMS_StdCust_Product__c from case where id =:caseID ];                    
            integrated = false;
            bank = false;
            rxVendor = false;
            BehavioralHealthVendor=false;   
            BCC_Product = false;
            MHA_Product = false; 
            FSA_Product=False;
            vendor = false;
            isError = false;
            BPAASOCheck =false;
            BPAASACheck=false;
            ILBPAAttach = false;
            checkProductCategory();         
        }
        catch(Exception ex) {
            System.debug('=====exception============'+ex);
            //GEMS_CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_BenefitAgreementController','High'); 
        }
        
    } 
    public void  checkProductCategory() {
        
        String[] producList;
        String[] rxList;
        String[] FundingTypeList;
        Set<String> productSet = new Set<String>();
        Set<String> rxSet = new Set<String>();
        Set<String> FundingtypeSet = new Set<String>();
        
        
      
        if(caseRec.GEMS_Products__c != null) {
            producList = caseRec.GEMS_Products__c.split(';');
            system.debug('**********************producList'+producList);
            //Set<String> productSet = new Set<String>();
            for( String str : producList){
                productSet.add(str);
            }
            
          /********************************Start check for HSA**************/
            if(caserec.GEMS_Integrated__c)
            {
                System.debug('caserec.GEMS_Integrated__c==>'+caserec.GEMS_Integrated__c);
                bank = true;
            }
            if(!caserec.GEMS_Integrated__c)
            {
                bank = false;
                caserec.GEMS_Bank__c='';
            }
            if (productSet.contains('HSA')) {
                integrated  = true;
            }
            
            /********************** Praveen Added***************/
            
            if(productSet.contains('COBRA'))
            {
                displayCobra=true;
            }
            if(!productSet.contains('COBRA'))
            {
                displayCobra=false;
                caserec.GEMS_Is_HCSC_Administering_COBRA__c=false;
            }
            if(productSet.contains('Shared Accums'))
            {
                displaySharedAcc=true;
            }
            if(!productSet.contains('Shared Accums'))
            {
                displaySharedAcc=false;
                caserec.GEMS_Shared_Accums_Shared_With__c='';
            }
            
            /***********************************************************/
            
            if (productSet.contains('HSA')) {
                System.debug('++GEMS_Integrated +'+caserec.GEMS_Integrated__c);
                integrated  = true;
            }
            if(!productSet.contains('HSA'))
            {
                integrated = false;
                bank = false;
                caserec.GEMS_Bank__c='';
                caserec.GEMS_Integrated__c=false;
            }          
            /*****************End of HSA Check*******************************/      
            
            
            if (productSet.contains('FSA')) {
                vendor = true;
            }
            if (!productSet.contains('FSA'))
            {
                vendor = false;
                caseRec.GEMS_Vendor__c = '';
            }      
            /***************************************/      

            //if (productSet.contains('EPO') || productSet.contains('RX') ) {
            
            if (productSet.contains('RX'))  {
                rxVendor = true;
                if(caseRec.GEMS_Rx_Vendor__c == null || caseRec.GEMS_Rx_Vendor__c == '') caseRec.GEMS_Rx_Vendor__c='Prime';
           }
            
            //if(!(productSet.contains('EPO') || productSet.contains('RX') ))
            
            if(!(productSet.contains('RX') ))
            {
                rxVendor = false; 
                caseRec.GEMS_Rx_Vendor__c = '';
                //caseRec.GEMS_Rx_Vendor__c='';
            }       
            
            /***************************************/      

                //System.debug('caseRec.GEMS_Behavioral_Health_Vendor__c ==>'+caseRec.GEMS_Behavioral_Health_Vendor__c ); 
            if (productSet.contains('Behavioral Health') && productSet.contains('Shared Accums'))  {                 
                BehavioralHealthVendor = true;
                
           }
            
            //if(!(productSet.contains('EPO') || productSet.contains('RX') ))
            
            if(!((productSet.contains('Behavioral Health') && productSet.contains('Shared Accums'))  ))
            {
                BehavioralHealthVendor = false; 
                caseRec.GEMS_Behavioral_Health_Vendor__c = '';
                
            }       
            
            /********************************************/    
            if (ProductSet.contains('BCC') || ProductSet.contains('Blue Care Connection')) {
                BCC_Product = true;
            }          
            else
            {
                BCC_Product = false;
                caserec.GEMS_BCC_Products__c='';           
            }
            // SFDC-5584 Display MHA if BCC is selected in Product.
             if (ProductSet.contains('BCC') ) {
                MHA_Product = true;
            }          
            else
            {
                MHA_Product = false;
                caserec.GEMS_MHA__c= false;           
            }
                              
           // SFDC-6190 Default BCC Product for Health Advocacy Solutions.
                        
             if (productSet.contains('BCC') && productSet.contains('Health Advocacy Solutions'))  {                 
                BehavioralHealthVendor = true;
                caserec.GEMS_BCC_Products__c = 'Selective I/O';
           }           
            
            /********************************************/   
            System.debug('bank==>'+bank);      
        }        
        if(caseRec.Funding_Type_Multiselect__c != null && caseRec.GEMS_Rx_Vendor__c != null){
            FundingTypeList = caserec.Funding_Type_Multiselect__c.split(';');
            rxList = caserec.GEMS_Rx_Vendor__c.split(';');
            
            for( String str1 : FundingTypeList){
                FundingtypeSet.add(str1);
            }
            for( String str2 : rxList){
                rxSet.add(str2);
            }
            if(rxVendor && rxSet.contains('Prime'))
            {
                if(FundingtypeSet.contains('Cost Plus') && caserec.HCSC_Division__c =='IL')
                {
                    ILBPAAttach=true;
                }
                else if(!FundingtypeSet.contains('Cost Plus') || caserec.HCSC_Division__c !='IL')
                {
                    ILBPAAttach=false;
                    caseRec.GEMS_X2017_IL_Unified_BPA_attached__c='';
                }
                
                if(FundingtypeSet.contains('ASO') && (caserec.HCSC_Division__c !=null && (caserec.HCSC_Division__c =='IL' ||caserec.HCSC_Division__c =='TX' || caserec.HCSC_Division__c =='NM' ||caserec.HCSC_Division__c =='MT'||caserec.HCSC_Division__c =='OK')))
                {
                    BPAASOCheck=true;
                }
                else if(!FundingtypeSet.contains('ASO') || (caserec.HCSC_Division__c !='IL' ||caserec.HCSC_Division__c !='TX' || caserec.HCSC_Division__c !='NM' ||caserec.HCSC_Division__c !='MT'||caserec.HCSC_Division__c !='OK'))
                {
                    BPAASOCheck=false;
                    caseRec.GEMS_X2017_ASO_BPA_wRx_Benefits_attached__c='';
                }
                
                if(FundingtypeSet.contains('ASO') && BPAASOCheck && caseRec.GEMS_X2017_ASO_BPA_wRx_Benefits_attached__c == 'No' && (caserec.HCSC_Division__c !=null && (caserec.HCSC_Division__c =='IL' ||caserec.HCSC_Division__c =='TX' || caserec.HCSC_Division__c =='NM' ||caserec.HCSC_Division__c =='MT'||caserec.HCSC_Division__c =='OK')))
                {
                    BPAASACheck=true;
                }
                else if(!FundingtypeSet.contains('ASO') || (caserec.HCSC_Division__c !='IL' ||caserec.HCSC_Division__c !='TX' || caserec.HCSC_Division__c !='NM' ||caserec.HCSC_Division__c !='MT'||caserec.HCSC_Division__c !='OK' || caseRec.GEMS_X2017_ASO_BPA_wRx_Benefits_attached__c != 'No'))
                {
                    BPAASACheck=false;
                    caseRec.GEMS_XSigned_2017_ASA_prior_BPA_attached__c ='';
                }
            }
            else
            {
                BPAASOCheck=false;
                ILBPAAttach=false;
                BPAASACheck=false;
                caseRec.GEMS_X2017_IL_Unified_BPA_attached__c='';
                caseRec.GEMS_X2017_ASO_BPA_wRx_Benefits_attached__c='';
                caseRec.GEMS_XSigned_2017_ASA_prior_BPA_attached__c ='';
            }
            
        }
        
        /********Else condition for Product List is empty*********/      
        else
        {
            integrated = false;
            bank = false;
            rxVendor = false;
            BehavioralHealthVendor=false;
            BCC_Product = false;
            vendor = false;
        }
    }
    
    public pagereference Save1() {
        //caseRec.GEMS_Products__c = productCategory + ';'+ caseRec .GEMS_Products__c;
        System.debug('+++caseRec.GEMS_Products__c+'+caseRec.GEMS_Products__c);
        try {
            isError = false;
            /*
            if(caseRec.GEMS_StdCust_Product__c =='' || caseRec.GEMS_StdCust_Product__c == null || caseRec.GEMS_StdCust_Product__c=='--None--')
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select "Is Standard Product Only?"');
                ApexPages.addMessage(myMsg);
                isError = true;
            }
            */
            String productss = caseRec.GEMS_Products__c;
            if(productss != null && productss != '') {
                List<String> productsList = productss.split(';');
                String errorMessage='';
                
                for(String productName : productsList ) {
                    if(productName == 'FSA' && caseRec.GEMS_Vendor__c == null) {            
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'FSA Vendor should not be empty when FSA selected');
                        ApexPages.addMessage(myMsg);
                        isError = true;
                    }
                    //comment below code as part of october release
                    /*if(productName == 'HSA' && caseRec.GEMS_Integrated__c == false ) {            
                        isError = true;
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'HSA Integrated should be checked when HSA selected');
                        ApexPages.addMessage(myMsg);
                    } 
                    
                    if(productName == 'HSA' && caseRec.GEMS_Integrated__c == true && caseRec.GEMS_Bank__c == null) {            
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'HSA Bank Vendor should not be empty');
                        ApexPages.addMessage(myMsg);
                        isError = true;
                    */
                    /*****************Praveen Added************************/
                    if(productName == 'COBRA' && caseRec.GEMS_Is_HCSC_Administering_COBRA__c==false)
                    {
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Is HCSC Administering COBRA? has to be checked');
                        ApexPages.addMessage(myMsg);
                        isError = true;
                    }
                    if(productName == 'BCC' && (caseRec.GEMS_BCC_Products__c==null || caseRec.GEMS_BCC_Products__c=='' ))
                    {
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'When BCC Product is selected in Products, please select a value in BCC Prodcts');
                        ApexPages.addMessage(myMsg);
                        isError = true;
                    }
                    //SFDC-6190 Display error when 'Health Advocacy Solutions' is selected and 'BCC' is not selected in products list
                    if(productName == 'Health Advocacy Solutions' && !(productss.contains('BCC') ))
                    {
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'When Health Advocacy Solutions Product is selected in Products, please select BCC too along with it.');
                        ApexPages.addMessage(myMsg);
                        isError = true;
                    }                                        
                    
                     if(productName == 'Health Advocacy Solutions' && (caseRec.GEMS_BCC_Products__c != 'Selective I/O'))
                    {
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'When Health Advocacy Solutions is selected as a product, BCC Product should only be Selective I/O.');
                        ApexPages.addMessage(myMsg);
                        isError = true;
                    }                                        
                    /*if(productName == 'Shared Accums' && caseRec.GEMS_Shared_Accums_Shared_With__c == null ) {            
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'"Accums Shared With" should be selected when HSA selected');
                        ApexPages.addMessage(myMsg);
                        isError = true;
                    }*/
                    /******************************************************/         
                }
            }
            
            if(!isError) {
                update caseRec;
                isError = false;
            }
            System.debug('++caseRec+++'+caseRec);
            
            //added to refresh the compelte page
            //PageReference pageRef = new PageReference('/' + ApexPages.currentPage().getParameters().get('id') );
           //return null;
          //return pageRef;
    
        }
        Catch(Exception ex) {
            GEMS_CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_BenefitAgreementController.Save()','High'); 
            return null;
        }
        return null; 
    }
    /*
    public pagereference CancelAccSubCase() {
        
        try {
            List<Case> casesToUpdate = new List<Case>();
            Id caseGEMSGetRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS GET').getRecordTypeId();
            List<Case> getCasesList = [select id,status,subject,recordTypeId from case where GEMS_Account_Submission_Info__c =: caseRec.Id and recordTypeId =:caseGEMSGetRecordTypeId];
            if(getCasesList != null && !getCasesList.isEmpty()) {
                getCasesList[0].status = 'Cancelled';
                casesToUpdate.add(getCasesList[0]);
            }
            caseRec.Status='Cancelled';
            casesToUpdate.add(caseRec);
            
            update casesToUpdate;
        }
        Catch(Exception ex)
        {
            GEMS_CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_BenefitAgreementController.CancelAccSubCase()','High');
            return null;
        }
        return null;
    }
    */
}