import { deletePost } from "../../../../db/firebase";

export async function POST(request) {
    const query = await request.json();
    try {
        const userUid = query.user_id;
        const postId = query.post_id;
        const result = await deletePost(postId, userUid);
        if (result) {
            return Response.json({ message: 'Seccess'}, {status: 200});
        }
        return Response.json({ message: 'Failed'}, {status: 500});
    } catch (error) {
        console.error("Error adding document: ", error);
        return Response.json({ message: 'Failed'}, {status: 500});
    }
}
