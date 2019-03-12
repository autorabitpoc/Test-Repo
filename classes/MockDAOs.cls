@isTest public class MockDAOs {

    public class OpportunityDAOMock implements OpportunityDAO.IOpportunityDAO {
        private fflib_ApexMocks mocks;

        public OpportunityDAOMock (fflib_ApexMocks mocks) {
            this.mocks = mocks;
        }

        public Opportunity getOpportunityById(Id opportunityId) {
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getOpportunityById', new List<Object> {opportunityId});
                return null;
            } else {
                mocks.recordMethod(this, 'getOpportunityById', new List<Object> {opportunityId});
                fflib_MethodReturnValue methodReturnValue =
                    mocks.getMethodReturnValue(this, 'getOpportunityById', new List<Object> {opportunityId});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceof Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (Opportunity) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public void updateOpportunity(Opportunity opportunityObj) {
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'updateOpportunity', new List<Object> {opportunityObj});
            } else {
                mocks.recordMethod(this, 'updateOpportunity', new List<Object> {opportunityObj});
                fflib_MethodReturnValue methodReturnValue =
                    mocks.getMethodReturnValue(this, 'updateOpportunity', new List<Object> {opportunityObj});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceof Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                }
            }
        }

        public void updateOpportunities(List<Opportunity> opportunityObjs) {
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'updateOpportunities', new List<Object> {opportunityObjs});
            } else {
                mocks.recordMethod(this, 'updateOpportunities', new List<Object> {opportunityObjs});
                fflib_MethodReturnValue methodReturnValue =
                    mocks.getMethodReturnValue(this, 'updateOpportunities', new List<Object> {opportunityObjs});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceof Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                }
            }
        }

        public List<Opportunity> getOpportunitiesForProduct360(Set<Id> opportunityIds) {
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getOpportunitiesForProduct360', new List<Object> {opportunityIds});
            } else {
                mocks.recordMethod(this, 'getOpportunitiesForProduct360', new List<Object> {opportunityIds});
                fflib_MethodReturnValue methodReturnValue =
                    mocks.getMethodReturnValue(this, 'getOpportunitiesForProduct360', new List<Object> {opportunityIds});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceof Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Opportunity>) methodReturnValue.ReturnValue;

                }
            }
            return null;
        }

        public List<Opportunity> getOpportunitiesForCustomContractsCurrProds(Id acctId, Id productRecordTypeId) {
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getOpportunitiesForCustomContractsCurrProds', new List<Object> {acctId, productRecordTypeId});
            } else {
                mocks.recordMethod(this, 'getOpportunitiesForCustomContractsCurrProds', new List<Object> {acctId, productRecordTypeId});
                fflib_MethodReturnValue methodReturnValue =
                    mocks.getMethodReturnValue(this, 'getOpportunitiesForCustomContractsCurrProds', new List<Object> {acctId, productRecordTypeId});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceof Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Opportunity>) methodReturnValue.ReturnValue;

                }
            }
            return null;
        }

        public List<Opportunity> getOpportunitiesByParentAccount(Set<Id> parentIds) {
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getOpportunitiesByParentAccount', new List<Object> {parentIds});
            } else {
                mocks.recordMethod(this, 'getOpportunitiesByParentAccount', new List<Object> {parentIds});
                fflib_MethodReturnValue methodReturnValue =
                    mocks.getMethodReturnValue(this, 'getOpportunitiesByParentAccount', new List<Object> {parentIds});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceof Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Opportunity>) methodReturnValue.ReturnValue;

                }
            }
            return null;
        }

        public List<Opportunity> getOpportunitiesForCustomContractsActiveProds(Id acctId) {
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getOpportunitiesForCustomContractsActiveProds', new List<Object> {acctId});
            } else {
                mocks.recordMethod(this, 'getOpportunitiesForCustomContractsActiveProds', new List<Object> {acctId});
                fflib_MethodReturnValue methodReturnValue =
                    mocks.getMethodReturnValue(this, 'getOpportunitiesForCustomContractsActiveProds', new List<Object> {acctId});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceof Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Opportunity>) methodReturnValue.ReturnValue;

                }
            }
            return null;
        }

    }

    public class OpportunityProductDAOMock implements OpportunityProductDAO.IOpportunityProductDAO {
        private fflib_ApexMocks mocks;

        public OpportunityProductDAOMock (fflib_ApexMocks mocks) {
            this.mocks = mocks;
        }

        public List<Opportunity_Product__c> getLostProducts(List<String> lostProductIds) {
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getLostProducts', new List<Object> {lostProductIds});
                return null;
            } else {
                mocks.recordMethod(this, 'getLostProducts', new List<Object> {lostProductIds});
                fflib_MethodReturnValue methodReturnValue =
                    mocks.getMethodReturnValue(this, 'getLostProducts', new List<Object> {lostProductIds});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceof Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Opportunity_Product__c>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public List<Opportunity_Product__c> getSelectedProducts(List<String> selectedProductIds) {
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getSelectedProducts', new List<Object> {selectedProductIds});
                return null;
            } else {
                mocks.recordMethod(this, 'getSelectedProducts', new List<Object> {selectedProductIds});
                fflib_MethodReturnValue methodReturnValue =
                    mocks.getMethodReturnValue(this, 'getSelectedProducts', new List<Object> {selectedProductIds});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceof Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Opportunity_Product__c>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

         public List<Opportunity_Product__c> getRatingProducts(Id opportunityId){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'getRatingProducts', new List<Object> {opportunityId});
                return null;
            }else{
                mocks.recordMethod(this, 'getRatingProducts', new List<Object> {opportunityId});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'getRatingProducts', new List<Object> {opportunityId});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Opportunity_Product__c>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public void updateOpportunityProducts(List<Opportunity_Product__c> opProducts) {
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'updateOpportunityProducts', new List<Object> {opProducts});
            } else {
                mocks.recordMethod(this, 'updateOpportunityProducts', new List<Object> {opProducts});
                fflib_MethodReturnValue methodReturnValue =
                    mocks.getMethodReturnValue(this, 'updateOpportunityProducts', new List<Object> {opProducts});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceof Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                }
            }
        }

        public Opportunity_Product__c getOpportunityProductById(Id opProduct) {
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getOpportunityProductById', new List<Object> {opProduct});
            } else {
                mocks.recordMethod(this, 'getOpportunityProductById', new List<Object> {opProduct});
                fflib_MethodReturnValue methodReturnValue =
                    mocks.getMethodReturnValue(this, 'getOpportunityProductById', new List<Object> {opProduct});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceof Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (Opportunity_Product__c) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public void deleteOpportunityProduct(Opportunity_Product__c opProduct) {
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'deleteOpportunityProduct', new List<Object> {opProduct});
            } else {
                mocks.recordMethod(this, 'deleteOpportunityProduct', new List<Object> {opProduct});
                fflib_MethodReturnValue methodReturnValue =
                    mocks.getMethodReturnValue(this, 'deleteOpportunityProduct', new List<Object> {opProduct});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceof Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                }
            }
        }

        public void upsertOpportunityProducts(List<Opportunity_Product__c> opProducts) {
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'upsertOpportunityProducts', new List<Object> {opProducts});
            } else {
                mocks.recordMethod(this, 'upsertOpportunityProducts', new List<Object> {opProducts});
                fflib_MethodReturnValue methodReturnValue =
                    mocks.getMethodReturnValue(this, 'upsertOpportunityProducts', new List<Object> {opProducts});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceof Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                }
            }
        }

        public List<AggregateResult> getAggregateOpportunityProductByIds(List<Id> ids){
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getAggregateOpportunityProductByIds', new List<Object> {ids});
                return null;
            } else {
                mocks.recordMethod(this, 'getAggregateOpportunityProductByIds', new List<Object> {ids});
                fflib_MethodReturnValue methodReturnValue =
                    mocks.getMethodReturnValue(this, 'getAggregateOpportunityProductByIds', new List<Object> {ids});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceof Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<AggregateResult>) methodReturnValue.ReturnValue; 
                }
                return null;
            }
        }
    }

    public class FieldSetDAOMock implements FieldSetDAO.IFieldSetDAO {

        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType objectType;
        Schema.DescribeSObjectResult objectResult;
        Schema.FieldSet fieldSet;

        private fflib_ApexMocks mocks;

        public FieldSetDAOMock(fflib_ApexMocks mocks) {
            this.mocks = mocks;
        }

        public Schema.FieldSet getFieldSetByNameAndSObject(String fieldSetName, String objectName) {
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getFieldSetByNameAndSObject', new List<Object> {fieldSetName, objectName});
                objectType = globalDescribeMap.get(objectName);
                objectResult = objectType.getDescribe();
                fieldSet = objectResult.FieldSets.getMap().get(fieldSetName);
                return null;
            } else {
                return fieldSet;
            }
            return null;
        }

        public List<String> getFieldSetMemberFieldPaths(Schema.FieldSet fieldSet) {
         Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe(); 
            Schema.SObjectType objectType = globalDescribeMap.get('Contact');
            Schema.DescribeSObjectResult objectResult = objectType.getDescribe();
            Schema.FieldSet fieldSetMock = objectResult.FieldSets.getMap().get('BlueSTAR_Contact_Primary_Required_Fields');

            List<String> fieldPaths = new List<String>();
            for(FieldSetMember fieldSetMember: fieldSetMock.getFields()){
                fieldPaths.add(fieldSetMember.getFieldPath());
            }

            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getFieldSetMemberFieldPaths', new List<Object> {fieldSet});
                return null;
            } else {
                return fieldPaths;
                }
            return null;
        }
    }

    public class UserDAOMock implements UserDAO.IUserDAO {
        private fflib_ApexMocks mocks;

        public UserDAOMock(fflib_ApexMocks mocks) {
            this.mocks = mocks;
        }

        public User createUser(Id profileId, String username, String lastName, String email) {
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'createUser', new List<Object> {profileId, username, lastname, email});
                return null;
            } else {
                mocks.recordMethod(this, 'createUser', new List<Object> {profileId, username, lastname, email});
                fflib_MethodReturnValue methodReturnValue = mocks.getMethodReturnValue(this, 'createUser', new List<Object> {profileId, username, lastname, email});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceOf Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (User) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public User getCurrentUser() {
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getCurrentUser', new List<Object> {});
                return null;
            } else {
                mocks.recordMethod(this, 'getCurrentUser', new List<Object> {});
                fflib_MethodReturnValue methodReturnValue = mocks.getMethodReturnValue(this, 'getCurrentUser', new List<Object> {});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceOf Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (User) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public Id getUserIdByProfileName(String name) {

            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getUserIdByProfileName', new List<Object> {name});
                return null;
            } else {
                mocks.recordMethod(this, 'getUserIdByProfileName', new List<Object> {name});
                fflib_MethodReturnValue methodReturnValue = mocks.getMethodReturnValue(this, 'getUserIdByProfileName', new List<Object> {name});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceOf Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (Id) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

     public User getUserByName(String userName){
        
      if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getUserByName', new List<Object> {userName});
                return null;
            } else {
                   mocks.recordMethod(this, 'getUserByName', new List<Object> {userName});
                     fflib_MethodReturnValue methodReturnValue = mocks.getMethodReturnValue(this, 'getUserByName', new List<Object> {userName});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceOf Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (User) methodReturnValue.ReturnValue;
                }
            }
            return null;
          
    }
      
        public List<User> getUsersWithEmployeeNumber(Set<String> userIds) {

                if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getUsersWithEmployeeNumber', new List<Object> {userIds});
                return null;
            } else {
                mocks.recordMethod(this, 'getUsersWithEmployeeNumber', new List<Object> {userIds});
                fflib_MethodReturnValue methodReturnValue = mocks.getMethodReturnValue(this, 'getUsersWithEmployeeNumber', new List<Object> {userIds});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceOf Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<User>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

/*
        public User getRequesterForTicketDistro(Id requesterId) {
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getRequesterForTicketDistro', new List<Object> {requesterId});
                return null;
            } else {
                mocks.recordMethod(this, 'getRequesterForTicketDistro', new List<Object> {requesterId});
                fflib_MethodReturnValue methodReturnValue = mocks.getMethodReturnValue(this, 'getRequesterForTicketDistro', new List<Object> {requesterId});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceOf Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (User) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }
*/
         public Contact getRequesterForTicketDistro(Id requesterId) {
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getRequesterForTicketDistro', new List<Object> {requesterId});
                return null;
            } else {
                mocks.recordMethod(this, 'getRequesterForTicketDistro', new List<Object> {requesterId});
                fflib_MethodReturnValue methodReturnValue = mocks.getMethodReturnValue(this, 'getRequesterForTicketDistro', new List<Object> {requesterId});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceOf Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (Contact) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

/*
        public List<User> getCostCenterForTicketDistro(Set<Id> userIds) {

            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getCostCenterForTicketDistro', new List<Object> {userIds});
                return null;
            } else {
                mocks.recordMethod(this, 'getCostCenterForTicketDistro', new List<Object> {userIds});
                fflib_MethodReturnValue methodReturnValue = mocks.getMethodReturnValue(this, 'getCostCenterForTicketDistro', new List<Object> {userIds});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceOf Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<User>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }
    }
*/

 public List<Contact> getContactCostCenterForTicketDistro(Set<Id> userIds) {

            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getCostCenterForTicketDistro', new List<Object> {userIds});
                return null;
            } else {
                mocks.recordMethod(this, 'getCostCenterForTicketDistro', new List<Object> {userIds});
                fflib_MethodReturnValue methodReturnValue = mocks.getMethodReturnValue(this, 'getCostCenterForTicketDistro', new List<Object> {userIds});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceOf Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Contact>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }
    }
    public class ProfileDAOMock implements ProfileDAO.IProfileDAO {
        private fflib_ApexMocks mocks;

        public ProfileDAOMock(fflib_ApexMocks mocks) {
            this.mocks = mocks;
        }

        public Profile getProfileByName(String name) {
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getProfileByName', new List<String> {name});
                return null;
            } else {
                mocks.recordMethod(this, 'getProfileByName', new List<String> {name});
                fflib_MethodReturnValue methodReturnValue = mocks.getMethodReturnValue(this, 'getProfileByName', new List<String> {name});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceOf Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (Profile) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public Profile getProfileById(Id profileId) {
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getProfileById', new List<Object> {profileId});
                return null;
            } else {
                mocks.recordMethod(this, 'getProfileById', new List<Object> {profileId});
                fflib_MethodReturnValue methodReturnValue = mocks.getMethodReturnValue(this, 'getProfileById', new List<Object> {profileId});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceOf Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (Profile) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }
    }

    public class CustomMetadataTypeDAOMock implements CustomMetadataTypeDAO.ICustomMetadataTypeDAO{
        
        private fflib_ApexMocks mocks;

        public CustomMetadataTypeDAOMock(fflib_ApexMocks mocks) {
            this.mocks = mocks;
        }

        public List<CP_Completion_Rate_Fields__mdt> getClientProfileCompletionRateFields() {
            return null;
        }

        public List<Complexity_Score_Fields__mdt> getComplexityScoreFields() {
            return null;
        }

        public SObject getCustomMetadaTypeDynamically(String soql){
        
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getCustomMetadaTypeDynamically', new List<Object> {soql});
            } else {
                mocks.recordMethod(this, 'getCustomMetadaTypeDynamically', new List<Object> {soql});
                fflib_MethodReturnValue methodReturnValue = mocks.getMethodReturnValue(this, 'getCustomMetadaTypeDynamically', new List<Object> {soql});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceOf Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (SObject) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public Callout_Configuration__mdt getCustomMetadaTypeByName(String name){

            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getCustomMetadaTypeByName', new List<Object> {name});
            } else {
                mocks.recordMethod(this, 'getCustomMetadaTypeByName', new List<Object> {name});
                fflib_MethodReturnValue methodReturnValue = mocks.getMethodReturnValue(this, 'getCustomMetadaTypeByName', new List<Object> {name});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceOf Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (Callout_Configuration__mdt) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public SharePoint_Configuration__mdt getSharePointConfigurationByName(String name) {
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getSharePointConfigurationByName', new List<Object> {name});
            } else {
                mocks.recordMethod(this, 'getSharePointConfigurationByName', new List<Object> {name});
                fflib_MethodReturnValue methodReturnValue = mocks.getMethodReturnValue(this, 'getSharePointConfigurationByName', new List<Object> {name});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceOf Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (SharePoint_Configuration__mdt) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }
    }

    public class CustomSettingDAOMock implements CustomSettingDAO.ICustomSettingDAO {
        private fflib_ApexMocks mocks;

        public CustomSettingDAOMock(fflib_ApexMocks mocks) {
            this.mocks = mocks;
        }
             

        public Username_Password__c getUsernamePasswordCSByName(String endpoint) {
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getUsernamePasswordCSByName', new List<Object> {endpoint});
            } else {
                mocks.recordMethod(this, 'ggetUsernamePasswordCSByName', new List<Object> {endpoint});
                fflib_MethodReturnValue methodReturnValue = mocks.getMethodReturnValue(this, 'getUsernamePasswordCSByName', new List<Object> {endpoint});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceOf Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (Username_Password__c) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public Encryption_Key__c getEncryptionKeyCSByProfileId(Id profileId) {
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getEncryptionKeyCSByProfileId', new List<Object> {profileId});
            } else {
                mocks.recordMethod(this, 'getEncryptionKeyCSByProfileId', new List<Object> {profileId});
                fflib_MethodReturnValue methodReturnValue = mocks.getMethodReturnValue(this, 'getEncryptionKeyCSByProfileId', new List<Object> {profileId});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceOf Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (Encryption_Key__c) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public SearchFIPS__c getFIPSByStateAndZip(String state, String zip){
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getFIPSByStateAndZip', new List<Object> {state, zip});
            } else {
                mocks.recordMethod(this, 'getFIPSByStateAndZip', new List<Object> {state, zip});
                fflib_MethodReturnValue methodReturnValue = mocks.getMethodReturnValue(this, 'getFIPSByStateAndZip', new List<Object> {state, zip});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceOf Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (SearchFIPS__c) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public SharePointOAuth__c getSharePointOAuthSettings(Id profileId){
             if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getSharePointOAuthSettings', new List<Object> {profileId});
            } else {
                mocks.recordMethod(this, 'getSharePointOAuthSettings', new List<Object> {profileId});
                fflib_MethodReturnValue methodReturnValue = mocks.getMethodReturnValue(this, 'getSharePointOAuthSettings', new List<Object> {profileId});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceOf Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (SharePointOAuth__c) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public List<SharePointOAuthTEST__c> getAllSharePointOAuths(){
             if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getAllSharePointOAuths', new List<Object> {});
            } else {
                mocks.recordMethod(this, 'getAllSharePointOAuths', new List<Object> {});
                fflib_MethodReturnValue methodReturnValue = mocks.getMethodReturnValue(this, 'getAllSharePointOAuths', new List<Object> {});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceOf Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<SharePointOAuthTEST__c>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }
        
           //SFDC-5096 Get oAuth settings for Request Hub
          public SharePointOAuthReqHub__c getSPOAuthSettingsReqHub(Id profileId){
             if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getSPOAuthSettingsReqHub', new List<Object> {profileId});
            } else {
                mocks.recordMethod(this, 'getSPOAuthSettingsReqHub', new List<Object> {profileId});
                fflib_MethodReturnValue methodReturnValue = mocks.getMethodReturnValue(this, 'getSPOAuthSettingsReqHub', new List<Object> {profileId});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceOf Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (SharePointOAuthReqHub__c) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }     
                   
       public List<SPOAuthTestReqHub__c> getAllSharePointOAuthsRqHub(){
             if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getAllSharePointOAuthsRqHub', new List<Object> {});
            } else {
                mocks.recordMethod(this, 'getAllSharePointOAuthsRqHub', new List<Object> {});
                fflib_MethodReturnValue methodReturnValue = mocks.getMethodReturnValue(this, 'getAllSharePointOAuthsRqHub', new List<Object> {});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceOf Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<SPOAuthTestReqHub__c>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }
        
        //SFDC-4784 Get oAuth settings for Quote Request
        public SharePoint_PROD_HeronQuotes__c getSPOAuthSettingsQuoteRq(Id profileId){
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getSPOAuthSettingsQuoteRq', new List<Object> {profileId});
            } else {
                mocks.recordMethod(this, 'getSPOAuthSettingsQuoteRq', new List<Object> {profileId});
                fflib_MethodReturnValue methodReturnValue = mocks.getMethodReturnValue(this, 'getSPOAuthSettingsQuoteRq', new List<Object> {profileId});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceOf Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (SharePoint_PROD_HeronQuotes__c) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }
        
        //SFDC-4784            
        public List<SharePoint_TEST_HeronQuotes__c> getAllSharePointOAuthsQuoteRq(){
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getAllSharePointOAuthsQuoteRq', new List<Object> {});
            } else {
                mocks.recordMethod(this, 'getAllSharePointOAuthsQuoteRq', new List<Object> {});
                fflib_MethodReturnValue methodReturnValue = mocks.getMethodReturnValue(this, 'getAllSharePointOAuthsQuoteRq', new List<Object> {});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceOf Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<SharePoint_TEST_HeronQuotes__c>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }
        
        
      public Heron_OAuth__c getHeronOAuthSetting(Id userId){
        
         if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getSPOAuthSettingsReqHub', new List<Object> {userId});
            } else {
                mocks.recordMethod(this, 'getHeronOAuthSetting', new List<Object> {userId});
                fflib_MethodReturnValue methodReturnValue = mocks.getMethodReturnValue(this, 'getHeornOAuthSetting', new List<Object> {userId});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceOf Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (Heron_OAuth__c) methodReturnValue.ReturnValue;
                }
            }
            return null;
       }
        public OAuth_Jwt_Token__c getJWTOAuthSetting(Id userId){
        
         if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getSPOAuthSettingsReqHub', new List<Object> {userId});
            } else {
                mocks.recordMethod(this, 'getHeronOAuthSetting', new List<Object> {userId});
                fflib_MethodReturnValue methodReturnValue = mocks.getMethodReturnValue(this, 'getHeornOAuthSetting', new List<Object> {userId});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceOf Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (OAuth_Jwt_Token__c) methodReturnValue.ReturnValue;
                }
            }
            return null;
       }
       
        public OAuth_Jwt_Token2__c getJWTOAuthSettingCallOut(String calloutName){
        
         if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getJWTOAuthSettingCallOut', new List<Object> {calloutName});
            } else {
                mocks.recordMethod(this, 'getJWTOAuthSettingCallOut', new List<Object> {calloutName});
                fflib_MethodReturnValue methodReturnValue = mocks.getMethodReturnValue(this, 'getJWTOAuthSettingCallOut', new List<Object> {calloutName});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceOf Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (OAuth_Jwt_Token2__c) methodReturnValue.ReturnValue;
                }
            }
            return null;
       }
       
    } 

    public class OrganizationDAOMock implements OrganizationDAO.IOrganizationDAO {
        private fflib_ApexMocks mocks;

        public OrganizationDAOMock(fflib_ApexMocks mocks) {
            this.mocks = mocks;
        }

        public Boolean isRunningInSandbox() {
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'isRunningInSandbox', null);
            } else {
                mocks.recordMethod(this, 'ggetUsernamePasswordCSByName', null);
                fflib_MethodReturnValue methodReturnValue = mocks.getMethodReturnValue(this, 'isRunningInSandbox', null);
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceOf Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (Boolean) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public Id getCurrentOrganizationId() {
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getCurrentOrganizationId', null);
            } else {
                mocks.recordMethod(this, 'ggetUsernamePasswordCSByName', null);
                fflib_MethodReturnValue methodReturnValue = mocks.getMethodReturnValue(this, 'getCurrentOrganizationId', null);
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceOf Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (Id) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }
    }

    public class ContactDAOMock implements ContactDAO.IContactDAO {
        private fflib_ApexMocks mocks;

        public ContactDAOMock(fflib_ApexMocks mocks) {
            this.mocks = mocks;
        }

        public List<Contact> getPrimaryGroupContacts(Map<Id, Account> groupAccounts, Id groupContactRecordType) {
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getPrimaryGroupContacts', new List<Object> {groupAccounts, groupContactRecordType});
            } else {
                mocks.recordMethod(this, 'getPrimaryGroupContacts', new List<Object> {groupAccounts, groupContactRecordType});
                fflib_MethodReturnValue methodReturnValue = mocks.getMethodReturnValue(this, 'getPrimaryGroupContacts', new List<Object> {groupAccounts, groupContactRecordType});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceOf Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Contact>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public List<Contact> getContactsById(List<Id> ids) {
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getContactsById', new List<Object> {ids});
            } else {
                mocks.recordMethod(this, 'getContactsById', new List<Object> {ids});
                fflib_MethodReturnValue methodReturnValue = mocks.getMethodReturnValue(this, 'getContactsById', new List<Object> {ids});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceOf Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Contact>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public List<Contact> updateContacts(List<Contact> contacts) {
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'updateContacts', new List<Object> {contacts});
            } else {
                mocks.recordMethod(this, 'updateContacts', new List<Object> {contacts});
                fflib_MethodReturnValue methodReturnValue = mocks.getMethodReturnValue(this, 'updateContacts', new List<Object> {contacts});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceOf Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Contact>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public List<Contact> getContactsWithAssociatedUsers(Set<String> associatedUserIds, 
                                        Map<String, User> userEmploymentNumbers, String recordTypeId) {
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getContactsWithAssociatedUsers', 
                                        new List<Object> {associatedUserIds, userEmploymentNumbers, recordTypeId});
            } else {
                mocks.recordMethod(this, 'getContactsWithAssociatedUsers', new List<Object> {associatedUserIds, userEmploymentNumbers, recordTypeId});
                fflib_MethodReturnValue methodReturnValue = 
                                mocks.getMethodReturnValue(this, 'getContactsWithAssociatedUsers', 
                                                new List<Object> {associatedUserIds, userEmploymentNumbers, recordTypeId});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceOf Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Contact>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public List<Contact> getContactsByAccountAddressSeqNumAndAccountId(String accountAddressSeqNum, String accountId){
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getContactsByAccountAddressSeqNumAndAccountId', 
                                        new List<Object> {accountAddressSeqNum, accountId});
            } else {
                mocks.recordMethod(this, 'getContactsByAccountAddressSeqNumAndAccountId', new List<Object> {accountAddressSeqNum, accountId});
                fflib_MethodReturnValue methodReturnValue = 
                                mocks.getMethodReturnValue(this, 'getContactsByAccountAddressSeqNumAndAccountId', 
                                                new List<Object> {accountAddressSeqNum, accountId});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceOf Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Contact>) methodReturnValue.ReturnValue;
            }
            }
            return null;
        }

        public Map<String, List<Contact>> getAcctAddrSeqNumMapToContactListByAcctIdsAndTypes(List<Contact> contacts, List<String> types){ 
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getAcctAddrSeqNumMapToContactListByAcctIdsAndTypes', 
                                        new List<Object> {contacts, types});
            } else {
                mocks.recordMethod(this, 'getAcctAddrSeqNumMapToContactListByAcctIdsAndTypes', new List<Object> {contacts, types});
                fflib_MethodReturnValue methodReturnValue = 
                                mocks.getMethodReturnValue(this, 'getAcctAddrSeqNumMapToContactListByAcctIdsAndTypes', 
                                                new List<Object> {contacts, types});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceOf Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (Map<String, List<Contact>>) methodReturnValue.ReturnValue;
                    }
            }
            return null;
        }
    }

    public class PermissionSetDAOMock implements PermissionSetDAO.IPermissionSetDAO {
        private fflib_ApexMocks mocks;

        public PermissionSetDAOMock(fflib_ApexMocks mocks) {
            this.mocks = mocks;
        }

        public List<PermissionSet> getSUAndSPPermissionSetList() {
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getSUAndSPPermissionSetList', null);
                return null;
            } else {
                mocks.prepareMethodReturnValue(this, 'getSUAndSPPermissionSetList', null);
                fflib_MethodReturnValue methodReturnValue = mocks.getMethodReturnValue(this, 'getSUAndSPPermissionSetList', null);
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceOf Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<PermissionSet>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }
    }

    public class EncryptionUtilityMock implements EncryptionUtility.IEncryptionUtility {
        
        private fflib_ApexMocks mocks;

        public EncryptionUtilityMock(fflib_ApexMocks mocks) {
            this.mocks = mocks;
        }

        public String getDecryptedMessage(String encryptedMessage){
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getDecryptedMessage', new List<Object> {encryptedMessage});
            } else {
                mocks.recordMethod(this, 'getDecryptedMessage', new List<Object> {encryptedMessage});
                fflib_MethodReturnValue methodReturnValue = mocks.getMethodReturnValue(this, 'getDecryptedMessage', new List<Object> {encryptedMessage});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceOf Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (String) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }
    }

    public class CalloutUtilityMock implements CalloutUtility.ICalloutUtility {
        
        private fflib_ApexMocks mocks;

        public CalloutUtilityMock(fflib_ApexMocks mocks) {
            this.mocks = mocks;
        }

        public Object sendCallout(String username, String password, String body, String endpoint, String certificate, String organizationId, String type){
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'sendCallout', 
                            new List<Object> {username, password, body, endpoint, certificate, organizationId, type});
            } else {
                mocks.recordMethod(this, 'sendCallout', 
                        new List<Object> {username, password, body, endpoint, certificate, organizationId, type});
                fflib_MethodReturnValue methodReturnValue = 
                        mocks.getMethodReturnValue(this, 'sendCallout', 
                                new List<Object> {username, password, body, endpoint, certificate, organizationId, type});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceOf Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (HttpResponse) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }
    }


    public class PermissionSetAssignmentDAOMock implements PermissionSetAssignmentDAO.IPermissionSetAssignmentDAO {
        private fflib_ApexMocks mocks;

        public PermissionSetAssignmentDAOMock(fflib_ApexMocks mocks) {
            this.mocks = mocks;
        }

        public void insertPermissionSetAssignmentList(List<PermissionSetAssignment> permissionSetAssignments) {
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'insertPermissionSetAssignmentList', new List<Object> {permissionSetAssignments});
            } else {
                mocks.prepareMethodReturnValue(this, 'insertPermissionSetAssignmentList', new List<Object> {permissionSetAssignments});
                fflib_MethodReturnValue methodReturnValue = mocks.getMethodReturnValue(this, 'insertPermissionSetAssignmentList', new List<Object> {permissionSetAssignments});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceOf Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                }
            }
        }

        public void deletePermissionSetAssignmentList(List<PermissionSetAssignment> permissionSetAssignments) {
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'deletePermissionSetAssignmentList', new List<Object> {permissionSetAssignments});
            } else {
                mocks.prepareMethodReturnValue(this, 'deletePermissionSetAssignmentList', new List<Object> {permissionSetAssignments});
                fflib_MethodReturnValue methodReturnValue = mocks.getMethodReturnValue(this, 'deletePermissionSetAssignmentList', new List<Object> {permissionSetAssignments});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceOf Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                }
            }
        }

        public List<PermissionSetAssignment> getSUAndSPPermissionSetAssignmentList(Id superUserPSId, Id strategicPlanPSId, Set<Id> superUserIds, Set<Id> strategicPlanUserIds) {
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getSUAndSPPermissionSetAssignmentList', new List<Object> {superUserPSId, strategicPlanPSId, superUserIds, strategicPlanUserIds});
                return null;
            } else {
                mocks.prepareMethodReturnValue(this, 'getSUAndSPPermissionSetAssignmentList', new List<Object> {superUserPSId, strategicPlanPSId, superUserIds, strategicPlanUserIds});
                fflib_MethodReturnValue methodReturnValue = mocks.getMethodReturnValue(this, 'getSUAndSPPermissionSetAssignmentList', new List<Object> {superUserPSId, strategicPlanPSId, superUserIds, strategicPlanUserIds});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceOf Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<PermissionSetAssignment>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }
    }

    public class CronTriggerDAOMock implements CronTriggerDAO.ICronTriggerDAO {
        
        private fflib_ApexMocks mocks;

        public CronTriggerDAOMock(fflib_ApexMocks mocks) {
            this.mocks = mocks;
        }

        public Integer getCronDetailCountByName(String name){
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getCronDetailCountByName', 
                            new List<Object> {name});
            } else {
                mocks.recordMethod(this, 'getCronDetailCountByName', 
                        new List<Object> {name});
                fflib_MethodReturnValue methodReturnValue = 
                        mocks.getMethodReturnValue(this, 'getCronDetailCountByName', 
                                new List<Object> {name});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceOf Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (Integer) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public CronTrigger getCronTriggerByDetailName(String name){
            if (mocks.Stubbing) {
                mocks.prepareMethodReturnValue(this, 'getCronTriggerByDetailName', 
                            new List<Object> {name});
            } else {
                mocks.recordMethod(this, 'getCronTriggerByDetailName', 
                        new List<Object> {name});
                fflib_MethodReturnValue methodReturnValue = 
                        mocks.getMethodReturnValue(this, 'getCronTriggerByDetailName', 
                                new List<Object> {name});
                if (methodReturnValue != null) {
                    if (methodReturnValue.ReturnValue instanceOf Exception) {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (CronTrigger) methodReturnValue.ReturnValue;
                }
            }
            return null;
        } 
    }

    public class RateDAOMock implements RateDAO.IRateDAO{
        private fflib_ApexMocks mocks;

        public RateDAOMock(fflib_ApexMocks mocks){
            this.mocks = mocks;
        } 
        
        public Rate__c insertRate(Rate__c rateObj){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'insertRate', new List<Object> {rateObj});
                return null;
            }else{
                mocks.recordMethod(this, 'insertRate', new List<Object> {rateObj});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'insertRate', new List<Object> {rateObj});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (Rate__c) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public Rate__c updateRate(Rate__c rateObj){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'updateRate', new List<Object> {rateObj});
                return null;
            }else{
                mocks.recordMethod(this, 'updateRate', new List<Object> {rateObj});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'updateRate', new List<Object> {rateObj});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (Rate__c) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public Rate__c grabRateObj(Id rateId){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'grabRateObj', new List<Object> {rateId});
                return null;
            }else{
                mocks.recordMethod(this, 'grabRateObj', new List<Object> {rateId});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'grabRateObj', new List<Object> {rateId});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (Rate__c) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public Rate__c grabASORateObj(Id rateId){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'grabASORateObj', new List<Object> {rateId});
                return null;
            }else{
                mocks.recordMethod(this, 'grabASORateObj', new List<Object> {rateId});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'grabASORateObj', new List<Object> {rateId});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (Rate__c) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public Rate__c grabHCARateObj(Id rateId){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'grabHCARateObj', new List<Object> {rateId});
                return null;
            }else{
                mocks.recordMethod(this, 'grabHCARateObj', new List<Object> {rateId});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'grabHCARateObj', new List<Object> {rateId});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (Rate__c) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }
    }

    public class RateProductDAOMock implements RateProductDAO.IRateProductDAO{
        private fflib_ApexMocks mocks;

        public RateProductDAOMock(fflib_ApexMocks mocks){
            this.mocks = mocks;
        } 
        
        public List<Rate_Product__c> insertRateProducts(List<Rate_Product__c> rateProductObj){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'insertRateProducts', new List<Object> {rateProductObj});
                return null;
            }else{
                mocks.recordMethod(this, 'insertRateProducts', new List<Object> {rateProductObj});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'insertRateProducts', new List<Object> {rateProductObj});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Rate_Product__c>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public List<Rate_Product__c> updateRateProducts(List<Rate_Product__c> rateProductObj){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'updateRateProducts', new List<Object> {rateProductObj});
                return null;
            }else{
                mocks.recordMethod(this, 'updateRateProducts', new List<Object> {rateProductObj});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'updateRateProducts', new List<Object> {rateProductObj});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Rate_Product__c>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public List<Rate_Product__c> grabRateProducts(Id rateId){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'grabRateProducts', new List<Object> {rateId});
                return null;
            }else{
                mocks.recordMethod(this, 'grabRateProducts', new List<Object> {rateId});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'grabRateProducts', new List<Object> {rateId});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Rate_Product__c>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }
    }

    public class RateGroupDAOMock implements RateGroupDAO.IRateGroupDAO{
        private fflib_ApexMocks mocks;

        public RateGroupDAOMock(fflib_ApexMocks mocks){
            this.mocks = mocks;
        } 
        
        public List<Rate_Group__c> insertRateGroup(List<Rate_Group__c> rateGroupObj){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'insertRateGroup', new List<Object> {rateGroupObj});
                return null;
            }else{
                mocks.recordMethod(this, 'insertRateGroup', new List<Object> {rateGroupObj});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'insertRateGroup', new List<Object> {rateGroupObj});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Rate_Group__c>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public List<Rate_Group__c> upsertRateGroup(List<Rate_Group__c> rateGroupObj){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'upsertRateGroup', new List<Object> {rateGroupObj});
                return null;
            }else{
                mocks.recordMethod(this, 'upsertRateGroup', new List<Object> {rateGroupObj});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'upsertRateGroup', new List<Object> {rateGroupObj});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Rate_Group__c>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public List<Rate_Group__c> grabRateGroups(Id rateId){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'grabRateGroups', new List<Object> {rateId});
                return null;
            }else{
                mocks.recordMethod(this, 'grabRateGroups', new List<Object> {rateId});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'grabRateGroups', new List<Object> {rateId});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Rate_Group__c>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }
    }

    public class RateAdminChargeDAOMock implements RateAdminChargeDAO.IRateAdminChargeDAO{
        private fflib_ApexMocks mocks;

        public RateAdminChargeDAOMock(fflib_ApexMocks mocks){
            this.mocks = mocks;
        } 
        
        public List<Rate_Admin_Charge__c> insertRateAdminCharge(List<Rate_Admin_Charge__c> rateAdminChargeObj){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'insertRateAdminCharge', new List<Object> {rateAdminChargeObj});
                return null;
            }else{
                mocks.recordMethod(this, 'insertRateAdminCharge', new List<Object> {rateAdminChargeObj});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'insertRateAdminCharge', new List<Object> {rateAdminChargeObj});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Rate_Admin_Charge__c>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public List<Rate_Admin_Charge__c> upsertRateAdminCharge(List<Rate_Admin_Charge__c> rateAdminChargeObj){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'upsertRateAdminCharge', new List<Object> {rateAdminChargeObj});
                return null;
            }else{
                mocks.recordMethod(this, 'upsertRateAdminCharge', new List<Object> {rateAdminChargeObj});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'upsertRateAdminCharge', new List<Object> {rateAdminChargeObj});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Rate_Admin_Charge__c>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public List<Rate_Admin_Charge__c> grabRateAdminCharges(Id rateId){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'grabRateAdminCharges', new List<Object> {rateId});
                return null;
            }else{
                mocks.recordMethod(this, 'grabRateAdminCharges', new List<Object> {rateId});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'grabRateAdminCharges', new List<Object> {rateId});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Rate_Admin_Charge__c>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }
    }

    public class RateHCADAOMock implements RateHCADAO.IRateHCADAO{
        private fflib_ApexMocks mocks;

        public RateHCADAOMock(fflib_ApexMocks mocks){
            this.mocks = mocks;
        } 
        
        public List<Rate_HCA__c> insertRateHCA(List<Rate_HCA__c> rateHCAObj){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'insertRateHCA', new List<Object> {rateHCAObj});
                return null;
            }else{
                mocks.recordMethod(this, 'insertRateHCA', new List<Object> {rateHCAObj});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'insertRateHCA', new List<Object> {rateHCAObj});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Rate_HCA__c>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public List<Rate_HCA__c> upsertRateHCA(List<Rate_HCA__c> rateHCAObj){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'upsertRateHCA', new List<Object> {rateHCAObj});
                return null;
            }else{
                mocks.recordMethod(this, 'upsertRateHCA', new List<Object> {rateHCAObj});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'upsertRateHCA', new List<Object> {rateHCAObj});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Rate_HCA__c>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public List<Rate_HCA__c> grabRateHCAs(Id rateId){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'grabRateHCAs', new List<Object> {rateId});
                return null;
            }else{
                mocks.recordMethod(this, 'grabRateHCAs', new List<Object> {rateId});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'grabRateHCAs', new List<Object> {rateId});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Rate_HCA__c>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }
    }

    public class BenefitAgreementDAOMock implements BenefitAgreementDAO.IBenefitAgreementDAO{
        private fflib_ApexMocks mocks;

        public BenefitAgreementDAOMock(fflib_ApexMocks mocks){
            this.mocks = mocks;
        } 
        
        public List<Benefit_Agreement__c> getBatchBenefitAgreements(Set<Id> accountIds){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'getBatchBenefitAgreements', new List<Object> {accountIds});
                return null;
            }else{
                mocks.recordMethod(this, 'getBatchBenefitAgreements', new List<Object> {accountIds});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'getBatchBenefitAgreements', new List<Object> {accountIds});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Benefit_Agreement__c>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public List<Benefit_Agreement__c> getGroupAccountBenefitAgreements(List<Account> groupAccounts){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'getGroupAccountBenefitAgreements', new List<Object> {groupAccounts});
                return null;
            }else{
                mocks.recordMethod(this, 'getGroupAccountBenefitAgreements', new List<Object> {groupAccounts});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'getGroupAccountBenefitAgreements', new List<Object> {groupAccounts});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Benefit_Agreement__c>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public List<Benefit_Agreement__c> getActiveBenefitAgreementsAndCoverages(Map<Id, Account> groupAccounts){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'getActiveBenefitAgreementsAndCoverages', new List<Object> {groupAccounts});
                return null;
            }else{
                mocks.recordMethod(this, 'getActiveBenefitAgreementsAndCoverages', new List<Object> {groupAccounts});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'getActiveBenefitAgreementsAndCoverages', new List<Object> {groupAccounts});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Benefit_Agreement__c>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public void updateBenefitAgreements(List<Benefit_Agreement__c> bnftAgrmnts){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'updateBenefitAgreements', new List<Object> {bnftAgrmnts});
            }else{
                mocks.recordMethod(this, 'updateBenefitAgreements', new List<Object> {bnftAgrmnts});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'updateBenefitAgreements', new List<Object> {bnftAgrmnts});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                }
            }
        }

        public List<Benefit_Agreement__c> getActiveBlueStarBenefitAgreements(Set<Id> baIds, Id BlueSTARRecType){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'getActiveBlueStarBenefitAgreements', new List<Object> {baIds, BlueSTARRecType});
                return null;
            }else{
                mocks.recordMethod(this, 'getActiveBlueStarBenefitAgreements', new List<Object> {baIds, BlueSTARRecType});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'getActiveBlueStarBenefitAgreements', new List<Object> {baIds, BlueSTARRecType});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Benefit_Agreement__c>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public List<Benefit_Agreement__c> getBenefitAgreementsForCurrentProds(Id acctId){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'getBenefitAgreementsForCurrentProds', new List<Object> {acctId});
                return null;
            }else{
                mocks.recordMethod(this, 'getBenefitAgreementsForCurrentProds', new List<Object> {acctId});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'getBenefitAgreementsForCurrentProds', new List<Object> {acctId});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Benefit_Agreement__c>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }
    }

    public class AccountDAOMock implements AccountDAO.IAccountDAO{
        private fflib_ApexMocks mocks;

        public AccountDAOMock(fflib_ApexMocks mocks){
            this.mocks = mocks;
        } 
        
        public List<Account> getAccountsForProduct360(Id userId, Set<Id> accountIds){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'getAccountsForProduct360', new List<Object> {userId, accountIds});
                return null;
            }else{
                mocks.recordMethod(this, 'getAccountsForProduct360', new List<Object> {userId, accountIds});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'getAccountsForProduct360', new List<Object> {userId, accountIds});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Account>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

     
       
        public void updateAccounts(List<Account> accountsToUpdate){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'updateAccounts', new List<Object> {accountsToUpdate});
            }else{
                mocks.recordMethod(this, 'updateAccounts', new List<Object> {accountsToUpdate});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'updateAccounts', new List<Object> {accountsToUpdate});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                }
            }
        }

        public List<Account> getAccountForPrimaryContactUpdate(Set<Id> accountIds){
            
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'getAccountForPrimaryContactUpdate', new List<Object> {accountIds});
                return null;
            }else{
                mocks.recordMethod(this, 'getAccountForPrimaryContactUpdate', new List<Object> {accountIds});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'getAccountForPrimaryContactUpdate', new List<Object> {accountIds});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Account>) methodReturnValue.ReturnValue;
                }
            }
            return null;
       }
       
        public List<Account> getAccounts(Set<Id> accountIds){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'getAccounts', new List<Object> {accountIds});
                return null;
            }else{
                mocks.recordMethod(this, 'getAccounts', new List<Object> {accountIds});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'getAccounts', new List<Object> {accountIds});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Account>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public List<Account> getCaseComplexityGroupAccounts(Set<Id> parentAccountIds, Id groupAccountRecordType){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'getCaseComplexityGroupAccounts', new List<Object> {parentAccountIds, groupAccountRecordType});
                return null;
            }else{
                mocks.recordMethod(this, 'getCaseComplexityGroupAccounts', new List<Object> {parentAccountIds, groupAccountRecordType});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'getCaseComplexityGroupAccounts', new List<Object> {parentAccountIds, groupAccountRecordType});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Account>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public List<Account> getContactComplexityGroupAccounts(Set<Id> parentAccountIds, Id groupAccountRecordType){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'getContactComplexityGroupAccounts', new List<Object> {parentAccountIds, groupAccountRecordType});
                return null;
            }else{
                mocks.recordMethod(this, 'getContactComplexityGroupAccounts', new List<Object> {parentAccountIds, groupAccountRecordType});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'getContactComplexityGroupAccounts', new List<Object> {parentAccountIds, groupAccountRecordType});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Account>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public List<Account> getCompetitorRelationshipComplexityGroupAccounts(Set<Id> parentAccountIds, Id groupAccountRecordType){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'getCompetitorRelationshipComplexityGroupAccounts', new List<Object> {parentAccountIds, groupAccountRecordType});
                return null;
            }else{
                mocks.recordMethod(this, 'getCompetitorRelationshipComplexityGroupAccounts', new List<Object> {parentAccountIds, groupAccountRecordType});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'getCompetitorRelationshipComplexityGroupAccounts', new List<Object> {parentAccountIds, groupAccountRecordType});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Account>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public List<Account> getBenefitAgreementComplexityGroupAccounts(Set<Id> parentAccountIds, Id groupAccountRecordType){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'getBenefitAgreementComplexityGroupAccounts', new List<Object> {parentAccountIds, groupAccountRecordType});
                return null;
            }else{
                mocks.recordMethod(this, 'getBenefitAgreementComplexityGroupAccounts', new List<Object> {parentAccountIds, groupAccountRecordType});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'getBenefitAgreementComplexityGroupAccounts', new List<Object> {parentAccountIds, groupAccountRecordType});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Account>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public List<Account> getContractAdministrationComplexityGroupAccounts(Set<Id> parentAccountIds, Id groupAccountRecordType){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'getContractAdministrationComplexityGroupAccounts', new List<Object> {parentAccountIds, groupAccountRecordType});
                return null;
            }else{
                mocks.recordMethod(this, 'getContractAdministrationComplexityGroupAccounts', new List<Object> {parentAccountIds, groupAccountRecordType});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'getContractAdministrationComplexityGroupAccounts', new List<Object> {parentAccountIds, groupAccountRecordType});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Account>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public List<Account> getAccountsForContractSignerAccount(Set<Id> accIds){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'getAccountsForContractSignerAccount', new List<Object> {accIds});
                return null;
            }else{
                mocks.recordMethod(this, 'getAccountsForContractSignerAccount', new List<Object> {accIds});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'getAccountsForContractSignerAccount', new List<Object> {accIds});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Account>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public List<Account> getAccountsForContractSignerCase(Set<Id> accIds, Id groupRecordTypeId, Id prospectRecordTypeId){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'getAccountsForContractSignerCase', new List<Object> {accIds, groupRecordTypeId, prospectRecordTypeId});
                return null;
            }else{
                mocks.recordMethod(this, 'getAccountsForContractSignerCase', new List<Object> {accIds, groupRecordTypeId, prospectRecordTypeId});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'getAccountsForContractSignerCase', new List<Object> {accIds, groupRecordTypeId, prospectRecordTypeId});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Account>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public Account getAccountForCustomContractsProdsPage(Id acctId){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'getAccountForCustomContractsProdsPage', new List<Object> {acctId});
                return null;
            }else{
                mocks.recordMethod(this, 'getAccountForCustomContractsProdsPage', new List<Object> {acctId});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'getAccountForCustomContractsProdsPage', new List<Object> {acctId});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (Account) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public List<Account> getProducerAccountsForTicketDistro(Set<Id> accIds, Id producerRecordTypeId){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'getProducerAccountsForTicketDistro', new List<Object> {accIds, producerRecordTypeId});
                return null;
            }else{
                mocks.recordMethod(this, 'getProducerAccountsForTicketDistro', new List<Object> {accIds, producerRecordTypeId});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'getProducerAccountsForTicketDistro', new List<Object> {accIds, producerRecordTypeId});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Account>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public List<Account> getGroupAccountsForTicketDistro(Set<Id> accIds, Id groupRecordTypeId){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'getGroupAccountsForTicketDistro', new List<Object> {accIds, groupRecordTypeId});
                return null;
            }else{
                mocks.recordMethod(this, 'getGroupAccountsForTicketDistro', new List<Object> {accIds, groupRecordTypeId});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'getGroupAccountsForTicketDistro', new List<Object> {accIds, groupRecordTypeId});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Account>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }
    }

    public class TicketEventDAOMock implements TicketEventDAO.ITicketEventDAO{
        private fflib_ApexMocks mocks;

        public TicketEventDAOMock(fflib_ApexMocks mocks){
            this.mocks = mocks;
        } 
        
        public Ticket_Event__c insertTicketEvent(Ticket_Event__c ticketEventObj){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'insertTicketEvent', new List<Object> {ticketEventObj});
                return null;
            }else{
                mocks.recordMethod(this, 'insertTicketEvent', new List<Object> {ticketEventObj});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'insertTicketEvent', new List<Object> {ticketEventObj});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (Ticket_Event__c) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public Ticket_Event__c updateTicketEvent(Ticket_Event__c ticketEventObj){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'updateTicketEvent', new List<Object> {ticketEventObj});
                return null;
            }else{
                mocks.recordMethod(this, 'updateTicketEvent', new List<Object> {ticketEventObj});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'updateTicketEvent', new List<Object> {ticketEventObj});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (Ticket_Event__c) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public Ticket_Event__c grabTicketEventObj(Id ticketEventId){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'grabTicketEventObj', new List<Object> {ticketEventId});
                return null;
            }else{
                mocks.recordMethod(this, 'grabTicketEventObj', new List<Object> {ticketEventId});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'grabTicketEventObj', new List<Object> {ticketEventId});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (Ticket_Event__c) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }
    }

    public class TicketGroupingDAOMock implements TicketGroupingDAO.ITicketGroupingDAO{
        private fflib_ApexMocks mocks;

        public TicketGroupingDAOMock(fflib_ApexMocks mocks){
            this.mocks = mocks;
        } 
        
        public List<Ticket_Grouping__c> insertTicketGroupings(List<Ticket_Grouping__c> ticketGroupings){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'insertTicketGroupings', new List<Object> {ticketGroupings});
                return null;
            }else{
                mocks.recordMethod(this, 'insertTicketGroupings', new List<Object> {ticketGroupings});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'insertTicketGroupings', new List<Object> {ticketGroupings});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Ticket_Grouping__c>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public List<Ticket_Grouping__c> upsertTicketGroupings(List<Ticket_Grouping__c> ticketGroupings){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'upsertTicketGroupings', new List<Object> {ticketGroupings});
                return null;
            }else{
                mocks.recordMethod(this, 'upsertTicketGroupings', new List<Object> {ticketGroupings});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'upsertTicketGroupings', new List<Object> {ticketGroupings});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Ticket_Grouping__c>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public Ticket_Grouping__c deleteTicketGrouping(Ticket_Grouping__c ticketGroupingObj){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'deleteTicketGrouping', new List<Object> {ticketGroupingObj});
                return null;
            }else{
                mocks.recordMethod(this, 'deleteTicketGrouping', new List<Object> {ticketGroupingObj});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'deleteTicketGrouping', new List<Object> {ticketGroupingObj});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (Ticket_Grouping__c) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public List<Ticket_Grouping__c> grabTicketGroupings(Id ticketId){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'grabTicketGroupings', new List<Object> {ticketId});
                return null;
            }else{
                mocks.recordMethod(this, 'grabTicketGroupings', new List<Object> {ticketId});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'grabTicketGroupings', new List<Object> {ticketId});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Ticket_Grouping__c>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }
    }

    public class TicketDAOMock implements TicketDAO.ITicketDAO{
        private fflib_ApexMocks mocks;

        public TicketDAOMock(fflib_ApexMocks mocks){
            this.mocks = mocks;
        } 
        
        public List<Ticket__c> insertTickets(List<Ticket__c> ticketObjs){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'insertTickets', new List<Object> {ticketObjs});
                return null;
            }else{
                mocks.recordMethod(this, 'insertTickets', new List<Object> {ticketObjs});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'insertTickets', new List<Object> {ticketObjs});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Ticket__c>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public List<Ticket__c> upsertTickets(List<Ticket__c> ticketObjs){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'upsertTickets', new List<Object> {ticketObjs});
                return null;
            }else{
                mocks.recordMethod(this, 'upsertTickets', new List<Object> {ticketObjs});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'upsertTickets', new List<Object> {ticketObjs});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Ticket__c>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }

        public List<Ticket__c> deleteTickets(List<Ticket__c> ticketObjs){
            if (mocks.Stubbing){
                mocks.prepareMethodReturnValue(this, 'deleteTickets', new List<Object> {ticketObjs});
                return null;
            }else{
                mocks.recordMethod(this, 'deleteTickets', new List<Object> {ticketObjs});
                fflib_MethodReturnValue methodReturnValue =   
                                mocks.getMethodReturnValue(this, 'deleteTickets', new List<Object> {ticketObjs});
                if (methodReturnValue != null){
                    if (methodReturnValue.ReturnValue instanceof Exception)
                    {
                        throw ((Exception) methodReturnValue.ReturnValue);
                    }
                    return (List<Ticket__c>) methodReturnValue.ReturnValue;
                }
            }
            return null;
        }
    }
}