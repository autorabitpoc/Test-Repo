<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>BP_Cancellation_Status_to_Cancelled</fullName>
        <field>Cancellation_Status__c</field>
        <literalValue>Cancelled</literalValue>
        <name>BP Cancellation Status to Cancelled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BP_Cancellation_Submitted_Date</fullName>
        <field>Cancellation_Submitted_Date__c</field>
        <formula>Today()</formula>
        <name>BP Cancellation Submitted Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Cancellation_Code_Null_Billing</fullName>
        <description>Set Cancellation Code Null Billing</description>
        <field>Cancellation_Code__c</field>
        <name>Set Cancellation Code Null Billing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Cancellation_Date_Null_Billing</fullName>
        <description>Set Cancellation Date Null Billing</description>
        <field>Cancellation_Date__c</field>
        <name>Set Cancellation Date Null Billing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Cancellation_Explanation_Null_Billin</fullName>
        <description>Set Cancellation Explanation Null Billin</description>
        <field>Cancellation_Explanation__c</field>
        <name>Set Cancellation Explanation Null Billin</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Cancellation_Reason_Null_Billing</fullName>
        <description>Set Cancellation Reason Null Billing</description>
        <field>Cancellation_Reason__c</field>
        <name>Set Cancellation Reason Null Billing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Cancellation_Submitted_Date_Null_Bil</fullName>
        <description>Set Cancellation Submitted Date Null Bil</description>
        <field>Cancellation_Submitted_Date__c</field>
        <name>Set Cancellation Submitted Date Null Bil</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Cancellation_status_null_Billing</fullName>
        <description>Set Cancellation status null Billing</description>
        <field>Cancellation_Status__c</field>
        <name>Set Cancellation status null Billing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Req_Cancellation_Date_Null_Billin</fullName>
        <description>Set Req Cancellation Date Null Billin</description>
        <field>Requested_Cancellation_Date__c</field>
        <name>Set Req Cancellation Date Null Billin</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>BP Immediate Cancellation Process</fullName>
        <actions>
            <name>BP_Cancellation_Status_to_Cancelled</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>BP_Cancellation_Submitted_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF(OR(AND(ISPICKVAL(Cancellation_Status__c , &quot;Requested Cancellation&quot;),(Group_Account__r.Automated_Eligibility_Process__c = false), NOT(INCLUDES(Group_Account__r.Funding_Type__c , &quot;ASO&quot;))), AND( ISPICKVAL( Cancellation_Status__c , &quot;Requested Cancellation&quot;), (Requested_Cancellation_Date__c - Today() &lt; 5), OR( Group_Account__r.Automated_Eligibility_Process__c = true, INCLUDES( Group_Account__r.Funding_Type__c , &quot;ASO&quot;)))), true, false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>BP Time Based Cancellation Process</fullName>
        <active>true</active>
        <formula>IF( AND( ISPICKVAL( Cancellation_Status__c , &quot;Requested Cancellation&quot;), (Requested_Cancellation_Date__c - Today() &gt;= 5) ,OR( Group_Account__r.Automated_Eligibility_Process__c = true,INCLUDES( Group_Account__r.Funding_Type__c , &quot;ASO&quot;))) , true, false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>BP_Cancellation_Status_to_Cancelled</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>BP_Cancellation_Submitted_Date</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Billing__c.Requested_Cancellation_Date__c</offsetFromField>
            <timeLength>-5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Clear Cancellation Values For Billing</fullName>
        <actions>
            <name>Set_Cancellation_Code_Null_Billing</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Cancellation_Date_Null_Billing</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Cancellation_Explanation_Null_Billin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Cancellation_Reason_Null_Billing</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Cancellation_Submitted_Date_Null_Bil</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Cancellation_status_null_Billing</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Req_Cancellation_Date_Null_Billin</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This is used for setting the cancellation values as blank when the status is changed to active from Cancelled.</description>
        <formula>AND(  ISPICKVAL(PRIORVALUE(Status__c),&apos;Cancelled&apos;)  ,  ISPICKVAL(Status__c,&apos;Active&apos;)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
