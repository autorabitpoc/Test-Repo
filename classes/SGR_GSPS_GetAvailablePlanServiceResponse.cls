//*************************************************************************************
// Name             : SGR_GSPS_GetAvailablePlanServiceResponse.cls
// Description      : Output Class for Get All Available Plans GSPS Service
// Created By       : Shankar
// Created Date     : 10/29/2018
// 
// ************************Version Updates********************************************
// Date         Developer   Description
// -----------------------------------------------------------------------------------
// 10/29/2018   Shankar     SFDC 14001, SFDC-14002 Initial version
// 11/12/2018	Shankar		SFDC-14001, SFDC-14002 Changes to reflect data model updates
// ************************************************************************************

global class SGR_GSPS_GetAvailablePlanServiceResponse {

    webService String name;
    webService String productGroupCode;
    webService String[] productGroupType;
    webService String division;
    webService String expiryDate;
    webService String effectiveDate;
    webService String endDate;
    webService String marketSegment;
    webService String fundingType;
    webService String lineOfBusiness;
    webService List<GSPS_PlanGroup> planGroups;
    webService String statusCode;
    webService String statusMessage;
    webService String errorMessage;
    webService String reqBody;
    webService String respBody;
    webService String fipsCodeList; //mulitple fipscodes in str
    webService Datetime execStart;
    webService Datetime execEnd;

    global class GSPS_PlanGroup {
        webService String name;
        webService String code;
        webService String planGroupExtId;
        webService String startDate;
        webService String endDate;
        webService String lineOfBusiness;
        webService String sortOrder;
        webService List<GSPS_PlanGroup> subPlanGroups;
        webService List<GSPS_Plan> plans;
        webService List<GSPS_BenefitHeader> benefitHeaders;
        webService List<GSPS_NoteDetail> noteDetails;
        webService GSPS_ProductType productType;
    }

    global class GSPS_Plan {
        webService String planName;
        webService String planSalesId;
        webService String description;
        webService String longDescription;
        webService String shortDescription;
        webService String effectiveDate;
        webService String retiredDate;
        webService String expiryDate;
        webService String endDate;
        webService String division;
        webService String planLevel;
        webService String network;
        webService String channel;
        webService Boolean isHsa;
        webService Boolean isAllCopay;
        webService String sortOrder;
        webService String hsacontribution;
        webService String mappedPlanName;
        webService List<GSPS_BenefitHeaderDetail> benefitHeaderDetails;
        webService List<GSPS_Note> notes;

        //added by MC
        webService String startDate;
        webService String lineOfBusiness;
        webService String level1SortOrder;
        webService String level2SortOrder;

    }

    global class GSPS_BenefitHeader {
        webService Integer id;
        webService Integer sortOrder;
        webService String name;
        webService List<GSPS_Note> notes;
    }
    global class GSPS_BenefitHeaderDetail {
        webService Integer id;
        webService String name;
        webService String value;
    }

    global class GSPS_NoteDetail {
        webService Integer id;
        webService String type;
        webService String text;
        webService String symbol;
    }

    global class GSPS_Note {
        webService Integer id;
        webService String symbol;
    }

    global class GSPS_ProductType {
        webService String code;
        webService String abbreviationCode;
        webService String description;
    }
}