<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>GEMSPeerReviewRejectCounter</fullName>
        <field>Peer_Review_Reject_Counter__c</field>
        <formula>Peer_Review_Reject_Counter__c + 1</formula>
        <name>PeerReviewRejectCounter</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GEMS_Peer_Review_Check_box_Unset</fullName>
        <field>GEMS_Peer_Review_In_Progress__c</field>
        <literalValue>0</literalValue>
        <name>GEMS Peer Review Check box Unset</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GEMS_Peer_Review_Checkbox_Set</fullName>
        <field>GEMS_Peer_Review_In_Progress__c</field>
        <literalValue>1</literalValue>
        <name>GEMS Peer Review Checkbox Set</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Update_Approved</fullName>
        <field>Status__c</field>
        <literalValue>Peer Review Approved</literalValue>
        <name>Status Update Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Update_Rejected</fullName>
        <field>Status__c</field>
        <literalValue>Peer Review Rejected</literalValue>
        <name>Status Update Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <tasks>
        <fullName>GEMS_AS400_BlueStar_Update_Task</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>2</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>AS400 &amp; BlueStar Update</subject>
    </tasks>
    <tasks>
        <fullName>GEMS_AS400_BlueStar_Verification_Task</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>2</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>AS400 &amp; BlueStar Verification</subject>
    </tasks>
    <tasks>
        <fullName>GEMS_BET_Creation</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>2</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>BET Creation</subject>
    </tasks>
    <tasks>
        <fullName>GEMS_Prime_Build_Task</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>2</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Prime Build</subject>
    </tasks>
</Workflow>
