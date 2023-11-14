import  admin  from './firebaseAdmin';
import { getFirestore } from "firebase-admin/firestore";

const db = getFirestore();


class Post {
    constructor(id, description, videoUrl, created_at, user, tags) {
        this.id = id;
        this.description = description;
        this.videoUrl = videoUrl;
        this.created_at = created_at;
        this.user = user;
        this.created_at = created_at;
        this.tags = tags;
    }
}

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

const getPost = async (id) => {
    try {
        const docRef = await db.collection('posts').doc(id).get();
        if (!docRef.exists) {
            console.log('No such document!');
            return {
                is_found: false,
            };
        } else {
            const postData = docRef.data();
            // Fetch the user's name
            const userName = await getUserName(postData.user);

            // Create and return a new Post instance
            return {
                is_found: true,
                data: new Post(
                    id, 
                    postData.videoDescription, 
                    postData.videoUrl, 
                    postData.createdAt, 
                    userName, // Pass the userName here
                    postData.tags
                )
            };
        }
    } catch (error) {
        console.error("Error fetching document: ", error);
        return {
            is_found: false,
        };
    }
}


// get user name from user reference
const getUserName = async (userRef) => {
    try {
        const userDoc = await userRef.get();
        if (!userDoc.exists) {
            console.log('User not found');
            return '';
        } else {
            const userData = userDoc.data();
            return userData.name; // Assuming the field for name is 'name'
        }
    } catch (error) {
        console.error("Error fetching user: ", error);
        return '';
    }
}

export { getAds, handlerUsr, createAd, getPost };