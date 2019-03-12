public with sharing class SGR_OppPlanRateSummary_Controller {

    @AuraEnabled
    /*SFDC-14950 - 12/2018 - Begin */
    public static wrapperOppPlanRateSummary fetchRates(Id inputOpportunityId, String inputCoverageType) {

        List<SGR_Opportunity_Plan_Rate__c> listReturnValues = new List<SGR_Opportunity_Plan_Rate__c>();
        List<SGR_Opportunity_Plan_Rate__c> listTempReturnValues = new List<SGR_Opportunity_Plan_Rate__c>();

        wrapperOppPlanRateSummary returnWrapper = new wrapperOppPlanRateSummary();

        String tempCoverageType = '';

        switch on inputCoverageType {
            when 'Health', 'H', 'h' {
                tempCoverageType = 'H';
            }
            when 'Dental', 'D', 'd' {
                tempCoverageType = 'D';
            }
            when 'Vision', 'V', 'v' {
                tempCoverageType = 'V';
            }
        }

        listReturnValues = [
                SELECT
                        Id,
                        Name,
                        Type__c,
                        Coverage_Type__c,
                        Opportunity__c,
                        Rate_Type_Code__c,
                        Enrolled_Subscriber_Count__c,
                        Enrolled_Member_Count__c,
                        Current_Comp_Total_Monthly_Premium__c,
                        Renw_Comp_Total_Monthly_Premium__c,
                        Current_Comp_Total_Est_Tax_and_Fees__c,
                        Renw_Comp_Total_Est_Tax_and_Fees__c,
                        Current_Age_Total_Monthly_Premium__c,
                        Renw_Age_Total_Monthly_Premium__c,
                        Current_Age_Total_Est_Tax_and_Fees__c,
                        Renw_Age_Total_Est_Tax_and_Fees__c
                FROM SGR_Opportunity_Plan_Rate__c
                WHERE
                Type__c IN ('Renewal', 'Alternate', 'Current') AND
                Coverage_Type__c = :tempCoverageType AND
                Opportunity__c = :inputOpportunityId
        ];

        //Check to see if Record has only Default Values to handle differently
        for (SGR_Opportunity_Plan_Rate__c aRecord : listReturnValues) {
            Boolean booleanIsNotADefaultRec = checkRecordToSeeIfOnlyDefaultValues(aRecord);
            if (booleanIsNotADefaultRec == true) {
                listTempReturnValues.add(aRecord);
            }
        }

        //Clear the original
        listReturnValues.clear();

        //Add those records who are not Default Only
        listReturnValues = listTempReturnValues.clone();

        for (SGR_Opportunity_Plan_Rate__c aRecord : listReturnValues) {

            if (aRecord.Rate_Type_Code__c != null) {
                returnWrapper.theRateTypeCode = aRecord.Rate_Type_Code__c;
            }

            if (aRecord.Enrolled_Subscriber_Count__c != null) {
                if (returnWrapper.sumEnrolledSubscriberCount != null) {
                    returnWrapper.sumEnrolledSubscriberCount = returnWrapper.sumEnrolledSubscriberCount + aRecord.Enrolled_Subscriber_Count__c;
                } else {
                    returnWrapper.sumEnrolledSubscriberCount = aRecord.Enrolled_Subscriber_Count__c;
                }
            }

            if (aRecord.Enrolled_Member_Count__c != null) {
                if (returnWrapper.sumEnrolledMemberCount != null) {
                    returnWrapper.sumEnrolledMemberCount = returnWrapper.sumEnrolledMemberCount + aRecord.Enrolled_Member_Count__c;
                } else {
                    returnWrapper.sumEnrolledMemberCount = aRecord.Enrolled_Member_Count__c;
                }
            }

            if (aRecord.Current_Comp_Total_Monthly_Premium__c != null) {
                if (returnWrapper.sumCurrentCompTotalMonthlyPremium != null) {
                    returnWrapper.sumCurrentCompTotalMonthlyPremium = returnWrapper.sumCurrentCompTotalMonthlyPremium + aRecord.Current_Comp_Total_Monthly_Premium__c;
                } else {
                    returnWrapper.sumCurrentCompTotalMonthlyPremium = aRecord.Current_Comp_Total_Monthly_Premium__c;
                }
            }

            if (aRecord.Renw_Comp_Total_Monthly_Premium__c != null) {
                if (returnWrapper.sumRenwCompTotalMonthlyPremium != null) {
                    returnWrapper.sumRenwCompTotalMonthlyPremium = returnWrapper.sumRenwCompTotalMonthlyPremium + aRecord.Renw_Comp_Total_Monthly_Premium__c;
                } else {
                    returnWrapper.sumRenwCompTotalMonthlyPremium = aRecord.Renw_Comp_Total_Monthly_Premium__c;
                }
            }

            if (aRecord.Current_Comp_Total_Est_Tax_and_Fees__c != null) {
                if (returnWrapper.sumCurrentCompTotalEstTaxandFees != null) {
                    returnWrapper.sumCurrentCompTotalEstTaxandFees = returnWrapper.sumCurrentCompTotalEstTaxandFees + aRecord.Current_Comp_Total_Est_Tax_and_Fees__c;
                } else {
                    returnWrapper.sumCurrentCompTotalEstTaxandFees = aRecord.Current_Comp_Total_Est_Tax_and_Fees__c;
                }
            }

            if (aRecord.Renw_Comp_Total_Est_Tax_and_Fees__c != null) {
                if (returnWrapper.sumRenwCompTotalEstTaxandFees != null) {
                    returnWrapper.sumRenwCompTotalEstTaxandFees = returnWrapper.sumRenwCompTotalEstTaxandFees + aRecord.Renw_Comp_Total_Est_Tax_and_Fees__c;
                } else {
                    returnWrapper.sumRenwCompTotalEstTaxandFees = aRecord.Renw_Comp_Total_Est_Tax_and_Fees__c;
                }
            }

            if (aRecord.Current_Age_Total_Monthly_Premium__c != null) {
                if (returnWrapper.sumCurrentAgeTotalMonthlyPremium != null) {
                    returnWrapper.sumCurrentAgeTotalMonthlyPremium = returnWrapper.sumCurrentAgeTotalMonthlyPremium + aRecord.Current_Age_Total_Monthly_Premium__c;
                } else {
                    returnWrapper.sumCurrentAgeTotalMonthlyPremium = aRecord.Current_Age_Total_Monthly_Premium__c;
                }
            }

            if (aRecord.Renw_Age_Total_Monthly_Premium__c != null) {
                if (returnWrapper.sumRenwAgeTotalMonthlyPremium != null) {
                    returnWrapper.sumRenwAgeTotalMonthlyPremium = returnWrapper.sumRenwAgeTotalMonthlyPremium + aRecord.Renw_Age_Total_Monthly_Premium__c;
                } else {
                    returnWrapper.sumRenwAgeTotalMonthlyPremium = aRecord.Renw_Age_Total_Monthly_Premium__c;
                }
            }

            if (aRecord.Current_Age_Total_Est_Tax_and_Fees__c != null) {
                if (returnWrapper.sumCurrentAgeTotalEstTaxandFees != null) {
                    returnWrapper.sumCurrentAgeTotalEstTaxandFees = returnWrapper.sumCurrentAgeTotalEstTaxandFees + aRecord.Current_Age_Total_Est_Tax_and_Fees__c;
                } else {
                    returnWrapper.sumCurrentAgeTotalEstTaxandFees = aRecord.Current_Age_Total_Est_Tax_and_Fees__c;
                }
            }

            if (aRecord.Renw_Age_Total_Est_Tax_and_Fees__c != null) {
                if (returnWrapper.sumRenwAgeTotalEstTaxandFees != null) {
                    returnWrapper.sumRenwAgeTotalEstTaxandFees = returnWrapper.sumRenwAgeTotalEstTaxandFees + aRecord.Renw_Age_Total_Est_Tax_and_Fees__c;
                } else {
                    returnWrapper.sumRenwAgeTotalEstTaxandFees = aRecord.Renw_Age_Total_Est_Tax_and_Fees__c;
                }
            }

        }


        //Calculate the Net Adjustment Value
        if (listReturnValues.size() > 0) {
            if (returnWrapper.theRateTypeCode == 'AGE') {
                //Ensure Values used in the logic are not Null to avoid "de-reference a null object" errors
                if (returnWrapper.sumRenwAgeTotalMonthlyPremium != null && returnWrapper.sumCurrentAgeTotalMonthlyPremium != null) {
                    //Cant divide by Zero(0)
                    if (returnWrapper.sumCurrentAgeTotalMonthlyPremium != 0) {
                        returnWrapper.theNetAdjustment = (returnWrapper.sumRenwAgeTotalMonthlyPremium / returnWrapper.sumCurrentAgeTotalMonthlyPremium) - 1;
                    } else {
                        //Could not do calculation so just return Zero
                        returnWrapper.theNetAdjustment = 0;
                    }
                } else {
                    //Null Values so just return Zero
                    returnWrapper.theNetAdjustment = 0;
                }
            } else {
                //Ensure Values used in the logic are not Null to avoid "de-reference a null object" errors
                if (returnWrapper.sumCurrentCompTotalMonthlyPremium != null && returnWrapper.sumRenwCompTotalMonthlyPremium != null) {
                    //Cant divide by Zero(0)
                    if (returnWrapper.sumCurrentCompTotalMonthlyPremium != 0) {
                        returnWrapper.theNetAdjustment = (returnWrapper.sumRenwCompTotalMonthlyPremium / returnWrapper.sumCurrentCompTotalMonthlyPremium) - 1;
                    } else {
                        //Could not do calculation so just return Zero
                        returnWrapper.theNetAdjustment = 0;
                    }
                } else {
                    //Null Values so just return Zero
                    returnWrapper.theNetAdjustment = 0;
                }
            }
        }

        if (listReturnValues.size() == 0) {
            listReturnValues.clear();
            SGR_Opportunity_Plan_Rate__c emptyRecord = new SGR_Opportunity_Plan_Rate__c();
            emptyRecord.Coverage_Type__c = tempCoverageType;
            emptyRecord.Opportunity__c = inputOpportunityId;
            listReturnValues.add(emptyRecord);
        }
        returnWrapper.listRates = listReturnValues;
        return returnWrapper;
    }

    //Check a SGR_Opportunity_Plan_Rate__c to see if actual data or just default data
    private static Boolean checkRecordToSeeIfOnlyDefaultValues(SGR_Opportunity_Plan_Rate__c inputRecord) {

        Boolean theReturnValue = false;

        if (inputRecord.Enrolled_Subscriber_Count__c != null) {
            if (inputRecord.Enrolled_Subscriber_Count__c > 0 && theReturnValue == false) {
                theReturnValue = true;
            }
        }

        if (inputRecord.Enrolled_Member_Count__c != null) {
            if (inputRecord.Enrolled_Member_Count__c > 0 && theReturnValue == false) {
                theReturnValue = true;
            }
        }

        if (inputRecord.Current_Comp_Total_Monthly_Premium__c != null) {
            if (inputRecord.Current_Comp_Total_Monthly_Premium__c > 0 && theReturnValue == false) {
                theReturnValue = true;
            }
        }

        if (inputRecord.Renw_Comp_Total_Monthly_Premium__c != null) {
            if (inputRecord.Renw_Comp_Total_Monthly_Premium__c > 0 && theReturnValue == false) {
                theReturnValue = true;
            }
        }

        if (inputRecord.Current_Comp_Total_Est_Tax_and_Fees__c != null) {
            if (inputRecord.Current_Comp_Total_Est_Tax_and_Fees__c > 0 && theReturnValue == false) {
                theReturnValue = true;
            }
        }

        if (inputRecord.Renw_Comp_Total_Est_Tax_and_Fees__c != null) {
            if (inputRecord.Renw_Comp_Total_Est_Tax_and_Fees__c > 0 && theReturnValue == false) {
                theReturnValue = true;
            }
        }

        if (inputRecord.Current_Age_Total_Monthly_Premium__c != null) {
            if (inputRecord.Current_Age_Total_Monthly_Premium__c > 0 && theReturnValue == false) {
                theReturnValue = true;
            }
        }

        if (inputRecord.Renw_Age_Total_Monthly_Premium__c != null) {
            if (inputRecord.Renw_Age_Total_Monthly_Premium__c > 0 && theReturnValue == false) {
                theReturnValue = true;
            }
        }

        if (inputRecord.Current_Age_Total_Est_Tax_and_Fees__c != null) {
            if (inputRecord.Current_Age_Total_Est_Tax_and_Fees__c > 0 && theReturnValue == false) {
                theReturnValue = true;
            }
        }

        if (inputRecord.Renw_Age_Total_Est_Tax_and_Fees__c != null) {
            if (inputRecord.Renw_Age_Total_Est_Tax_and_Fees__c > 0 && theReturnValue == false) {
                theReturnValue = true;
            }
        }

        return theReturnValue;

    }

    public class wrapperOppPlanRateSummary {
        @AuraEnabled List<SGR_Opportunity_Plan_Rate__c > listRates { get; set; }
        @AuraEnabled String theRateTypeCode { get; set; }
        @AuraEnabled Decimal theNetAdjustment { get; set; }
        @AuraEnabled Decimal sumEnrolledSubscriberCount { get; set; }
        @AuraEnabled Decimal sumEnrolledMemberCount { get; set; }
        @AuraEnabled Decimal sumCurrentCompTotalMonthlyPremium { get; set; }
        @AuraEnabled Decimal sumRenwCompTotalMonthlyPremium { get; set; }
        @AuraEnabled Decimal sumCurrentCompTotalEstTaxandFees { get; set; }
        @AuraEnabled Decimal sumRenwCompTotalEstTaxandFees { get; set; }
        @AuraEnabled Decimal sumCurrentAgeTotalMonthlyPremium { get; set; }
        @AuraEnabled Decimal sumRenwAgeTotalMonthlyPremium { get; set; }
        @AuraEnabled Decimal sumCurrentAgeTotalEstTaxandFees { get; set; }
        @AuraEnabled Decimal sumRenwAgeTotalEstTaxandFees { get; set; }

    }
}