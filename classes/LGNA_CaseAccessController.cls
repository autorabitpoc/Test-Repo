/* 
 * Author:  Rakesh Nunna
 * Initial Version: V1.0
 * Created date: 04/11/2018
  * Discription : Claas to control the access, based on the current logged in user record permission  for the Record Types(Insatallation(GEMS), SAM REquests)
*/
public class LGNA_CaseAccessController {
    
    @AuraEnabled
    public Static UserRecordAccess userAccessLevel(String caseId){
      UserRecordAccess caseRecord = [SELECT HasDeleteAccess, HasEditAccess, HasReadAccess, RecordId FROM UserRecordAccess WHERE RecordId=:caseId AND UserId = :UserInfo.getUserId()];
		System.debug('==caseRecord=='+caseRecord);
        return caseRecord;
    }

}