<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Line_Item_Review_Created</fullName>
        <description>Line Item Review Created</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Line_Item_Review_Templates/Line_Item_Review_Created</template>
    </alerts>
    <fieldUpdates>
        <fullName>Populate_Date_Dispositioned</fullName>
        <field>Disposition_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Populate Date Dispositioned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Email Line Item Review Owner on Creation</fullName>
        <actions>
            <name>Line_Item_Review_Created</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Line_Item_Review__c.OwnerId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Sends an email to the Owner of the Line Item Review when it is created.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Line Item Review Dispositioned</fullName>
        <actions>
            <name>Populate_Date_Dispositioned</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When the Line Item Review &apos;Disposition Status&apos; is updated from Submitted to another value, it is considered dispositioned</description>
        <formula>TEXT(Disposition_Status__c) &lt;&gt; &apos;Submitted&apos; &amp;&amp; NOT(ISBLANK(TEXT(Disposition_Status__c)))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
