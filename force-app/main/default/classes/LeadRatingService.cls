public with sharing class LeadRatingService {
    
    // Enterprise Configuration Constants
    private static final Decimal HOT_REVENUE_THRESHOLD = 10000000.00;
    private static final Integer HOT_EMPLOYEE_THRESHOLD = 500;
    
    private static final Decimal WARM_REVENUE_THRESHOLD = 1000000.00;
    private static final Integer WARM_EMPLOYEE_THRESHOLD = 100;
    
    // Public Global Strings to prevent typo mistakes across classes
    public static final String RATING_HOT = 'Hot';
    public static final String RATING_WARM = 'Warm';
    public static final String RATING_COLD = 'Cold';

    /**
     * Iterates over a collection of Leads to assign tiered ratings.
     * Engineered with explicit guard rails against null collection inputs.
     */
    public void evaluateAndAssignRatings(List<Lead> leadRecords) {
        if (leadRecords == null || leadRecords.isEmpty()) {
            return;
        }

        for (Lead targetLead : leadRecords) {
            targetLead.Rating = calculateRating(targetLead);
        }
    }

    /**
     * Pure functional evaluation logic decoupled from the mutation loop.
     */
    private String calculateRating(Lead myLead) {
        // Enforce null safety defaults on numeric values
        Decimal revenue = (myLead.AnnualRevenue != null) ? myLead.AnnualRevenue : 0.00;
        Integer employees = (myLead.NumberOfEmployees != null) ? myLead.NumberOfEmployees : 0;

        // Condition Hierarchy Evaluation
        if (revenue >= HOT_REVENUE_THRESHOLD || employees >= HOT_EMPLOYEE_THRESHOLD) {
            return RATING_HOT;
        }
        
        if (revenue >= WARM_REVENUE_THRESHOLD || employees >= WARM_EMPLOYEE_THRESHOLD) {
            return RATING_WARM;
        }

        return RATING_COLD;
    }
}