/********************************************************************************

 *
 * Copyright (C) 2016
 * Health Care Service Corporation (HCSC)
 * All Rights Reserved
 * 
 * File: GEMS_AccountSubmissionCompleteValidation.cls

*********************************************************************************
 *  Ver     Date(MM/DD/YYYY)  Name              Description
 *  ---     ----------------  ---------------   ----------------------
 *  1.1     06/10/2015        Praveen           Class that validates below scenarios:
 
                                                Whenever user clicks the â€œCompleteâ€™ button on Account Submission Case, 
                                                system should validate following scenarios 
                                                - Parent ID Card case has completed. 
                                                - Parent SBC Case has Completed 
                                                - SIGNED BPA document to be attached the Account submission case 
                                                - Medical Benefit Coding has completed (â€œMedical Benefits Production Readyâ€) 
                                                - Pharmacy Coding has completed (â€œAS400 & BlueStar Update Completedâ€) 
                                                - Dental Benefit Coding has completed 
                                                If above all conditions satisfy, then Change status of Submission Case to Completed
                                                else if SIGNED BPA document is not found then change the Submission Case status to Completed – Without SIGNED BPA
 
*********************************************************************************/

global class GEMS_AccountSubmissionCompleteValidation
{
    public GEMS_AccountSubmissionCompleteValidation() 
    {
        
    }
    webservice static String validateChildCasesStatus(String caseID )
    {
        Map<Id, Case>  recordTypeIdAndChildCaseMap = new Map<Id, Case>();
        
        Case caseRec;
        
        Boolean signedBPAFound = false;
        
        Id accountStructureCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
        Id parentIDCardCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS ID Card').getRecordTypeId();
        Id parentAccSetUpProcessCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Setup').getRecordTypeId();
        Id parentSBCCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS SBC').getRecordTypeId();
        Id parentGEMSMedicalBenefitCodingCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Benefit Coding').getRecordTypeId();
        Id parentGEMSPharmacyCodingCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Pharmacy Coding').getRecordTypeId();
        Id parentGEMSDentalBenefitCodingCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Dental Benefit Coding').getRecordTypeId();
        
        Id GEMSAdditionalUnderwritingCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Additional Underwriting').getRecordTypeId();
        Id GEMSDentalUnderwritingCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Dental Underwriting').getRecordTypeId();
        Id GEMSMedicalUnderwritingCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Medical Underwriting').getRecordTypeId();
        
        Id GEMSFSUClaimsCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS FSUClaims').getRecordTypeId();
        Id GEMSEligibilityCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Eligibility').getRecordTypeId();
        Id GEMSMembershipCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Membership').getRecordTypeId();
        Id GEMSManualEligibilityCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Manual Eligibility').getRecordTypeId();
        Id GEMSGETCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS GET').getRecordTypeId();
        
        Set<String> errorMessages = new Set<String>();
        
        try
        {
            caseRec = [SELECT id,Status,RecordTypeId ,Recordtype.Name, GEMS_SBC_Required__c,GEMS_Products__c,
                            (SELECT Id, Status, RecordTypeId ,Recordtype.Name, isClosed from Cases1__r) 
                            FROM case WHERE Id =:caseID];
            
            List<GEMS_Attachment__c> attachedGEMSDocumentsList = New List<GEMS_Attachment__c>();
            attachedGEMSDocumentsList = [SELECT ID, Name, Attachment__c, BA_Info__c, Case__c,
                                        Description__c, Type__c, Level__c
                                        FROM GEMS_Attachment__c WHERE Case__c=:caseID];
            
            List<Case> childCaseList = new List<Case>();
            childCaseList=caseRec.Cases1__r;
            
            if(!childCaseList.isEmpty())
            {
                for(Case childRec: childCaseList)
                {
                    if(childRec.RecordTypeId == accountStructureCaseRecordTypeId)
                    {
                        recordTypeIdAndChildCaseMap.put(childRec.RecordTypeId, childRec);
                    }
                    
                    if(childRec.RecordTypeId == parentIDCardCaseRecordTypeId)
                    {
                        recordTypeIdAndChildCaseMap.put(childRec.RecordTypeId, childRec);
                    }
                    if(childRec.RecordTypeId == parentAccSetUpProcessCaseRecordTypeId)
                    {
                        recordTypeIdAndChildCaseMap.put(childRec.RecordTypeId, childRec);
                    }
                    if(childRec.RecordTypeId == GEMSAdditionalUnderwritingCaseRecordTypeId)
                    {
                        recordTypeIdAndChildCaseMap.put(childRec.RecordTypeId, childRec);
                    }
                    if(childRec.RecordTypeId == GEMSDentalUnderwritingCaseRecordTypeId)
                    {
                        recordTypeIdAndChildCaseMap.put(childRec.RecordTypeId, childRec);
                    }
                    if(childRec.RecordTypeId == GEMSMedicalUnderwritingCaseRecordTypeId )
                    {
                        recordTypeIdAndChildCaseMap.put(childRec.RecordTypeId, childRec);
                    }
                    if((childRec.RecordTypeId == parentSBCCaseRecordTypeId) || (caseRec.GEMS_SBC_Required__c != 'Yes') )
                    {
                        recordTypeIdAndChildCaseMap.put(childRec.RecordTypeId, childRec);
                    }
                    if(childRec.RecordTypeId == parentGEMSMedicalBenefitCodingCaseRecordTypeId)
                    {
                        recordTypeIdAndChildCaseMap.put(childRec.RecordTypeId, childRec);
                    }
                    if(childRec.RecordTypeId == parentGEMSPharmacyCodingCaseRecordTypeId)
                    {
                        recordTypeIdAndChildCaseMap.put(childRec.RecordTypeId, childRec);
                    }
                    if(childRec.RecordTypeId == parentGEMSDentalBenefitCodingCaseRecordTypeId)
                    {
                        recordTypeIdAndChildCaseMap.put(childRec.RecordTypeId, childRec);
                    }
                    
                    
                    if(childRec.RecordTypeId == GEMSFSUClaimsCaseRecordTypeId)
                    {
                        recordTypeIdAndChildCaseMap.put(childRec.RecordTypeId, childRec);
                    }
                    if(childRec.RecordTypeId == GEMSEligibilityCaseRecordTypeId)
                    {
                        recordTypeIdAndChildCaseMap.put(childRec.RecordTypeId, childRec);
                    }
                    if(childRec.RecordTypeId == GEMSMembershipCaseRecordTypeId)
                    {
                        recordTypeIdAndChildCaseMap.put(childRec.RecordTypeId, childRec);
                    }
                    if(childRec.RecordTypeId == GEMSManualEligibilityCaseRecordTypeId)
                    {
                        recordTypeIdAndChildCaseMap.put(childRec.RecordTypeId, childRec);
                    }
                    if(childRec.RecordTypeId == GEMSGETCaseRecordTypeId)
                    {
                        recordTypeIdAndChildCaseMap.put(childRec.RecordTypeId, childRec);
                    }
                }
            }
            if(!attachedGEMSDocumentsList.isEmpty())
            {
                for(GEMS_Attachment__c attachRec: attachedGEMSDocumentsList)
                {
                    if(attachRec.Type__c=='BPA - SIGNED' || attachRec.Type__c=='BPA - ASO SIGNED' 
                    || attachRec.Type__c=='BPA - DENTAL SIGNED' || attachRec.Type__c=='BPA - HCA SIGNED' 
                    || attachRec.Type__c=='BPA - HEALTH SIGNED')
                    {
                        signedBPAFound = true;
                    }
                }
            }
        }
        Catch(Exception ex)
        {
            return ex.getMessage();
        }
        
        if(!recordTypeIdAndChildCaseMap.Values().isEmpty() || recordTypeIdAndChildCaseMap.Values()!=null)
        {
            Case accountStructureCase = recordTypeIdAndChildCaseMap.get(accountStructureCaseRecordTypeId);
            if(accountStructureCase!=null && !(accountStructureCase.status =='Client Approval Received' || accountStructureCase.status == 'BlueSTAR Sent' || accountStructureCase.status == 'BlueSTAR Shell Created' 
                 || accountStructureCase.status == 'BlueSTAR Failed' || accountStructureCase.status == 'BlueSTAR Partial Fail'))
            {
                errorMessages.add('\nStructure Case is not Closed');
            }
            Case GEMSGETCaseRecord = recordTypeIdAndChildCaseMap.get(GEMSGETCaseRecordTypeId);
            if(GEMSGETCaseRecord!=null && !GEMSGETCaseRecord.isClosed)
            {
                errorMessages.add('\nGET Case is not Closed');
            }
            Case parentIDCardCase = recordTypeIdAndChildCaseMap.get(parentIDCardCaseRecordTypeId);
            if(parentIDCardCase!=null && !parentIDCardCase.isClosed)
            {
                errorMessages.add('\nID Card Case is not Closed');
            }
            
            Case parentAccSetUpProcessCase = recordTypeIdAndChildCaseMap.get(parentAccSetUpProcessCaseRecordTypeId);
            if(parentAccSetUpProcessCase!=null && !parentAccSetUpProcessCase.isClosed)
            {
                errorMessages.add('\nAccount Setup Process Case is not Closed');
            }
            
            Case GEMSAdditionalUnderwritingCase = recordTypeIdAndChildCaseMap.get(GEMSAdditionalUnderwritingCaseRecordTypeId);
            if(GEMSAdditionalUnderwritingCase!=null && !GEMSAdditionalUnderwritingCase.isClosed)
            {
                errorMessages.add('\nAdditional Underwriting Case is not Closed');
            }
            Case GEMSDentalUnderwritingCase = recordTypeIdAndChildCaseMap.get(GEMSDentalUnderwritingCaseRecordTypeId);
            if(GEMSDentalUnderwritingCase!=null && !GEMSDentalUnderwritingCase.isClosed)
            {
                errorMessages.add('\nDental Underwriting Case is not Closed');
            }
            Case GEMSMedicalUnderwritingCase = recordTypeIdAndChildCaseMap.get(GEMSMedicalUnderwritingCaseRecordTypeId);
            if(GEMSMedicalUnderwritingCase!=null && !GEMSMedicalUnderwritingCase.isClosed)
            {
                errorMessages.add('\nMedical Underwriting Case is not Closed');
            }
            
            Case parentSBCCaseRecord = recordTypeIdAndChildCaseMap.get(parentSBCCaseRecordTypeId);
            if(parentSBCCaseRecord!=null && !parentSBCCaseRecord.isClosed)
            {
                errorMessages.add('\nSBC Case is not Closed');
            }
            
            Case parentGEMSMedicalBenefitCodingCaseRecord = recordTypeIdAndChildCaseMap.get(parentGEMSMedicalBenefitCodingCaseRecordTypeId);
            if(parentGEMSMedicalBenefitCodingCaseRecord!=null && !parentGEMSMedicalBenefitCodingCaseRecord.isClosed)
            {
                errorMessages.add('\nMedical Benefit Coding Case is not Closed');
            }
            
            Case parentGEMSPharmacyCodingCaseRecord = recordTypeIdAndChildCaseMap.get(parentGEMSPharmacyCodingCaseRecordTypeId);
            if(parentGEMSPharmacyCodingCaseRecord!=null && !parentGEMSPharmacyCodingCaseRecord.isClosed)
            {
                errorMessages.add('\nPharmacy Coding Case is not Closed');
            }
            
            Case parentGEMSDentalBenefitCodingCaseRecord = recordTypeIdAndChildCaseMap.get(parentGEMSDentalBenefitCodingCaseRecordTypeId);
            if(parentGEMSDentalBenefitCodingCaseRecord!=null && !parentGEMSDentalBenefitCodingCaseRecord.isClosed)
            {
                errorMessages.add('\nDental Benefit Coding Case is not Closed');
            }
            
            
            Case GEMSFSUClaimsCaseRecord = recordTypeIdAndChildCaseMap.get(GEMSFSUClaimsCaseRecordTypeId);
            if(GEMSFSUClaimsCaseRecord!=null && !GEMSFSUClaimsCaseRecord.isClosed)
            {
                errorMessages.add('\nFSU Claims Case is not Closed');
            }
            Case GEMSEligibilityCaseRecord = recordTypeIdAndChildCaseMap.get(GEMSEligibilityCaseRecordTypeId);
            if(GEMSEligibilityCaseRecord!=null && !GEMSEligibilityCaseRecord.isClosed)
            {
                errorMessages.add('\nEligibility Process Case is not Closed');
            }
            Case GEMSMembershipCaseRecord = recordTypeIdAndChildCaseMap.get(GEMSMembershipCaseRecordTypeId);
            if(GEMSMembershipCaseRecord!=null && !GEMSMembershipCaseRecord.isClosed)
            {
                errorMessages.add('\nMembership Case is not Closed');
            }
            Case GEMSManualEligibilityCaseRecord = recordTypeIdAndChildCaseMap.get(GEMSManualEligibilityCaseRecordTypeId);
            if(GEMSManualEligibilityCaseRecord!=null && !GEMSManualEligibilityCaseRecord.isClosed)
            {
                errorMessages.add('\nManual Eligibility Case is not Closed');
            }
            
            
            /***********Add more errors here**************/
            if(!signedBPAFound)
            {
                errorMessages.add('\nSIGNED BPA attachment is not found');
            }
        }
        
        List<String> listStrings = new List<String>(errorMessages);
        
        if(errorMessages.size()>=1 && !(listStrings[0].Contains('\nSIGNED BPA attachment is not found'))) // && errorMessages[0]!='SIGNED BPA attachment is not found'
        {
            String errorMsgString = 'Please review below items to Close Submission Case:' + string.join(listStrings,',');
            return errorMsgString;
        }
        if(errorMessages.isEmpty() && signedBPAFound)
        {
             caseRec.Status = 'Completed';
             update caseRec;
             return ('Case Status Updated to "Complete" Successfully');
        }
        if(errorMessages.Size()==1 && !signedBPAFound && listStrings[0]=='\nSIGNED BPA attachment is not found')
        {
             caseRec.Status = 'Completed – Without SIGNED BPA';
             update caseRec;
             return ('Case Status Updated to "Completed – Without SIGNED BPA" Successfully');
        }
        
        return null;
    }
}