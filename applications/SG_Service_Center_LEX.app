<?xml version="1.0" encoding="UTF-8"?>
<CustomApplication xmlns="http://soap.sforce.com/2006/04/metadata">
    <actionOverrides>
        <actionName>View</actionName>
        <comment>Action override created by Lightning App Builder during activation.</comment>
        <content>Case_Record_Page_SG_ServiceCenter</content>
        <formFactor>Large</formFactor>
        <skipRecordTypeSelect>false</skipRecordTypeSelect>
        <type>Flexipage</type>
        <pageOrSobjectType>Case</pageOrSobjectType>
    </actionOverrides>
    <actionOverrides>
        <actionName>View</actionName>
        <comment>Action override created by Lightning App Builder during activation.</comment>
        <content>GroupAccount_SG</content>
        <formFactor>Large</formFactor>
        <skipRecordTypeSelect>false</skipRecordTypeSelect>
        <type>Flexipage</type>
        <pageOrSobjectType>Account</pageOrSobjectType>
    </actionOverrides>
    <brand>
        <headerColor>#0080C7</headerColor>
    </brand>
    <description>HCSC - Small Group Service Center application</description>
    <formFactors>Large</formFactors>
    <label>Small Group - Service Center</label>
    <navType>Console</navType>
    <profileActionOverrides>
        <actionName>View</actionName>
        <content>ProducerAccount_SG</content>
        <formFactor>Large</formFactor>
        <pageOrSobjectType>Account</pageOrSobjectType>
        <recordType>Account.Producer_Account</recordType>
        <type>Flexipage</type>
        <profile>SG Service Center_LEX</profile>
    </profileActionOverrides>
    <profileActionOverrides>
        <actionName>View</actionName>
        <content>SGR_Cases</content>
        <formFactor>Large</formFactor>
        <pageOrSobjectType>Case</pageOrSobjectType>
        <recordType>Case.SGR_Renewals</recordType>
        <type>Flexipage</type>
        <profile>SGR UW User</profile>
    </profileActionOverrides>
    <profileActionOverrides>
        <actionName>View</actionName>
        <content>SGR_Cases</content>
        <formFactor>Large</formFactor>
        <pageOrSobjectType>Case</pageOrSobjectType>
        <recordType>Case.SGR_Renewals</recordType>
        <type>Flexipage</type>
        <profile>Admin</profile>
    </profileActionOverrides>
    <profileActionOverrides>
        <actionName>View</actionName>
        <content>SGR_Cases</content>
        <formFactor>Large</formFactor>
        <pageOrSobjectType>Case</pageOrSobjectType>
        <recordType>Case.SGR_Renewals</recordType>
        <type>Flexipage</type>
        <profile>SGR Operations User</profile>
    </profileActionOverrides>
    <profileActionOverrides>
        <actionName>View</actionName>
        <content>SGR_Cases</content>
        <formFactor>Large</formFactor>
        <pageOrSobjectType>Case</pageOrSobjectType>
        <recordType>Case.SGR_Renewals</recordType>
        <type>Flexipage</type>
        <profile>SGR Actuary User</profile>
    </profileActionOverrides>
    <profileActionOverrides>
        <actionName>View</actionName>
        <content>SGR_Cases</content>
        <formFactor>Large</formFactor>
        <pageOrSobjectType>Case</pageOrSobjectType>
        <recordType>Case.SGR_Renewals</recordType>
        <type>Flexipage</type>
        <profile>SGR_Group Verifier</profile>
    </profileActionOverrides>
    <profileActionOverrides>
        <actionName>View</actionName>
        <content>ProducerAccount_SG</content>
        <formFactor>Large</formFactor>
        <pageOrSobjectType>Account</pageOrSobjectType>
        <recordType>Account.Producer_House</recordType>
        <type>Flexipage</type>
        <profile>SG Service Center_LEX</profile>
    </profileActionOverrides>
    <setupExperience>all</setupExperience>
    <tab>standard-Account</tab>
    <tab>standard-Opportunity</tab>
    <tab>CaseQueues</tab>
    <tab>standard-Case</tab>
    <tab>SGR_Lowest_Cost_Plan_Option__c</tab>
    <tab>SGRRenewalBatch__c</tab>
    <tab>standard-report</tab>
    <tab>standard-Dashboard</tab>
    <uiType>Lightning</uiType>
    <utilityBar>Small_Group_Service_Center_UtilityBar</utilityBar>
    <workspaceMappings>
        <mapping>
            <tab>CaseQueues</tab>
        </mapping>
        <mapping>
            <tab>SGRRenewalBatch__c</tab>
        </mapping>
        <mapping>
            <tab>SGR_Lowest_Cost_Plan_Option__c</tab>
        </mapping>
        <mapping>
            <tab>standard-Account</tab>
        </mapping>
        <mapping>
            <tab>standard-Case</tab>
        </mapping>
        <mapping>
            <tab>standard-Dashboard</tab>
        </mapping>
        <mapping>
            <tab>standard-Opportunity</tab>
        </mapping>
        <mapping>
            <tab>standard-report</tab>
        </mapping>
    </workspaceMappings>
</CustomApplication>
