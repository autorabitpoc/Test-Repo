/**************************************************************************************
  Apex Class Name     : LineItemReviewTriggerHandler
  Version             : 1.0
  Function            : This is a handler class for LineItemReviewTrigger. The methods in 
                        this class are used as utility methods for LineItemReviewTrigger
  Modification Log    :
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Ralph Tariga              6/20/2016                Original Version
 *************************************************************************************/
public with sharing class LineItemReviewTriggerHandler {

   /* changePGParentCaseStatusIfAllLineItemsHaveDispositionHelper
   *  @developer: Ralph Tariga/Slalom, LLC
   *  @date: 6/20/2016
   *  @description: Helper method that checks if the Line Item Review children of a PG Case have all been dispositioned.
   *                If so, updates the status of the PG Case
   *  @parameters:  List<Case> cases : PG Cases to be checked
   *                String caseDesiredStatus : PG Case status to check against  
   *                String caseStatusToChangeTo : PG Case status to update to
   *                Id desiredPgCaseRecordTypeId : PG Case Record Type to check
   *  @return type: List<Case>
   */
   @TestVisible private static List<Case> changePGParentCaseStatusIfAllLineItemsHaveDispositionHelper(List<Case> cases, String caseDesiredStatus, String caseStatusToChangeTo, Id desiredPgCaseRecordTypeId) {
   		List<Case> casesToUpdate = new List<Case>();

   		for(Case curCase : cases) {
   			Boolean updateCaseStatus = False;
   			for(Line_Item_Review__c lir : curCase.Line_Item_Reviews__r) {
               if(lir.recordTypeId == desiredPgCaseRecordTypeId) {
                  updateCaseStatus = True;
                  if(curCase.Status != caseDesiredStatus || lir.Disposition_Date_Time__c == null) {
                     updateCaseStatus = False;
                     break;
                  }
               }
   			}
   			if(updateCaseStatus) {
   				curCase.Status = caseStatusToChangeTo;
   				casesToUpdate.add(curCase);	
   			}
   		}

   		return casesToUpdate; 	
   }

   /* changePGParentCaseStatusIfAllUWLineItemsHaveDisposition
   *  @developer: Ralph Tariga/Slalom, LLC
   *  @date: 6/20/2016
   *  @description: Helper method that checks if all Line Item Review Records with 
   *                "PG UW Line Item Review" Record Type for the Parent PG Case are closed. 
   *                If true, changes the Case Status to "Reviewed by UW"              
   *  @parameters: List<Line_Item_Review__c> lirList : List of updated Line Item Review records
   *                                                   of "PG UW Line Item Review" Record Type
   *  @return type: void
   */
   public static void changePGParentCaseStatusIfAllLineItemsHaveDisposition(List<Line_Item_Review__c> lirList) {
   	CaseDao.ICaseDAO caseDAOInstance = new CaseDAO();
      Set<Id> caseIds = new Set<Id>();

   	for(Line_Item_Review__c lir : lirList) {
   		if(lir.Disposition_Date_Time__c != null) {
   				caseIds.add(lir.Related_Case__c);
   		}
   	}

   	List<Case> caseMasterList = caseDAOInstance.getPGCasesAndLineItemReviewChildren(caseIds); 		
 		List<Case> smeCases = new List<Case>(); 
 		List<Case> uwCases = new List<Case>();
 		for(Case curCase : caseMasterList) {
 			if(curCase.Status == ConstantsController.pgCaseStatusInternalHCSCSMEReview) {
 				smeCases.add(curCase);
 			} 
 			else if(curCase.Status == ConstantsController.pgCaseStatusInternalHCSCUWReview) {
 				uwCases.add(curCase);
 			}
 		}

   	List<Case> smeCasesToUpdate = changePGParentCaseStatusIfAllLineItemsHaveDispositionHelper(smeCases, ConstantsController.pgCaseStatusInternalHCSCSMEReview, ConstantsController.pgCaseStatusInternalReviewedbySMEs, Schema.SObjectType.Line_Item_Review__c.getRecordTypeInfosByName().get('PG SME Line Item Review').getRecordTypeId());
   	List<Case> uwCasesToUpdate = changePGParentCaseStatusIfAllLineItemsHaveDispositionHelper(uwCases, ConstantsController.pgCaseStatusInternalHCSCUWReview, ConstantsController.pgCaseStatusInternalReviewedbyUW, Schema.SObjectType.Line_Item_Review__c.getRecordTypeInfosByName().get('PG UW Line Item Review').getRecordTypeId());

   	List<Case> masterCaseToUpdateList = new List<Case>();
   	masterCaseToUpdateList.addAll(smeCasesToUpdate);
   	masterCaseToUpdateList.addAll(uwCasesToUpdate);
   	caseDAOInstance.updatePGCasesStatuses(masterCaseToUpdateList);
   }
}