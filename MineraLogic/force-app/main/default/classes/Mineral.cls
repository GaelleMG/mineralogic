public with sharing class Mineral {
	private static final MineralDA minDA = new MineralDA();

	@AuraEnabled(cacheable=true)
	public static List<Mineral.LocationDetails> getLocationInformation(){
		try {
			List<LocationDetails> locations = new List<LocationDetails>();
			List<Location__mdt> locationList = minDA.getLocationInformation();
			for(Location__mdt column: locationList) {
				LocationDetails location = new LocationDetails();
				location.description = column.Description__c;
				location.icon = column.Icon__c;
				location.latitude = column.Latitude__c;
				location.longitude = column.Longitude__c;
				location.title = column.Title__c;
				location.type = column.Type__c;
				location.value = column.Value__c;
				locations.add(location);
			}
			return locations;
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	public class LocationDetails {
		@AuraEnabled public String description {get; set;}
		@AuraEnabled public String icon {get; set;}
		@AuraEnabled public String latitude {get; set;}
		@AuraEnabled public String longitude {get; set;}
		@AuraEnabled public String title {get; set;}
		@AuraEnabled public String type {get; set;}
		@AuraEnabled public String value {get; set;}
	}
}