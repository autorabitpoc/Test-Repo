<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Populate_Authorized_Purchaser_Email</fullName>
        <description>Populate Authorized Purchaser Email for Docusign</description>
        <field>Authorized_Purchaser_Email__c</field>
        <formula>Authorized_Purchaser__r.Email</formula>
        <name>Populate Authorized Purchaser Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Print_Signer_Email</fullName>
        <description>Populate Print Signer Email for Docusign.</description>
        <field>Print_Signer_Email__c</field>
        <formula>Print_Signer__r.Email</formula>
        <name>Populate Print Signer Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Producer_Representative_Email</fullName>
        <description>Populates Producer Rep email</description>
        <field>Producer_Representative_Email__c</field>
        <formula>Producer_Representative__r.Email</formula>
        <name>Populate Producer Representative Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Sales_Rep_Email</fullName>
        <description>Populate Sales Rep Email</description>
        <field>Sales_Representative_Email__c</field>
        <formula>Sales_Representative__r.Email</formula>
        <name>Populate Sales Rep Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Underwriting_Email</fullName>
        <description>Populate Underwriting for Docusign.</description>
        <field>Underwriting_Email__c</field>
        <formula>Underwriting__r.Email</formula>
        <name>Populate Underwriting Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Vice_President_Email</fullName>
        <description>populate vice president email for docusign</description>
        <field>HCSC_Vice_President_Email__c</field>
        <formula>HCSC_Vice_President__r.Email</formula>
        <name>Populate Vice President Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Populate Authorized Purchaser Email</fullName>
        <actions>
            <name>Populate_Authorized_Purchaser_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Populate auth purchaser for Docusign</description>
        <formula>OR(ISNEW(), ISCHANGED(Authorized_Purchaser_Id__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Producer Representative Email</fullName>
        <actions>
            <name>Populate_Producer_Representative_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Populate Producer Representative Email</description>
        <formula>OR( ISNEW() ,ISCHANGED( Producer_Representative_Id__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Sales Rep Email</fullName>
        <actions>
            <name>Populate_Sales_Rep_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(ISNEW(), ISCHANGED( Sales_Representative_Id__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Undewriting Email</fullName>
        <actions>
            <name>Populate_Underwriting_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Populate Undewriting Email for Docusign</description>
        <formula>OR(ISNEW(), ISCHANGED( Underwriting_Id__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Vice President Email</fullName>
        <actions>
            <name>Populate_Vice_President_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Populate Vice President email for Docusign</description>
        <formula>OR(ISNEW(), ISCHANGED( HCSC_Vice_President_Id__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Print Signer Email</fullName>
        <actions>
            <name>Populate_Print_Signer_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Populate Print Signer Email</description>
        <formula>OR(ISNEW(), ISCHANGED( Print_Signer_Id__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
