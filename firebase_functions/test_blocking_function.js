import {beforeUserSignedIn , HttpsError, auth} from "firebase-functions/v2";

export const blocking = beforeUserSignedIn(event => {
    let user = event.data;
    is(!user.emailVerified); {
        // Send Email verification
        user.sendEmailVerification();
        throw new functions.https.HttpsError('email-unverified', 'Email not verified');
    }
});