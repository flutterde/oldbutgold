import { getPost } from "../../../../db/firebase";

export async function POST(request) {
    const query = await request.json();
    try {
        const id = query.post_id;
        const post = await getPost(id);
        if (post.is_found) {
            return Response.json({ message: 'Seccess', data: post.data}, {status: 200});
        } else {
            return Response.json({ message: 'Failed to Get Post'}, {status: 404});
        }
    } catch (error) {
        console.error("Error adding document: ", error);
        return Response.json({ message: 'Failed'}, {status: 500});
    }
}
