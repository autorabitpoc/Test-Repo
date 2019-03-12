<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>SharePoint TEST Rqst Hub</label>
    <protected>false</protected>
    <values>
        <field>Auth_URL_Path__c</field>
        <value xsi:type="xsd:string">/_layouts/15/OAuthAuthorize.aspx</value>
    </values>
    <values>
        <field>Content_Type_Id__c</field>
        <value xsi:type="xsd:string">0x01010034867B4ABA7B3F4BB337891DBEDAE31F</value>
    </values>
    <values>
        <field>Create_URL_Path__c</field>
        <value xsi:type="xsd:string">&lt;team_path&gt;/_api/web/folders</value>
    </values>
    <values>
        <field>Delete_URL_Path__c</field>
        <value xsi:type="xsd:string">&lt;team_path&gt;/_api/web/GetFolderByServerRelativeUrl(&quot;&lt;buildFolderName&gt;&quot;)</value>
    </values>
    <values>
        <field>Find_Files_URL__c</field>
        <value xsi:type="xsd:string">/_api/web/getFolderByServerRelativeUrl(&apos;&lt;team_path&gt;/&lt;folder_name&gt;&apos;)/files?$select=*&amp;$expand=Properties,Author</value>
    </values>
    <values>
        <field>Find_Folder_URL__c</field>
        <value xsi:type="xsd:string">/_api/web/getFolderByServerRelativeUrl(&apos;&lt;team_path&gt;/&lt;folder_name&gt;&apos;)/files</value>
    </values>
    <values>
        <field>GEMS_Content_Type_Id__c</field>
        <value xsi:type="xsd:string">0x01010034867B4ABA7B3F4BB337891DBEDAE31F</value>
    </values>
    <values>
        <field>List_Item_Name__c</field>
        <value xsi:type="xsd:string">ReqHubItem</value>
    </values>
    <values>
        <field>List_Name__c</field>
        <value xsi:type="xsd:string">/ReqHub</value>
    </values>
    <values>
        <field>List_URL_Path__c</field>
        <value xsi:type="xsd:string">&lt;team_path&gt;/_api/web/lists/GetByTitle(&lt;record_type&gt;)/items</value>
    </values>
    <values>
        <field>Realm_Path__c</field>
        <value xsi:type="xsd:string">/_vti_bin/client.svc</value>
    </values>
    <values>
        <field>SharePoint_Resource__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>SharePoint_URL__c</field>
        <value xsi:type="xsd:string">https://myfyi.sharepoint.com</value>
    </values>
    <values>
        <field>Site_Realm__c</field>
        <value xsi:type="xsd:string">sgrdev</value>
    </values>
    <values>
        <field>Team_Path__c</field>
        <value xsi:type="xsd:string">teams/phi_rqthbtest</value>
    </values>
    <values>
        <field>Token_Expired_Response_Text__c</field>
        <value xsi:type="xsd:string">Invalid JWT token. The token is expired.</value>
    </values>
    <values>
        <field>Token_URL__c</field>
        <value xsi:type="xsd:string">https://accounts.accesscontrol.windows.net/&lt;site_realm&gt;/tokens/OAuth/2</value>
    </values>
    <values>
        <field>Update_URL_Path__c</field>
        <value xsi:type="xsd:string">&lt;team_path&gt;/_api/web/GetFolderByServerRelativeUrl(&apos;&lt;team_path&gt;/ReqHub/&lt;folder_name&gt;&apos;)/ListItemAllFields</value>
    </values>
    <values>
        <field>View_URL_Path__c</field>
        <value xsi:type="xsd:string">/_layouts/WopiFrame.aspx</value>
    </values>
</CustomMetadata>
