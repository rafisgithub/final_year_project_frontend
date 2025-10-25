// ignore_for_file: constant_identifier_names, unnecessary_string_interpolations

const String url = "https://admin.letme.no/api/v1/app";

// ignore: unnecessary_brace_in_string_interps
//const String imageUrl = "https://admin.letme.no";
const String imageUrl = "";
//String imageUrl = String.fromEnvironment("IMAGE_URL");

final class NetworkConstants {
  NetworkConstants._();
  static const ACCEPT = "Accept";
  static const APP_KEY = "App-Key";
  static const ACCEPT_LANGUAGE = "Accept-Language";
  static const ACCEPT_LANGUAGE_VALUE = "pt";
  static const APP_KEY_VALUE = String.fromEnvironment("APP_KEY_VALUE");
  static const ACCEPT_TYPE = "application/json";
  static const AUTHORIZATION = "Authorization";
  static const CONTENT_TYPE = "content-Type";
}

final class Endpoints {
  Endpoints._();

  // auth
  static String clientSignUp() => "/clientsignup/";
  static String clientSignIn() => "/signin/";
  static String companySignup() => "/company/profile/";
  static String staffSignup() => "/staffsignup/";
  static String staffExperience() => "/staff/experiences/";
  static String staffProfileSignup() => "/staff/profile/";
  static String getStaffProfile() => "/staff/profile/";

  static String getBusinessProfile() => "/company/profile/";

  // job data dropdown
  static String clientJobRole() => "/api/jobroles/";
  static String clientSkill() => "/api/skills/";
  static String clientUniform() => "/uniforms/";
  static String clientinvitestaff() => "/company/staff/favourites/";
  static String clientJobTemplete() => "/job/templates/";
  static String clientJobTempletList(int id) => "/job/templates/$id/";

  //jobs
  static String createJob() => "/company/jobs/";
  static String jobListing(String status) => "/dashboard/jobs/?status=$status";
  static String jobDetails(int id) => "/dashboard/jobs/$id/";

  //staff jobs
  static String staffAllJobListing() => "/dashboard/jobs/";
  static String staffJobDetails(int id) => "/dashboard/jobs/$id/";
  static String staffJobApply(int id) => "/staff/job/apply/$id/";
  static String upcommingJobs() => "/staff/jobs/";
  static String upcomingJobDetails(int id) => "/staff/jobs/$id/";
  static String staffJobCheckin(int id) => "/staff/jobs/$id/checkin/";
  static String staffJobCheckout(int id) => "/staff/jobs/$id/checkout/";
  static String staffJobReport(int id, bool isallReport) =>
      "/staff/job/report/$id/?all=$isallReport";
  static String staffJobPastReport(int id, bool isallReport) =>
      "/staff/job/report/$id/?all=$isallReport";

  static String staffReviews() => "/staff/reviews/";
  static String staffjobHistory(int id) => "/staff/review/job-history/$id/";

  static String getapplicants(int id) => "/company/job/$id/applications/";
  static String jobStatus(int id) => "/company/job/applications/$id/";
  static String clientSideStaffProfile(int id) => "/staff/profile/$id/";
  static String clientUpcomming(int id) => "/staff/review/upcomming-job/$id/";
  static String clientHistory(int id) => "/staff/review/job-history/$id/";
  static String clientReview(int id) => "/staff/review/review-list/$id/";
  static String businessReviews() => "/company/review/";
  static String workingHour(int id) => "/staff/workinghours/$id/";
  static String clientCheckin() => "/company/job/applications/checkin/";
  static String clientCheckinApproved(int id) =>
      "/company/job/applications/checkin/$id/";
  static String pendingApprovalsOverview() =>
      "/company/pending/checkin-checkout/";
  static String clientCheckout() => "/company/job/applications/checkout/";
  static String clientCheckoutApproved(int id) =>
      "/company/job/applications/checkout/$id/";
  static String jobApplicationList() => "/company/job/applications/";
  static String jobApplicationApproved(int id) =>
      "/company/job/applications/$id/";

  static String givestaffreview(int id) => "/vacancy/$id/review/";
  static String staffLogout() => "/logout/";
}
