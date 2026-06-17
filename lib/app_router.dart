// 📁 lib/nav.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:thix_id/auth/auth_controller.dart';
import 'package:thix_id/models/app_user.dart';

// ==================== PAGES EXISTANTES ====================
import 'presentation/home/home_page.dart';
import 'presentation/auth/login_page.dart';
import 'presentation/auth/personal_registration_page.dart';
import 'presentation/auth/enterprise_registration_page.dart';
import 'presentation/payment/payment_gateway_page.dart';
import 'presentation/payment/activation_receipt_page.dart';
import 'presentation/profile/public_profile_page.dart';
import 'presentation/dashboard/user_dashboard_page.dart';
import 'presentation/enterprise/enterprise_dashboard_page.dart';
import 'presentation/chat/thix_chat_page.dart';
import 'presentation/vault/document_vault_page.dart';
import 'presentation/settings/settings_page.dart';

// ==================== RÉSEAU PRO ====================
import 'presentation/network/network_pro_home.dart';
import 'presentation/network/member_profile.dart';
import 'presentation/network/post_detail_page.dart';
import 'presentation/network/search_network_page.dart';
import 'presentation/network/community_detail_page.dart';
import 'presentation/network/settings_network_page.dart';
import 'presentation/network/blocked_users_page.dart';
import 'presentation/network/network_groups_list.dart';
import 'presentation/network/messages/conversations_list.dart';
import 'presentation/network/messages/chat_screen.dart';
import 'presentation/network/notifications/notifications_page.dart';

// ==================== AUTRES SERVICES ====================
import 'presentation/jobs/jobs_page.dart';
import 'presentation/jobs/job_apply_page.dart';
import 'presentation/jobs/job_details_page.dart';
import 'presentation/jobs/job_dashboard_page.dart';
import 'presentation/recruiter/recruiter_portal_page.dart';
import 'presentation/opportunities/opportunities_page.dart';
import 'presentation/opportunities/opportunity_apply_page.dart';
import 'presentation/opportunities/opportunity_details_page.dart';
import 'presentation/education/education_page.dart';
import 'presentation/training/training_home_page.dart';
import 'presentation/training/training_details_page.dart';
import 'presentation/training/learning_dashboard_page.dart';
import 'presentation/training/lesson_player_page.dart';
import 'presentation/admin/admin_page.dart';
import 'presentation/thix_market/thix_market_page.dart';
import 'presentation/thix_market/cart_page.dart';
import 'presentation/thix_market/checkout_page.dart';
import 'presentation/thix_market/order_history_page.dart';
import 'presentation/thix_reservation/thix_reservation_page.dart';
import 'presentation/thix_money/thix_money_page.dart';
import 'presentation/thix_media/thix_media_page.dart';

// ==================== THIX SANTÉ - PATIENT ====================
import 'presentation/thix_sante/patient/screens/patient_home_screen.dart';
import 'presentation/thix_sante/patient/screens/patient_tracking_screen.dart';
import 'presentation/thix_sante/patient/screens/patient_appointments_screen.dart';
import 'presentation/thix_sante/patient/screens/patient_messages_screen.dart';
import 'presentation/thix_sante/patient/screens/patient_profile_screen.dart';
import 'presentation/thix_sante/patient/screens/patient_family_screen.dart';
import 'presentation/thix_sante/patient/screens/patient_consents_screen.dart';
import 'presentation/thix_sante/patient/screens/patient_notifications_screen.dart';

// ==================== THIX SANTÉ - DOCTEUR ====================
import 'presentation/thix_sante/doctor/screens/doctor_dashboard_screen.dart';
import 'presentation/thix_sante/doctor/screens/doctor_patient_list_screen.dart';
import 'presentation/thix_sante/doctor/screens/doctor_patient_detail_screen.dart';
import 'presentation/thix_sante/doctor/screens/doctor_prescription_screen.dart';
import 'presentation/thix_sante/doctor/screens/doctor_teleconsultation_screen.dart';
import 'presentation/thix_sante/doctor/screens/doctor_teleexpertise_screen.dart';
import 'presentation/thix_sante/doctor/screens/doctor_schedule_screen.dart';
import 'presentation/thix_sante/doctor/screens/doctor_messages_screen.dart';
import 'presentation/thix_sante/doctor/screens/doctor_profile_screen.dart';
import 'presentation/thix_sante/doctor/screens/doctor_analytics_screen.dart';
import 'presentation/thix_sante/doctor/screens/doctor_notes_screen.dart';
import 'presentation/thix_sante/doctor/mobile/screens/doctor_mobile_screen.dart';

// ==================== THIX SANTÉ - PHARMACIE ====================
import 'presentation/thix_sante/pharmacy/screens/pharmacy_dashboard_screen.dart';
import 'presentation/thix_sante/pharmacy/screens/pharmacy_orders_screen.dart';
import 'presentation/thix_sante/pharmacy/screens/pharmacy_inventory_screen.dart';
import 'presentation/thix_sante/pharmacy/screens/pharmacy_delivery_screen.dart';
import 'presentation/thix_sante/pharmacy/screens/pharmacy_prescription_detail_screen.dart';
import 'presentation/thix_sante/pharmacy/screens/pharmacy_messages_screen.dart';
import 'presentation/thix_sante/pharmacy/screens/pharmacy_profile_screen.dart';
import 'presentation/thix_sante/pharmacy/screens/pharmacy_reports_screen.dart';

// ==================== THIX SANTÉ - AUTH ====================
import 'presentation/thix_sante/auth/screens/login_screen.dart';
import 'presentation/thix_sante/auth/screens/role_selection_screen.dart';
import 'presentation/thix_sante/onboarding/screens/onboarding_screen.dart';
import 'presentation/thix_sante/onboarding/screens/permissions_screen.dart';

// ==================== ADMIN HÔPITAL ====================
// Dashboard
import 'presentation/admin_hopital/dashboard/screens/dashboard_screen.dart';
// Patients
import 'presentation/admin_hopital/patients/screens/patient_list_screen.dart';
import 'presentation/admin_hopital/patients/screens/patient_admission_screen.dart';
import 'presentation/admin_hopital/patients/screens/patient_detail_screen.dart';
import 'presentation/admin_hopital/patients/screens/patient_edit_screen.dart';
// Appointments
import 'presentation/admin_hopital/appointments/screens/appointment_list_screen.dart';
import 'presentation/admin_hopital/appointments/screens/appointment_create_screen.dart';
import 'presentation/admin_hopital/appointments/screens/appointment_detail_screen.dart';
// Beds
import 'presentation/admin_hopital/beds/screens/bed_planning_screen.dart';
import 'presentation/admin_hopital/beds/screens/bed_detail_screen.dart';
// Staff
import 'presentation/admin_hopital/staff/screens/staff_list_screen.dart';
import 'presentation/admin_hopital/staff/screens/staff_detail_screen.dart';
import 'presentation/admin_hopital/staff/screens/staff_schedule_screen.dart';
// Medications
import 'presentation/admin_hopital/medications/screens/medication_inventory_screen.dart';
import 'presentation/admin_hopital/medications/screens/medication_dispensation_screen.dart';
// Exams
import 'presentation/admin_hopital/exams/screens/exam_prescription_screen.dart';
import 'presentation/admin_hopital/exams/screens/exam_result_entry_screen.dart';
import 'presentation/admin_hopital/exams/screens/exam_archive_screen.dart';
// Surgery
import 'presentation/admin_hopital/surgery/screens/surgery_schedule_screen.dart';
import 'presentation/admin_hopital/surgery/screens/surgery_preop_screen.dart';
import 'presentation/admin_hopital/surgery/screens/surgery_postop_screen.dart';
// Billing
import 'presentation/admin_hopital/billing/screens/billing_invoice_screen.dart';
import 'presentation/admin_hopital/billing/screens/billing_payment_screen.dart';
// Messaging
import 'presentation/admin_hopital/messaging/screens/message_inbox_screen.dart';
import 'presentation/admin_hopital/messaging/screens/message_compose_screen.dart';
// Reports
import 'presentation/admin_hopital/reports/screens/report_dashboard_screen.dart';
import 'presentation/admin_hopital/reports/screens/report_detail_screen.dart';
// Settings
import 'presentation/admin_hopital/settings/screens/settings_services_screen.dart';
import 'presentation/admin_hopital/settings/screens/settings_specialties_screen.dart';
import 'presentation/admin_hopital/settings/screens/settings_general_screen.dart';
// Advanced Clinics
import 'presentation/admin_hopital/advanced_clinics/screens/triage_screen.dart';
import 'presentation/admin_hopital/advanced_clinics/screens/infection_control_screen.dart';
import 'presentation/admin_hopital/advanced_clinics/screens/chemotherapy_screen.dart';
import 'presentation/admin_hopital/advanced_clinics/screens/dialysis_screen.dart';
import 'presentation/admin_hopital/advanced_clinics/screens/rehabilitation_screen.dart';
import 'presentation/admin_hopital/advanced_clinics/screens/transfusion_screen.dart';
import 'presentation/admin_hopital/advanced_clinics/screens/neonatology_screen.dart';
// Operations
import 'presentation/admin_hopital/operations/screens/equipment_maintenance_screen.dart';
import 'presentation/admin_hopital/operations/screens/sterilization_screen.dart';
import 'presentation/admin_hopital/operations/screens/linen_management_screen.dart';
import 'presentation/admin_hopital/operations/screens/diet_management_screen.dart';
import 'presentation/admin_hopital/operations/screens/transport_screen.dart';
import 'presentation/admin_hopital/operations/screens/waste_management_screen.dart';
// Analytics
import 'presentation/admin_hopital/analytics/screens/cdss_screen.dart';
import 'presentation/admin_hopital/analytics/screens/predictive_analytics_screen.dart';
import 'presentation/admin_hopital/analytics/screens/radiology_ai_screen.dart';
import 'presentation/admin_hopital/analytics/screens/bi_dashboard_screen.dart';
import 'presentation/admin_hopital/analytics/screens/fraud_detection_screen.dart';
import 'presentation/admin_hopital/analytics/screens/epidemic_risk_screen.dart';
// Security
import 'presentation/admin_hopital/security/screens/consent_management_screen.dart';
import 'presentation/admin_hopital/security/screens/audit_log_screen.dart';
import 'presentation/admin_hopital/security/screens/signature_screen.dart';
import 'presentation/admin_hopital/security/screens/security_settings_screen.dart';
import 'presentation/admin_hopital/security/screens/iam_management_screen.dart';
// Interoperability
import 'presentation/admin_hopital/interoperability/screens/hl7_integration_screen.dart';
import 'presentation/admin_hopital/interoperability/screens/sns_connection_screen.dart';
import 'presentation/admin_hopital/interoperability/screens/external_pharmacy_screen.dart';
import 'presentation/admin_hopital/interoperability/screens/import_export_screen.dart';
// Finance
import 'presentation/admin_hopital/advanced_finance/screens/pricing_screen.dart';
import 'presentation/admin_hopital/advanced_finance/screens/third_party_screen.dart';
import 'presentation/admin_hopital/advanced_finance/screens/billing_reminder_screen.dart';
import 'presentation/admin_hopital/advanced_finance/screens/budget_screen.dart';
import 'presentation/admin_hopital/advanced_finance/screens/tender_screen.dart';

// ==================== NAVIGATION WIDGETS ====================
import 'presentation/thix_sante/patient/navigation/patient_bottom_nav.dart';
import 'presentation/thix_sante/doctor/navigation/doctor_bottom_nav.dart';
import 'presentation/thix_sante/pharmacy/navigation/pharmacy_bottom_nav.dart';
import 'presentation/admin_hopital/navigation/admin_sidebar_nav.dart';

// ==================== PROVIDERS ====================
import 'presentation/shared/providers/role_provider.dart';

// ==================== HELPERS ====================
class NoTransitionPage<T> extends Page<T> {
  final Widget child;
  const NoTransitionPage({required this.child, super.key});

  @override
  Route<T> createRoute(BuildContext context) {
    return MaterialPageRoute(builder: (context) => child, settings: this);
  }
}

// ==================== ROUTE CONSTANTS ====================
class AppRoutes {
  // ==================== EXISTANTS ====================
  static const String home = '/';
  static const String login = '/login';
  static const String personalReg = '/personal-reg';
  static const String enterpriseReg = '/enterprise-reg';
  static const String userDashboard = '/user-dashboard';
  static const String enterpriseDashboard = '/enterprise-dashboard';
  static const String chat = '/chat';
  static const String vault = '/vault';
  static const String settings = '/settings';

  // ==================== RÉSEAU PRO ====================
  static const String networkPro = '/network-pro';
  static const String networkProfile = '/network/profile/:userId';
  static const String networkPost = '/network/post/:postId';
  static const String networkSearch = '/network/search';
  static const String networkCommunity = '/network/community/:communityId';
  static const String networkSettings = '/network/settings';
  static const String networkBlocked = '/network/blocked';
  static const String networkGroups = '/network/groups';
  static const String networkMessages = '/network/messages';
  static const String networkChat = '/network/chat/:userId';
  static const String networkNotifications = '/network/notifications';

  // ==================== THIX SANTÉ - AUTH & ONBOARDING ====================
  static const String santeLogin = '/sante/login';
  static const String santeRoleSelection = '/sante/role-selection';
  static const String santeOnboarding = '/sante/onboarding';
  static const String santePermissions = '/sante/permissions';

  // ==================== THIX SANTÉ - PATIENT ====================
  static const String patientHome = '/sante/patient';
  static const String patientTracking = '/sante/patient/tracking';
  static const String patientAppointments = '/sante/patient/appointments';
  static const String patientMessages = '/sante/patient/messages';
  static const String patientProfile = '/sante/patient/profile';
  static const String patientFamily = '/sante/patient/family';
  static const String patientConsents = '/sante/patient/consents';
  static const String patientNotifications = '/sante/patient/notifications';

  // ==================== THIX SANTÉ - DOCTEUR ====================
  static const String doctorHome = '/sante/doctor';
  static const String doctorMobile = '/sante/doctor/mobile';
  static const String doctorPatients = '/sante/doctor/patients';
  static const String doctorPatientDetail = '/sante/doctor/patient/:id';
  static const String doctorPrescription = '/sante/doctor/prescription';
  static const String doctorTeleconsultation = '/sante/doctor/teleconsultation';
  static const String doctorTeleexpertise = '/sante/doctor/teleexpertise';
  static const String doctorSchedule = '/sante/doctor/schedule';
  static const String doctorMessages = '/sante/doctor/messages';
  static const String doctorProfile = '/sante/doctor/profile';

  // ==================== THIX SANTÉ - PHARMACIE ====================
  static const String pharmacyHome = '/sante/pharmacy';
  static const String pharmacyOrders = '/sante/pharmacy/orders';
  static const String pharmacyInventory = '/sante/pharmacy/inventory';
  static const String pharmacyDelivery = '/sante/pharmacy/delivery';
  static const String pharmacyPrescriptionDetail = '/sante/pharmacy/prescription/:id';
  static const String pharmacyMessages = '/sante/pharmacy/messages';
  static const String pharmacyProfile = '/sante/pharmacy/profile';

  // ==================== ADMIN HÔPITAL ====================
  static const String adminDashboard = '/admin/hospital';
  static const String adminPatients = '/admin/hospital/patients';
  static const String adminPatientAdmission = '/admin/hospital/patients/admission';
  static const String adminPatientDetail = '/admin/hospital/patients/:id';
  static const String adminPatientEdit = '/admin/hospital/patients/:id/edit';
  static const String adminAppointments = '/admin/hospital/appointments';
  static const String adminAppointmentCreate = '/admin/hospital/appointments/create';
  static const String adminAppointmentDetail = '/admin/hospital/appointments/:id';
  static const String adminBeds = '/admin/hospital/beds';
  static const String adminBedDetail = '/admin/hospital/beds/:id';
  static const String adminStaff = '/admin/hospital/staff';
  static const String adminStaffDetail = '/admin/hospital/staff/:id';
  static const String adminStaffSchedule = '/admin/hospital/staff/schedule';
  static const String adminMedications = '/admin/hospital/medications';
  static const String adminDispensation = '/admin/hospital/medications/dispensation';
  static const String adminExams = '/admin/hospital/exams';
  static const String adminExamResult = '/admin/hospital/exams/result';
  static const String adminExamArchive = '/admin/hospital/exams/archive';
  static const String adminSurgery = '/admin/hospital/surgery';
  static const String adminSurgeryPreop = '/admin/hospital/surgery/preop/:id';
  static const String adminSurgeryPostop = '/admin/hospital/surgery/postop/:id';
  static const String adminBilling = '/admin/hospital/billing';
  static const String adminBillingPayment = '/admin/hospital/billing/payment';
  static const String adminMessages = '/admin/hospital/messages';
  static const String adminMessageCompose = '/admin/hospital/messages/compose';
  static const String adminReports = '/admin/hospital/reports';
  static const String adminReportDetail = '/admin/hospital/reports/:type';
  static const String adminSettingsServices = '/admin/hospital/settings/services';
  static const String adminSettingsSpecialties = '/admin/hospital/settings/specialties';
  static const String adminSettingsGeneral = '/admin/hospital/settings/general';
  static const String adminTriage = '/admin/hospital/clinics/triage';
  static const String adminInfection = '/admin/hospital/clinics/infection';
  static const String adminChemotherapy = '/admin/hospital/clinics/chemo';
  static const String adminDialysis = '/admin/hospital/clinics/dialysis';
  static const String adminRehabilitation = '/admin/hospital/clinics/rehab';
  static const String adminTransfusion = '/admin/hospital/clinics/transfusion';
  static const String adminNeonatology = '/admin/hospital/clinics/neonatology';
  static const String adminEquipment = '/admin/hospital/ops/equipment';
  static const String adminSterilization = '/admin/hospital/ops/sterilization';
  static const String adminLinen = '/admin/hospital/ops/linen';
  static const String adminDiet = '/admin/hospital/ops/diet';
  static const String adminTransport = '/admin/hospital/ops/transport';
  static const String adminWaste = '/admin/hospital/ops/waste';
  static const String adminCdss = '/admin/hospital/analytics/cdss';
  static const String adminPredictive = '/admin/hospital/analytics/predictive';
  static const String adminRadiologyAI = '/admin/hospital/analytics/radiology';
  static const String adminBIDashboard = '/admin/hospital/analytics/bi';
  static const String adminFraud = '/admin/hospital/analytics/fraud';
  static const String adminEpidemic = '/admin/hospital/analytics/epidemic';
  static const String adminConsents = '/admin/hospital/security/consents';
  static const String adminAudit = '/admin/hospital/security/audit';
  static const String adminSignature = '/admin/hospital/security/signature';
  static const String adminSecurity = '/admin/hospital/security/settings';
  static const String adminIAM = '/admin/hospital/security/iam';
  static const String adminHL7 = '/admin/hospital/interop/hl7';
  static const String adminSNS = '/admin/hospital/interop/sns';
  static const String adminPharmacyExternal = '/admin/hospital/interop/pharmacy';
  static const String adminImportExport = '/admin/hospital/interop/import-export';
  static const String adminPricing = '/admin/hospital/finance/pricing';
  static const String adminThirdParty = '/admin/hospital/finance/third-party';
  static const String adminReminders = '/admin/hospital/finance/reminders';
  static const String adminBudget = '/admin/hospital/finance/budget';
  static const String adminTender = '/admin/hospital/finance/tender';

  // ==================== AUTRES SERVICES ====================
  static const String jobs = '/jobs';
  static const String opportunities = '/opportunities';
  static const String education = '/education';
  static const String trainingHome = '/training';
  static const String admin = '/admin';
  static const String market = '/market';
  static const String marketCart = '/market/cart';
  static const String marketCheckout = '/market/checkout';
  static const String marketOrders = '/market/orders';
  static const String reservation = '/reservation';
  static const String thixMoney = '/thix-money';
  static const String thixMedia = '/thix-media';
}

// ==================== APP ROUTER ====================
class AppRouter {
  static GoRouter create(AuthController auth) {
    return GoRouter(
      initialLocation: AppRoutes.home,
      refreshListenable: auth,
      redirect: (context, state) {
        final isLoggedIn = auth.isAuthenticated;
        final location = state.matchedLocation;

        // Pages d'auth
        final isAuthPage = location == AppRoutes.login ||
            location == AppRoutes.personalReg ||
            location == AppRoutes.enterpriseReg ||
            location == AppRoutes.santeLogin;

        // Pages publiques
        final isPublic = location == AppRoutes.home ||
            location.startsWith('/sante') ||
            location == AppRoutes.jobs ||
            location == AppRoutes.opportunities ||
            location == AppRoutes.education ||
            location == AppRoutes.trainingHome;

        // Redirections
        if (!isLoggedIn && !isAuthPage && !isPublic) {
          return AppRoutes.login;
        }
        if (isLoggedIn && isAuthPage) {
          final user = auth.currentUser;
          if (user?.accountType == AccountType.enterprise) {
            return AppRoutes.enterpriseDashboard;
          }
          return AppRoutes.userDashboard;
        }
        return null;
      },
      routes: [
        // ==================== PAGE D'ACCUEIL ====================
        GoRoute(
          path: AppRoutes.home,
          pageBuilder: (context, state) => NoTransitionPage(child: HomePagePremium()),
        ),

        // ==================== AUTHENTIFICATION ====================
        GoRoute(
          path: AppRoutes.login,
          pageBuilder: (context, state) => NoTransitionPage(child: LoginPage()),
        ),
        GoRoute(
          path: AppRoutes.personalReg,
          pageBuilder: (context, state) => NoTransitionPage(child: PersonalRegistrationPage()),
        ),
        GoRoute(
          path: AppRoutes.enterpriseReg,
          pageBuilder: (context, state) => NoTransitionPage(child: EnterpriseRegistrationPage()),
        ),

        // ==================== TABLEAUX DE BORD ====================
        GoRoute(
          path: AppRoutes.userDashboard,
          pageBuilder: (context, state) => NoTransitionPage(child: UserDashboardPage()),
        ),
        GoRoute(
          path: AppRoutes.enterpriseDashboard,
          pageBuilder: (context, state) => NoTransitionPage(child: EnterpriseDashboardPage()),
        ),

        // ==================== SERVICES GÉNÉRAUX ====================
        GoRoute(
          path: AppRoutes.chat,
          pageBuilder: (context, state) => NoTransitionPage(child: ThixChatPage()),
        ),
        GoRoute(
          path: AppRoutes.vault,
          pageBuilder: (context, state) => NoTransitionPage(child: DocumentVaultPage()),
        ),
        GoRoute(
          path: AppRoutes.settings,
          pageBuilder: (context, state) => NoTransitionPage(child: SettingsPage()),
        ),

        // ==================== RÉSEAU PRO ====================
        GoRoute(
          path: AppRoutes.networkPro,
          name: 'network-pro',
          pageBuilder: (context, state) => NoTransitionPage(child: NetworkProHome()),
        ),
        GoRoute(
          path: AppRoutes.networkProfile,
          name: 'network-profile',
          pageBuilder: (context, state) {
            final userId = state.pathParameters['userId']!;
            return NoTransitionPage(child: MemberProfile(userId: userId));
          },
        ),
        GoRoute(
          path: AppRoutes.networkPost,
          name: 'network-post',
          pageBuilder: (context, state) {
            final postId = state.pathParameters['postId']!;
            return NoTransitionPage(child: PostDetailPage(postId: postId));
          },
        ),
        GoRoute(
          path: AppRoutes.networkSearch,
          name: 'network-search',
          pageBuilder: (context, state) => NoTransitionPage(child: SearchNetworkPage()),
        ),
        GoRoute(
          path: AppRoutes.networkCommunity,
          name: 'network-community',
          pageBuilder: (context, state) {
            final communityId = state.pathParameters['communityId']!;
            return NoTransitionPage(child: CommunityDetailPage(communityId: communityId));
          },
        ),
        GoRoute(
          path: AppRoutes.networkSettings,
          name: 'network-settings',
          pageBuilder: (context, state) => NoTransitionPage(child: SettingsNetworkPage()),
        ),
        GoRoute(
          path: AppRoutes.networkBlocked,
          name: 'network-blocked',
          pageBuilder: (context, state) => NoTransitionPage(child: BlockedUsersPage()),
        ),
        GoRoute(
          path: AppRoutes.networkGroups,
          name: 'network-groups',
          pageBuilder: (context, state) => NoTransitionPage(child: NetworkGroupsList()),
        ),
        GoRoute(
          path: AppRoutes.networkMessages,
          name: 'network-messages',
          pageBuilder: (context, state) => NoTransitionPage(child: ConversationsList()),
        ),
        GoRoute(
          path: AppRoutes.networkChat,
          name: 'network-chat',
          pageBuilder: (context, state) {
            final userId = state.pathParameters['userId']!;
            final userName = state.extra as String? ?? '';
            return NoTransitionPage(child: ChatScreen(userId: userId, userName: userName));
          },
        ),
        GoRoute(
          path: AppRoutes.networkNotifications,
          name: 'network-notifications',
          pageBuilder: (context, state) => NoTransitionPage(child: NotificationsPage()),
        ),

        // ==================== THIX SANTÉ - AUTH ====================
        GoRoute(
          path: AppRoutes.santeLogin,
          name: 'santeLogin',
          pageBuilder: (context, state) => NoTransitionPage(child: LoginScreen()),
        ),
        GoRoute(
          path: AppRoutes.santeRoleSelection,
          name: 'santeRoleSelection',
          pageBuilder: (context, state) => NoTransitionPage(child: RoleSelectionScreen()),
        ),
        GoRoute(
          path: AppRoutes.santeOnboarding,
          name: 'santeOnboarding',
          pageBuilder: (context, state) => NoTransitionPage(
            child: OnboardingScreen(
              onComplete: () => context.go(AppRoutes.santePermissions),
            ),
          ),
        ),
        GoRoute(
          path: AppRoutes.santePermissions,
          name: 'santePermissions',
          pageBuilder: (context, state) => NoTransitionPage(
            child: PermissionsScreen(onAllGranted: () {}),
          ),
        ),

        // ==================== THIX SANTÉ - PATIENT ====================
        StatefulShellRoute.indexedStack(
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.patientHome,
                  name: 'patientHome',
                  pageBuilder: (context, state) => NoTransitionPage(child: const PatientHomeScreen()),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.patientTracking,
                  name: 'patientTracking',
                  pageBuilder: (context, state) => NoTransitionPage(child: const PatientTrackingScreen()),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.patientAppointments,
                  name: 'patientAppointments',
                  pageBuilder: (context, state) => NoTransitionPage(child: const PatientAppointmentsScreen()),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.patientMessages,
                  name: 'patientMessages',
                  pageBuilder: (context, state) => NoTransitionPage(child: const PatientMessagesScreen()),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.patientProfile,
                  name: 'patientProfile',
                  pageBuilder: (context, state) => NoTransitionPage(child: const PatientProfileScreen()),
                ),
              ],
            ),
          ],
          builder: (context, state, navigationShell) {
            return PatientBottomNav(navigationShell: navigationShell);
          },
        ),

        // ==================== THIX SANTÉ - PATIENT SECONDAIRES ====================
        GoRoute(
          path: AppRoutes.patientFamily,
          name: 'patientFamily',
          pageBuilder: (context, state) => NoTransitionPage(child: const PatientFamilyScreen()),
        ),
        GoRoute(
          path: AppRoutes.patientConsents,
          name: 'patientConsents',
          pageBuilder: (context, state) => NoTransitionPage(child: const PatientConsentsScreen()),
        ),
        GoRoute(
          path: AppRoutes.patientNotifications,
          name: 'patientNotifications',
          pageBuilder: (context, state) => NoTransitionPage(child: const PatientNotificationsScreen()),
        ),

        // ==================== THIX SANTÉ - DOCTEUR ====================
        StatefulShellRoute.indexedStack(
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.doctorHome,
                  name: 'doctorHome',
                  pageBuilder: (context, state) => NoTransitionPage(child: const DoctorDashboardScreen()),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.doctorPatients,
                  name: 'doctorPatients',
                  pageBuilder: (context, state) => NoTransitionPage(child: const DoctorPatientListScreen()),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.doctorSchedule,
                  name: 'doctorSchedule',
                  pageBuilder: (context, state) => NoTransitionPage(child: const DoctorScheduleScreen()),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.doctorMessages,
                  name: 'doctorMessages',
                  pageBuilder: (context, state) => NoTransitionPage(child: const DoctorMessagesScreen()),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.doctorProfile,
                  name: 'doctorProfile',
                  pageBuilder: (context, state) => NoTransitionPage(child: const DoctorProfileScreen()),
                ),
              ],
            ),
          ],
          builder: (context, state, navigationShell) {
            return DoctorBottomNav(navigationShell: navigationShell);
          },
        ),

        // ==================== THIX SANTÉ - DOCTEUR SECONDAIRES ====================
        GoRoute(
          path: AppRoutes.doctorPatientDetail,
          name: 'doctorPatientDetail',
          pageBuilder: (context, state) {
            final id = state.pathParameters['id']!;
            return NoTransitionPage(child: DoctorPatientDetailScreen(patientId: id));
          },
        ),
        GoRoute(
          path: AppRoutes.doctorPrescription,
          name: 'doctorPrescription',
          pageBuilder: (context, state) => NoTransitionPage(child: const DoctorPrescriptionScreen()),
        ),
        GoRoute(
          path: AppRoutes.doctorTeleconsultation,
          name: 'doctorTeleconsultation',
          pageBuilder: (context, state) => NoTransitionPage(child: const DoctorTeleconsultationScreen()),
        ),
        GoRoute(
          path: AppRoutes.doctorTeleexpertise,
          name: 'doctorTeleexpertise',
          pageBuilder: (context, state) => NoTransitionPage(child: const DoctorTeleexpertiseScreen()),
        ),
        GoRoute(
          path: AppRoutes.doctorMobile,
          name: 'doctorMobile',
          pageBuilder: (context, state) => NoTransitionPage(child: const DoctorMobileScreen()),
        ),
        GoRoute(
          path: AppRoutes.doctorAnalytics,
          name: 'doctorAnalytics',
          pageBuilder: (context, state) => NoTransitionPage(child: const DoctorAnalyticsScreen()),
        ),
        GoRoute(
          path: AppRoutes.doctorNotes,
          name: 'doctorNotes',
          pageBuilder: (context, state) => NoTransitionPage(child: const DoctorNotesScreen()),
        ),

        // ==================== THIX SANTÉ - PHARMACIE ====================
        StatefulShellRoute.indexedStack(
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.pharmacyHome,
                  name: 'pharmacyHome',
                  pageBuilder: (context, state) => NoTransitionPage(child: const PharmacyDashboardScreen()),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.pharmacyOrders,
                  name: 'pharmacyOrders',
                  pageBuilder: (context, state) => NoTransitionPage(child: const PharmacyOrdersScreen()),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.pharmacyInventory,
                  name: 'pharmacyInventory',
                  pageBuilder: (context, state) => NoTransitionPage(child: const PharmacyInventoryScreen()),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.pharmacyMessages,
                  name: 'pharmacyMessages',
                  pageBuilder: (context, state) => NoTransitionPage(child: const PharmacyMessagesScreen()),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.pharmacyProfile,
                  name: 'pharmacyProfile',
                  pageBuilder: (context, state) => NoTransitionPage(child: const PharmacyProfileScreen()),
                ),
              ],
            ),
          ],
          builder: (context, state, navigationShell) {
            return PharmacyBottomNav(navigationShell: navigationShell);
          },
        ),

        // ==================== THIX SANTÉ - PHARMACIE SECONDAIRES ====================
        GoRoute(
          path: AppRoutes.pharmacyPrescriptionDetail,
          name: 'pharmacyPrescriptionDetail',
          pageBuilder: (context, state) {
            final id = state.pathParameters['id']!;
            return NoTransitionPage(child: PharmacyPrescriptionDetailScreen(prescriptionId: id));
          },
        ),
        GoRoute(
          path: AppRoutes.pharmacyDelivery,
          name: 'pharmacyDelivery',
          pageBuilder: (context, state) => NoTransitionPage(child: const PharmacyDeliveryScreen()),
        ),
        GoRoute(
          path: AppRoutes.pharmacyReports,
          name: 'pharmacyReports',
          pageBuilder: (context, state) => NoTransitionPage(child: const PharmacyReportsScreen()),
        ),

        // ==================== ADMIN HÔPITAL ====================
        StatefulShellRoute.indexedStack(
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.adminDashboard,
                  name: 'adminDashboard',
                  pageBuilder: (context, state) => NoTransitionPage(child: const DashboardScreen()),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.adminPatients,
                  name: 'adminPatients',
                  pageBuilder: (context, state) => NoTransitionPage(child: const PatientListScreen()),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.adminAppointments,
                  name: 'adminAppointments',
                  pageBuilder: (context, state) => NoTransitionPage(child: const AppointmentListScreen()),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.adminBeds,
                  name: 'adminBeds',
                  pageBuilder: (context, state) => NoTransitionPage(child: const BedPlanningScreen()),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.adminStaff,
                  name: 'adminStaff',
                  pageBuilder: (context, state) => NoTransitionPage(child: const StaffListScreen()),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.adminMedications,
                  name: 'adminMedications',
                  pageBuilder: (context, state) => NoTransitionPage(child: const MedicationInventoryScreen()),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.adminExams,
                  name: 'adminExams',
                  pageBuilder: (context, state) => NoTransitionPage(child: const ExamArchiveScreen()),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.adminSurgery,
                  name: 'adminSurgery',
                  pageBuilder: (context, state) => NoTransitionPage(child: const SurgeryScheduleScreen()),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.adminBilling,
                  name: 'adminBilling',
                  pageBuilder: (context, state) => NoTransitionPage(child: const BillingInvoiceScreen()),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.adminMessages,
                  name: 'adminMessages',
                  pageBuilder: (context, state) => NoTransitionPage(child: const MessageInboxScreen()),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.adminReports,
                  name: 'adminReports',
                  pageBuilder: (context, state) => NoTransitionPage(child: const ReportDashboardScreen()),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.adminSettingsServices,
                  name: 'adminSettingsServices',
                  pageBuilder: (context, state) => NoTransitionPage(child: const SettingsServicesScreen()),
                ),
              ],
            ),
          ],
          builder: (context, state, navigationShell) {
            return AdminSidebarNav(navigationShell: navigationShell);
          },
        ),

        // ==================== ADMIN HÔPITAL - SECONDAIRES ====================
        // Patients
        GoRoute(
          path: AppRoutes.adminPatientAdmission,
          name: 'adminPatientAdmission',
          pageBuilder: (context, state) => NoTransitionPage(child: const PatientAdmissionScreen()),
        ),
        GoRoute(
          path: AppRoutes.adminPatientDetail,
          name: 'adminPatientDetail',
          pageBuilder: (context, state) {
            final id = state.pathParameters['id']!;
            return NoTransitionPage(child: PatientDetailScreen(patientId: id));
          },
        ),
        GoRoute(
          path: AppRoutes.adminPatientEdit,
          name: 'adminPatientEdit',
          pageBuilder: (context, state) {
            final id = state.pathParameters['id']!;
            return NoTransitionPage(child: PatientEditScreen(patientId: id));
          },
        ),
        // Appointments
        GoRoute(
          path: AppRoutes.adminAppointmentCreate,
          name: 'adminAppointmentCreate',
          pageBuilder: (context, state) => NoTransitionPage(child: const AppointmentCreateScreen()),
        ),
        GoRoute(
          path: AppRoutes.adminAppointmentDetail,
          name: 'adminAppointmentDetail',
          pageBuilder: (context, state) {
            final id = state.pathParameters['id']!;
            return NoTransitionPage(child: AppointmentDetailScreen(appointmentId: id));
          },
        ),
        // Beds
        GoRoute(
          path: AppRoutes.adminBedDetail,
          name: 'adminBedDetail',
          pageBuilder: (context, state) {
            final id = state.pathParameters['id']!;
            return NoTransitionPage(child: BedDetailScreen(bedId: id));
          },
        ),
        // Staff
        GoRoute(
          path: AppRoutes.adminStaffDetail,
          name: 'adminStaffDetail',
          pageBuilder: (context, state) {
            final id = state.pathParameters['id']!;
            return NoTransitionPage(child: StaffDetailScreen(staffId: id));
          },
        ),
        GoRoute(
          path: AppRoutes.adminStaffSchedule,
          name: 'adminStaffSchedule',
          pageBuilder: (context, state) => NoTransitionPage(child: const StaffScheduleScreen()),
        ),
        // Medications
        GoRoute(
          path: AppRoutes.adminDispensation,
          name: 'adminDispensation',
          pageBuilder: (context, state) => NoTransitionPage(child: const MedicationDispensationScreen()),
        ),
        // Exams
        GoRoute(
          path: AppRoutes.adminExamResult,
          name: 'adminExamResult',
          pageBuilder: (context, state) => NoTransitionPage(child: const ExamResultEntryScreen()),
        ),
        GoRoute(
          path: AppRoutes.adminExamArchive,
          name: 'adminExamArchive',
          pageBuilder: (context, state) => NoTransitionPage(child: const ExamArchiveScreen()),
        ),
        // Surgery
        GoRoute(
          path: AppRoutes.adminSurgeryPreop,
          name: 'adminSurgeryPreop',
          pageBuilder: (context, state) {
            final id = state.pathParameters['id']!;
            return NoTransitionPage(child: SurgeryPreopScreen(operationId: id));
          },
        ),
        GoRoute(
          path: AppRoutes.adminSurgeryPostop,
          name: 'adminSurgeryPostop',
          pageBuilder: (context, state) {
            final id = state.pathParameters['id']!;
            return NoTransitionPage(child: SurgeryPostopScreen(operationId: id));
          },
        ),
        // Billing
        GoRoute(
          path: AppRoutes.adminBillingPayment,
          name: 'adminBillingPayment',
          pageBuilder: (context, state) => NoTransitionPage(child: const BillingPaymentScreen()),
        ),
        // Messages
        GoRoute(
          path: AppRoutes.adminMessageCompose,
          name: 'adminMessageCompose',
          pageBuilder: (context, state) => NoTransitionPage(child: const MessageComposeScreen()),
        ),
        // Reports
        GoRoute(
          path: AppRoutes.adminReportDetail,
          name: 'adminReportDetail',
          pageBuilder: (context, state) {
            final type = state.pathParameters['type']!;
            return NoTransitionPage(child: ReportDetailScreen(reportType: type));
          },
        ),
        // Settings
        GoRoute(
          path: AppRoutes.adminSettingsSpecialties,
          name: 'adminSettingsSpecialties',
          pageBuilder: (context, state) => NoTransitionPage(child: const SettingsSpecialtiesScreen()),
        ),
        GoRoute(
          path: AppRoutes.adminSettingsGeneral,
          name: 'adminSettingsGeneral',
          pageBuilder: (context, state) => NoTransitionPage(child: const SettingsGeneralScreen()),
        ),

        // ==================== ADMIN HÔPITAL - AVANCÉS ====================
        // Clinics
        GoRoute(
          path: AppRoutes.adminTriage,
          name: 'adminTriage',
          pageBuilder: (context, state) => NoTransitionPage(child: const TriageScreen()),
        ),
        GoRoute(
          path: AppRoutes.adminInfection,
          name: 'adminInfection',
          pageBuilder: (context, state) => NoTransitionPage(child: const InfectionControlScreen()),
        ),
        GoRoute(
          path: AppRoutes.adminChemotherapy,
          name: 'adminChemotherapy',
          pageBuilder: (context, state) => NoTransitionPage(child: const ChemotherapyScreen()),
        ),
        GoRoute(
          path: AppRoutes.adminDialysis,
          name: 'adminDialysis',
          pageBuilder: (context, state) => NoTransitionPage(child: const DialysisScreen()),
        ),
        GoRoute(
          path: AppRoutes.adminRehabilitation,
          name: 'adminRehabilitation',
          pageBuilder: (context, state) => NoTransitionPage(child: const RehabilitationScreen()),
        ),
        GoRoute(
          path: AppRoutes.adminTransfusion,
          name: 'adminTransfusion',
          pageBuilder: (context, state) => NoTransitionPage(child: const TransfusionScreen()),
        ),
        GoRoute(
          path: AppRoutes.adminNeonatology,
          name: 'adminNeonatology',
          pageBuilder: (context, state) => NoTransitionPage(child: const NeonatologyScreen()),
        ),
        // Operations
        GoRoute(
          path: AppRoutes.adminEquipment,
          name: 'adminEquipment',
          pageBuilder: (context, state) => NoTransitionPage(child: const EquipmentMaintenanceScreen()),
        ),
        GoRoute(
          path: AppRoutes.adminSterilization,
          name: 'adminSterilization',
          pageBuilder: (context, state) => NoTransitionPage(child: const SterilizationScreen()),
        ),
        GoRoute(
          path: AppRoutes.adminLinen,
          name: 'adminLinen',
          pageBuilder: (context, state) => NoTransitionPage(child: const LinenManagementScreen()),
        ),
        GoRoute(
          path: AppRoutes.adminDiet,
          name: 'adminDiet',
          pageBuilder: (context, state) => NoTransitionPage(child: const DietManagementScreen()),
        ),
        GoRoute(
          path: AppRoutes.adminTransport,
          name: 'adminTransport',
          pageBuilder: (context, state) => NoTransitionPage(child: const TransportScreen()),
        ),
        GoRoute(
          path: AppRoutes.adminWaste,
          name: 'adminWaste',
          pageBuilder: (context, state) => NoTransitionPage(child: const WasteManagementScreen()),
        ),
        // Analytics
        GoRoute(
          path: AppRoutes.adminCdss,
          name: 'adminCdss',
          pageBuilder: (context, state) => NoTransitionPage(child: const CdssScreen()),
        ),
        GoRoute(
          path: AppRoutes.adminPredictive,
          name: 'adminPredictive',
          pageBuilder: (context, state) => NoTransitionPage(child: const PredictiveAnalyticsScreen()),
        ),
        GoRoute(
          path: AppRoutes.adminRadiologyAI,
          name: 'adminRadiologyAI',
          pageBuilder: (context, state) => NoTransitionPage(child: const RadiologyAIScreen()),
        ),
        GoRoute(
          path: AppRoutes.adminBIDashboard,
          name: 'adminBIDashboard',
          pageBuilder: (context, state) => NoTransitionPage(child: const BIDashboardScreen()),
        ),
        GoRoute(
          path: AppRoutes.adminFraud,
          name: 'adminFraud',
          pageBuilder: (context, state) => NoTransitionPage(child: const FraudDetectionScreen()),
        ),
        GoRoute(
          path: AppRoutes.adminEpidemic,
          name: 'adminEpidemic',
          pageBuilder: (context, state) => NoTransitionPage(child: const EpidemicRiskScreen()),
        ),
        // Security
        GoRoute(
          path: AppRoutes.adminConsents,
          name: 'adminConsents',
          pageBuilder: (context, state) => NoTransitionPage(child: const ConsentManagementScreen()),
        ),
        GoRoute(
          path: AppRoutes.adminAudit,
          name: 'adminAudit',
          pageBuilder: (context, state) => NoTransitionPage(child: const AuditLogScreen()),
        ),
        GoRoute(
          path: AppRoutes.adminSignature,
          name: 'adminSignature',
          pageBuilder: (context, state) => NoTransitionPage(child: const SignatureScreen()),
        ),
        GoRoute(
          path: AppRoutes.adminSecurity,
          name: 'adminSecurity',
          pageBuilder: (context, state) => NoTransitionPage(child: const SecuritySettingsScreen()),
        ),
        GoRoute(
          path: AppRoutes.adminIAM,
          name: 'adminIAM',
          pageBuilder: (context, state) => NoTransitionPage(child: const IamManagementScreen()),
        ),
        // Interop
        GoRoute(
          path: AppRoutes.adminHL7,
          name: 'adminHL7',
          pageBuilder: (context, state) => NoTransitionPage(child: const Hl7IntegrationScreen()),
        ),
        GoRoute(
          path: AppRoutes.adminSNS,
          name: 'adminSNS',
          pageBuilder: (context, state) => NoTransitionPage(child: const SnsConnectionScreen()),
        ),
        GoRoute(
          path: AppRoutes.adminPharmacyExternal,
          name: 'adminPharmacyExternal',
          pageBuilder: (context, state) => NoTransitionPage(child: const ExternalPharmacyScreen()),
        ),
        GoRoute(
          path: AppRoutes.adminImportExport,
          name: 'adminImportExport',
          pageBuilder: (context, state) => NoTransitionPage(child: const ImportExportScreen()),
        ),
        // Finance
        GoRoute(
          path: AppRoutes.adminPricing,
          name: 'adminPricing',
          pageBuilder: (context, state) => NoTransitionPage(child: const PricingScreen()),
        ),
        GoRoute(
          path: AppRoutes.adminThirdParty,
          name: 'adminThirdParty',
          pageBuilder: (context, state) => NoTransitionPage(child: const ThirdPartyScreen()),
        ),
        GoRoute(
          path: AppRoutes.adminReminders,
          name: 'adminReminders',
          pageBuilder: (context, state) => NoTransitionPage(child: const BillingReminderScreen()),
        ),
        GoRoute(
          path: AppRoutes.adminBudget,
          name: 'adminBudget',
          pageBuilder: (context, state) => NoTransitionPage(child: const BudgetScreen()),
        ),
        GoRoute(
          path: AppRoutes.adminTender,
          name: 'adminTender',
          pageBuilder: (context, state) => NoTransitionPage(child: const TenderScreen()),
        ),

        // ==================== JOB ROUTES ====================
        GoRoute(
          path: AppRoutes.jobs,
          pageBuilder: (context, state) => NoTransitionPage(child: JobsPage()),
        ),
        GoRoute(
          path: '/jobs/:jobId',
          pageBuilder: (context, state) {
            final jobId = state.pathParameters['jobId'] ?? '';
            final applied = (state.uri.queryParameters['applied'] ?? '').trim() == '1';
            return NoTransitionPage(child: JobDetailsPage(jobId: jobId, applied: applied));
          },
        ),
        GoRoute(
          path: '/jobs/:jobId/apply',
          pageBuilder: (context, state) {
            final jobId = state.pathParameters['jobId'] ?? '';
            return NoTransitionPage(child: JobApplyPage(jobId: jobId));
          },
        ),
        GoRoute(
          path: '/job-dashboard',
          pageBuilder: (context, state) => NoTransitionPage(child: JobDashboardPage()),
        ),
        GoRoute(
          path: '/recruiter',
          pageBuilder: (context, state) => NoTransitionPage(child: RecruiterPortalPage()),
        ),

        // ==================== OPPORTUNITIES ROUTES ====================
        GoRoute(
          path: AppRoutes.opportunities,
          pageBuilder: (context, state) => NoTransitionPage(child: OpportunitiesPage()),
        ),
        GoRoute(
          path: '/opportunities/:opportunityId',
          pageBuilder: (context, state) {
            final opportunityId = state.pathParameters['opportunityId'] ?? '';
            final applied = (state.uri.queryParameters['applied'] ?? '').trim() == '1';
            return NoTransitionPage(child: OpportunityDetailsPage(opportunityId: opportunityId, applied: applied));
          },
        ),
        GoRoute(
          path: '/opportunities/:opportunityId/apply',
          pageBuilder: (context, state) {
            final opportunityId = state.pathParameters['opportunityId'] ?? '';
            return NoTransitionPage(child: OpportunityApplyPage(opportunityId: opportunityId));
          },
        ),

        // ==================== TRAINING ROUTES ====================
        GoRoute(
          path: AppRoutes.trainingHome,
          pageBuilder: (context, state) => NoTransitionPage(child: TrainingHomePage()),
        ),
        GoRoute(
          path: '/training/:trainingId',
          pageBuilder: (context, state) {
            final trainingId = state.pathParameters['trainingId'] ?? '';
            return NoTransitionPage(child: TrainingDetailsPage(trainingId: trainingId));
          },
        ),
        GoRoute(
          path: '/learning-dashboard',
          pageBuilder: (context, state) => NoTransitionPage(child: LearningDashboardPage()),
        ),
        GoRoute(
          path: '/lesson/:enrollmentId',
          pageBuilder: (context, state) {
            final enrollmentId = state.pathParameters['enrollmentId'] ?? '';
            return NoTransitionPage(child: LessonPlayerPage(enrollmentId: enrollmentId));
          },
        ),

        // ==================== EDUCATION ROUTE ====================
        GoRoute(
          path: AppRoutes.education,
          pageBuilder: (context, state) => NoTransitionPage(child: EducationPage()),
        ),

        // ==================== THIX MARKET ROUTES ====================
        GoRoute(
          path: AppRoutes.market,
          name: 'market',
          pageBuilder: (context, state) => NoTransitionPage(child: ThixMarketPage()),
        ),
        GoRoute(
          path: AppRoutes.marketCart,
          name: 'marketCart',
          pageBuilder: (context, state) => NoTransitionPage(child: CartPage()),
        ),
        GoRoute(
          path: AppRoutes.marketCheckout,
          name: 'marketCheckout',
          pageBuilder: (context, state) => NoTransitionPage(child: CheckoutPage()),
        ),
        GoRoute(
          path: AppRoutes.marketOrders,
          name: 'marketOrders',
          pageBuilder: (context, state) => NoTransitionPage(child: OrderHistoryPage()),
        ),

        // ==================== THIX SERVICES ROUTES ====================
        GoRoute(
          path: AppRoutes.reservation,
          pageBuilder: (context, state) => NoTransitionPage(child: ThixReservationPage()),
        ),
        GoRoute(
          path: AppRoutes.thixMoney,
          pageBuilder: (context, state) => NoTransitionPage(child: ThixMoneyPage()),
        ),
        GoRoute(
          path: AppRoutes.thixMedia,
          pageBuilder: (context, state) => NoTransitionPage(child: ThixMediaPage()),
        ),

        // ==================== ADMIN ROUTES ====================
        GoRoute(
          path: AppRoutes.admin,
          name: 'adminRoot',
          redirect: (_, __) => '/admin/overview',
        ),
        GoRoute(
          path: '/admin/:module',
          name: 'admin',
          pageBuilder: (context, state) {
            final moduleName = state.pathParameters['module'] ?? 'overview';
            final module = _stringToModule(moduleName);
            return NoTransitionPage(
              child: AdminPage(module: module),
            );
          },
        ),
      ],
    );
  }

  // Helper pour convertir string en AdminModule
  static AdminModule _stringToModule(String name) {
    final slug = name.toLowerCase().trim();
    switch (slug) {
      case 'overview':
        return AdminModule.overview;
      case 'account-access-requests':
      case 'access-requests':
      case 'accessrequests':
        return AdminModule.accessRequests;
      case 'user-management':
      case 'users':
        return AdminModule.users;
      case 'verification-center':
      case 'verification':
        return AdminModule.verification;
      case 'trainings':
        return AdminModule.trainings;
      case 'thix-uid':
      case 'uid':
        return AdminModule.uid;
      case 'jobs-opportunities':
      case 'jobs':
        return AdminModule.jobs;
      case 'info-news':
      case 'news':
        return AdminModule.news;
      case 'thix-chat-admin':
      case 'chat':
        return AdminModule.chat;
      case 'sos-emergency':
      case 'sos':
        return AdminModule.sos;
      case 'institutions':
        return AdminModule.institutions;
      case 'analytics':
        return AdminModule.analytics;
      case 'cybersecurity':
        return AdminModule.cybersecurity;
      case 'api-integrations':
      case 'api':
        return AdminModule.api;
      case 'audit-activity':
      case 'audit':
        return AdminModule.audit;
      case 'thix-media':
      case 'media':
        return AdminModule.media;
      case 'settings':
        return AdminModule.settings;
      default:
        debugPrint('⚠️ Module inconnu: $slug → fallback sur overview');
        return AdminModule.overview;
    }
  }
}
