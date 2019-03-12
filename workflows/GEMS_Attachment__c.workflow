<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>GEMS_ASA_Requirement</fullName>
        <description>GEMS ASA Requirement</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>andrew_halkyn@bcbsil.com.lgna</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>john_tao@bcbsil.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_ASA_Requirement</template>
    </alerts>
    <rules>
        <fullName>GEMS ASA Requirement</fullName>
        <actions>
            <name>GEMS_ASA_Requirement</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>GEMS_Attachment__c.Type__c</field>
            <operation>equals</operation>
            <value>BPA - ASO</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
