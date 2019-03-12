<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Assign_Date_Assigned_to_Assistant_UW</fullName>
        <description>Sets the Assign Date Assigned to Assistant UW</description>
        <field>Date_Assigned_to_Assistant_UW__c</field>
        <formula>IF(OR(ISNULL(Case__r.Date_Assigned_to_Assistant_UW__c),ISBLANK(Case__r.Date_Assigned_to_Assistant_UW__c)) ,NOW(),Case__r.Date_Assigned_to_Assistant_UW__c)</formula>
        <name>Assign Date Assigned to Assistant UW</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_Date_Assigned_to_Underwriting</fullName>
        <field>Date_Assigned_to_Underwriting__c</field>
        <formula>IF(OR(ISNULL(Case__r.Date_Assigned_to_Underwriting__c),ISBLANK(Case__r.Date_Assigned_to_Underwriting__c)) ,NOW(),Case__r.Date_Assigned_to_Underwriting__c)</formula>
        <name>Assign Date Assigned to Underwriting</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Name_of_Advanced_Underwriter</fullName>
        <field>Advanced_Underwriter_Name__c</field>
        <formula>Case__r.Owner_Name__c</formula>
        <name>Populate Name of Advanced Underwriter</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Name_of_Assistant_Underwriter</fullName>
        <field>Assistant_Underwriter_Name__c</field>
        <formula>Case__r.Owner_Name__c</formula>
        <name>Populate Name of Assistant Underwriter</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Populate Date Assigned to Assistant UW</fullName>
        <actions>
            <name>Assign_Date_Assigned_to_Assistant_UW</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case_Ownership_Tracking__c.User_Role_Title__c</field>
            <operation>contains</operation>
            <value>Assistant Underwriter</value>
        </criteriaItems>
        <description>Rule to populate the Date Assigned to Assistant UW field on the case based on owner role</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Populate Date Assigned to Underwriting</fullName>
        <actions>
            <name>Assign_Date_Assigned_to_Underwriting</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3</booleanFilter>
        <criteriaItems>
            <field>Case_Ownership_Tracking__c.User_Role_Title__c</field>
            <operation>contains</operation>
            <value>UW</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case_Ownership_Tracking__c.User_Role_Title__c</field>
            <operation>contains</operation>
            <value>Underwrit</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case_Ownership_Tracking__c.User_Profile__c</field>
            <operation>contains</operation>
            <value>Underwriting</value>
        </criteriaItems>
        <description>Rule to populate the Date Assigned to Underwriting field on the case based on owner role</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Populate Name of Advanced Underwriter</fullName>
        <actions>
            <name>Populate_Name_of_Advanced_Underwriter</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case_Ownership_Tracking__c.User_Role_Title__c</field>
            <operation>contains</operation>
            <value>Advanced Under</value>
        </criteriaItems>
        <description>Rule to populate the name of the first advanced underwriter to own a case</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Populate Name of Assistant Underwriter</fullName>
        <actions>
            <name>Populate_Name_of_Assistant_Underwriter</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case_Ownership_Tracking__c.User_Role_Title__c</field>
            <operation>contains</operation>
            <value>Assistant Under</value>
        </criteriaItems>
        <description>Rule to populate the name of the first assistant underwriter to own a case</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
