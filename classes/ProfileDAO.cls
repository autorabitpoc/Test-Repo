public with sharing class ProfileDAO implements IProfileDAO {
    static Profile profile;
    
	public interface IProfileDAO {
		Profile getProfileByName(String name);
		Profile getProfileById(Id profileId);
	}

	public Profile getProfileByName(String name) {
        if (null == profile) {
            profile = [SELECT id, name FROM profile WHERE name = :name LIMIT 1];
        }
		return profile;
	}

	public Profile getProfileById(Id profileId) {
    if (null == profile) {
            profile = [SELECT Id,Name FROM Profile WHERE Id=:profileId LIMIT 1];
        }
		return profile;
	}
}