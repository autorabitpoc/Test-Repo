<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>StickinessNumberUpdate</fullName>
        <field>StickinessNumber__c</field>
        <formula>Stickiness__c</formula>
        <name>StickinessNumberUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateMultiplier_Discount_AdvantageSP_c</fullName>
        <description>Update the value with Multiplier_Discount_Advantage__c</description>
        <field>Multiplier_Discount_AdvantageSP__c</field>
        <formula>Multiplier_Discount_Advantage__c</formula>
        <name>UpdateMultiplier_Discount_AdvantageSP__c</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateScale_Contract_End_DateSP_c</fullName>
        <description>Update Value with Scale_Contract_End_Date__c</description>
        <field>Scale_Contract_End_DateSP__c</field>
        <formula>Scale_Contract_End_Date__c</formula>
        <name>UpdateScale_Contract_End_DateSP__c</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateSplit_vs_Sole_Medical_Carrier_syst</fullName>
        <description>Update Value with Split_vs_Sole_Medical_Carrier_system__c</description>
        <field>Split_vs_Sole_Medical_Carrier_SP__c</field>
        <formula>Split_vs_Sole_Medical_Carrier_system__c</formula>
        <name>UpdateSplit_vs_Sole_Medical_Carrier_syst</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Check Value For Split_vs_Sole_Medical_Carrier_system%5F%5Fc</fullName>
        <actions>
            <name>UpdateMultiplier_Discount_AdvantageSP_c</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UpdateScale_Contract_End_DateSP_c</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UpdateSplit_vs_Sole_Medical_Carrier_syst</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Null</value>
        </criteriaItems>
        <description>Hidden Field used in Stickiness__c Calculation</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Stickiness Scoring</fullName>
        <actions>
            <name>StickinessNumberUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This takes formula field Stickiness and places in field StickinessNumber. This was necessary because  5,000 characters was being met with all the formula fields on this object.</description>
        <formula>ISCHANGED(Stickiness__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
