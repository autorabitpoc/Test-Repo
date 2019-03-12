<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Cancellation_Status_to_Requested_Cancel</fullName>
        <field>Cancellation_Status__c</field>
        <literalValue>Requested Cancellation</literalValue>
        <name>Cancellation Status to Requested Cancel</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GS_Cancellation_Status_Rejected</fullName>
        <field>Cancellation_Status__c</field>
        <literalValue>Cancellation Rejected</literalValue>
        <name>GS Cancellation Status Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GS_Cancellation_Status_to_Cancelled</fullName>
        <field>Cancellation_Status__c</field>
        <literalValue>Cancelled</literalValue>
        <name>GS Cancellation Status to Cancelled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GS_Cancellation_Submitted_Date</fullName>
        <field>Cancellation_Submitted_Date__c</field>
        <formula>Today()</formula>
        <name>GS Cancellation Submitted Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Cancellation_Code_Null_GS</fullName>
        <description>Set Cancellation Code Null GS</description>
        <field>Cancellation_Code__c</field>
        <name>Set Cancellation Code Null GS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Cancellation_Date_Null_GS</fullName>
        <description>Set Cancellation Date Null GS</description>
        <field>Cancellation_Date__c</field>
        <name>Set Cancellation Date Null GS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Cancellation_Explanation_Null_GS</fullName>
        <description>Set Cancellation Explanation Null GS</description>
        <field>Cancellation_Explanation__c</field>
        <name>Set Cancellation Explanation Null GS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Cancellation_Reason_Null_GS</fullName>
        <description>Set Cancellation Reason Null GS</description>
        <field>Cancellation_Reason__c</field>
        <name>Set Cancellation Reason Null GS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Cancellation_Submitted_Date_Null_GS</fullName>
        <description>Set Cancellation Submitted Date Null GS</description>
        <field>Cancellation_Submitted_Date__c</field>
        <name>Set Cancellation Submitted Date Null GS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Cancellation_status_null_GS</fullName>
        <description>Set Cancellation status null GS</description>
        <field>Cancellation_Status__c</field>
        <name>Set Cancellation status null GS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Req_Cancellation_Date_Null_GS</fullName>
        <description>Set Req Cancellation Date Null GS</description>
        <field>Requested_Cancellation_Date__c</field>
        <name>Set Req Cancellation Date Null GS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Clear Cancellation Values For Groups Section</fullName>
        <actions>
            <name>Set_Cancellation_Code_Null_GS</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Cancellation_Date_Null_GS</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Cancellation_Explanation_Null_GS</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Cancellation_Reason_Null_GS</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Cancellation_Submitted_Date_Null_GS</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Cancellation_status_null_GS</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Req_Cancellation_Date_Null_GS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This is used for setting the cancellation values as blank when the status is changed to active from Cancelled.</description>
        <formula>AND(  ISPICKVAL(PRIORVALUE(Status__c),&apos;Cancelled&apos;)  ,  ISPICKVAL(Status__c,&apos;Active&apos;)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>GS Immediate Cancellation Process</fullName>
        <actions>
            <name>GS_Cancellation_Status_to_Cancelled</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>GS_Cancellation_Submitted_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>IF(OR(AND(ISPICKVAL(Cancellation_Status__c , &quot;Requested Cancellation&quot;),(Group_Account__r.Automated_Eligibility_Process__c = false), NOT(INCLUDES(Group_Account__r.Funding_Type__c , &quot;ASO&quot;))), AND( ISPICKVAL( Cancellation_Status__c , &quot;Requested Cancellation&quot;), (Requested_Cancellation_Date__c - Today() &lt; 5), OR( Group_Account__r.Automated_Eligibility_Process__c  = true, INCLUDES( Group_Account__r.Funding_Type__c , &quot;ASO&quot;)))), true, false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>GS Time Based Cancellation Process</fullName>
        <active>false</active>
        <formula>IF( AND( ISPICKVAL( Cancellation_Status__c , &quot;Requested Cancellation&quot;), (Requested_Cancellation_Date__c - Today() &gt;= 5) ,OR( Group_Account__r.Automated_Eligibility_Process__c = true,INCLUDES( Group_Account__r.Funding_Type__c , &quot;ASO&quot;))) , true, false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>GS_Cancellation_Status_to_Cancelled</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>GS_Cancellation_Submitted_Date</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Group_Section__c.Requested_Cancellation_Date__c</offsetFromField>
            <timeLength>-5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
