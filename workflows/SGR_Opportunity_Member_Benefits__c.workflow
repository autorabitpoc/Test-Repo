<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>Update Opportunity Census</fullName>
        <active>false</active>
        <criteriaItems>
            <field>SGR_Opportunity_Member_Benefits__c.Benefit_Agreement_Number__c</field>
            <operation>notEqual</operation>
            <value>NULL</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
