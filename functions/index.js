const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

/**
 * Cloud Function: onReportCreated
 * Triggered when a citizen submits a new civic issue report in Firestore.
 * Automatically logs a submission audit entry and sends a notification to the ward desk.
 */
exports.onReportCreated = functions.firestore
  .document('civic_reports/{reportId}')
  .onCreate(async (snap, context) => {
    const reportData = snap.data();
    const reportId = context.params.reportId;

    console.log(`[CivicVoice] New report received: ${reportId} for category: ${reportData.category}`);

    // Update report with an initial server-side audit timestamp if needed
    const auditLog = {
      status: 'Submitted',
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
      remarks: `Report registered in Ward Grievance Center. Assigned Reference ID: ${reportId}`
    };

    return snap.ref.update({
      serverProcessedAt: admin.firestore.FieldValue.serverTimestamp(),
      lastAuditRemarks: auditLog.remarks
    });
  });

/**
 * Cloud Function: onStatusUpdated
 * Triggered when an administrator/officer updates the status of a report.
 * Dispatches an FCM push alert to the citizen.
 */
exports.onStatusUpdated = functions.firestore
  .document('civic_reports/{reportId}')
  .onUpdate(async (change, context) => {
    const beforeData = change.before.data();
    const afterData = change.after.data();

    if (beforeData.status !== afterData.status) {
      console.log(`[CivicVoice] Report ${context.params.reportId} changed from ${beforeData.status} to ${afterData.status}`);

      // Dispatch FCM Push Notification to the citizen
      const userDoc = await admin.firestore().collection('users').doc(afterData.userId).get();
      if (userDoc.exists && userDoc.data().fcmToken) {
        const payload = {
          notification: {
            title: `Civic Report Status: ${afterData.status}`,
            body: `Your report regarding "${afterData.title}" is now marked as ${afterData.status}.`
          }
        };
        await admin.messaging().sendToDevice(userDoc.data().fcmToken, payload);
      }
    }
    return null;
  });
