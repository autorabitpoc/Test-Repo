<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_MBC_Owner_CDHP</fullName>
        <description>Notify MBC Owner CDHP</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_MBC_Test_Failure_CDHP</template>
    </alerts>
    <alerts>
        <fullName>Notify_MBC_Owner_DTU</fullName>
        <description>Notify MBC Owner DTU</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_MBC_Test_Failure_DTU</template>
    </alerts>
    <alerts>
        <fullName>Notify_MBC_Owner_FEAK</fullName>
        <description>Notify MBC Owner FEAK</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_MBC_Test_Failure_FEAK</template>
    </alerts>
    <alerts>
        <fullName>Notify_MBC_Owner_FEAK_Analysis</fullName>
        <description>Notify MBC Owner FEAK Analysis</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_MBC_Test_Failure_FEAK_Analysis</template>
    </alerts>
    <alerts>
        <fullName>Notify_MBC_Owner_SAT</fullName>
        <description>Notify MBC Owner SAT</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>no-reply@hcsc.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GEMS_Templates/GEMS_MBC_Test_Failure_SAT</template>
    </alerts>
</Workflow>
