public class CoverageTriggerHandler { 

	/**
	* @author       Sana Fatima/Slalom
	* @description  Filters the parent benefit agreements that need to be updated
	*/
	public static void updateBenefitAgreementComplexityScore(List<Coverage__c> coveragesToUpdate) {
		Set<Id> baIds = new Set<Id>();
		Map<Id, Benefit_Agreement__c> parentBAs = new Map<Id, Benefit_Agreement__c>();
		Id BlueSTARRecType = Schema.SObjectType.Benefit_Agreement__c.getRecordTypeInfosByName().get( ConstantsController.BlueStar ).getRecordTypeId();
		BenefitAgreementDAO.IBenefitAgreementDAO bnftAgrmntDAOInstance = new BenefitAgreementDAO();

		for (Coverage__c coverage : coveragesToUpdate ) {
			if ( coverage.Benefit_Agreement__c != null ) {
				baIds.add( coverage.Benefit_Agreement__c );
			}
		}
		if ( !baIds.isEmpty() ) {
			parentBAs = new Map<Id, Benefit_Agreement__c>( bnftAgrmntDAOInstance.getActiveBlueStarBenefitAgreements(baIds, BlueSTARRecType) );
		}
		if ( !parentBAs.isEmpty() ) {
			calculateBenefitAgreementCoverageComplexity( parentBAs );
		}
	}

	/**
	* @author       Sana Fatima/Slalom
	* @description  Computes the Complexity Score on Benefit Agreement for the Coverage object
	*/
	public static void calculateBenefitAgreementCoverageComplexity(Map<Id, Benefit_Agreement__c> blueSTARBAs) {
		try{
			List<Coverage__c> coverages = new List<Coverage__c>();
			List<Benefit_Agreement__c> BAsToUpdate = new List<Benefit_Agreement__c>();
			Map<Id, List<Coverage__c>> coveragesByBA = new Map<Id, List<Coverage__c>>();
			BenefitAgreementDAO.IBenefitAgreementDAO bnftAgrmntDAOInstance = new BenefitAgreementDAO();
			CoverageDAO.ICoverageDAO coverageDAOInstance = new CoverageDAO();
			Decimal oldValue;
			Boolean typeDrug;

			coverages = coverageDAOInstance.getCoveragesForBAs(blueSTARBAs.keySet());

			for( Coverage__c coverage :coverages ) {
				if ( coveragesByBA.containsKey(coverage.Benefit_Agreement__c) ) {
					coveragesByBA.get(coverage.Benefit_Agreement__c).add( coverage );
				} else {
					coveragesByBA.put( coverage.Benefit_Agreement__c, new List<Coverage__c>{coverage} );
				}
			}

			for( Benefit_Agreement__c bnftAgrmnt : blueSTARBAs.values() ) {
				oldValue = bnftAgrmnt.ComplexityScoreCoverage__c;
				typeDrug = false;

				List<Coverage__c> cvrgs = new List<Coverage__c>();
				if( coveragesByBA.containsKey(bnftAgrmnt.id) ) {
					cvrgs = coveragesByBA.get(bnftAgrmnt.id);
				}
				for (Coverage__c coverage: cvrgs) {
					if( coverage.Type__c == ConstantsController.typeDrug ) {
						typeDrug = true;
					} 
				}
				if( typeDRUG == true ) {
					bnftAgrmnt.ComplexityScoreCoverage__c = 3;
				} else {
					bnftAgrmnt.ComplexityScoreCoverage__c = 0;
				}
				if ( bnftAgrmnt.ComplexityScoreCoverage__c != oldValue) {
					BAsToUpdate.add(bnftAgrmnt);
				}
			}
			bnftAgrmntDAOInstance.updateBenefitAgreements( BAsToUpdate );
		} catch (Exception ex) {
			CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Coverage', 'CoverageTrigger', 'CoverageTriggerHandler.calculateBenefitAgreementCoverageComplexity', 'High');
		}
	}
}