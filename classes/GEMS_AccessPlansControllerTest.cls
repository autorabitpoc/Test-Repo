@isTest
public class GEMS_AccessPlansControllerTest {
private static testmethod void GEMS_AccessPlansControllerTest()
{
      test.starttest(); 
                    product2 prod = new product2();
                    prod.IsActive = True;
                    prod.name = 'Accident Insurance (Dearborn)';
                    insert prod;      
       
                    List<product2> prodRecQuery=[SELECT ID, name,IsActive FROM product2 WHERE IsActive =true];
                    System.assertEquals('Accident Insurance (Dearborn)',prodRecQuery[0].Name);
                  
           
                    Plan__c Plan = New Plan__c();            
                    Plan.Product__c =prod.Id;
                    Plan.Plan_Type__c ='PDent';
                    Plan.Name ='Insurance';
                    insert Plan;
           
                   List<Plan__c> planRecQuery=[SELECT ID, name FROM Plan__c WHERE name='Insurance'];
                   System.assertEquals('Insurance',planRecQuery[0].Name);
                   GEMS_AccessPlansController gems = new GEMS_AccessPlansController ();
                   
                   gems.getPlans();        
          
       test.stoptest();
 
 }
 }