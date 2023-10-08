public inherited sharing class MineralDA {

	public List<Location__mdt> getLocationInformation() {
		List<Location__mdt> locationList = [
			SELECT
				Id,
				Description__c,
				Icon__c,
				Latitude__c,
				Longitude__c,
				Title__c,
				Type__c,
				Value__c
			FROM Location__mdt
			ORDER BY Value__c DESC];
		return locationList;
	}
}