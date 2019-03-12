<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>BA_Cancellation_Status_to_Cancelled</fullName>
        <field>Cancellation_Status__c</field>
        <literalValue>Cancelled</literalValue>
        <name>BA Cancellation Status to Cancelled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BA_Cancellation_Submitted_Date</fullName>
        <field>Cancellation_Submitted_Date__c</field>
        <formula>Today()</formula>
        <name>BA Cancellation Submitted Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_BA_RecordType_to_BlueStar</fullName>
        <field>RecordTypeId</field>
        <lookupValue>BlueStar</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set BA RecordType to BlueStar</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_BA_RecordType_to_Non_BlueStar</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Non_BlueStar</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set BA RecordType to Non BlueStar</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Cancellation_Code_Null_BA</fullName>
        <description>Set BA RecordType to Non BlueStar</description>
        <field>Cancellation_Code__c</field>
        <name>Set Cancellation Code Null BA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Cancellation_Date_Null_BA</fullName>
        <description>Set Cancellation Date Null BA</description>
        <field>Cancellation_Date__c</field>
        <name>Set Cancellation Date Null BA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Cancellation_Explanation_Null_BA</fullName>
        <description>Set Cancellation Date Null BA</description>
        <field>Cancellation_Explanation__c</field>
        <name>Set Cancellation Explanation Null BA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Cancellation_Reason_Null_BA</fullName>
        <description>Set Cancellation Reason Null BA</description>
        <field>Cancellation_Reason__c</field>
        <name>Set Cancellation Reason Null BA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Cancellation_Submitted_Date_Null_BA</fullName>
        <description>Set Cancellation Submitted Date Null BA</description>
        <field>Cancellation_Submitted_Date__c</field>
        <name>Set Cancellation Submitted Date Null BA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Cancellation_status_null_BA</fullName>
        <description>Set Cancellation status null BA</description>
        <field>Cancellation_Status__c</field>
        <name>Set Cancellation status null BA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Req_Cancellation_Date_Null_BA</fullName>
        <description>Set Req Cancellation Date Null BA</description>
        <field>Requested_Cancellation_Date__c</field>
        <name>Set Req Cancellation Date Null BA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>BA Immediate Cancellation Process</fullName>
        <actions>
            <name>BA_Cancellation_Status_to_Cancelled</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>BA_Cancellation_Submitted_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF(OR(AND(ISPICKVAL(Cancellation_Status__c , &quot;Requested Cancellation&quot;),(Group_Account__r.Automated_Eligibility_Process__c = false), NOT(ISPICKVAL(Funding_Type__c , &quot;ASO&quot;))), AND( ISPICKVAL( Cancellation_Status__c , &quot;Requested Cancellation&quot;), (Requested_Cancellation_Date__c - Today() &lt; 5), OR( Group_Account__r.Automated_Eligibility_Process__c = true, ISPICKVAL(Funding_Type__c , &quot;ASO&quot;)))), true, false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>BA Time Based Cancellation Process</fullName>
        <active>true</active>
        <formula>IF( AND( ISPICKVAL( Cancellation_Status__c , &quot;Requested Cancellation&quot;), (Requested_Cancellation_Date__c - Today() &gt;= 5), OR( Group_Account__r.Automated_Eligibility_Process__c = true,  ISPICKVAL(Funding_Type__c , &quot;ASO&quot;))) , true, false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>BA_Cancellation_Status_to_Cancelled</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>BA_Cancellation_Submitted_Date</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Benefit_Agreement__c.Requested_Cancellation_Date__c</offsetFromField>
            <timeLength>-5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Clear Cancellation Values For Benefit Agreement</fullName>
        <actions>
            <name>Set_Cancellation_Code_Null_BA</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Cancellation_Date_Null_BA</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Cancellation_Explanation_Null_BA</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Cancellation_Reason_Null_BA</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Cancellation_Submitted_Date_Null_BA</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Cancellation_status_null_BA</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Req_Cancellation_Date_Null_BA</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This is used for setting the cancellation values as null when the status is  changed to active from canelled</description>
        <formula>AND(  ISPICKVAL(PRIORVALUE(Status__c),&apos;Cancelled&apos;)  ,  ISPICKVAL(Status__c,&apos;Active&apos;)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Benefit Agreement Record Type To BlueStar</fullName>
        <actions>
            <name>Set_BA_RecordType_to_BlueStar</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Product__r.RecordType.DeveloperName &lt;&gt; &apos;HCSC_Non_BlueStar_Product&apos;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Benefit Agreement Record Type To Non BlueStar</fullName>
        <actions>
            <name>Set_BA_RecordType_to_Non_BlueStar</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Product__r.RecordType.DeveloperName = &apos;HCSC_Non_BlueStar_Product&apos;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
