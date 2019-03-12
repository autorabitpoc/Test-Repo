<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_AE_and_UW_about_Note_Attachment_Update</fullName>
        <description>Notify AE and UW about Note &amp; Attachment Update</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>mei_chen@bcbsil.com.sgprod</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Account_Sales_Executive1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Account_Sales_Executive2__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>LGNA_Automated_Email_Templates/Notification_for_Note_Attachment_Update_on_Quote_Request</template>
    </alerts>
    <alerts>
        <fullName>Notify_Dental_Underwriting_Queue_for_Quote_Request</fullName>
        <ccEmails>bluecaredentalrfp@bcbstx.com</ccEmails>
        <description>Notify Dental Underwriting Queue for Quote Request</description>
        <protected>false</protected>
        <recipients>
            <recipient>Dental_Underwriting</recipient>
            <type>group</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>LGNA_Automated_Email_Templates/Notify_Dental_Underwriting_Queue_From_Quote_Req_Summary</template>
    </alerts>
    <alerts>
        <fullName>Notify_Owner_for_Quote_Request_when_created</fullName>
        <description>Notify Owner for Quote Request when created</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>LGNA_Automated_Email_Templates/Notify_QROwner_from_Quote_Request</template>
    </alerts>
    <alerts>
        <fullName>Notify_Under_Writer_For_Quote_Req_Summary</fullName>
        <description>Notify Underwriter For Quote Req Summary</description>
        <protected>false</protected>
        <recipients>
            <field>Underwriter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>LGNA_Automated_Email_Templates/Notify_Underwriter_from_Quote_Request</template>
    </alerts>
    <alerts>
        <fullName>Notify_Underwriting_25_000_Exchange_Only_RFP_For_Quote_Request</fullName>
        <description>Notify Underwriting_25_000_Exchange_Only_RFP For Quote Request</description>
        <protected>false</protected>
        <recipients>
            <recipient>Underwriting_25_000_Exchange_Only_RFP</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LGNA_Automated_Email_Templates/Notify_Underwriter_from_Quote_Request</template>
    </alerts>
    <alerts>
        <fullName>Notify_Underwriting_5_000_25_000_For_Quote_Request</fullName>
        <description>Notify Underwriting: 5,000 – 25,000 For Quote Request</description>
        <protected>false</protected>
        <recipients>
            <recipient>Underwriting_5_000_25_000</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LGNA_Automated_Email_Templates/Notify_Underwriter_from_Quote_Request</template>
    </alerts>
    <alerts>
        <fullName>Notify_Underwriting_IL_LG_151_5_000_for_Quote_Request</fullName>
        <description>Notify Underwriting: IL LG 151 - 5,000 for Quote Request</description>
        <protected>false</protected>
        <recipients>
            <recipient>Underwriting_IL_LG_151_5_000</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LGNA_Automated_Email_Templates/Notify_Underwriter_from_Quote_Request</template>
    </alerts>
    <alerts>
        <fullName>Notify_Underwriting_IL_NA_151_5_000_For_Quote_Request</fullName>
        <description>Notify Underwriting: IL NA 151 - 5,000 For Quote Request</description>
        <protected>false</protected>
        <recipients>
            <recipient>Underwriting_IL_NA_151_5_000</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LGNA_Automated_Email_Templates/Notify_Underwriter_from_Quote_Request</template>
    </alerts>
    <alerts>
        <fullName>Notify_Underwriting_Queue_for_Quote_Request</fullName>
        <description>Notify Underwriting Queue for Quote Request</description>
        <protected>false</protected>
        <recipients>
            <recipient>Underwriting</recipient>
            <type>group</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>LGNA_Automated_Email_Templates/Notify_Underwriter_from_Quote_Request</template>
    </alerts>
    <alerts>
        <fullName>Notify_dental_underwriter_for_Quote_Request</fullName>
        <description>Notify Dental Underwriter for Quote Request</description>
        <protected>false</protected>
        <recipients>
            <field>Dental_Underwriter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>LGNA_Automated_Email_Templates/Notify_Dental_Underwriter_From_Quote_Req_Summary</template>
    </alerts>
    <alerts>
        <fullName>Quote_Request_Declined_Notification</fullName>
        <description>Quote Request Declined Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/Quote_Request_Declined</template>
    </alerts>
    <alerts>
        <fullName>Quote_Request_Rate_Receive_Notification</fullName>
        <description>Quote Request Rate Receive Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Account_Sales_Executive1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Account_Sales_Executive2__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LGNA_Automated_Email_Templates/Notify_AE_for_Rate_received_from_Heron</template>
    </alerts>
    <rules>
        <fullName>Notify AE About Initial Final Rate Received From Heron</fullName>
        <actions>
            <name>Quote_Request_Rate_Receive_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notify to AE from the AE field1 and AE field2 when ever Initial or final rate is received from Heorn</description>
        <formula>AND(ISCHANGED( Status__c ), OR(TEXT(Status__c)=&apos;Received Final&apos;, TEXT(Status__c)=&apos;Received Initial&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Dental Underwriter For Quote Request</fullName>
        <actions>
            <name>Notify_dental_underwriter_for_Quote_Request</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notify dental Underwriter who is assigned with quote request  by dental manager.</description>
        <formula>AND( Dental_Underwriter__c !=null, ISCHANGED( Dental_Underwriter__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Dental Underwriting Queue for Quote Request</fullName>
        <actions>
            <name>Notify_Dental_Underwriting_Queue_for_Quote_Request</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notify dental Underwriting Queue  member if Dental Underwriting queue field is filled</description>
        <formula>(ISNEW() &amp;&amp; NOT(ISBLANK(TEXT(Dental_Underwriter_Queue__c)))) || ISCHANGED( Dental_Underwriter_Queue__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify NoteAttachment Update</fullName>
        <actions>
            <name>Notify_AE_and_UW_about_Note_Attachment_Update</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>rule to send notify to AE and UW when Note and Attachment is updated or created. The Note Count field used here is updated by the Attachment and Note trigger.</description>
        <formula>ISCHANGED(Note_Count__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Owner For Quote Req Summary</fullName>
        <actions>
            <name>Notify_Owner_for_Quote_Request_when_created</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notify owner when quote request summary record is created.</description>
        <formula>!ISBLANK( OwnerId )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Notify Underwriter For Quote Req Summary</fullName>
        <actions>
            <name>Notify_Under_Writer_For_Quote_Req_Summary</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notify the underwriter and owner when quote request summary record is created.</description>
        <formula>!ISBlank( Underwriter__c )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Notify Underwriting Queue for Quote Request</fullName>
        <actions>
            <name>Notify_Underwriting_Queue_for_Quote_Request</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Notify Underwriting Queue  member if  Underwriting queue field is provided/updated.</description>
        <formula>!ISBLANK(TEXT(Underwriter_Queue__c))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Notify Underwriting%3A 25%2C000%2B %26 Exchange Only RFP for Quote Request</fullName>
        <actions>
            <name>Notify_Underwriting_25_000_Exchange_Only_RFP_For_Quote_Request</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notify Underwriting Queue  member if  Underwriting queue field is provided/updated.</description>
        <formula>AND(ISCHANGED(Underwriter_Queue__c),ISPICKVAL(Underwriter_Queue__c,&quot;Underwriting_25_000_Exchange_Only_RFP&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Underwriting%3A 5%2C000 %E2%80%93 25%2C000for Quote Request</fullName>
        <actions>
            <name>Notify_Underwriting_5_000_25_000_For_Quote_Request</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notify Underwriting Queue  member if  Underwriting queue field is provided/updated.</description>
        <formula>AND(ISCHANGED(Underwriter_Queue__c),ISPICKVAL(Underwriter_Queue__c,&quot;Underwriting_5_000_25_000&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Underwriting%3A IL LG 151 - 5%2C000 for Quote Request</fullName>
        <actions>
            <name>Notify_Underwriting_IL_LG_151_5_000_for_Quote_Request</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notify Underwriting Queue  member if  Underwriting queue field is provided/updated.</description>
        <formula>AND(ISCHANGED(Underwriter_Queue__c), ISPICKVAL(Underwriter_Queue__c, &quot;Underwriting_IL_LG_151_5_000&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Underwriting%3A IL NA 151 - 5%2C000 for Quote Request</fullName>
        <actions>
            <name>Notify_Underwriting_IL_NA_151_5_000_For_Quote_Request</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notify Underwriting Queue  member if  Underwriting queue field is provided/updated.</description>
        <formula>AND(ISCHANGED(Underwriter_Queue__c),ISPICKVAL(Underwriter_Queue__c,&quot;Underwriting_IL_NA_151_5_000&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NotifyQuoteRequestUnderwriterChange</fullName>
        <actions>
            <name>Notify_Under_Writer_For_Quote_Req_Summary</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Email alert when Underwriter/Owner on an *existing* Quote Request Summary is changed.</description>
        <formula>AND(ISCHANGED( Underwriter__c ),  NOT(ISNEW())  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>QuoteRequestSummaryUnderwriterChange</fullName>
        <actions>
            <name>Notify_Under_Writer_For_Quote_Req_Summary</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Email alert when Underwriter/Owner on an *existing* Quote Request Summary is changed.</description>
        <formula>AND(ISCHANGED( OwnerId ),  NOT(ISNEW()),  IF(LEFT(PRIORVALUE(OwnerId), 3) &lt;&gt; &quot;00G&quot;, TRUE, FALSE)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
