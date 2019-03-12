<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>SGR_PlanIndicated</fullName>
        <field>Prototype_Plan_Indicated__c</field>
        <literalValue>Alternated</literalValue>
        <name>SGR_PlanIndicated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SGR_PlanIndicatedAltered</fullName>
        <field>Prototype_Plan_Indicated__c</field>
        <literalValue>Alternated</literalValue>
        <name>SGR_PlanIndicatedAltered</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SGR_PlanIndicatedField</fullName>
        <field>Prototype_Plan_Indicated__c</field>
        <literalValue>Indicated</literalValue>
        <name>SGR_PlanIndicatedField</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SGR_Plan_Status_To_Cancelled</fullName>
        <description>Field update to change the plan status to Cacelled</description>
        <field>Plan_Status__c</field>
        <literalValue>Cancelled</literalValue>
        <name>SGR Plan Status To Cancelled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SGR_Plan_Status_To_SOLD</fullName>
        <description>This is a field update to update the plan status to SOLD (SFDC-14939)</description>
        <field>Plan_Status__c</field>
        <literalValue>Sold</literalValue>
        <name>SGR Plan Status To SOLD</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>statusUpdate</fullName>
        <description>statusUpdate on opportunity plan rate</description>
        <field>Plan_Status__c</field>
        <literalValue>Cancelled</literalValue>
        <name>statusUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>SGR Plan Status to Cancelled</fullName>
        <actions>
            <name>SGR_Plan_Status_To_Cancelled</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow updates the Plan status to cancelled</description>
        <formula>(Plan__r.Expiry_Date__c &lt; Plan__r.Effective_Date__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SGR Plan Status to SOLD</fullName>
        <actions>
            <name>SGR_Plan_Status_To_SOLD</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>To update the plan status on the opportunity plan rate table (SFDC-14939)</description>
        <formula>AND(ISPICKVAL(Opportunity__r.Rating_Status__c,&apos;Marketing Release&apos;),ISPICKVAL(Opportunity__r.SGR_Workflow_Activity__c,&apos;Awaiting BlueSTAR Transfer&apos;),OR(ISPICKVAL(Plan_Status__c,&apos;Renewing&apos;),ISPICKVAL(Plan_Status__c,&apos;Mapped&apos;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SGR_PlanIndicated Rule</fullName>
        <actions>
            <name>SGR_PlanIndicatedAltered</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>ISCHANGED( SGR_Include_BA_Plan_Rate__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
