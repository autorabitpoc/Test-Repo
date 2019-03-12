<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>NewOpportunityTeamMemberAlert</fullName>
        <description>NewOpportunityTeamMemberAlert</description>
        <protected>false</protected>
        <recipients>
            <field>UserId</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>LGNA_Automated_Email_Templates/NewOpportunityTeamMemberTemplate</template>
    </alerts>
    <rules>
        <fullName>NewOpportunityTeamMember</fullName>
        <actions>
            <name>NewOpportunityTeamMemberAlert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>SFDC-4051 - 06/2017 - Receive notification when added to an opportunity team</description>
        <formula>AND(IsNew(), Member_Profile__c = &apos;LGNA - Dearborn&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
