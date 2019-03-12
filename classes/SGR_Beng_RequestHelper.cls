/*
*   11/27/2018  Luke Chen       SFDC-14848 SGR-BEngaged: Create request to call B-Engaged
*/
public class SGR_Beng_RequestHelper { 
    private static Id ProducerTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Producer Account').getRecordTypeId();
    private SGR_Beng_XML_TemplateDAO bengDAO = null;
    private Id oppId;
    private Boolean isSTNRate = true;  // standard/composite rate or age rate
    private Date effectiveDate = null;
    private Set<Id> planGroupIds = null;

    // constructor - run all queries to collect data from tables
    public SGR_Beng_RequestHelper(SGR_Beng_XML_TemplateDAO xmlDAO){
        // xmlDAO is a data holder to pass in input data
        String correspondenceId=xmlDAO.correspondenceId; 
        String docVer=xmlDAO.docVer;
        String printType = xmlDAO.printType==null?'Account':xmlDAO.printType;  // Producer, Account, GA; default='Account'
        this.oppId = xmlDAO.oppId;
        try{
            // bengDAO is for internal use to hold all query data
            bengDAO = new SGR_Beng_XML_TemplateDAO();
            bengDAO.docVer = docVer; bengDAO.correspondenceId = correspondenceId;
            // get Opportunity records
            bengDAO.opportunity = [select Id,Requested_Effective_Date__c,Renewal_Date__c,Effective_Month__c,HCSC_Division__c,County_Name__c,Zip_Code__c,FIPS_Code__c,SGR_Opportunity_Auto_Number__c,account.Primary_Producer_Account__r.name,Special_Eligibility__c,
                                  Total_Medical_Monthly_Premium__c, Total_Dental_Monthly_Premium__c, Total_Vision_Monthly_Premium__c,Total_Est_Medical_Insurer_Fees__c, Total_Est_Dental_Insurer_Fees__c, Total_Est_Vision_Insurer_Fees__c,account.External_ID__c,
                                  Submit_Date__c,Days_To_Submit__c,Expected_Dental_Members__c,Account_Market_Segment__c,Opportunity_Number__c,account.Id,account.name,account.AccountNumber,account.Line_of_business__c, 
                                  account.primary_contact_name__c,account.ShippingStreet,account.ShippingCity,account.ShippingState,account.ShippingPostalCode 
                                  from opportunity where Id = :oppId limit 1];
            if(bengDAO.opportunity.Renewal_Date__c == null) throw new SGR_Exception('Opportunity Renewal_Date__c is null !!!');
            // always use the 1st day of the month where the Opportunity Renewal_Date__c is in as the requirement to pick up child records
            effectiveDate=Date.newInstance(bengDAO.opportunity.Renewal_Date__c.year(), bengDAO.opportunity.Renewal_Date__c.month(), 1);
            // assign recipient data into a contact as data holder
            Contact c1 = new Contact();
		    c1.firstname = bengDAO.opportunity.account.primary_contact_name__c; c1.lastname = '';
		    c1.MailingStreet=bengDAO.opportunity.account.ShippingStreet; c1.MailingCity=bengDAO.opportunity.account.ShippingCity;
		    c1.MailingState=bengDAO.opportunity.account.ShippingState; c1.MailingPostalCode=bengDAO.opportunity.account.ShippingPostalCode;                      
            bengDAO.primaryContact = c1;
            bengDAO.adminContact =c1;
            // get contact records
           /* List<Contact> contacts = [select Id,MailingAddress,name,Primary__c,Type__c from contact where Accountid  = :bengDAO.opportunity.account.Id];
            system.debug('>>>> contact #:' + contacts.size());
            for(Contact c : contacts){
               // if(c.Primary__c) bengDAO.primaryContact = c;
                if(c.Type__c == 'Renewal') bengDAO.adminContact = c;
                // #TODO
                // bengDAO.rep
                // bengDAO.agent
            }*/
            bengDAO.rep = 'Small Group Account Management';
            bengDAO.agent = bengDAO.opportunity.account.Primary_Producer_Account__r.name==null?'N/A':bengDAO.opportunity.account.Primary_Producer_Account__r.name;
            if(bengDAO.adminContact == null) bengDAO.adminContact = bengDAO.primaryContact; // use primary if there's no admin
            // get producer numbers
            // List<Producer_Group_Association__c> pAccts = [select Id,Group_Account__c,Producer_Account__r.Type,Producer_Account__r.National_Producer_Number__c,Producer_Account__r.Producer_Number__c,
            //     Producer_Account__r.recordTypeId,Producer_Account__r.name,Producer_Account__r.ShippingAddress from Producer_Group_Association__c where Group_Account__c = :bengDAO.opportunity.account.Id];
            List<Producer_Association_For_Opportunity__c> pAccts = [select id,Producer_Consultant__c,Account_Type__c,Producer_Consultant__r.National_Producer_Number__c,Producer_Consultant__r.Producer_Number__c,Producer_Consultant__r.recordTypeId,Producer_Consultant__r.name,Producer_Consultant__r.ShippingAddress,Producer_Consultant__r.Type from Producer_Association_For_Opportunity__c where Opportunity__c = :bengDAO.opportunity.id];
            system.debug('>>>> Producer_Association_For_Opportunity__c #:' + pAccts.size());
            List<Contact> producerConts = new List<Contact>();
            // get recipient name and address according to printType='Account', 'Producer' or 'GA',             
            for(Producer_Association_For_Opportunity__c p : pAccts){
                if(p.Producer_Consultant__r.recordTypeId != ProducerTypeId) continue;
                if(p.Producer_Consultant__r.Type == 'Producer'){
                    bengDAO.npnProducer=p.Producer_Consultant__r.National_Producer_Number__c;bengDAO.pnProducer=p.Producer_Consultant__r.Producer_Number__c;
                    if(printType=='Producer'){
                        bengDAO.recipient=p.Producer_Consultant__r.name;setMailAddress(p.Producer_Consultant__r.ShippingAddress, bengDAO.mailingAddr);
                        producerConts=[select Id,MailingAddress,name,Primary__c,Type__c from contact where Accountid = :p.Producer_Consultant__c];
                        system.debug('>>>> contact #:' + producerConts.size());
                    }
                }else if(p.Account_Type__c == 'Sub Producer'){
                    bengDAO.npnSubProd=p.Producer_Consultant__r.National_Producer_Number__c;bengDAO.pnSubProd=p.Producer_Consultant__r.Producer_Number__c;
                }
                else if(p.Account_Type__c == 'General Agent'){
                    bengDAO.npnGenAgent=p.Producer_Consultant__r.National_Producer_Number__c;bengDAO.pnGenAgent=p.Producer_Consultant__r.Producer_Number__c;
                    if(printType=='GA'){
                        bengDAO.recipient=p.Producer_Consultant__r.name;setMailAddress(p.Producer_Consultant__r.ShippingAddress, bengDAO.mailingAddr);
                        producerConts=[select Id,MailingAddress,name,Primary__c,Type__c from contact where Accountid = :p.Producer_Consultant__c];
                        system.debug('>>>> contact #:' + producerConts.size());
                    }
                }
            }
            if(printType=='Account' && bengDAO.primaryContact != null){
                bengDAO.recipient = (bengDAO.primaryContact.name==null ? '' : bengDAO.primaryContact.name);
                setMailAddress(bengDAO.primaryContact.MailingAddress, bengDAO.mailingAddr);
            }else{
                // producer or GA for recipient and mail address
                bengDAO.primaryContact=null;
                //Navya: Receiving error "Attempt to de-reference a null object" so checking the size of producerConts list
                if(producerConts.size()>0){
                    for(Contact c : producerConts) if(c.Primary__c) bengDAO.primaryContact = c;
                }
                if(bengDAO.primaryContact==null){
                    bengDAO.recipient = '';
                    setMailAddress(null, bengDAO.mailingAddr);
                }else{
                    bengDAO.recipient = bengDAO.primaryContact.name;
                    setMailAddress(bengDAO.primaryContact.MailingAddress, bengDAO.mailingAddr);
                }
            }
            // SGR_Lowest_Cost_Plan_Option__c
            List<SGR_Lowest_Cost_Plan_Option__c> opt2_3List = [select Division__c,Type__c,RenewalEffectiveDate__c,
            						LowestCostOption2__c,LowestCostOption2__r.Name,LowestCostOption2__r.Marketing_Plan_Number__c,LowestCostOption2__r.Network__c,LowestCostOption2__r.Plan_Level__c,LowestCostOption2__r.Product_Name__c,LowestCostOption2__r.Level_1_Product_Name__c,LowestCostOption2__r.Level_2_Product_Name__c,LowestCostOption2__r.Level_1_Product__c,LowestCostOption2__r.Level_2_Product__c,LowestCostOption2__r.Product__c,
            						LowestCostOption3__c,LowestCostOption3__r.Name,LowestCostOption3__r.Marketing_Plan_Number__c,LowestCostOption3__r.Network__c,LowestCostOption3__r.Plan_Level__c,LowestCostOption3__r.Product_Name__c,LowestCostOption3__r.Level_1_Product_Name__c,LowestCostOption3__r.Level_2_Product_Name__c,LowestCostOption3__r.Level_1_Product__c,LowestCostOption3__r.Level_2_Product__c,LowestCostOption3__r.Product__c  
            						from SGR_Lowest_Cost_Plan_Option__c where Type__c='Medical' and Division__c=:bengDAO.opportunity.HCSC_Division__c and RenewalEffectiveDate__c <= :bengDAO.opportunity.Renewal_Date__c order by RenewalEffectiveDate__c desc];
            system.debug('>>>> SGR_Lowest_Cost_Plan_Option__c #:' + opt2_3List.size());
            if(!opt2_3List.isEmpty()){
            	// bengDAO.opt2, bengDAO.opt3 of Plan__c
            	bengDAO.opt2 = new Plan__c(); bengDAO.opt3 = new Plan__c();
            	bengDAO.opt2.id=opt2_3List[0].LowestCostOption2__c;
            	bengDAO.opt2.Name=opt2_3List[0].LowestCostOption2__r.Name;
            	bengDAO.opt2.Marketing_Plan_Number__c=opt2_3List[0].LowestCostOption2__r.Marketing_Plan_Number__c;
            	bengDAO.opt2.Network__c=opt2_3List[0].LowestCostOption2__r.Network__c;
            	bengDAO.opt2.Plan_Level__c=opt2_3List[0].LowestCostOption2__r.Plan_Level__c;
            	bengDAO.opt2.Product_Name__c=opt2_3List[0].LowestCostOption2__r.Product_Name__c;
            	bengDAO.opt2.Level_1_Product_Name__c=opt2_3List[0].LowestCostOption2__r.Level_1_Product_Name__c;
            	bengDAO.opt2.Level_2_Product_Name__c=opt2_3List[0].LowestCostOption2__r.Level_2_Product_Name__c;
            	bengDAO.opt2.Level_1_Product__c=opt2_3List[0].LowestCostOption2__r.Level_1_Product__c;
            	bengDAO.opt2.Level_2_Product__c=opt2_3List[0].LowestCostOption2__r.Level_2_Product__c;
            	bengDAO.opt2.Product__c=opt2_3List[0].LowestCostOption2__r.Product__c;
            	bengDAO.opt3.id=opt2_3List[0].LowestCostOption3__c;
            	bengDAO.opt3.Name=opt2_3List[0].LowestCostOption3__r.Name;
            	bengDAO.opt3.Marketing_Plan_Number__c=opt2_3List[0].LowestCostOption3__r.Marketing_Plan_Number__c;
            	bengDAO.opt3.Network__c=opt2_3List[0].LowestCostOption3__r.Network__c;
            	bengDAO.opt3.Plan_Level__c=opt2_3List[0].LowestCostOption3__r.Plan_Level__c;
            	bengDAO.opt3.Product_Name__c=opt2_3List[0].LowestCostOption3__r.Product_Name__c;
            	bengDAO.opt3.Level_1_Product_Name__c=opt2_3List[0].LowestCostOption3__r.Level_1_Product_Name__c;
            	bengDAO.opt3.Level_2_Product_Name__c=opt2_3List[0].LowestCostOption3__r.Level_2_Product_Name__c;
            	bengDAO.opt3.Level_1_Product__c=opt2_3List[0].LowestCostOption3__r.Level_1_Product__c;
            	bengDAO.opt3.Level_2_Product__c=opt2_3List[0].LowestCostOption3__r.Level_2_Product__c;
            	bengDAO.opt3.Product__c=opt2_3List[0].LowestCostOption3__r.Product__c;
            }            
            // get Census records
            bengDAO.oppCensuses = new Map<Id,SGR_Opportunity_Census__c>([select Id,Age__c,First_Name__c,Last_Name__c,Date_of_Birth__c,State__c,Relationship__c,Row__c,Health_Tier__c,Health_Plan_ID__c,Dental_Tier__c,Dental_Plan_ID__c,Vision_Tier__c,Vision_Plan_ID__c from SGR_Opportunity_Census__c where Opportunity__c = :oppId order by row__c]);
            system.debug('>>>> SGR_Opportunity_Census__c #:' + bengDAO.oppCensuses.size());
            // get member benefit records
            bengDAO.memberBenefits = new Map<Id,SGR_Opportunity_Member_Benefits__c>([select id,Opportunity_Census__c,Opportunity_Plan_Rate__c,Relationship_Code__c,Age_Total_Employee_Rate__c,Renw_Age_Gross_Premium__c,Renw_Comp_Gross_Premium__c,Member_Policy_Tier__c,
            					Opt2_Age_Total_All_Rate__c,Opt2_Age_Total_Child_Rate__c,Opt2_Age_Total_Employee_Rate__c,Opt2_Age_Total_Spouse_Rate__c,Opt3_Age_Total_All_Rate__c,Opt3_Age_Total_Child_Rate__c,Opt3_Age_Total_Employee_Rate__c,Opt3_Age_Total_Spouse_Rate__c,Tier_Code__c,Opt2_Renw_Comp_Total_Monthly_Premium__c,Opt3_Renw_Comp_Total_Monthly_Premium__c,
                                Age_Total_Spouse_Rate__c,Age_Total_Child_Rate__c,Renw_Age_Total_Monthly_Premium__c from SGR_Opportunity_Member_Benefits__c where Opportunity_Census__c in :bengDAO.oppCensuses.keySet()]);
            system.debug('>>>> SGR_Opportunity_Member_Benefits__c #:' + bengDAO.memberBenefits.size());
            // Opportunity Plan Rate and plan
            // Medical -
            // (Level 1) Network = Plan__c.Network__c, e.g. PPO, HMO
            // (Level 2) Plan Type = Plan__c.Level_2_Product_Name__c, e.g. PPO Plans, HMO Plans
            // (Level 3) Metallic Level = Plan__c.Plan_Level__c, e.g. Gold, Silver
            // Dental -
            // (Level 1) Plan__c.Level_1_Product_Name__c, e.g. Dental Plans, only 1 record
            // (Level 2) Plan__c.Level_2_Product_Name__c, e.g. Contributory Group and Voluntary Group, only 2 records
            // (Level 3) Plan__c.Product_Name__c, e.g. High Coverage Allocation and Low Coverage Allocation, only 2 records
            // Vision -
            // (Level 1) Plan__c.Level_1_Product_Name__c, e.g. Vision Plans, only 1 record
            // (Level 2) Plan__c.Level_2_Product_Name__c, e.g. PREFERRED and PREMIER, only 2 records
            // (Level 3) null, no level 3 plan group
            bengDAO.planRates = new Map<Id,SGR_Opportunity_Plan_Rate__c>([select id,Name,Type__c,Sales_Plan_ID__c,Plan_Name__c,Coverage_Type__c,Rate_Type_Code__c,Plan__r.Line_Of_Business__c,Plan__r.description__c,
            					Plan__c,Plan__r.Name,Plan__r.Marketing_Plan_Number__c,Plan__r.Network__c,Plan__r.Plan_Level__c,Plan__r.Product_Name__c,Plan__r.Level_1_Product_Name__c,Plan__r.Level_2_Product_Name__c,Plan__r.Level_1_Product__c,Plan__r.Level_2_Product__c,Plan__r.Product__c,
                                Opt2_Plan_Id__c,Opt2_Renw_Age_Total_Est_Tax_and_Fees__c,Opt2_Renw_Age_Total_Monthly_Premium__c,Opt2_Renw_Comp_Total_Monthly_Premium__c,
                                Opt3_Plan_Id__c,Opt3_Renw_Age_Total_Est_Tax_and_Fees__c,Opt3_Renw_Age_Total_Monthly_Premium__c,Opt3_Renw_Comp_Total_Monthly_Premium__c,          					
                                Current_Age_Total_Monthly_Premium__c,Current_Comp_Total_Monthly_Premium__c,Current_Comp_Total_Est_Tax_and_Fees__c,Current_Age_Total_Est_Tax_and_Fees__c,
                                Renw_Age_Total_Monthly_Premium__c,Renw_Comp_Total_Monthly_Premium__c,Renw_Comp_Total_Est_Tax_and_Fees__c,Renw_Age_Total_Est_Tax_and_Fees__c,
                                Member_Premium__c,Enrolled_Subscriber_Count__c,Mapping_From_Plan_Id__c,Rate_Size_Code__c from SGR_Opportunity_Plan_Rate__c where Opportunity__c = :oppId and Plan_Status__c != 'Cancelled']);
            system.debug('>>>> SGR_Opportunity_Plan_Rate__c #:' + bengDAO.planRates.size());
            // Plan ID set
            bengDAO.planIds = new Set<Id>();
            planGroupIds = new Set<Id>();
            if(!bengDAO.planRates.isEmpty()){
                for(SGR_Opportunity_Plan_Rate__c pr : bengDAO.planRates.values()) {
                    bengDAO.planIds.add(pr.Plan__c);
                    addPGId(planGroupIds,pr);
                }}
            system.debug('>>>> Plan #:' + bengDAO.planIds.size());
            // Opportunity Plan Composite Rate
            bengDAO.planCompRates = new Map<Id,SGR_Opportunity_Plan_Composite_Rate__c>([select id,Opportunity_Plan_Rate__c,Tier_Code__c,Gross_Premium__c,Opportunity_Plan_Rate__r.Coverage_Type__c,Total_Monthly_Premium__c,Total_Estimated_Taxes_and_Fees__c from SGR_Opportunity_Plan_Composite_Rate__c where Opportunity_Plan_Rate__c in :bengDAO.planRates.keySet()]);
            system.debug('>>>> SGR_Opportunity_Plan_Composite_Rate__c #:' + bengDAO.planCompRates.size());
            // Plan Age Rate Detail
            bengDAO.ageRateDetails = new Map<Id,SGR_Plan_Age_Rate_Detail__c>([select id,name,Gross_Premium__c,Age_Rate_Header__c,From_Age__c,To_Age__c,Age_Rate_Header__r.Plan__c,Age_Rate_Header__r.FIPS_Code__c 
                                     from SGR_Plan_Age_Rate_Detail__c where Age_Rate_Header__r.Plan__c in :bengDAO.planIds and Age_Rate_Header__r.FIPS_Code__c = :bengDAO.opportunity.FIPS_Code__c and Relationship_Code__c = 'PR' and Is_TEFRA__c = false and Is_Tobacco__c = false
                                     and  Age_Rate_Header__r.Rate_Effective_Date__c = :effectiveDate order by To_Age__c asc]);
            system.debug('>>>> SGR_Plan_Age_Rate_Detail__c #:' + bengDAO.ageRateDetails.size());
            // Benefit header detail, include the option2/3 ID for lookup purpose for plan benefits
            Set<Id> planAndOptIds = new Set<Id>(bengDAO.planIds); planAndOptIds.add(bengDAO.opt2.id); planAndOptIds.add(bengDAO.opt3.id); 
            bengDAO.benefitHDAs = new Map<Id,Benefit_Header_Detail_Association__c>([select id,name,Benefit_Header_Detail__c,Benefit_Header_Detail__r.name,Benefit_Header_Detail__r.Value__c,Benefit_Header_Detail__r.Benefit_Header_Detail_Name__c, Plan__c from Benefit_Header_Detail_Association__c where Plan__c in :planAndOptIds and Effective_Date__c = :effectiveDate]);
            system.debug('>>>> Benefit_Header_Detail_Association__c #:' + bengDAO.benefitHDAs.size());
            /* Remove, no more plan group
            List<Plan__c> plans = [select id,Plan_Group_Level1__c,Plan_Group_Level2__c,Plan_Group_Level3__c from Plan__c where id in :bengDAO.planIds];
            Set<Id> planGroupIds = new Set<Id>();
            for(Plan__c p : plans){
                if(p.Plan_Group_Level1__c != null) planGroupIds.add(p.Plan_Group_Level1__c);
                if(p.Plan_Group_Level2__c != null) planGroupIds.add(p.Plan_Group_Level2__c);
                if(p.Plan_Group_Level3__c != null) planGroupIds.add(p.Plan_Group_Level3__c);
            } */
            // Note Details
            bengDAO.noteDetailAs = new Map<Id,Product_Note_Detail_Association__c>([select id,Plan_Note_Detail__c,Product__c,Mapped_Note_Detail_Id__c,Mapped_Product_Key__c,Plan_Note_Detail__r.Symbol__c,Plan_Note_Detail__r.Text__c,Plan_Note_Detail__r.name,Effective_Date__c from Product_Note_Detail_Association__c where Product__c in :planGroupIds and Effective_Date__c = :effectiveDate]);
            system.debug('>>>> Product_Note_Detail_Association__c #:' + bengDAO.noteDetailAs.size());
            bengDAO.noteAs = new Map<Id,Plan_Note_Association__c>([select id,Plan__c,Mapped_Note_Id__c,Plan_Note__c,Plan_Note__r.Symbol__c,Plan_Note__r.name from Plan_Note_Association__c where Plan__c in :bengDAO.planIds and Effective_Date__c = :effectiveDate]);
        	system.debug('>>>> Plan_Note_Association__c #:' + bengDAO.noteAs.size());
        }catch (Exception e){
          bengDAO = null;
          system.debug('Line#: '+ e.getLineNumber() + ' - SGR_Beng_RequestHelper() constructor exception: '+e);
          throw e;  
        }

    }
    
    // create XML string from data in SGR_Beng_XML_TemplateDAO 
    public String generateXML(){
        if(bengDAO == null){
            system.debug('No data in SGR_Beng_XML_TemplateDAO instance. Please check if SGR_Beng_XML_TemplateDAO is instantiated correctly.');
            return null;
        }
        try{
            // determine if plans are Composite or Age rated, one opportunity should have plans with the same rate so we just check the first plan rate
            if(!bengDAO.planRates.isEmpty()){
                String rateType = bengDAO.planRates.values()[0].Rate_Type_Code__c;
                if(rateType != null && rateType.trim().toUpperCase() == 'AGE') isSTNRate=false;
            }
            // determine which Eligibility is suppressed. Use Integer variable, suppresed, among code to determine which plans are suppressed
            // Health = Medical = 1
            // Dental = Dental = 2
            // Both = Medical/Dental = 3
            // anything else = nothing suppressed = 0
            Integer suppressed = 0;
            String supEli = bengDAO.opportunity.Special_Eligibility__c;
            if(supEli=='Health') suppressed = 1; else if(supEli=='Dental') suppressed = 2; else if(supEli=='Both') suppressed = 3;

            Date reqDate = system.today();
            String todayString = getYYYYMMDD(reqDate);  // e.g. 12202018
            XmlStreamWriter w = new XmlStreamWriter();
            w.writeStartDocument(null, '1.0');
            w.writeStartElement(null, 'mcc_output', null); // start <mcc_output> element
            // ************* global_mcc_section ************************************
            w.writeStartElement(null, 'global_mcc_section', null); // start <global_mcc_section> element
            addXmlElement(w, 'file_name', 'Renewals_Input');  
            addXmlElement(w, 'source_system', 'Salesforce'); 
            addXmlElement(w, 'env', GEMS_Utility.getEnvAbbrName()=='PR'?'PROD':'UAT');  // <> #Luke FIX
            w.writeStartElement(null, 'correspondence_count', null); // start <correspondence_count> element
            addXmlElement(w, 'total_input_count', '');   
            addXmlElement(w, 'total_output_count', '');  
            addXmlElement(w, 'cc_count', '');  
            addXmlElement(w, 'original', '');  
            addXmlElement(w, 'error_count', '');  
            w.writeEndElement(); // end <correspondence_count> element
            w.writeEndElement(); // end <global_mcc_section> element
            // ************ correspondence ****************************************
            w.writeStartElement(null, 'correspondence', null); // start <correspondence> element
            // *************** correspondence > mcc_section ****************
            w.writeStartElement(null, 'mcc_section', null); // start <mcc_section> element
            addXmlElement(w, 'tracking_db_key', ''); 
            addXmlElement(w, 'letter_code', 'Renewal');  
            addXmlElement(w, 'state_cd', bengDAO.opportunity.HCSC_Division__c);  // <state_cd>
            addXmlElement(w, 'corp_ind', bengDAO.opportunity.HCSC_Division__c + '1'); 
            addXmlElement(w, 'processing_date', todayString);
            addXmlElement(w, 'primary_delivery_channel', '');  
            addXmlElement(w, 'secondary_delivery_channel', '');  
            addXmlElement(w, 'business_type', 'GROUP');  // <> #Luke FIX
            addXmlElement(w, 'print_flag', bengDAO.docVer=='PRINT'?'Y':'N'); 
            addXmlElement(w, 'draft_ind', bengDAO.docVer=='DRAFT'?'Y':'N'); 
            addXmlElement(w, 'correspondence_id', bengDAO.correspondenceId); 
            w.writeEndElement();  // end <mcc_section> element          
            // *********** correspondence > ucr **********************************************
            w.writeStartElement(null, 'ucr', null); // start <ucr> element
            addXmlElement(w, 'market_segment', bengDAO.opportunity.Account_Market_Segment__c); 
            addXmlElement(w, 'bluestar_segment', 'SG');  // <> #Luke FIX
            addXmlElement(w, 'doc_description', 'Renewals_Input');  
            addXmlElement(w, 'second_description', 'Renewals_Input');  
            addXmlElement(w, 'opportunity_id', bengDAO.opportunity.SGR_Opportunity_Auto_Number__c); 
            addXmlElement(w, 'number_npn', bengDAO.npnProducer);  
            addXmlElement(w, 'number_general_agent', bengDAO.pnGenAgent);  
            addXmlElement(w, 'number_sub_producer', bengDAO.pnSubProd);  
            addXmlElement(w, 'license_number', '');  
            addXmlElement(w, 'file_id', bengDAO.correspondenceId);  
            w.writeEndElement();  // end <ucr> element  
            // *********** correspondence > recipient_section *********************
            w.writeStartElement(null, 'recipient_section', null); // start <recipient_section> element
            w.writeStartElement(null, 'full_name', null); // start <full_name> element
            String fname = '', lname = '', fullname = bengDAO.recipient==null?'':bengDAO.recipient;
            w.writeCharacters(fullname); // recipient name
            fullname = fullname.trim();
            if(fullname.containsWhitespace()){
                fname = fullname.substring(0,fullname.indexOf(' '));
                lname = fullname.substring(fullname.lastIndexOf(' '),fullname.length());
            }else fname = lname = fullname;
            w.writeEndElement(); // end <full_name> element
            addXmlElement(w, 'first_name', fname);
            addXmlElement(w, 'last_name', lname);
            w.writeStartElement(null, 'address', null);  // start <address> element     
            addXmlElement(w, 'isForeign', 'N');  
            addXmlElement(w, 'street_addr_1', bengDAO.mailingAddr.street);  // <street_addr_1>
            addXmlElement(w, 'street_addr_2', '');  // <street_addr_2>
            addXmlElement(w, 'city', bengDAO.mailingAddr.city); // <city>
            addXmlElement(w, 'state',bengDAO.mailingAddr.state );   // <state>
            addXmlElement(w, 'zip', bengDAO.mailingAddr.zip);    // <zip>
            addXmlElement(w, 'country_name', 'USA');  
            w.writeEndElement(); // end <address> element
            w.writeEndElement(); // end <recipient_section> element
            // *********** correspondence > plan_info ****************************                  
            w.writeStartElement(null, 'plan_info', null); // start <plan_info> element
            // split bengDAO.planRates into below 9 lists
            // medical.current, medical.renewal, medical.alt, dental.current, dental.renewal, dental.alt, vision.current and vision.renewal, vision.alt
            List<SGR_Opportunity_Plan_Rate__c> medCurr = new List<SGR_Opportunity_Plan_Rate__c>();
            List<SGR_Opportunity_Plan_Rate__c> medRenw = new List<SGR_Opportunity_Plan_Rate__c>();
            List<SGR_Opportunity_Plan_Rate__c> medAlt = new List<SGR_Opportunity_Plan_Rate__c>();
            List<SGR_Opportunity_Plan_Rate__c> denCurr = new List<SGR_Opportunity_Plan_Rate__c>();
            List<SGR_Opportunity_Plan_Rate__c> denRenw = new List<SGR_Opportunity_Plan_Rate__c>();
            List<SGR_Opportunity_Plan_Rate__c> denAlt = new List<SGR_Opportunity_Plan_Rate__c>();
            List<SGR_Opportunity_Plan_Rate__c> visCurr = new List<SGR_Opportunity_Plan_Rate__c>();
            List<SGR_Opportunity_Plan_Rate__c> visRenw = new List<SGR_Opportunity_Plan_Rate__c>();
            List<SGR_Opportunity_Plan_Rate__c> visAlt = new List<SGR_Opportunity_Plan_Rate__c>();
            for(SGR_Opportunity_Plan_Rate__c pr : bengDAO.planRates.values()){
                if(pr.Coverage_Type__c == 'H' || pr.Plan__r.Line_Of_Business__c == 'H'){
                    if(pr.Type__c == 'Current') medCurr.add(pr);
                    else if(pr.Type__c == 'Renewal') medRenw.add(pr);
                    else if(pr.Type__c == 'Alternate' || pr.Type__c == 'Alternative') medAlt.add(pr);
                }else if(pr.Coverage_Type__c == 'D' || pr.Plan__r.Line_Of_Business__c == 'D'){
                    if(pr.Type__c == 'Current') denCurr.add(pr);
                    else if(pr.Type__c == 'Renewal') denRenw.add(pr);
                    else if(pr.Type__c == 'Alternate' || pr.Type__c == 'Alternative') denAlt.add(pr);
                }else if(pr.Coverage_Type__c == 'V' || pr.Plan__r.Line_Of_Business__c == 'V'){
                    if(pr.Type__c == 'Current') visCurr.add(pr);
                    else if(pr.Type__c == 'Renewal') visRenw.add(pr);
                    else if(pr.Type__c == 'Alternate' || pr.Type__c == 'Alternative') visAlt.add(pr);
                }
            }
            // sort current and renewal plans so they look in order with identical plans in the front
            sortPlans(medCurr, medRenw); sortPlans(denCurr, denRenw); sortPlans(visCurr, visRenw);
            
            /* Eligibility Suppression
            - For Medical, 
            if no current Medical plans, make the medAlt list empty
            if there are current Medical plans but with any suppression, make medAlt = medRenw (alternate plans contain only renewal plans)
            - For Dental,
            if no current Dental plans and suppression is Medical/Dental, make the denAlt list empty
            if current Dental plans exist and suppression is Dental or Medical/Dental, make denAlt = denRenw
            - For Vision,
            if no current Vision plans exist and with any suppression, make visAlt list empty.
            if current Vision plans exist and with any suppression, make visAlt = visRenw.
            */
            if(medCurr.isEmpty()) medAlt = new List<SGR_Opportunity_Plan_Rate__c>();
            else if(suppressed != 0) medAlt = medRenw;
            if(denCurr.isEmpty() && suppressed == 3) denAlt = new List<SGR_Opportunity_Plan_Rate__c>();
            else if( !denCurr.isEmpty() && (suppressed == 2 || suppressed == 3)) denAlt = denRenw;
            if(visCurr.isEmpty() && suppressed != 0) visAlt = new List<SGR_Opportunity_Plan_Rate__c>();
            else if( !visCurr.isEmpty() && suppressed != 0) visAlt = visRenw;

            // split bengDAO.benefitHDAs into a MAP of plan ID to MAP of <"header detail name string", Benefit_Header_Detail_Association__c>
            Map<Id,Map<String,Benefit_Header_Detail_Association__c>> plan2BenHDs = new Map<Id,Map<String,Benefit_Header_Detail_Association__c>>();
            for(Benefit_Header_Detail_Association__c b : bengDAO.benefitHDAs.values()){
                Id planId = b.Plan__c;
                if(planId == null ) continue;
                if(plan2BenHDs.get(planId) == null) plan2BenHDs.put(planId, new Map<String,Benefit_Header_Detail_Association__c>());
                String hdname = b.Benefit_Header_Detail__r.Benefit_Header_Detail_Name__c;
                String hdkey = getMapKeyBHD(hdname);
                plan2BenHDs.get(planId).put(hdkey, b);
            }
            system.debug(plan2BenHDs);
            // split bengDAO.planCompRates into a MAP of Plan Rate ID to Map of <Tier_Code__c,SGR_Opportunity_Plan_Composite_Rate__c>
            Map<Id,Map<String,SGR_Opportunity_Plan_Composite_Rate__c>> planRate2ComRates = new Map<Id,Map<String,SGR_Opportunity_Plan_Composite_Rate__c>>();
            for(SGR_Opportunity_Plan_Composite_Rate__c com : bengDAO.planCompRates.values()){
                Id planRateId = com.Opportunity_Plan_Rate__c;
                if(planRateId == null ) continue;
                if(planRate2ComRates.get(planRateId) == null) planRate2ComRates.put(planRateId, new Map<String,SGR_Opportunity_Plan_Composite_Rate__c>());
                String comKey = com.Tier_Code__c==null?'':com.Tier_Code__c;
                planRate2ComRates.get(planRateId).put(comKey,com);
            }
            // split bengDAO.memberBenefits into a MAP of Plan Rate ID to list of SGR_Opportunity_Member_Benefits__c
            // split bengDAO.oppCensuses into a MAP of Member Benefit ID to SGR_Opportunity_Census__c
            Map<Id,List<SGR_Opportunity_Member_Benefits__c>> planRate2MemBens = new Map<Id,List<SGR_Opportunity_Member_Benefits__c>>();
            Map<Id,SGR_Opportunity_Census__c> memBen2Census = new Map<Id,SGR_Opportunity_Census__c>();
            for(SGR_Opportunity_Member_Benefits__c mem : bengDAO.memberBenefits.values()){
                Id planRateId = mem.Opportunity_Plan_Rate__c;
                if(planRateId == null ) continue;
                if(planRate2MemBens.get(planRateId) == null){
                    List<SGR_Opportunity_Member_Benefits__c> oneList = new List<SGR_Opportunity_Member_Benefits__c>();
                    oneList.add(mem);
                    planRate2MemBens.put(planRateId, oneList);
                }else planRate2MemBens.get(planRateId).add(mem);
                Id censusId = mem.Opportunity_Census__c;
                if(censusId == null) continue;
                if(bengDAO.oppCensuses.get(censusId) != null) memBen2Census.put(mem.id, bengDAO.oppCensuses.get(censusId));
            }
            w.writeStartElement(null, 'medical', null); // start <medical> element
            // *********** correspondence > plan_info > medical > current ****************************          
            if(medCurr.isEmpty()){
                    w.writeStartElement(null, 'current', null); // start <current> element
					writeMedBenNA(w, '');
					writeMedDenComNA(w,'');
					writeMedDenAgeNA(w,'');
                    w.writeEndElement(); // end <current> element
            }else{
                for(SGR_Opportunity_Plan_Rate__c medpr : medCurr){
                    w.writeStartElement(null, 'current', null); // start <current> element
                    addXmlMedicalPlanRates('medical', w, medpr, plan2BenHDs, planRate2ComRates, planRate2MemBens, memBen2Census);
                    w.writeEndElement(); // end <current> element
                }
            }
            // *********** correspondence > plan_info > medical > renewal ****************************
            if(medRenw.isEmpty()){
                w.writeStartElement(null, 'renewal', null); // start <renewal> element
				writeMedBenNA(w, '');
				writeMedDenComNA(w,'');
				writeMedDenAgeNA(w,'');
                w.writeEndElement(); // end <renewal> element
            }else{
                for(SGR_Opportunity_Plan_Rate__c medpr : medRenw){
                    w.writeStartElement(null, 'renewal', null); // start <renewal> element
                    addXmlMedicalPlanRates('medical', w, medpr, plan2BenHDs, planRate2ComRates, planRate2MemBens, memBen2Census);
                    w.writeEndElement(); // end <renewal> element
                }
            }
            // *********** correspondence > plan_info > medical > option 2 ****************************
            // produce a lookup map of EO, ES, EC, EF for option 2/3
            Map<String,String> opt2Com = new Map<String,String>();
            Map<String,String> opt3Com = new Map<String,String>();
            // Go to Opportunity's Alternate plans to find the Option 2/3 plan and use their SGR_Opportunity_Plan_Composite_Rate__c records of 'EO', 'ES', 'EC' and 'EF'
            // Alternate plans contain all renewal, option and other plans that an Account can choose from and switch to
            boolean hasOpt2=false, hasOpt3=false;
            for(SGR_Opportunity_Plan_Rate__c pr : medAlt){  
            	if(pr.Plan__c==bengDAO.opt2.id){     // option 2 composite
                    if(planRate2ComRates.get(pr.id) != null){
                        Map<String,SGR_Opportunity_Plan_Composite_Rate__c> comMap = planRate2ComRates.get(pr.id);
                        opt2Com.put('EO',getMapValueCom(comMap.get('EO')));
                        opt2Com.put('ES',getMapValueCom(comMap.get('ES')));
                        opt2Com.put('EC',getMapValueCom(comMap.get('EC')));
                        opt2Com.put('EF',getMapValueCom(comMap.get('EF')));
                        hasOpt2=true;
                    }
            	}else if(pr.Plan__c==bengDAO.opt3.id){  // option 3 composite
                    if(planRate2ComRates.get(pr.id) != null){
                        Map<String,SGR_Opportunity_Plan_Composite_Rate__c> comMap = planRate2ComRates.get(pr.id);
                        opt3Com.put('EO',getMapValueCom(comMap.get('EO')));
                        opt3Com.put('ES',getMapValueCom(comMap.get('ES')));
                        opt3Com.put('EC',getMapValueCom(comMap.get('EC')));
                        opt3Com.put('EF',getMapValueCom(comMap.get('EF')));
                        hasOpt3=true;
                    }
            	}
            	if(hasOpt2&&hasOpt3) break;
            }
            // check Eligibility Suppression -
            // if no current Medical plans, make option 2/3 empty
            // if there are current Medical plans but with any suppression, make option 2/3 N/A
			// start writing option 2 tags
            if(medRenw.isEmpty()){
                    w.writeStartElement(null, 'option2', null); // start <option2> element
					writeMedBenNA(w, '');
					writeMedDenComNA(w,'');
					writeMedDenAgeNA(w,'');
                    w.writeEndElement(); // end <option2> element
            }else{
            	for(SGR_Opportunity_Plan_Rate__c medpr : medRenw){
            		if(suppressed!=0){
	                    w.writeStartElement(null, 'option2', null); // start <option2> element
						writeMedBenNA(w, 'N/A');
						writeMedDenComNA(w,'N/A');
						writeMedDenAgeNA(w,'N/A');
	                    w.writeEndElement(); // end <option2> element
        			}else{
		                w.writeStartElement(null, 'option2', null); // start <option2> element
		                addXmlOptPlanRates('medical', w, medpr, plan2BenHDs, planRate2ComRates, planRate2MemBens, memBen2Census, bengDAO.opt2, opt2Com, bengDAO.opt2.id==medpr.Plan__c, true);
		                w.writeEndElement(); // end <option2> element
            		}
            	}
            }
            // *********** correspondence > plan_info > medical > option 3 ****************************
            if(medRenw.isEmpty()){
                    w.writeStartElement(null, 'option3', null);
					writeMedBenNA(w, '');
					writeMedDenComNA(w,'');
					writeMedDenAgeNA(w,'');
                    w.writeEndElement();
            }else{
            	for(SGR_Opportunity_Plan_Rate__c medpr : medRenw){
            		if(suppressed!=0){
	                    w.writeStartElement(null, 'option3', null); // start <option3> element
						writeMedBenNA(w, 'N/A');
						writeMedDenComNA(w,'N/A');
						writeMedDenAgeNA(w,'N/A');
	                    w.writeEndElement(); // end <option3> element
        			}else{
		                w.writeStartElement(null, 'option3', null);
		                addXmlOptPlanRates('medical', w, medpr, plan2BenHDs, planRate2ComRates, planRate2MemBens, memBen2Census, bengDAO.opt3, opt3Com, bengDAO.opt3.id==medpr.Plan__c, false);
		                w.writeEndElement(); 
            		}
            	}
            }
            addXmlElement(w, 'total_monthly_premium', getCurrency(bengDAO.opportunity.Total_Medical_Monthly_Premium__c));
            w.writeEndElement(); // end <medical> element
            // *********** correspondence > plan_info > dental **************************************
            w.writeStartElement(null, 'dental', null); // start <dental> element
            if(denCurr.isEmpty()){
                w.writeStartElement(null, 'current', null); // start <current> element
				writeDenBenNA(w,'');
				writeMedDenComNA(w,'');
				writeMedDenAgeNA(w,'');
                w.writeEndElement(); // end <current> element
            }else{
                for(SGR_Opportunity_Plan_Rate__c denpr : denCurr){
                    w.writeStartElement(null, 'current', null); // start <current> element
                    addXmlMedicalPlanRates('dental', w, denpr, plan2BenHDs, planRate2ComRates, planRate2MemBens, memBen2Census);
                    w.writeEndElement(); // end <current> element
                }
            }
            if(denRenw.isEmpty()){
                w.writeStartElement(null, 'renewal', null); // start <renewal> element
				writeDenBenNA(w,'');
				writeMedDenComNA(w,'');
				writeMedDenAgeNA(w,'');
                w.writeEndElement(); // end <renewal> element
            }else{
                for(SGR_Opportunity_Plan_Rate__c denpr : denRenw){
                    w.writeStartElement(null, 'renewal', null); // start <renewal> element
                    addXmlMedicalPlanRates('dental', w, denpr, plan2BenHDs, planRate2ComRates, planRate2MemBens, memBen2Census);
                    w.writeEndElement(); // end <renewal> element
                }
            }
            addXmlElement(w, 'total_monthly_premium', getCurrency(bengDAO.opportunity.Total_Dental_Monthly_Premium__c)); 
            w.writeEndElement(); // end <dental> element
            // *********** correspondence > plan_info > vision **************************************
            w.writeStartElement(null, 'vision', null); // start <vision> element
            if(visCurr.isEmpty()){
                w.writeStartElement(null, 'current', null); // start <current> element
                writeVisNA(w,'');
                w.writeEndElement(); // end <current> element
            }else{
                for(SGR_Opportunity_Plan_Rate__c vispr : visCurr){
                    w.writeStartElement(null, 'current', null); // start <current> element
                    addXmlMedicalPlanRates('vision', w, vispr, plan2BenHDs, planRate2ComRates, planRate2MemBens, memBen2Census);
                    w.writeEndElement(); // end <current> element
                }
            }
            if(visRenw.isEmpty()){
                w.writeStartElement(null, 'renewal', null); // start <renewal> element
                writeVisNA(w,'');
                w.writeEndElement(); // end <renewal> element
            }else{
                for(SGR_Opportunity_Plan_Rate__c vispr : visRenw){
                    w.writeStartElement(null, 'renewal', null); // start <renewal> element
                    addXmlMedicalPlanRates('vision', w, vispr, plan2BenHDs, planRate2ComRates, planRate2MemBens, memBen2Census);
                    w.writeEndElement(); // end <renewal> element
                }
            }
            w.writeEndElement(); // end <vision> element
            w.writeEndElement(); // end <plan_info> element
            
            // *********** correspondence > census *******************************
            w.writeStartElement(null, 'census', null); // start <census> element
            // split census into 3 lists - medical, dental and vision
            List<SGR_Opportunity_Census__c> medCen = new List<SGR_Opportunity_Census__c>();
            List<SGR_Opportunity_Census__c> denCen = new List<SGR_Opportunity_Census__c>();
            List<SGR_Opportunity_Census__c> visCen = new List<SGR_Opportunity_Census__c>();
            List<Decimal> rowNos = new List<Decimal>();
            Map<Decimal, SGR_Opportunity_Census__c> medCenMap = new Map<Decimal, SGR_Opportunity_Census__c>();
            Decimal tmpNo = 10000;
            for(SGR_Opportunity_Census__c c : bengDAO.oppCensuses.values()){   // census data
            	/* comment out - only checks if the census member has any plan ID associated
                if(c.Health_Tier__c!=null || c.Health_Plan_ID__c != null) medCen.add(c);
                else if(c.Dental_Tier__c!=null || c.Dental_Plan_ID__c != null) denCen.add(c);
                else if(c.Vision_Tier__c!=null || c.Vision_Plan_ID__c != null) visCen.add(c); */
                if(c.Health_Plan_ID__c != null) medCen.add(c);
                else if(c.Dental_Plan_ID__c != null) denCen.add(c);
                else if(c.Vision_Plan_ID__c != null) visCen.add(c);
                // below is to sort the census in 1,2,3..10,11 instead of 1,10,11,...,2,3
                Decimal oneDec;
                try{oneDec = Decimal.valueOf(c.Row__c) * 100;}catch(Exception e){oneDec = tmpNo++;}
                rowNos.add(oneDec); medCenMap.put(oneDec,c);
            }
            if(!rowNos.isEmpty()) rowNos.sort();
            if(medCen.isEmpty()){
                    // if no medical census, at least put one census with all fields empty
                    w.writeStartElement(null, 'medical', null); // start <medical> element  
                    addXmlEmptyCensus(w);
                    w.writeEndElement(); // end <medical> element
            }else{
                for(Decimal d : rowNos){
                	SGR_Opportunity_Census__c c = medCenMap.get(d);
                    w.writeStartElement(null, 'medical', null); // start <medical> element  
                    addXmlCensus(w, c);
                    w.writeEndElement(); // end <medical> element
                }
            }
            /* as of 12/5/2018 discussin with Scott, no need for dental & vision census
            w.writeStartElement(null, 'dental', null); // start <dental> element
            for(SGR_Opportunity_Census__c c : denCen) addXmlCensus(w, c); 
            w.writeEndElement();
            w.writeStartElement(null, 'vision', null); // start <vision> element
            for(SGR_Opportunity_Census__c c : visCen) addXmlCensus(w, c); 
            w.writeEndElement(); // end <vision> element
            */
            w.writeEndElement(); // end <census> element    
            // *********** correspondence > plan_notes **********************************************
            // plan note details only have lookup to Plan Group so we use Plan Group to divide them into medical, dental and vision
            List<SGR_Opportunity_Plan_Rate__c> medPRs = new List<SGR_Opportunity_Plan_Rate__c>();
            List<SGR_Opportunity_Plan_Rate__c> denPRs = new List<SGR_Opportunity_Plan_Rate__c>();
            List<SGR_Opportunity_Plan_Rate__c> visPRs = new List<SGR_Opportunity_Plan_Rate__c>();
            // We only do Plan Notes for Alternate plans
            // medPRs.addAll(medCurr); medPRs.addAll(medRenw); 
            medPRs.addAll(medAlt);
            // denPRs.addAll(denCurr); denPRs.addAll(denRenw); 
            denPRs.addAll(denAlt);
            // visPRs.addAll(visCurr); visPRs.addAll(visRenw); 
            visPRs.addAll(visAlt);
            Set<Id> medPGIds = new Set<Id>();
            for(SGR_Opportunity_Plan_Rate__c pr : medPRs) addPGId(medPGIds,pr);
            Set<Id> denPGIds = new Set<Id>();
            for(SGR_Opportunity_Plan_Rate__c pr : denPRs) addPGId(denPGIds,pr);
            Set<Id> visPGIds = new Set<Id>();
            for(SGR_Opportunity_Plan_Rate__c pr : visPRs) addPGId(visPGIds,pr);
            Map<String,Product_Note_Detail_Association__c> meds = new Map<String,Product_Note_Detail_Association__c>();
            Map<String,Product_Note_Detail_Association__c> dens = new Map<String,Product_Note_Detail_Association__c>();
            Map<String,Product_Note_Detail_Association__c> viss = new Map<String,Product_Note_Detail_Association__c>();
            Set<String> allSymbols = new Set<String>();  // this is used to sort and lookup purpose
            // divide into 3 note detail lists (medical, dental, vision)
            for(Product_Note_Detail_Association__c nda : bengDAO.noteDetailAs.values()){
                if(medPGIds.contains(nda.Product__c)) meds.put(nda.Plan_Note_Detail__r.Symbol__c,nda);
                if(denPGIds.contains(nda.Product__c)) dens.put(nda.Plan_Note_Detail__r.Symbol__c,nda);
                if(visPGIds.contains(nda.Product__c)) viss.put(nda.Plan_Note_Detail__r.Symbol__c,nda);
                allSymbols.add(nda.Plan_Note_Detail__r.Symbol__c);
            }
            // Plan Notes, re-construct to Plan (1) -> (M) Notes
            Map<Id,Set<Integer>> plan2Notes = new Map<Id,Set<Integer>>();
            for(Plan_Note_Association__c n : bengDAO.noteAs.values()){
                Id planId = n.Plan__c;
                Integer i = sym2int(n.Plan_Note__r.Symbol__c);
                if(i==-1) continue; // skip this symbol as it's not in the form of *1, *2, *3.....
                if(plan2Notes.get(planId)==null) plan2Notes.put(planId, new Set<Integer>());
                plan2Notes.get(planId).add(i);
            }
            Map<Integer,String> sym2Lkup = new Map<Integer,String>();
            for(String s : allSymbols){
            	Integer i = sym2int(s);
            	if(i==-1) continue; // skip this symbol as it's not in the form of *1, *2, *3.....
            	sym2Lkup.put(i,s);
            }
            List<Integer> symInOrder = new List<Integer>(sym2Lkup.keySet());
            symInOrder.sort();
            
            // Print out for <plan_notes>
            w.writeStartElement(null, 'plan_notes', null); // start <plan_notes> element
            // correspondence > plan_notes > medical
            w.writeStartElement(null, 'medical', null); // start <medical> element
            if(meds.isEmpty()) addXMLNoteDet(w,'','');
            // else for(Product_Note_Detail_Association__c nda : meds) addXMLNoteDet(w,nda.Plan_Note_Detail__r.Symbol__c,nda.Plan_Note_Detail__r.Text__c);
            else {
            	for(Integer symInt : symInOrder){
            		Product_Note_Detail_Association__c nda = meds.get(sym2Lkup.get(symInt));
            		if(nda == null) continue;
            		addXMLNoteDet(w,nda.Plan_Note_Detail__r.Symbol__c,nda.Plan_Note_Detail__r.Text__c);
            	}
            }
            w.writeEndElement();  // end <medical> element
            // correspondence > plan_notes > dental
            w.writeStartElement(null, 'dental', null); // start <dental> element
            if(dens.isEmpty()) addXMLNoteDet(w,'','');
            // else for(Product_Note_Detail_Association__c nda : dens) addXMLNoteDet(w,nda.Plan_Note_Detail__r.Symbol__c,nda.Plan_Note_Detail__r.Text__c);
            else {
            	for(Integer symInt : symInOrder){
            		Product_Note_Detail_Association__c nda = dens.get(sym2Lkup.get(symInt));
            		if(nda == null) continue;
            		addXMLNoteDet(w,nda.Plan_Note_Detail__r.Symbol__c,nda.Plan_Note_Detail__r.Text__c);
            	}
            }
            w.writeEndElement();  // end <dental> element
            // correspondence > plan_notes > vision         
            w.writeStartElement(null, 'vision', null); // start <vision> element
            if(viss.isEmpty()) addXMLNoteDet(w,'','');
            // else for(Product_Note_Detail_Association__c nda : viss) addXMLNoteDet(w,nda.Plan_Note_Detail__r.Symbol__c,nda.Plan_Note_Detail__r.Text__c);
            else {
            	for(Integer symInt : symInOrder){
            		Product_Note_Detail_Association__c nda = viss.get(sym2Lkup.get(symInt));
            		if(nda == null) continue;
            		addXMLNoteDet(w,nda.Plan_Note_Detail__r.Symbol__c,nda.Plan_Note_Detail__r.Text__c);
            	}
            }
            w.writeEndElement();  // end <vision> element           
            w.writeEndElement();  // end <plan_notes> element

            // *********** correspondence > source_domain_record *****************
            w.writeStartElement(null, 'source_domain_record', null);    // start <source_domain_record>
            addXmlElement(w, 'renw_year', bengDAO.opportunity.Renewal_Date__c==null ? '' : ''+bengDAO.opportunity.Renewal_Date__c.year());  // <renw_year>
            addXmlElement(w, 'group_name',bengDAO.opportunity.account.name);  // <group_name>
            addXmlElement(w, 'renw_generation_date', getYYYYMMDD(Date.today()));  // <renw_generation_date>
            w.writeStartElement(null, 'administrator', null);   
            if(bengDAO.adminContact != null ) w.writeCharacters(bengDAO.adminContact.firstname==null?'N/A':bengDAO.adminContact.firstname);
            else w.writeCharacters('Group Administrator');
            w.writeEndElement();  // end <administrator> element        
            addXmlElement(w, 'premium_start_month', bengDAO.opportunity.Effective_Month__c);  // <premium_start_month>
            addXmlElement(w, 'premium', goString(bengDAO.opportunity.Total_Medical_Monthly_Premium__c));  // <> #Luke FIX, new field in Opportunity
            addXmlElement(w, 'renw_gen_timestamp', system.now().format());  
            addXmlElement(w, 'account_name', bengDAO.opportunity.account.name);  // <account_name>
            addXmlElement(w, 'account_number', bengDAO.opportunity.account.External_ID__c);  // <account_number>
            addXmlElement(w, 'renw_effective_date', getYYYYMMDD(bengDAO.opportunity.Renewal_Date__c)); 
            addXmlElement(w, 'days_to_submit', ''+bengDAO.opportunity.Days_To_Submit__c);
            addXmlElement(w, 'rep_name', bengDAO.rep);  // <> #Luke FIX ??
            addXmlElement(w, 'agent_name', bengDAO.agent);  // <> #Luke FIX ??
            addXmlElement(w, 'rating_county', bengDAO.opportunity.FIPS_Code__c);  // <rating_county>
            addXmlElement(w, 'rating_zip', bengDAO.opportunity.Zip_Code__c);  // <rating_zip>
            // lob is not used but needed inside <source_domain_record> for B-Engaged to process
            String pnExp = '';
            String lob = '';
            String dentalGrp = '';
            if(!medRenw.isEmpty()){
                lob=lob+'Medical';
                boolean expired=true;
                for(SGR_Opportunity_Plan_Rate__c pr : medRenw) if(pr.Mapping_From_Plan_Id__c==null){expired=false;break;}
                if(expired) pnExp=pnExp+'Medical';
            }
            if(!denRenw.isEmpty()){
            	dentalGrp = denRenw[0].Rate_Size_Code__c==null?'':denRenw[0].Rate_Size_Code__c;
                lob=lob.length()==0?'Dental':lob+'/Dental';
                boolean expired=true;
                for(SGR_Opportunity_Plan_Rate__c pr : denRenw) if(pr.Mapping_From_Plan_Id__c==null){expired=false;break;}
                if(expired) pnExp=pnExp.length()==0?'Dental':pnExp+'/Dental';
            }
            if(!visRenw.isEmpty()){
                lob=lob.length()==0?'Vision':lob+'/Vision';
                boolean expired=true;
                for(SGR_Opportunity_Plan_Rate__c pr : visRenw) if(pr.Mapping_From_Plan_Id__c==null){expired=false;break;}
                if(expired) pnExp=pnExp.length()==0?'Vision':pnExp+'/Vision';
            }
            addXmlElement(w, 'lob', lob); 
            addXmlElement(w, 'submit_date', getYYYYMMDD(bengDAO.opportunity.Submit_Date__c)); 
            addXmlElement(w, 'plans_expired', pnExp);  
            addXmlElement(w, 'hsa_contribution', ''); 
            addXmlElement(w, 'estimated_medical_insurer_fees', getCurrency(bengDAO.opportunity.Total_Est_Medical_Insurer_Fees__c)); 
            addXmlElement(w, 'estimated_dental_insurer_fees', getCurrency(bengDAO.opportunity.Total_Est_Dental_Insurer_Fees__c)); 
            addXmlElement(w, 'estimated_vision_insurer_fees', getCurrency(bengDAO.opportunity.Total_Est_Vision_Insurer_Fees__c)); 
            addXmlElement(w, 'dental_group_size', dentalGrp);
            // Health = Medical = 1
            // Dental = Dental = 2
            // Both = Medical/Dental = 3
            // anything else = nothing suppressed = 0
            String supprEli = ( suppressed==1?'Medical':(suppressed==2?'Dental':(suppressed==3?'Medical/Dental':'')));
            addXmlElement(w, 'suppress_eligibility', supprEli);
            w.writeEndElement();  // end <source_domain_record> element
            // *********** correspondence > alt_plans **********************************************
            w.writeStartElement(null, 'alt_plans', null); // start <alt_plans> element
            w.writeStartElement(null, 'medical', null); // start <medical> element
            if(medAlt.isEmpty()){
                w.writeStartElement(null, 'network', null);  // start <network>
                addXmlElement(w, 'desc', '');  // <desc>
                w.writeStartElement(null, 'plan_type', null);  // start <plan_type>
                addXmlElement(w, 'desc', '');  // <desc>
                w.writeStartElement(null, 'metallic_level', null);  // start <metallic_level>
                addXmlElement(w, 'desc', '');  // <desc>
                w.writeStartElement(null, 'info', null);  // start <info>
                addXmlElement(w, 'plan_id', '');  // <plan_id>
                addXmlElement(w, 'plan_name', '');  // <plan_name>
				addXmlElement(w, 'individual_deduct', '');
				addXmlElement(w, 'copay', '');
				addXmlElement(w, 'coinsurance', '');
				addXmlElement(w, 'individual_oop', '');
				addXmlElement(w, 'er', '');
				addXmlElement(w, 'in_patient', '');
				addXmlElement(w, 'out_patient', '');
				addXmlElement(w, 'pediatric_dental', '');
				addXmlElement(w, 'pharmacy', '');
				addXmlElement(w, 'total', '');
				addXmlElement(w, 'notes', '');
                w.writeEndElement();  // end <info>
                w.writeEndElement();  // end <metallic_level>
                w.writeEndElement();  // end <plan_type>
                w.writeEndElement();  // end <network>
            }else{
                // rearrange medical plans into 3 levels to conform to B-engaged format
                // Network (1)->(M) PlanType (1)->(M) Metallics
                Map<String,Map<String,Map<String,List<SGR_Opportunity_Plan_Rate__c>>>> networks = new Map<String,Map<String,Map<String,List<SGR_Opportunity_Plan_Rate__c>>>>();
                for(SGR_Opportunity_Plan_Rate__c pr : medAlt){
                    String network = pr.Plan__r.Network__c;
                    String pnType = pr.Plan__r.Level_2_Product_Name__c;
                    String metallic = pr.Plan__r.Plan_Level__c;
                    if(networks.get(network)==null){
                        Map<String,Map<String,List<SGR_Opportunity_Plan_Rate__c>>> pnTypes = new Map<String,Map<String,List<SGR_Opportunity_Plan_Rate__c>>>();
                        networks.put(network,pnTypes);
                    }
                    if(networks.get(network).get(pnType)==null){
                        Map<String,List<SGR_Opportunity_Plan_Rate__c>> metallics = new Map<String,List<SGR_Opportunity_Plan_Rate__c>>();
                        networks.get(network).put(pnType,metallics);
                    }
                    if(networks.get(network).get(pnType).get(metallic)==null){
                        List<SGR_Opportunity_Plan_Rate__c> infos = new List<SGR_Opportunity_Plan_Rate__c>();
                        networks.get(network).get(pnType).put(metallic,infos);
                    }
                    networks.get(network).get(pnType).get(metallic).add(pr);
                }
                for(String netw : networks.keySet()){
                    w.writeStartElement(null, 'network', null);  // start <network>
                    addXmlElement(w, 'desc', netw);  // <desc>
                    for(String pnType : networks.get(netw).keySet()){
                        w.writeStartElement(null, 'plan_type', null);  // start <plan_type>
                        addXmlElement(w, 'desc', pnType);  // <desc>
                        for(String metal : networks.get(netw).get(pnType).keySet()){
                            w.writeStartElement(null, 'metallic_level', null);  // start <metallic_level>
                            addXmlElement(w, 'desc', metal);  // <desc>
                            for(SGR_Opportunity_Plan_Rate__c pr : networks.get(netw).get(pnType).get(metal)){
                                w.writeStartElement(null, 'info', null);  // start <info>
                                addXmlElement(w, 'plan_id', pr.Plan__r.Marketing_Plan_Number__c);  // <plan_id>
                                addXmlElement(w, 'plan_name', pr.Plan__r.description__c);  // <plan_name>
                                addAltPlanHDs('medical', w, pr, plan2BenHDs);
                                addXmlElement(w, 'total', getTotal('renewal',pr)); 
                                if(plan2Notes.get(pr.Plan__c) != null){
                                	// for(Plan_Note_Association__c n : plan2Notes.get(pr.Plan__c))addXmlElement(w, 'notes', n.Plan_Note__r.Symbol__c);  // <notes>
                                	Set<Integer> symSet = plan2Notes.get(pr.Plan__c);
                                	for(Integer symInt : symInOrder){
                                		if(symSet.contains(symInt)) addXmlElement(w, 'notes', sym2Lkup.get(symInt));  // <notes>
                                	}
                                }else addXmlElement(w, 'notes', '');  // <notes> empty notes
                                w.writeEndElement();  // end <info>
                            }
                            w.writeEndElement();  // end <metallic_level>
                        }
                        w.writeEndElement();  // end <plan_type>
                    }
                    w.writeEndElement();  // end <network>
                }
            }
            w.writeEndElement();  // end <medical> element
            w.writeStartElement(null, 'dental', null); // start <dental> element
            if(denAlt.isEmpty()){
                w.writeStartElement(null, 'allocation', null);  // start <allocation>
                addXmlElement(w, 'desc', '');  // <desc>
                w.writeStartElement(null, 'participation_reqs', null);  // start <participation_reqs>
                addXmlElement(w, 'desc', '');  // <desc>
                w.writeStartElement(null, 'info', null);  // start <info>
                addXmlElement(w, 'plan_id', '');  // <plan_id>
                addXmlElement(w, 'plan_type', '');  // <plan_name>
				addXmlElement(w, 'deduct', '');
				addXmlElement(w, 'benefit_max', '');
				addXmlElement(w, 'reimbursement', '');
				addXmlElement(w, 'in_net_coinsur', '');
				addXmlElement(w, 'out_net_coinsur', '');
				addXmlElement(w, 'orthodotia', '');
				addXmlElement(w, 'total', '');
                w.writeEndElement();  // end <info>
                w.writeEndElement();  // end <participation_reqs>
                w.writeEndElement();  // end <allocation>
            }else{
                // rearrange dental plans into 2 levels to conform to B-engaged format
                // allocation = Plan__r.Product_Name__c, contains(High or Low)                  
                // participation_reqs = Plan__r.Level_2_Product_Name__c, contains(Contributory or Voluntary)
                Map<String,Map<String,List<SGR_Opportunity_Plan_Rate__c>>> allos = new Map<String,Map<String,List<SGR_Opportunity_Plan_Rate__c>>>();
                for(SGR_Opportunity_Plan_Rate__c pr : denAlt){
                    String allo = pr.Plan__r.Product_Name__c!=null&&pr.Plan__r.Product_Name__c.toLowerCase().contains('high')?'High':'Low';
                    String part = pr.Plan__r.Level_2_Product_Name__c!=null&&pr.Plan__r.Level_2_Product_Name__c.toLowerCase().contains('contributory')?'Contributory':'Voluntary';
                    if(allos.get(allo)==null){
                        Map<String,List<SGR_Opportunity_Plan_Rate__c>> parts = new Map<String,List<SGR_Opportunity_Plan_Rate__c>>();
                        allos.put(allo,parts);
                    }
                    if(allos.get(allo).get(part)==null){
                        List<SGR_Opportunity_Plan_Rate__c> infos = new List<SGR_Opportunity_Plan_Rate__c>();
                        allos.get(allo).put(part,infos);
                    }
                    allos.get(allo).get(part).add(pr);
                }
                for(String al : allos.keySet()){
                    w.writeStartElement(null, 'allocation', null);  // start <allocation>
                    addXmlElement(w, 'desc', al);  // <desc>
                    for(String part : allos.get(al).keySet()){
                        w.writeStartElement(null, 'participation_reqs', null);  // start <participation_reqs>
                        addXmlElement(w, 'desc', part);  // <desc>
                        for(SGR_Opportunity_Plan_Rate__c pr : allos.get(al).get(part)){
                            w.writeStartElement(null, 'info', null);  // start <info>
                            addXmlElement(w, 'plan_id', pr.Plan__r.Marketing_Plan_Number__c);  // <plan_id>
                            // addXmlElement(w, 'plan_type', pr.Plan_Name__c);  // <plan_type>
                            addAltPlanHDs('dental', w, pr, plan2BenHDs);
                            addXmlElement(w, 'total', getTotal('renewal',pr)); 
                            /* no notes in dental
                            if(plan2Notes.get(pr.Plan__c) != null){
                            	// for(Plan_Note_Association__c n : plan2Notes.get(pr.Plan__c))addXmlElement(w, 'notes', n.Plan_Note__r.Symbol__c);  // <notes>
                            	Set<Integer> symSet = plan2Notes.get(pr.Plan__c);
                            	for(Integer symInt : symInOrder){
                            		if(symSet.contains(symInt)) addXmlElement(w, 'notes', sym2Lkup.get(symInt));  // <notes>
                            	}
                            }else addXmlElement(w, 'notes', '');  // <notes> empty notes
                            */
                            w.writeEndElement();  // end <info>
                        }
                        w.writeEndElement();  // end <participation_reqs>
                    }
                    w.writeEndElement();  // end <allocation>
                }
            }
            w.writeEndElement();  // end <dental> element
            // vision
            if(visAlt.isEmpty()){
                w.writeStartElement(null, 'vision', null);  // start <vision>
                addXmlElement(w, 'plan_id', '');  // <plan_id>
                addXmlElement(w, 'plan_type', '');  // <plan_name>
				addXmlElement(w, 'exam', '');
				addXmlElement(w, 'frames', '');
				addXmlElement(w, 'conventional_lenses', '');
				addXmlElement(w, 'contact_lenses', '');
                addXmlElement(w, 'enroll_count', '');  
                addXmlElement(w, 'per_member_rate', ''); 
                addXmlElement(w, 'total_monthly_premium', ''); 
                addXmlElement(w, 'estimated_taxes_fees', ''); 
                w.writeEndElement();  // end <vision>
            }else{
                for(SGR_Opportunity_Plan_Rate__c pr : visAlt){
                    w.writeStartElement(null, 'vision', null);  // start <vision>
                    addXmlElement(w, 'plan_id', pr.Plan__r.Marketing_Plan_Number__c);  // <plan_id>
                    addXmlElement(w, 'plan_type', pr.Plan__r.Level_2_Product_Name__c);  // <plan_type> #LUKE FIX, or pr.Plan__r.Level_2_Product__r.ProductCode
                    addAltPlanHDs('vision', w, pr, plan2BenHDs);
                    addXmlElement(w, 'enroll_count', goString(pr.Enrolled_Subscriber_Count__c));  
                    addXmlElement(w, 'per_member_rate', getVisPerRate(planRate2MemBens,pr.id,pr.Rate_Type_Code__c)); 
                    addXmlElement(w, 'total_monthly_premium', getTotal('renewal',pr)); 
                    addXmlElement(w, 'estimated_taxes_fees', getTax('renewal',pr)); 
                    w.writeEndElement();  // end <vision>
                }
            }
            w.writeEndElement();  // end <alt_plans> element
            // *************** correspondence > age_band ******************
            w.writeStartElement(null, 'age_band', null); // start <age_band> element
            // medical
            if(medAlt.isEmpty()) writeMedBandNA(w, '');
            else{
                for(SGR_Opportunity_Plan_Rate__c pr : medAlt){
                    w.writeStartElement(null, 'medical', null);  // start <medical>
                    addXmlElement(w, 'network', pr.Plan__r.Network__c);  // <>
                    addXmlElement(w, 'plan_type', pr.Plan__r.Level_2_Product_Name__c);  // <>
                    addXmlElement(w, 'metallic_level', pr.Plan__r.Plan_Level__c);  // <>
                    addXmlElement(w, 'plan_id', pr.Plan__r.Marketing_Plan_Number__c);  // <>
                    if(planRate2ComRates.get(pr.id) != null){
                        Map<String,SGR_Opportunity_Plan_Composite_Rate__c> comMap = planRate2ComRates.get(pr.id);
                        addXmlElement(w, 'eo', getMapValueCom(comMap.get('EO')));
                        addXmlElement(w, 'es', getMapValueCom(comMap.get('ES')));
                        addXmlElement(w, 'ec', getMapValueCom(comMap.get('EC')));
                        addXmlElement(w, 'ef', getMapValueCom(comMap.get('EF')));
                    }
                    addXmlElement(w, 'comp_total', goString(pr.Renw_Comp_Total_Monthly_Premium__c)); 
                    for(SGR_Plan_Age_Rate_Detail__c ageRate : bengDAO.ageRateDetails.values())
                        if(ageRate.Age_Rate_Header__r.Plan__c == pr.Plan__c && ageRate.To_Age__c >= 14 && ageRate.To_Age__c <= 64 && ageRate.To_Age__c > 64 && ageRate.To_Age__c <= 120)
                            addXmlElement(w, 'age_total', goString(ageRate.Gross_Premium__c));
                    w.writeEndElement();  // end <medical>
                }
            }
            // dental
            if(denAlt.isEmpty()) writeDenBandNA(w, '');
            else{
                for(SGR_Opportunity_Plan_Rate__c pr : denAlt){
                    String allo = pr.Plan__r.Product_Name__c!=null&&pr.Plan__r.Product_Name__c.toLowerCase().contains('high')?'High':'Low';
                    String part = pr.Plan__r.Level_2_Product_Name__c!=null&&pr.Plan__r.Level_2_Product_Name__c.toLowerCase().contains('contributory')?'Contributory':'Voluntary';
                    
                    w.writeStartElement(null, 'dental', null);  // start <dental>
                    addXmlElement(w, 'plan_id', pr.Plan__r.Marketing_Plan_Number__c);
                    addXmlElement(w, 'contribution', part); 
                    addXmlElement(w, 'allocation', allo); 
                    addXmlElement(w, 'status', 'Active');  // #FIXIT, Hardcode to Active for now 
                    Decimal u21 = 0, o21 = 0;
                    for(SGR_Plan_Age_Rate_Detail__c ageRate : bengDAO.ageRateDetails.values())
                        if(ageRate.Age_Rate_Header__r.Plan__c == pr.Plan__c){
                            if(ageRate.From_Age__c==20 && ageRate.To_Age__c==20) u21 = ageRate.Gross_Premium__c;
                            else if(ageRate.From_Age__c==21 && ageRate.To_Age__c==21) o21 = ageRate.Gross_Premium__c;
                        }
                    addXmlElement(w, 'under_21', goString(u21)); 
                    addXmlElement(w, 'over_21', goString(o21));
                    Decimal compTotal=0;
                    if(planRate2ComRates.get(pr.id) != null){
                        Map<String,SGR_Opportunity_Plan_Composite_Rate__c> comMap = planRate2ComRates.get(pr.id);
                        addXmlElement(w, 'eo', getMapValueCom(comMap.get('EO')));
                        addXmlElement(w, 'es', getMapValueCom(comMap.get('ES')));
                        addXmlElement(w, 'ec', getMapValueCom(comMap.get('EC')));
                        addXmlElement(w, 'ef', getMapValueCom(comMap.get('EF')));
                    }
                    addXmlElement(w, 'comp_total', goString(pr.Renw_Comp_Total_Monthly_Premium__c)); 
                    addXmlElement(w, 'comp_fee', goString(pr.Renw_Comp_Total_Est_Tax_and_Fees__c));  
                    addXmlElement(w, 'age_total', goString(pr.Renw_Age_Total_Monthly_Premium__c)); 
                    addXmlElement(w, 'age_fee', goString(pr.Renw_Age_Total_Est_Tax_and_Fees__c)); 
                    w.writeEndElement();  // end <dental>
                }
            }
            w.writeEndElement();  // end <age_band> element
            w.writeEndElement();  // end <correspondence> element
            w.writeEndElement();  // end <mcc_output> element
            w.writeEndDocument(); // end whole xml document 
            String xmlOutput = w.getXmlString();
            w.close();
            system.debug('>>>> xmlOutput: ' + xmlOutput);
            return xmlOutput;
        }catch (Exception e){
          system.debug('Line#: '+ e.getLineNumber() + ' - SGR_Beng_RequestHelper.generateXML() exception: '+e);
          throw e;  
        }
    }


    private void addXmlElement(XmlStreamWriter w, String elemName, String value){
            w.writeStartElement(null, elemName, null);
            w.writeCharacters(value==null?'':value);
            w.writeEndElement();
    }

    private void addXmlMedicalPlanRates(String type, XmlStreamWriter w, SGR_Opportunity_Plan_Rate__c medpr, Map<Id,Map<String,Benefit_Header_Detail_Association__c>> plan2BenHDs, Map<Id,Map<String,SGR_Opportunity_Plan_Composite_Rate__c>> planRate2ComRates, Map<Id,List<SGR_Opportunity_Member_Benefits__c>> planRate2MemBens, Map<Id,SGR_Opportunity_Census__c> memBen2Census){
        if(type == 'medical'){
            addXmlElement(w, 'plan_id', medpr.Plan__r.Marketing_Plan_Number__c);  // <plan_id>
            addXmlElement(w, 'metallic', medpr.Plan__r.Plan_Level__c);  // <metallic>
            addXmlElement(w, 'network', medpr.Plan__r.Network__c);  // <network>
        }else if(type == 'dental'){
            addXmlElement(w, 'plan_id', medpr.Plan__r.Marketing_Plan_Number__c);
            addXmlElement(w, 'participation', medpr.Plan__r.Level_2_Product_Name__c!=null&&medpr.Plan__r.Level_2_Product_Name__c.toLowerCase().contains('contributory')?'Contributory':'Voluntary');  // #Luke FIX
            addXmlElement(w, 'coverage_allocation', medpr.Plan__r.Product_Name__c!=null&&medpr.Plan__r.Product_Name__c.toLowerCase().contains('high')?'High':'Low');  // #Luke FIX
        }else if(type == 'vision'){
            addXmlElement(w, 'plan_name', medpr.Plan_Name__c);              
            addXmlElement(w, 'plan_id', medpr.Plan__r.Marketing_Plan_Number__c);  
            addXmlElement(w, 'plan_type', medpr.Plan__r.Level_2_Product_Name__c);  
        }else return; // invalid type
        if(plan2BenHDs.get(medpr.Plan__c) != null){
            Map<String,Benefit_Header_Detail_Association__c> hdMap = plan2BenHDs.get(medpr.Plan__c);
            if(type == 'medical'){
                addXmlElement(w, 'deductible', getMapValueBHD(hdMap.get('Ded In/Out')));
                addXmlElement(w, 'office_copays', getMapValueBHD(hdMap.get('Office Visit')));
                addXmlElement(w, 'coinsurance', getMapValueBHD(hdMap.get('Coins In/Out')));
                addXmlElement(w, 'out_of_pocket', getMapValueBHD(hdMap.get('OPX In/Out')));
                addXmlElement(w, 'pharmacy_copay', getMapValueBHD(hdMap.get('Preferred Rx')));
            }else if(type == 'dental'){
                addXmlElement(w, 'deductible', getMapValueBHD(hdMap.get('Deductible In/Out')));
                addXmlElement(w, 'coinsur_in_net', getMapValueBHD(hdMap.get('In Network')));
                addXmlElement(w, 'coinsur_out_net', getMapValueBHD(hdMap.get('Out Of Network')));
                addXmlElement(w, 'orthodontia', getMapValueBHD(hdMap.get('Orthodontia Lifetime Max')));
                addXmlElement(w, 'annual_ben_in_net', getMapValueBHD(hdMap.get('Annual Benefit Max')));
                addXmlElement(w, 'annual_ben_out_net', getMapValueBHD(hdMap.get('Out-of-Network Reimb')));          
            }else if(type == 'vision'){
                addXmlElement(w, 'exam', getMapValueBHD(hdMap.get('Exam')));
                addXmlElement(w, 'frames', getMapValueBHD(hdMap.get('Frames')));
                addXmlElement(w, 'conventional_lenses', getMapValueBHD(hdMap.get('Conventional Lenses')));
                addXmlElement(w, 'contact_lenses', getMapValueBHD(hdMap.get('Contact Lenses')));
            }
        }
        if(type == 'vision') addXmlElement(w, 'per_member_rate', getVisPerRate(planRate2MemBens,medpr.id,medpr.Rate_Type_Code__c));   
        addXmlElement(w, 'total_monthly_premium', getTotal(medpr.Type__c=='Current'?'current':'renewal',medpr));
        if(type == 'vision') addXmlElement(w, 'taxes_fees', getTax(medpr.Type__c=='Current'?'current':'renewal',medpr));
        addXmlElement(w, 'enrolled_count', goString(medpr.Enrolled_Subscriber_Count__c));
        if(type == 'vision') return;  // vision stops here, below processing
        // below processing for medical and dental only
        // either composite or age rated
        if(isSTNRate){
            // <composite_rates>
            w.writeStartElement(null, 'composite_rates', null);
            if(planRate2ComRates.get(medpr.id) != null){
                Map<String,SGR_Opportunity_Plan_Composite_Rate__c> comMap = planRate2ComRates.get(medpr.id);
                addXmlElement(w, 'EO', getMapValueCom(comMap.get('EO')));
                addXmlElement(w, 'ES', getMapValueCom(comMap.get('ES')));
                addXmlElement(w, 'EC', getMapValueCom(comMap.get('EC')));
                addXmlElement(w, 'EF', getMapValueCom(comMap.get('EF')));
            }
            w.writeEndElement(); // end of composite rates
            // it's needed to add one set of <age_rates> data with empty values
            w.writeStartElement(null, 'age_rates', null);  // <age_rates>                   
            addXmlElement(w, 'employee', '');
            addXmlElement(w, 'dob', '');
            addXmlElement(w, 'age','');
            addXmlElement(w, 'state', '');
            addXmlElement(w, 'employee_rates', ''); 
            addXmlElement(w, 'spouse_rates', '');   
            addXmlElement(w, 'child_rates', '');    
            addXmlElement(w, 'employee_total', ''); 
            w.writeEndElement();  // end <age_rates>
        }else{
            // it's needed to add one set of <composite_rates> data with empty values
            w.writeStartElement(null, 'composite_rates', null);
            addXmlElement(w, 'EO', '');
            addXmlElement(w, 'ES', '');
            addXmlElement(w, 'EC', '');
            addXmlElement(w, 'EF', '');
            w.writeEndElement(); // end of composite rates
            // age rated
            if(planRate2MemBens.get(medpr.id) != null){
                for(SGR_Opportunity_Member_Benefits__c mem : planRate2MemBens.get(medpr.id)){
                    if(mem.Relationship_Code__c!='Subscriber') continue;
                    w.writeStartElement(null, 'age_rates', null);  // <age_rates>                   
                    SGR_Opportunity_Census__c memCen = memBen2Census.get(mem.id);
                    addXmlElement(w, 'employee', memCen.First_Name__c + ' ' + memCen.Last_Name__c);
                    addXmlElement(w, 'dob', memCen.Date_of_Birth__c == null ? '' : memCen.Date_of_Birth__c.format());
                    addXmlElement(w, 'age',goString( memCen.Age__c));
                    addXmlElement(w, 'state', memCen.State__c);
                    addXmlElement(w, 'employee_rates', goString(mem.Age_Total_Employee_Rate__c));  
                    addXmlElement(w, 'spouse_rates', goString(mem.Age_Total_Spouse_Rate__c));  
                    addXmlElement(w, 'child_rates', goString(mem.Age_Total_Child_Rate__c));
                    addXmlElement(w, 'employee_total', goString(mem.Renw_Age_Total_Monthly_Premium__c));   
                    w.writeEndElement();  // end <age_rates>
                }
            }
        }
    }

    private void addXmlOptPlanRates(String type, XmlStreamWriter w, SGR_Opportunity_Plan_Rate__c medpr, Map<Id,Map<String,Benefit_Header_Detail_Association__c>> plan2BenHDs, Map<Id,Map<String,SGR_Opportunity_Plan_Composite_Rate__c>> planRate2ComRates, Map<Id,List<SGR_Opportunity_Member_Benefits__c>> planRate2MemBens, Map<Id,SGR_Opportunity_Census__c> memBen2Census, Plan__c opt, Map<String,String> optCom, boolean isNA, boolean isOpt2){
        // ignore the type for now because only Medical uses option
        if(isNA){
        	writeMedBenNA(w, 'N/A');
			writeMedDenComNA(w,'N/A');
			writeMedDenAgeNA(w,'N/A');
        	return;
        }
        addXmlElement(w, 'plan_id', opt.Marketing_Plan_Number__c);  // <plan_id>
        addXmlElement(w, 'metallic', opt.Plan_Level__c);  // <metallic>
        addXmlElement(w, 'network', opt.Network__c);  // <network>
        if(plan2BenHDs.get(opt.id) != null){
            Map<String,Benefit_Header_Detail_Association__c> hdMap = plan2BenHDs.get(opt.id);
            addXmlElement(w, 'deductible', getMapValueBHD(hdMap.get('Ded In/Out')));
            addXmlElement(w, 'office_copays', getMapValueBHD(hdMap.get('Office Visit')));
            addXmlElement(w, 'coinsurance', getMapValueBHD(hdMap.get('Coins In/Out')));
            addXmlElement(w, 'out_of_pocket', getMapValueBHD(hdMap.get('OPX In/Out')));
            addXmlElement(w, 'pharmacy_copay', getMapValueBHD(hdMap.get('Preferred Rx')));
        } 
        
        addXmlElement(w, 'total_monthly_premium', getTotal(isOpt2 ?'opt2':'opt3',medpr));
        addXmlElement(w, 'enrolled_count', goString(medpr.Enrolled_Subscriber_Count__c));
        if(isSTNRate){
            // <composite_rates>
            w.writeStartElement(null, 'composite_rates', null);
            addXmlElement(w, 'EO', optCom.get('EO'));
            addXmlElement(w, 'ES', optCom.get('ES'));
            addXmlElement(w, 'EC', optCom.get('EC'));
            addXmlElement(w, 'EF', optCom.get('EF'));
            w.writeEndElement(); // end of composite rates
            // it's needed to add one set of <age_rates> data with empty values
			writeMedDenAgeNA(w,'');
        }else{
            // it's needed to add one set of <composite_rates> data with empty values
            writeMedDenComNA(w,'');
            // age rated
            if(planRate2MemBens.get(medpr.id) != null){
                for(SGR_Opportunity_Member_Benefits__c mem : planRate2MemBens.get(medpr.id)){
                    if(mem.Relationship_Code__c!='Subscriber') continue;
                    w.writeStartElement(null, 'age_rates', null);  // <age_rates>                   
                    SGR_Opportunity_Census__c memCen = memBen2Census.get(mem.id);
                    addXmlElement(w, 'employee', memCen.First_Name__c + ' ' + memCen.Last_Name__c);
                    addXmlElement(w, 'dob', memCen.Date_of_Birth__c == null ? '' : memCen.Date_of_Birth__c.format());
                    addXmlElement(w, 'age',goString( memCen.Age__c));
                    addXmlElement(w, 'state', memCen.State__c);
                    addXmlElement(w, 'employee_rates', goString((isOpt2?mem.Opt2_Age_Total_Employee_Rate__c:mem.Opt3_Age_Total_Employee_Rate__c)));  
                    addXmlElement(w, 'spouse_rates', goString((isOpt2?mem.Opt2_Age_Total_Spouse_Rate__c:mem.Opt3_Age_Total_Spouse_Rate__c)));  
                    addXmlElement(w, 'child_rates', goString((isOpt2?mem.Opt2_Age_Total_Child_Rate__c:mem.Opt3_Age_Total_Child_Rate__c)));
                    addXmlElement(w, 'employee_total', goString((isOpt2?mem.Opt2_Age_Total_All_Rate__c:mem.Opt3_Age_Total_All_Rate__c)));   
                    w.writeEndElement();  // end <age_rates>
                }
            }
        }
    }

    private void addXmlCensus(XmlStreamWriter w, SGR_Opportunity_Census__c c){
        addXmlElement(w, 'number', c.Row__c==null?'':c.Row__c); 
        addXmlElement(w, 'name', c.First_Name__c + ' ' + c.Last_Name__c);
        addXmlElement(w, 'relationship', c.Relationship__c);
        addXmlElement(w, 'dob', c.Date_of_Birth__c==null ? '' : c.Date_of_Birth__c.format());
        addXmlElement(w, 'age', goString(c.Age__c));
        addXmlElement(w, 'coverage_type', c.Health_Tier__c);
        addXmlElement(w, 'state', c.State__c);
    }
    
    private void addXmlEmptyCensus(XmlStreamWriter w){
        addXmlElement(w, 'number', ''); 
        addXmlElement(w, 'name', '');
        addXmlElement(w, 'relationship', '');
        addXmlElement(w, 'dob', '');
        addXmlElement(w, 'age', '');
        addXmlElement(w, 'coverage_type', '');
        addXmlElement(w, 'state', '');
    }

    private void addAltPlanHDs(String type, XmlStreamWriter w, SGR_Opportunity_Plan_Rate__c medpr, Map<Id,Map<String,Benefit_Header_Detail_Association__c>> plan2BenHDs){
        if(plan2BenHDs.get(medpr.Plan__c) != null){
            Map<String,Benefit_Header_Detail_Association__c> hdMap = plan2BenHDs.get(medpr.Plan__c);
            if(type == 'medical'){
                addXmlElement(w, 'individual_deduct', getMapValueBHD(hdMap.get('Ded In/Out')));
                addXmlElement(w, 'copay', getMapValueBHD(hdMap.get('Office Visit')));
                addXmlElement(w, 'coinsurance', getMapValueBHD(hdMap.get('Coins In/Out')));
                addXmlElement(w, 'individual_oop', getMapValueBHD(hdMap.get('OPX In/Out')));
                addXmlElement(w, 'er', getMapValueBHD(hdMap.get('ER Copay')));
                addXmlElement(w, 'in_patient', getMapValueBHD(hdMap.get('IP In/Out')));
                addXmlElement(w, 'out_patient', getMapValueBHD(hdMap.get('OP Surg In/Out')));
                addXmlElement(w, 'pediatric_dental', getMapValueBHD(hdMap.get('Ped Dental')));
                addXmlElement(w, 'pharmacy', getMapValueBHD(hdMap.get('Preferred Rx')));
            }else if(type == 'dental'){
            	addXmlElement(w, 'plan_type', getMapValueBHD(hdMap.get('Plan Type')));
                addXmlElement(w, 'deduct', getMapValueBHD(hdMap.get('Deductible In/Out')));
                addXmlElement(w, 'benefit_max', getMapValueBHD(hdMap.get('In Network')));
                addXmlElement(w, 'reimbursement', getMapValueBHD(hdMap.get('Out Of Network')));
                addXmlElement(w, 'in_net_coinsur', getMapValueBHD(hdMap.get('Orthodontia Lifetime Max')));
                addXmlElement(w, 'out_net_coinsur', getMapValueBHD(hdMap.get('Annual Benefit Max')));
                addXmlElement(w, 'orthodotia', getMapValueBHD(hdMap.get('Out-of-Network Reimb')));
            }else if(type == 'vision'){
                addXmlElement(w, 'exam', getMapValueBHD(hdMap.get('Exam')));
                addXmlElement(w, 'frames', getMapValueBHD(hdMap.get('Frames')));
                addXmlElement(w, 'conventional_lenses', getMapValueBHD(hdMap.get('Conventional Lenses')));
                addXmlElement(w, 'contact_lenses', getMapValueBHD(hdMap.get('Contact Lenses')));
            }
        }   
    }

    private void addPGId(Set<Id> pgIds, SGR_Opportunity_Plan_Rate__c pr){
        if(pr.Plan__r.Level_1_Product__c!=null)pgIds.add(pr.Plan__r.Level_1_Product__c);
        if(pr.Plan__r.Level_2_Product__c!=null)pgIds.add(pr.Plan__r.Level_2_Product__c);
        if(pr.Plan__r.Product__c!=null)pgIds.add(pr.Plan__r.Product__c);
    }
    
    private void addXMLNoteDet(XmlStreamWriter w, String sym, String txt){
        w.writeStartElement(null, 'note', null); // start <note> element
        addXmlElement(w, 'symbol', sym);  // <symbol>
        addXmlElement(w, 'text', txt);  // <text>
        w.writeEndElement();  // end <note> element
    }
    
    private void setMailAddress(Address fromAddr, SGR_Beng_XML_TemplateDAO.SGR_Beng_Address toAddr){
        if(fromAddr==null){toAddr.street=toAddr.zip=toAddr.state=toAddr.city='';}else{
        toAddr.street = fromAddr.getStreet();
        toAddr.zip = fromAddr.getPostalCode();
        toAddr.state = fromAddr.getState();
        toAddr.city = fromAddr.getCity(); 
        }  
    }
    
    private String getMapKeyBHD(String hdname){
        if(hdname==null) return '';
        // medical
        else if(hdname.contains('Ded In/Out')) return 'Ded In/Out';
        else if(hdname.contains('Office Visit')) return 'Office Visit';
        else if(hdname.contains('Coins In/Out')) return 'Coins In/Out';
        else if(hdname.contains('OPX In/Out')) return 'OPX In/Out'; 
        else if(hdname.contains('ER Copay')) return 'ER Copay';
        else if(hdname.contains('IP In/Out'))  return 'IP In/Out';
        else if(hdname.contains('OP Surg In/Out'))  return 'OP Surg In/Out';
        else if(hdname.contains('Ped Dental'))  return 'Ped Dental';                
        else if(hdname.contains('Preferred Rx'))  return 'Preferred Rx';        
        // dental
        else if(hdname.contains('Plan Type'))  return 'Plan Type';
        else if(hdname.contains('Deductible In/Out'))  return 'Deductible In/Out';
        else if(hdname.contains('In Network'))  return 'In Network';
        else if(hdname.contains('Out Of Network'))  return 'Out Of Network';                
        else if(hdname.contains('Orthodontia Lifetime Max'))  return 'Orthodontia Lifetime Max';                
        else if(hdname.contains('Annual Benefit Max'))  return 'Annual Benefit Max';                
        else if(hdname.contains('Out-of-Network Reimb'))  return 'Out-of-Network Reimb';                
        // vision
        else if(hdname.contains('Exam'))  return 'Exam';                
        else if(hdname.contains('Frames')) return 'Frames';             
        else if(hdname.contains('Conventional Lenses'))  return 'Conventional Lenses';              
        else if(hdname.contains('Contact Lenses'))  return 'Contact Lenses';        
        else return '';
    }
    
    private String getMapValueBHD(Benefit_Header_Detail_Association__c bhd){
        if(bhd==null) return '';
        else return bhd.Benefit_Header_Detail__r.Value__c;
    }
    
    private String getMapValueCom(SGR_Opportunity_Plan_Composite_Rate__c com){
        if(com==null) return '';
        else return goString((com.Gross_Premium__c));
    }
    
    private String getTotal(String type, SGR_Opportunity_Plan_Rate__c pr){
        if(type=='current') return pr.Rate_Type_Code__c=='STN'?goString(pr.Current_Comp_Total_Monthly_Premium__c):goString(pr.Current_Age_Total_Monthly_Premium__c);
        else if(type=='opt2') return pr.Rate_Type_Code__c=='STN'?goString(pr.Opt2_Renw_Comp_Total_Monthly_Premium__c):goString(pr.Opt2_Renw_Age_Total_Monthly_Premium__c);
        else if(type=='opt3') return pr.Rate_Type_Code__c=='STN'?goString(pr.Opt3_Renw_Comp_Total_Monthly_Premium__c):goString(pr.Opt3_Renw_Age_Total_Monthly_Premium__c);
        else return pr.Rate_Type_Code__c=='STN'?goString(pr.Renw_Comp_Total_Monthly_Premium__c):goString(pr.Renw_Age_Total_Monthly_Premium__c);  // renewal
    }
    
    private String getTax(String type, SGR_Opportunity_Plan_Rate__c pr){
        if(type=='current') return pr.Rate_Type_Code__c=='STN'?goString(pr.Current_Comp_Total_Est_Tax_and_Fees__c):goString(pr.Current_Age_Total_Est_Tax_and_Fees__c);
        else return pr.Rate_Type_Code__c=='STN'?goString(pr.Renw_Comp_Total_Est_Tax_and_Fees__c):goString(pr.Renw_Age_Total_Est_Tax_and_Fees__c);
    }
    
    private String getYYYYMMDD(Date aDate){
        if(aDate==null) return '00000000';
        return ''+aDate.year()+(aDate.month()<10?'0'+aDate.month():''+aDate.month())+(aDate.day()<10?'0'+aDate.day():''+aDate.day());
    }

	private String getCurrency(Decimal d){return goString(d);}

	private String getVisPerRate(Map<Id,List<SGR_Opportunity_Member_Benefits__c>> planRate2MemBens, Id prId, String rateType){
		if(planRate2MemBens.get(prId) != null)
        	for(SGR_Opportunity_Member_Benefits__c mem : planRate2MemBens.get(prId))
            	if(mem.Relationship_Code__c=='Subscriber') {if(rateType=='STN') return goString(mem.Renw_Comp_Gross_Premium__c);else return goString(mem.Renw_Age_Gross_Premium__c);}
        return '0';
	}


	private void writeMedBenNA(XmlStreamWriter w, String s){
        addXmlElement(w, 'plan_id', s);  // <plan_id>
        addXmlElement(w, 'metallic', s);  // <metallic>
        addXmlElement(w, 'network', s);  // <network>
        addXmlElement(w, 'deductible', s);
        addXmlElement(w, 'office_copays', s);
        addXmlElement(w, 'coinsurance', s);
        addXmlElement(w, 'out_of_pocket', s);
        addXmlElement(w, 'pharmacy_copay', s);
        addXmlElement(w, 'total_monthly_premium', s);
        addXmlElement(w, 'enrolled_count', s);
	}

	private void writeMedDenComNA(XmlStreamWriter w, String s){
        w.writeStartElement(null, 'composite_rates', null);
        addXmlElement(w, 'EO', s);
        addXmlElement(w, 'ES', s);
        addXmlElement(w, 'EC', s);
        addXmlElement(w, 'EF', s);
        w.writeEndElement(); // end of composite rates
	}

	private void writeMedDenAgeNA(XmlStreamWriter w, String s){
        w.writeStartElement(null, 'age_rates', null);  // <age_rates>                   
        addXmlElement(w, 'employee', s);
        addXmlElement(w, 'dob', s);
        addXmlElement(w, 'age',s);
        addXmlElement(w, 'state', s);
        addXmlElement(w, 'employee_rates', s); 
        addXmlElement(w, 'spouse_rates', s);   
        addXmlElement(w, 'child_rates', s);    
        addXmlElement(w, 'employee_total', s); 
        w.writeEndElement();  // end <age_rates>
	}

	private void writeDenBenNA(XmlStreamWriter w, String s){
        addXmlElement(w, 'plan_id', s);
        addXmlElement(w, 'participation', s);  // #Luke FIX
        addXmlElement(w, 'coverage_allocation',s);  // #Luke FIX
        addXmlElement(w, 'deductible', s);
        addXmlElement(w, 'coinsur_in_net', s);
        addXmlElement(w, 'coinsur_out_net', s);
        addXmlElement(w, 'orthodontia', s);
        addXmlElement(w, 'annual_ben_in_net', s);
        addXmlElement(w, 'annual_ben_out_net', s);  
        addXmlElement(w, 'total_monthly_premium', s);
        addXmlElement(w, 'enrolled_count', s);
	}

	private void writeVisNA(XmlStreamWriter w, String s){
        addXmlElement(w, 'plan_name', s);              
        addXmlElement(w, 'plan_id', s);  
        addXmlElement(w, 'plan_type', s); 
        addXmlElement(w, 'exam', s);
        addXmlElement(w, 'frames', s);
        addXmlElement(w, 'conventional_lenses', s);
        addXmlElement(w, 'contact_lenses', s);
        addXmlElement(w, 'per_member_rate', s);   
        addXmlElement(w, 'total_monthly_premium', s);
        addXmlElement(w, 'taxes_fees', s);
        addXmlElement(w, 'enrolled_count', s);
	}

	private void writeMedBandNA(XmlStreamWriter w, String s){
                w.writeStartElement(null, 'medical', null);  // start <medical>
                addXmlElement(w, 'network', s); 
                addXmlElement(w, 'plan_type', s); 
                addXmlElement(w, 'metallic_level', s);  
                addXmlElement(w, 'plan_id', s);  
                addXmlElement(w, 'eo', s);  
                addXmlElement(w, 'es', s);                  
                addXmlElement(w, 'ec', s);                  
                addXmlElement(w, 'ef', s);                  
                addXmlElement(w, 'comp_total', s);                  
                addXmlElement(w, 'age_total', s);                  
                w.writeEndElement();  // end <medical>
	}

	private void writeDenBandNA(XmlStreamWriter w, String s){
                w.writeStartElement(null, 'dental', null);  // start <dental>
                addXmlElement(w, 'plan_id', s);  
                addXmlElement(w, 'contribution', s); 
                addXmlElement(w, 'allocation', s); 
                addXmlElement(w, 'status', s); 
                addXmlElement(w, 'under_21', s); 
                addXmlElement(w, 'over_21', s); 
                addXmlElement(w, 'eo', s);  
                addXmlElement(w, 'es', s);                  
                addXmlElement(w, 'ec', s);                  
                addXmlElement(w, 'ef', s);                  
                addXmlElement(w, 'comp_total', s); 
                addXmlElement(w, 'comp_fee', s);                  
                addXmlElement(w, 'age_total', s); 
                addXmlElement(w, 'age_fee', s);                  
                w.writeEndElement();  // end <dental>
	}

	private Integer sym2int(String s){
		if(String.isEmpty(s) || s.length() < 2) return -1;
		else {
			try{ return Integer.valueOf(s.substring(1));} catch(Exception e){return -1;}
		}
	}
	
	private String goString(Decimal d){ return ''+(d==null? 0:d);}
	private String goString(Integer i){ return ''+(i==null? 0:i);}
	
	private void sortPlans(List<SGR_Opportunity_Plan_Rate__c> currPs, List<SGR_Opportunity_Plan_Rate__c> renwPs){
		if(currPs==null || renwPs==null || currPs.isEmpty() || renwPs.isEmpty()) return; // empty list, nothing to sort
		if(currPs.size() != renwPs.size()) throw new SGR_Exception('Numbers of Current and Renewal plans do not match !!!');
		if(currPs.size() == 1) return; // one element in list, nothing to sort
		if(currPs.size() == 2){
			if(currPs[0].Plan__r.Marketing_Plan_Number__c == renwPs[0].Plan__r.Marketing_Plan_Number__c) return; // already in order for 2 elements, nothing to sort
			SGR_Opportunity_Plan_Rate__c renwP0 = renwPs[0]; SGR_Opportunity_Plan_Rate__c renwP1 = renwPs[1];
			// if different, swap [0] & [1] position and just return
			renwPs[0] = renwP1; renwPs[1] = renwP0; return;
		}
		// more than 3 elements, take out the idendical ones and sort them only
		List<String> currMpids = new List<String>();
		List<String> renwMpids = new List<String>();
		// below 2 boolean maps are used to mark identical plans
		Map<String,boolean> currBm = new Map<String,boolean>();
		Map<String,boolean> renwBm = new Map<String,boolean>();
		Map<String,SGR_Opportunity_Plan_Rate__c> currMps = new Map<String,SGR_Opportunity_Plan_Rate__c>();
		Map<String,SGR_Opportunity_Plan_Rate__c> renwMps = new Map<String,SGR_Opportunity_Plan_Rate__c>();
		setPrs(currPs, currMpids, currBm, currMps); setPrs(renwPs, renwMpids, renwBm, renwMps); 
		for(String s1 : currMpids){
			for(String s2 : renwMpids){
				if(s1 == s2){currBm.put(s1, true); RenwBm.put(s2, true); break;}
			}
		}
		List<String> identicalPns = new List<String>();
		for(String s1 : currMpids) if(currBm.get(s1) == true) identicalPns.add(s1);
		if(identicalPns.isEmpty()) return; // no sorting is needed
		identicalPns.sort();  // sort the identical elements
		// re-construct the currPs and renwPs
		List<SGR_Opportunity_Plan_Rate__c> currPsTmp = new List<SGR_Opportunity_Plan_Rate__c>(), renwPsTmp = new List<SGR_Opportunity_Plan_Rate__c>();
		pickPrs(identicalPns, currPsTmp, currMpids, currBm, currMps);
		pickPrs(identicalPns, renwPsTmp, renwMpids, renwBm, renwMps);
		currPs=currPsTmp; renwPs=renwPsTmp;  // re-assign new list and return
		return;
	}
	
	private void setPrs(List<SGR_Opportunity_Plan_Rate__c> prs, List<String> mpids, Map<String,boolean> bm, Map<String,SGR_Opportunity_Plan_Rate__c> prM){
		for(SGR_Opportunity_Plan_Rate__c pr : prs) {
			String mpn = pr.Plan__r.Marketing_Plan_Number__c;
			mpids.add(mpn); bm.put(mpn,false); prM.put(mpn,pr);
			return;
		}
	}
	
	private void pickPrs(List<String> identicalPns, List<SGR_Opportunity_Plan_Rate__c> psTmp, List<String> mpids, Map<String,boolean> bm, Map<String,SGR_Opportunity_Plan_Rate__c> prM){
		// put the identicals into the list first, then the non-identical ones
		for(String s : identicalPns) psTmp.add(prM.get(s));  // pick up the sorted identical ones
		for(String s : mpids) if( !bm.get(s)) psTmp.add(prM.get(s)); // pick up the non-identical ones
		return;
	}

}