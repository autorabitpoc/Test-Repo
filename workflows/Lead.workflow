<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_Acc_Exe_Lead_Created</fullName>
        <description>Notify Acc Exe Lead Created</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LGNA_Email_Templates/Notify_Acc_Exe_Lead_Created</template>
    </alerts>
    <rules>
        <fullName>Notify Acc Exe Lead Created</fullName>
        <actions>
            <name>Notify_Acc_Exe_Lead_Created</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Account Executive will be notified via email once a Lead has been created for that account.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
