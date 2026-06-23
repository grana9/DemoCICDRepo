@IsTest
private class LeadRatingServiceTest {

    // Test Data Factory Pattern generating records with your required custom field
    private static List<Lead> generateMockLeads() {
        List<Lead> records = new List<Lead>();
        
        records.add(new Lead(LastName = 'Tier1_HotRev', Company = 'Nexus Inc', AnnualRevenue = 15000000, NumberOfEmployees = 5));
        records.add(new Lead(LastName = 'Tier1_HotEmp', Company = 'Apex Corp', AnnualRevenue = 200000, NumberOfEmployees = 550));
        records.add(new Lead(LastName = 'Tier2_WarmRev', Company = 'Delta Co', AnnualRevenue = 3500000, NumberOfEmployees = 25));
        records.add(new Lead(LastName = 'Tier2_WarmEmp', Company = 'Sigma Ltd', AnnualRevenue = 80000, NumberOfEmployees = 120));
        records.add(new Lead(LastName = 'Tier3_ColdDefault', Company = 'Alpha LLC', AnnualRevenue = null, NumberOfEmployees = null));
        
        return records;
    }

    @IsTest
    static void testServiceRatingPipeline() {
        // Instantiate the service layer object
        LeadRatingService service = new LeadRatingService();
        List<Lead> testLeads = generateMockLeads();

        Test.startTest();
        service.evaluateAndAssignRatings(testLeads);
        Test.stopTest();

        // Validating the array indexes sequentially based on threshold conditions
        System.assertEquals(LeadRatingService.RATING_HOT, testLeads[0].Rating, 'Should evaluate to Hot via high revenue');
        System.assertEquals(LeadRatingService.RATING_HOT, testLeads[1].Rating, 'Should evaluate to Hot via high headcount');
        System.assertEquals(LeadRatingService.RATING_WARM, testLeads[2].Rating, 'Should evaluate to Warm via mid-tier revenue');
        System.assertEquals(LeadRatingService.RATING_WARM, testLeads[3].Rating, 'Should evaluate to Warm via mid-tier headcount');
        System.assertEquals(LeadRatingService.RATING_COLD, testLeads[4].Rating, 'Should default to Cold on null values');
    }

    @IsTest
    static void testNullAndEmptySafetyGuardrails() {
        LeadRatingService service = new LeadRatingService();
        
        Test.startTest();
        // Verifying that checking empty sets or completely null lists won't trigger standard NullPointerExceptions
        service.evaluateAndAssignRatings(null);
        service.evaluateAndAssignRatings(new List<Lead>());
        Test.stopTest();
        
        System.assert(true, 'The method successfully sustained empty and null parameters without crashing.');
    }
}