<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_Quote_Req_New_Comment_Notification</fullName>
        <description>Notify Quote Req New Comment Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Notify_User1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Notify_User2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Notify_User3__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>LGNA_Automated_Email_Templates/Notify_User_for_Quote_Request_New_Comment</template>
    </alerts>
    <rules>
        <fullName>Notify User for new Quote Req Comment Added</fullName>
        <actions>
            <name>Notify_Quote_Req_New_Comment_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3</booleanFilter>
        <criteriaItems>
            <field>Quote_Request_Comment__c.Notify_User1__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Quote_Request_Comment__c.Notify_User2__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Quote_Request_Comment__c.Notify_User3__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>send notification to the users who are added as Notify User from Quote Request Comment  page</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
