<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>Update Product Record</fullName>
        <active>false</active>
        <description>SGR: SFDC-14813. Update Product records Product_Type__c field based on associated Product Type record</description>
        <formula>ISCHANGED(description__c) || ISCHANGED(Plan_Group__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
