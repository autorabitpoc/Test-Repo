<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>LGNA EIN Send</label>
    <protected>false</protected>
    <values>
        <field>CertificateName__c</field>
        <value xsi:type="xsd:string">eamsg_salesforce_hcscexttest_net</value>
    </values>
    <values>
        <field>CertificatePassword__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>Certificate__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>Compressed__c</field>
        <value xsi:type="xsd:boolean">false</value>
    </values>
    <values>
        <field>EndPointParameters__c</field>
        <value xsi:type="xsd:boolean">false</value>
    </values>
    <values>
        <field>EndPoint__c</field>
        <value xsi:type="xsd:string">https://gateway.hcsc.net/services/group/setupAccount</value>
    </values>
    <values>
        <field>HeaderName__c</field>
        <value xsi:type="xsd:string">REST_XML_BlueSTAR</value>
    </values>
    <values>
        <field>InputClass__c</field>
        <value xsi:type="xsd:string">LGNA_EIN_SendInput</value>
    </values>
    <values>
        <field>LogRequest__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>LogResponse__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>LogStatus__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>LogWithCallout__c</field>
        <value xsi:type="xsd:boolean">false</value>
    </values>
    <values>
        <field>Operation__c</field>
        <value xsi:type="xsd:string">POST</value>
    </values>
    <values>
        <field>OutputClass__c</field>
        <value xsi:type="xsd:string">LGNA_EIN_SendOutput</value>
    </values>
    <values>
        <field>ProcessingClass__c</field>
        <value xsi:type="xsd:string">LGNA_EIN_SendCallout</value>
    </values>
    <values>
        <field>Strategy__c</field>
        <value xsi:type="xsd:string">FW_Service_REST</value>
    </values>
    <values>
        <field>Timeout__c</field>
        <value xsi:type="xsd:double">30000.0</value>
    </values>
</CustomMetadata>
