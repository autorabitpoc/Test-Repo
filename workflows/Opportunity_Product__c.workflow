<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Category_Dental</fullName>
        <field>Category__c</field>
        <literalValue>Dental</literalValue>
        <name>Category Dental</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Health_Update</fullName>
        <field>Category__c</field>
        <literalValue>Medical</literalValue>
        <name>Health Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ProbabilityLostProd</fullName>
        <field>Win_Probability__c</field>
        <formula>0</formula>
        <name>ProbabilityLostProd</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Product_Type</fullName>
        <field>Product_Type__c</field>
        <literalValue>New Sale</literalValue>
        <name>Product Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateWonProbability</fullName>
        <field>Win_Probability__c</field>
        <formula>1</formula>
        <name>UpdateWonProbability</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>opp_update</fullName>
        <field>Category__c</field>
        <literalValue>Non-Medical</literalValue>
        <name>opp update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>opp_update_3</fullName>
        <field>Category__c</field>
        <literalValue>Medicare</literalValue>
        <name>opp update 3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>opp_update_5</fullName>
        <field>Category__c</field>
        <literalValue>Other</literalValue>
        <name>opp update 5</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>New Sale Opp Product</fullName>
        <actions>
            <name>Product_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(Opportunity_Name__r.RecordType.Name = &apos;New Sale&apos;,  !ISPICKVAL( Product_Type__c ,&apos;Market Check&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opp Prod CategoryD</fullName>
        <actions>
            <name>Category_Dental</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(Product__r.Product_Type__c , &apos;Dental&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opp Prod CategoryM</fullName>
        <actions>
            <name>Health_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(Product__r.Product_Type__c , &apos;Medical&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opp Prod CategoryMD</fullName>
        <actions>
            <name>opp_update_3</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(Product__r.Product_Type__c , &apos;Medicare&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opp Prod CategoryNM</fullName>
        <actions>
            <name>opp_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(Product__r.Product_Type__c , &apos;Non-Medical&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opp Prod CategoryO</fullName>
        <actions>
            <name>opp_update_5</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(Product__r.Product_Type__c , &apos;Other&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>UpdateProbabilityLostProd</fullName>
        <actions>
            <name>ProbabilityLostProd</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity_Product__c.Status__c</field>
            <operation>equals</operation>
            <value>Lost</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UpdateProbabilityWonProd</fullName>
        <actions>
            <name>UpdateWonProbability</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity_Product__c.Status__c</field>
            <operation>equals</operation>
            <value>Won</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
