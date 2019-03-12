/**************************************************************************************
  Apex Class Name     : ConstantsController
  Version             : 1.0
  Function            : This is a utility Class used for maintaining various constants which are used in classes and triggers for removing the hardCoding
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------
* Nitin Paliwal           06/08/2015                Original Version
*************************************************************************************/
public with sharing class ConstantsController {
    public static String TaskTypeForUpdatingCaseStatus = 'Need Additional Information';
    public static string updatedCaseStatus = 'Waiting for Information';
    public static string UnderwritingCaseRecordType = 'Underwriting';
    public static string DentalUnderwritingCaseRecordTypeDeveloperName = 'Dental_Underwriting';
    public static string DentalUnderwritingCaseRecordType = 'Dental Underwriting';
    public static string HCSC_Non_BlueStar_Product = 'HCSC Non BlueStar Product';
    public static string  Risk_level_5 = '5 - In Jeopardy';
    public static string  Risk_level_4 = '4 - High';
    public static Date hpsPerformanceMetricDateRequired = Date.newInstance(date.today().year(), 1, 31);
    public static String hpsPerformanceMetricRecordTypeRequired = 'Renewal';
    public static String LGNAGeneralCaseRecordTypeName = 'LGNA_General_Case';
    public static List<String> smallGroupCaseRecordTypeNames = new List<String> {'SG_General_Case'};
    public static String smallGroupCaseRecordTypeName = 'SG - General Case';
    public Static String hpsAMGoalsReportNameCaseByPriority = 'Home_Page_Open_Cases_By_Priority';
    public Static String RenewalOppRecordTypeName = 'Renewal';
    public static String OpportunityStageNameRenewalPlanning = 'Renewal Planning';
    public static string ApexClassLabel = 'Apex Class';
    public static String HomePageLabel = 'HomePage';
    public static boolean shouldCarrierHistoryValidationFire = true;
    public static boolean isTaskCompletionEmailSent = false;
    public static boolean shouldCBSRCalloutProcess = true;
    public static String blueSTARName = 'Bluestar'; //match the name from custom setting 'username password'
    public static String cbsrName='CaseModule1';//match the name from custom setting 'username password'
    public static String eSalesName='ESalesModule';//match the name from custom setting 'username password'
    public static String blueSTARContactPrimaryFieldSet = 'BlueSTAR_Contact_Primary_Required_Fields';
    public static String blueSTARContactBAEFieldSet = 'BlueSTAR_Contact_BAE_Required_Fields';
    public static String blueSTARContactMailingFieldSet = 'BlueSTAR_Contact_Mailing_Required_Fields';
    public static String blueSTARContactBillingFieldSet = 'BlueSTAR_Contact_Billing_Required_Fields';
    public static String contactTypePrimary = 'Primary';
    public static String contactTypeBAE = 'BAE';
    public static String contactTypeMailing = 'Mailing';
    public static String contactTypeBilling = 'Billing';
    public static Boolean canMakeFutureCalls = True;
    public static String systemAdministrator = 'System Administrator';
    public static String integrationProfile = 'Integration Profile';

    //Record types used for AccountTriggerHandler
    public static String reasonForCaseCancel = 'Cancelled because the account was cancelled';
    public static String groupAccountRT = 'Group Account';
    public static String customContractRTCase = 'Custom Contracts';
    public static String caseCancelledStatus = 'Cancelled';
    
    //to be used in HPS_MY_GEMS_CasesController and HPS_MyCasesController
    public static String GEMS = 'GEMS';

 // Used in Case Trigger Handler 
    public static String GEMSAccountSubmissionRT = 'GEMS Account Submission';
    
    public static boolean changeIntegrationAction = true;
    //to be used in HPS_MyActiveAccountsController
    public static String GroupAccountRecordType = 'Group_Account';
    public static String ActiveAccountStatusMandatoryCriteria = 'Cancelled';
    public static String AccountStatusActive = 'Active';
    public static String OpportunityExchangeOfferingNoPE = 'No Private Exchange';
    //to be used in HPS_MyActivities
    public static String TaskStageToExclude = 'Completed';

    // used in AccountTriggerHandler.CreateRenewalOpportunity
    public static Integer DaysUntilAllowedAutoCreateOpp = 120;
    public static Integer DaysUntilAutoCreateOpp = 120;

    //to be used in the RatingMatrixASOController for the number of rate groups to create
    public static Integer numberOfOtherRatesCharge = 4;
    public static Integer numberOfOtherRatesPEPM = 4;
    public static Integer numberOfMiscellaneous = 2;
    
    //to be used in HPS_MyGoalsController
    public static String MyGoalsReportName = 'Sales_Pipeline';

    //to be used in HPS_MyMetrics_NewController
    public static String ProductsRequired = 'Ancillary and other';

    //to be used in HPS_MyOpportunitiesController
    public static String NewSaleOpportunityRecordTypeName = 'New_Sale';

    //to be used in Contact Trigger as the record Type Necessary in the populating associated user field funtion
    public static String ContactRecordType = 'Internal_Contact';
    public static String contactRecordTypeInternalContact = 'Internal Contact';

    //to be used in HPS_MyProspectsController
    public static String accountProspectRecordType = 'Prospect';

    //to be used in the HPS_MyTeamMetrics_NewController
    public static string productFamilyName = 'Ancillary and other';

    //to be used in HPS_MyTeamsActiveAccountsController
    public static string AccountTeamMemberRole = 'Account Executive';

    //to be used in HPS_MyTeamsOpportunitiesController
    public static string opportunityTeamMemberRole = 'Sales Executive';

    //to be used in HPS_MyTeamsOpportunitiesController
    public static string opportunityTeamMemberAccounRole = 'Account Executive';

    //to be used in HPS_MyTeamsProspectsController
    public static string AccountTeamMemberSalesRole = 'Sales Executive';

    //to be used in the Opportunity360ViewController
    public static string OpenActivitiesReport = 'Open_Activities_By_Opportunity';
    public static string PastDueActivitiesReport = 'Past_Due_Activities_By_Opportunity';

    //to be used in the OpportunityTriggerHandler
    public static string ClosedWonStatusLabel = 'Closed Won';
    public static String opportunityMarketSegmentSG = 'SG';
    public static String opportunityMarketSegmentNAL = 'NAL';
    public static String opportunityMarketSegmentHWB = 'HWB';
    public static String opportunityForecastSegmentENA = 'ENA';
    public static String opportunityForecastSegmentSmallGroup = 'Small Group';
    public static String opportunityForecastSegmentLabor = 'Labor';
    public static String opportunityForecastSegmentLargeGroup = 'Large Group';

    //to be used in the ProductLandscapeController
    public static String HCSCNonBlueStarRecordType = 'HCSC_Non_BlueStar_Product';
    public static string HCSCBlueStarProduct = 'HCSC_BlueStar_Product';

    //to be used in AccountTriggerHandler
    public static string accountType = 'Sub Producer';
    public static string contactType = 'Producer';
    public static String accountMarketSegmentSG = 'SG';
    public static String accountMarketSegmentNAL = 'NAL';
    public static String accountMarketSegmentHWB = 'HWB';
    public static String accountForecastSegmentENA = 'ENA';
    public static String accountForecastSegmentSmallGroup = 'Small Group';
    public static String accountForecastSegmentLabor = 'Labor';
    public static String accountForecastSegmentLargeGroup = 'Large Group';
    

    //to be used in BuyerHierarchyOnAccountController
    public static String ContactGroupRecordType = 'Group_Contact';

    //to be used in ConfirmProgressOnLostProductsController
    public static Integer numberToMultiplyTotalMembersByForContracts = 2;

    //to be used in the ESALESUtilityController
    public static String CaseMidMarketingRecordType = 'Mid_Market_Underwriting';

    //to be used in the GroupAccount360 page
    public static String Open_Cases_By_Priority = 'Open_Cases_By_Priority';
    public static String Open_Activities_By_Account = 'Open_Activities_By_Account';
	
    public static string optyPlanRateTypeCurrent = 'Current';
    public static string optyPlanRateTypeRenewal = 'Renewal';
    
    //to be used in the ContactRelationshipMapController
    public Static String Image1Url = 'https://c.cs15.content.force.com/servlet/servlet.ImageServer?id=015e00000008KbV&oid=00De0000005UsP5&lastMod=1424885463000';
    public static string Image2Url = 'https://c.cs15.content.force.com/servlet/servlet.ImageServer?id=015e00000008Kba&oid=00De0000005UsP5&lastMod=1424885444000';
    public static Set<ID> getAllSubordinateUsers(set<ID> userIds) {
        try {
            Set<ID> teamUserIds = new Set<ID>();
            for (User userObj : [    SELECT  Id
                                     FROM    User
                                     WHERE   ManagerId In :userIds limit   :Limits.getLimitQueryRows() - Limits.getQueryRows()]) {
                teamUserIds.add(userObj.Id);
            }


            return teamUserIds;
        } catch (Exception e) {
            System.debug( 'Exception : ' + e.getMessage() );
            throw e;
        }
    }
    public static set<String> caseRecordTypePermissibleWhenOppUpdatedChatter = new set<String> {'Proposal', 'Dental_Underwriting', 'Cede', 'Network_Information', 'Private_Exchange_Blue_Directions', 'Private_Exchange_External', 'Underwriting'};
    //public static set<String> caseRecordTypePermissibleWhenCaseUpdatedChatter = new set<String>{'Proposal','Dental_Underwriting','Network_Information','Underwriting','Cede'};
    public static set<String> caseRecordTypePermissibleWhenCaseUpdatedChatter {
        get{
            if (caseRecordTypePermissibleWhenCaseUpdatedChatter == null) {
                caseRecordTypePermissibleWhenCaseUpdatedChatter = new set<String>();
                for (Case_Record_Types_Chatter_Post__c crt : Case_Record_Types_Chatter_Post__c.getAll().values()) {
                    caseRecordTypePermissibleWhenCaseUpdatedChatter.add(crt.Name);
                }
            }
            return caseRecordTypePermissibleWhenCaseUpdatedChatter;
        }
        set{}
    }
    public static set<String> OpportunityStagesConsideredForChatterPost = new set<String> {'Won', 'Lost', 'Declined'};
    public static set<String> CaseStatusConsideredForChatterPost = new set<String> {'Closed', 'Declined'};
    //to be used for trigger execution
    public static Boolean CheckTriggerExecution(Id ProfileId, String FieldName) {
        TriggerExecution__c CS = TriggerExecution__c.getInstance(ProfileId);
        Boolean ExecutionFlag = Boolean.valueOf(CS.get(FieldName));
        return ExecutionFlag;
    }

    //Used for controlling trigger execution
    public static String AccountTriggerField                = 'Account_Trigger__c';
    public static String AttachmentTriggerField             = 'Attachment_Trigger__c';
    public static String BenefitAgreementTriggerField       = 'Benefit_Agreement_Trigger__c';
    public static String CaseComponentTriggerField          = 'Case_Component_Trigger__c';
    public static String CaseTriggerField                   = 'Case_Trigger__c';
    public static String ContactRelationshipTriggerField    = 'Contact_Relationship_Trigger__c';
    public static String ContactTriggerField                = 'Contact_Trigger__c';
    public static String IntegrationStatusTriggerField      = 'Integration_Status_Trigger__c';
    public static String OpportunityTriggerField            = 'Opportunity_Trigger__c';
    public static String TaskTriggerField                   = 'Task_Trigger__c';
    public static String UserTriggerField                   = 'User_Trigger__c';
    public static String CaseOwnershipTriggerField          = 'Case_Ownership_Trigger__c';
    public static String ContentDocumentLinkTriggerField    = 'Content_Document_Link_Trigger__c';
    public static String ContentVersionTriggerField         = 'Content_Version_Trigger__c';
    public static string CompetitorRelationshipTriggerFIeld = 'Competitor_Relationship_Trigger__c';
    public static string SecureInformationTriggerFIeld      = 'Secure_Information_Trigger__c';
    //Used in Account Cancellation
    public static String pendingApprovalStatus          = 'Pending Approval';
    public static String cancelledStatus                = 'Cancelled';
    public static String submittedStatus                = 'Submitted';
    public static String requestedCancellationStatus    = 'Requested Cancellation';
    public static boolean shouldCaseTriggerProcess      = true;

    //Used in LineItemReviewTriggerHandler.cls
    public static String pgCaseStatusInternalHCSCSMEReview = 'Internal HCSC SME Review';
    public static String pgCaseStatusInternalHCSCUWReview = 'Internal HCSC UW Review';
    public static String pgCaseStatusInternalReviewedbySMEs ='Reviewed by SMEs';
    public static String pgCaseStatusInternalReviewedbyUW ='Reviewed by UW';

    //Used in CaseTriggerHandler.cls for Performance Guarantee
    public static String pgCaseStatusNew = 'New';
    public static String pgCaseStatusInProgress = 'In Progress';
    public static String pgCaseStatusSentBackforMoreInfo = 'Sent Back for More Info';
    public static String profileLGNAAcctMgmt = 'LGNA - Account Management';
    public static String profileLGNASales = 'LGNA - Sales';
    public static String UWReviewStatus = 'Internal HCSC UW Review';
    public static String dispositionStatusSubmitted = 'Submitted';

    public static Set<Id> populateSmallGroupCaseRecordTypeIds() {
        Set<Id> smallGroupCaseRecordTypeIds = new Set<Id>();
        /*for ( RecordType rt : [   select  Id, DeveloperName
                                  from    RecordType
                                  where   DeveloperName IN :ConstantsController.smallGroupCaseRecordTypeNames
                                  and SobjectType = 'Case'
                                          limit   :Limits.getLimitQueryRows() - Limits.getQueryRows() ] ) {
            smallGroupCaseRecordTypeIds.add( rt.Id );
        }*/

        smallGroupCaseRecordTypeIds.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get(ConstantsController.smallGroupCaseRecordTypeName).getRecordTypeId());
        return smallGroupCaseRecordTypeIds;
    }
    public static BusinessHours defaultBusinessHours {
        get{
            if (defaultBusinessHours == null) {
                defaultBusinessHours = [    SELECT  IsActive, Id , IsDefault
                FROM    BusinessHours
                where   IsActive = true
                and IsDefault = true
                limit   1 ];
            }
            return defaultBusinessHours;
        }
        set{}

    }
    public static boolean fireContentVersionValidation = true;
    public static boolean shouldContinueWithOwnerCreation = true;
    public static User LoggedInUserInfo {
        get{
            if (LoggedInUserInfo == null) {
                LoggedInUserInfo = [select id , profile.name, Is_Super_User__c from user where id = : Userinfo.getUserId() limit 1];
            }
            return LoggedInUserInfo;
        }
        set{}

    }

    public static list<Group> groups {
        get{
            if (groups == null) {

                groups = [SELECT Id, Name, DeveloperName FROM Group where Type = 'Queue' limit   :Limits.getLimitQueryRows() - Limits.getQueryRows() ];
            }
            return groups;
        }
        set{}

    }

    public static list<FeedItem> sendChattertoTeams(set<String> userIds, string chatterMessage, string linkURL, String title) {
        try {
            /*map<String,list<Notify_Team_with_chatter__c>> customSettingsMap = new map<String,list<Notify_Team_with_chatter__c>>();
            for(Notify_Team_with_chatter__c ntc : Notify_Team_with_chatter__c.getAll().values()){
                if(!customSettingsMap.containsKey(ntc.Parent_Object__c)){
                   customSettingsMap.put(ntc.Parent_Object__c,new list<Notify_Team_with_chatter__c>());
                }
                if(ntc.Notify_Team_with_chatter__c)
                    customSettingsMap.get(ntc.Parent_Object__c.tolowerCase()).add(ntc);
            }
            string objectName = '';
            if(recordId.substring(0,3) == '500')
               objectName = 'case';

            else if(recordId.substring(0,3) == '001')
               objectName = 'account';

            else if(recordId.substring(0,3) == '006')
               objectName = 'opportunity';

            if(objectName != '' && customSettingsMap.containsKey(objectName)){

            }*/
            /*ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
            feedItemInput.body = messageBodyInput;
            List<ConnectApi.MessageSegmentInput> segments = new list<ConnectApi.MessageSegmentInput>();

            for(Id userId : userIds){
                ConnectApi.MentionSegmentInput mention = new ConnectApi.MentionSegmentInput();
                mention.id = userId ;
                segments.add(mention);
            }
            ConnectApi.TextSegmentInput beforeText = new ConnectApi.TextSegmentInput();
            beforeText.text = '\n'+chatterMessage;
            segments.add(beforeText);
            feedItemInput.body.messageSegments = segments;
            ConnectApi.ChatterFeeds.postFeedItem(null, ConnectApi.FeedType.Record, recordId, feedItemInput, null);
            */
            list<FeedItem> feeds = new list<FeedItem>();
            for (String userId : userIds) {
                FeedItem post = new FeedItem();
                post.ParentId =  userId;
                post.Body = chatterMessage;
                post.type = 'LinkPost';  // can be other type
                post.LinkUrl = linkURL;
                post.Title = title;
                feeds.add(post);
            }
            return feeds;
        } catch (Exception e) {
            return new list<FeedItem>();
        }
    }

    //to be used in AccountTriggerHandler.calculateFieldComplexityScore
    public static Integer PointsForFundingTypeOtherThanASO = 1;
    //to be used in BenefitAgreementTriggerHandler.calculateBenefitAgreementComplexityScore
    public static String stopLossY = 'Y';
    public static String productCategoryHMO = 'HMO';
    public static String productCategoryDearborn = 'Dearborn';
    public static String productCategoryDental = 'Dental';
    public static String BLUEEDGEplan = 'BLUEEDGE';
    //to be used in CaseTriggerHandler.calculateCaseComplexityScore
    public static Set<String> statuses = new Set<String>{ 'In Progress', 'Submitted', 'Sent Back for More Info', 'Internal HCSC SME Review', 
                                            'Reviewed by SMEs', 'Internal HCSC UW Review', 'Reviewed by UW', 'Approved'};
    //to be used in CoverageTriggerHandler.calculateBenefitAgreementCoverageComplexity
    public static String BlueStar = 'BlueStar';
    public static String typeDrug = 'DRUG';
    //to be used in ContractAdministrationTriggerHandler.calculateContractAdministrationComplexityScore
    public static Set<String> complexities = new Set<String>{'Low', 'Medium', 'High'};
    //to be used in SharePointFolderBuilder
    public static String prospectAccNum = '000000';
    
   // public static Map<String, String> certificateMap =System.label.HCSCCertificate;//assignCertificate();
    public static String certificateMap =System.label.HCSCCertificate;
    
  /*  public static Map<String, String> assignCertificate () {
		
		// Return Value
		Map<String, String> tempMap = new Map<String, String>(); 
		
		// Fetch values from Custom Setting - CallOut_Certificates__c
		for (CallOut_Certificates__c consObj : CallOut_Certificates__c.getAll().values()) {
			tempMap.put(consObj.Name,consObj.Certificate_Name__c);
		}
		return tempMap;
	} 
	
    */
    
}