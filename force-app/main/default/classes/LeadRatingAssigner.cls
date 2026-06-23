public with sharing class LeadRatingAssigner {
    /**
     * Automatically assigns the Rating field on a list of Lead records
     * based on AnnualRevenue and NumberOfEmployees thresholds.
     */
    public static void assignRatings(List<Lead> leads) {
        for (Lead ld : leads) {
            // Define business thresholds
            Boolean isHot = (ld.AnnualRevenue != null && ld.AnnualRevenue >= 10000000) || (ld.NumberOfEmployees != null && ld.NumberOfEmployees >= 500);
            Boolean isWarm = (ld.AnnualRevenue != null && ld.AnnualRevenue >= 1000000) || (ld.NumberOfEmployees != null && ld.NumberOfEmployees >= 100);

            if (isHot) {
                ld.Rating = 'Hot';
            } else if (isWarm) {
                ld.Rating = 'Warm';
            } else {
                ld.Rating = 'Cold';
            }
        }
    }
}