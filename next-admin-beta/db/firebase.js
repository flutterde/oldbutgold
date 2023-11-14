import  admin  from './firebaseAdmin';
import { getFirestore } from "firebase-admin/firestore";

const db = getFirestore();


const getAds = async () => {
try{
    const snapshot = await db.collection('ads').get();
    const ads = [];
    snapshot.forEach((doc) => {
        ads.push({id: doc.id, ...doc.data()});
    });
    return ads;
} catch (error) {
    console.error("Error getting documents: ", error);
    console.error(error);
    console.error("===== ====== ===== ==== ===== ====");
    return false;
}
}


const handlerUsr = async () => {
    // Use Firebase Admin functionalities here
    const users = await admin.auth().listUsers();
    const data = users.users
    return (data);
  }

const createAd = async (title, description, url, image) => {
    try {
        const docRef = await db.collection('ads').add({
            title: title,
            description: description,
            url: url,
            image: image,
            is_active: true,
            created_at: Date.now(),
            end_at: Date.now() + 30 * 24 * 60 * 60 * 1000,
        });
        console.log("Document written with ID: ", docRef.id);
        return true;
    } catch (error) {
        console.error("Error adding document: ", error);
        return false;
    }
}

export { getAds, handlerUsr, createAd };