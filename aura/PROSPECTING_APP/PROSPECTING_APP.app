<aura:application implements="force:appHostable" extends="force:slds" controller="ProspectingAppController"> 
    <aura:attribute name="defaultAccount" type="Account" default="{'sobjectType':'Account', 'Id':'', 'Name': ''}" />
    <aura:attribute name="accountId" type="Id" default="" />
    <aura:attribute name="sobjectType" type="String" default="Account" />
    <aura:attribute name="found" type="Boolean" default="False" />
    
	<aura:handler name="init" value="{!this}" action="{!c.appInit}" />
    <aura:handler event="c:PROSPECTING_APP_CREATE_ACCOUNT_PAGE_EVT" action="{!c.switchToAccountPage}"/>
    <aura:handler name="openLandingPage" event="c:PROSPECTING_APP_OPEN_LANDING_PAGE_EVT" action="{!c.openSearchPage}"/>
    
	<div class="slds">
        <div aura:id="pageHolder"/>
    </div>
</aura:application>