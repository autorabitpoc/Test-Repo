<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>GEMS_Shared_Accums_Created_Edited_Alert</fullName>
        <ccEmails>IntegratedVendorAccums@bcbsil.com</ccEmails>
        <description>GEMS Shared Accums Created / Edited Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>GEMS_Templates/GEMS_Shared_Accums_Create_edit_Notification</template>
    </alerts>
    <rules>
        <fullName>GEMS Shared Accums Create%2Fedit Rule</fullName>
        <actions>
            <name>GEMS_Shared_Accums_Created_Edited_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>OR(ISCHANGED(LastModifiedDate),  DATEVALUE(CreatedDate ) == TODAY())</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
