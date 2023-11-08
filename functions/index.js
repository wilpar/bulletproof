/**
 * Quick Function to delete profile when user deleted.
 *
 * You're gonna delete that test user a lot, I'll bet!
 */

const admin = require("firebase-admin");
const functions = require("firebase-functions");

admin.initializeApp();

//
// Delete associated Profile doc when a user is deleted
//

exports.onDelete = functions.auth.user().onDelete((user) => {
  const profileRef = admin.firestore().collection("profiles").doc(user.uid);
  profileRef.delete();
});

//
// Delete User.
//

exports.deleteUser = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
        "failed-precondition",
        "The function must be called while authenticated.");
  } else {
    const uid = context.auth.uid;
    functions.logger.debug("Delete User requested by " + uid);
  }

  const email = data.email;
  if (!(typeof email === "string") || email.length === 0) {
    throw new functions.https.HttpsError(
        "invalid-argument",
        "The function must be called with " +
        "one arguments \"email\" containing the user to delete.",
        data,
    );
  }

  try {
    const userRecord = await admin.auth().getUserByEmail(email);
    await admin.auth().deleteUser(userRecord.uid);
    return {user: data.email, result: true};
  } catch (e) {
    // cant find user
    return {user: data.email, result: false};
  }
});
