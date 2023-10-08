@isTest
public class MineralDATest {
	private static final MineralDA minDA = new MineralDA();

	@isTest
	static void getLocationInformation_givenNoParameters_shouldReturnCustomMetadataRecords() {
		List<Location__mdt> locationMetadata = new List<Location__mdt>();

		Test.startTest();
			locationMetadata = minDA.getLocationInformation();
		Test.stopTest();

		System.assertNotEquals(0, locationMetadata.size(), 'There should be more than one record available.');
	}
}