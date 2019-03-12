<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>GEMS_Service_Notification</fullName>
        <ccEmails>hcscsalesforceonsite.fssbu@capgemini.com</ccEmails>
        <description>GEMS Service Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_Integration_Status</template>
    </alerts>
    <alerts>
        <fullName>Gems_FW_Service_Status_Error_Log_Email_Alert</fullName>
        <ccEmails>SFDCGEMSBA@bcbsil.com,</ccEmails>
        <ccEmails>GEMS_AppDev_Group@domino.hcsc.net</ccEmails>
        <description>Gems FW Service Status Error Log Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_FW_Service_Status_Error_Log</template>
    </alerts>
    <alerts>
        <fullName>Gems_FW_Service_Status_Log_Email_Alert</fullName>
        <description>Gems FW Service Status Log Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GEMS_Templates/GEMS_FW_Service_Status_Log</template>
    </alerts>
    <alerts>
        <fullName>Notify_salesforce_ITG_if_MT_Account_Cancels</fullName>
        <description>Notify salesforce ITG if MT Account Cancels</description>
        <protected>false</protected>
        <recipients>
            <recipient>lori_d_dacus@bcbstx.com.samprod</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>praneeth_aditya@bcbsil.com.samprod</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>renay_readette@bcbsok.com.sgprod</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>shivendra_sirohi@bcbsil.com.samprod</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LGNA_Email_Templates/MT_Account_Cancellation</template>
    </alerts>
    <rules>
        <fullName>Account Cancellation for MT</fullName>
        <actions>
            <name>Notify_salesforce_ITG_if_MT_Account_Cancels</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2 OR 3) AND 4</booleanFilter>
        <criteriaItems>
            <field>FW_Service_Status_Log__c.RequestBody__c</field>
            <operation>contains</operation>
            <value>corpEntCd=MT1</value>
        </criteriaItems>
        <criteriaItems>
            <field>FW_Service_Status_Log__c.RequestBody__c</field>
            <operation>contains</operation>
            <value>&lt;corpEntCd&gt;MT1</value>
        </criteriaItems>
        <criteriaItems>
            <field>FW_Service_Status_Log__c.ResponseBody__c</field>
            <operation>contains</operation>
            <value>&lt;corpEntCd&gt;MT1</value>
        </criteriaItems>
        <criteriaItems>
            <field>FW_Service_Status_Log__c.RequestBody__c</field>
            <operation>contains</operation>
            <value>ACCOUNT CANCELLATION</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Gems FW Service Status Error Log Rule</fullName>
        <actions>
            <name>Gems_FW_Service_Status_Error_Log_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>FW_Service_Status_Log__c.Name</field>
            <operation>equals</operation>
            <value>GEMS_AccountStructureCreateService</value>
        </criteriaItems>
        <criteriaItems>
            <field>FW_Service_Status_Log__c.Status__c</field>
            <operation>equals</operation>
            <value>E</value>
        </criteriaItems>
        <description>- If there is a record gets ‘created’ with name ‘GEMS_AccountStructureCreateService’ send Email alert to Case Owners</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Gems FW Service Status Log Rule</fullName>
        <actions>
            <name>Gems_FW_Service_Status_Log_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>FW_Service_Status_Log__c.Name</field>
            <operation>equals</operation>
            <value>GEMS_AccountStructureCreateService</value>
        </criteriaItems>
        <criteriaItems>
            <field>FW_Service_Status_Log__c.Status__c</field>
            <operation>equals</operation>
            <value>S</value>
        </criteriaItems>
        <description>- If there is a record gets ‘created’ with name ‘GEMS_AccountStructureCreateService’ send Email alert to Case Owners</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
