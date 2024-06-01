import admin from "firebase-admin";

import serviceAccount from '../src/keys/firebase-admin.json';
if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: 'https://old-butgold-default-rtdb.europe-west1.firebasedatabase.app'
  });
}

export default admin ;
