<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_Requester_of_unassigned_tickets</fullName>
        <description>Notify Requester of unassigned tickets</description>
        <protected>false</protected>
        <recipients>
            <field>Requester_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TicketEvent/Unassigned_Tickets_For_Event</template>
    </alerts>
    <fieldUpdates>
        <fullName>UpdateTaxField</fullName>
        <description>updates tax field to not charge a tax for the ticket if it changes from a client or producer to employee within 48 hours of the event</description>
        <field>Personal_Non_taxable__c</field>
        <literalValue>1</literalValue>
        <name>UpdateTaxField</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Notify Requester of Unassigned Tickets</fullName>
        <active>false</active>
        <description>[Updatedat 4/21/2017: retired should be removed, replaced by the BatchFindUnassignedTicket]    This rule will send an email notification to remind the requester that they have unassigned tickets within 48 hours of the event start time.</description>
        <formula>AND(Client__c == null, Contact__c == null, Producer_for_Event__c == null )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Notify_Requester_of_unassigned_tickets</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Ticket__c.Event_Start_Date_Time__c</offsetFromField>
            <timeLength>-5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Update Within 48 hours of event start</fullName>
        <actions>
            <name>UpdateTaxField</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( IF((Ticket_Event__r.Event_Start_Date_Time__c - NOW()) &lt;= 2, TRUE, FALSE), OR( ISCHANGED(Client__c), ISCHANGED(Producer_for_Event__c) ), Client__c == &apos;&apos;, Producer_for_Event__c == &apos;&apos;, assignToEmployee__c == true, Contact__c != &apos;&apos; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
