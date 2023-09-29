/**
 * Triggered by a change to a Firestore document.
 *
 * @param {!Object} event Event payload.
 * @param {!Object} context Metadata for the event.
 */


const admin = require('firebase-admin');
admin.initializeApp();

exports.deletePostComments = async(event, context) => {
  const postId = context.params.uid;

  const db = admin.firestore();
  try {
    const collectionRef = db.collection(`/posts/${postId}/comments`);
    const querySnapshot = await collectionRef.get();
    const batch = db.batch();
    querySnapshot.forEach((doc) => {
      const docRef = collectionRef.doc(doc.id);
      batch.delete(docRef);
    });
    await batch.commit();
    console.log('All comments deleted successfully.');
    return null;
  } catch (error) {
    console.error('Error deleting comments:', error);
    throw new Error('Error deleting comments.');
  }
};
