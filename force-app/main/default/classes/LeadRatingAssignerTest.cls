@IsTest
private class LeadRatingAssignerTest {
    
    // Helper method to construct a Lead with your org's required custom field
    private static Lead buildLead(String lastName, Decimal annualRevenue, Integer employees) {
        return new Lead(
            LastName = lastName,
            Company = 'TestCompany',
            AnnualRevenue = annualRevenue,
            NumberOfEmployees = employees
        );
    }

    @IsTest
    static void testRatingAssignmentScenarios() {
        List<Lead> testLeads = new List<Lead>();
        
        // Populate scenarios matching Hot, Warm, and Cold thresholds
        testLeads.add(buildLead('HotRevenue', 15000000, 10));   // Hot by Revenue
        testLeads.add(buildLead('HotEmployees', 500000, 600));  // Hot by Employees
        testLeads.add(buildLead('WarmRevenue', 5000000, 10));   // Warm by Revenue
        testLeads.add(buildLead('WarmEmployees', 50000, 200));  // Warm by Employees
        testLeads.add(buildLead('ColdDefault', null, null));    // Cold by lack of data

        Test.startTest();
        LeadRatingAssigner.assignRatings(testLeads);
        Test.stopTest();

        // Assertions to verify the logic behaves exactly as expected
        System.assertEquals('Hot', testLeads[0].Rating, 'Expected Hot rating for AnnualRevenue >= 10M');
        System.assertEquals('Hot', testLeads[1].Rating, 'Expected Hot rating for NumberOfEmployees >= 500');
        System.assertEquals('Warm', testLeads[2].Rating, 'Expected Warm rating for AnnualRevenue >= 1M');
        System.assertEquals('Warm', testLeads[3].Rating, 'Expected Warm rating for NumberOfEmployees >= 100');
        System.assertEquals('Cold', testLeads[4].Rating, 'Expected Cold rating for low or null values');
    }
}