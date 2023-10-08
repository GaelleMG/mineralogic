@isTest
public class MineralTest {

	@isTest
	static void getLocationInformation_givenNoParameters_shouldReturnCustomMetadataRecords() {

		Test.startTest();
            List<Mineral.LocationDetails> mineralMetadata = Mineral.getLocationInformation();
		Test.stopTest();

		System.assertNotEquals(null, mineralMetadata, 'There should be more than one record available.');
	}
}