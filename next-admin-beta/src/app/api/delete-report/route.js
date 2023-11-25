import { deleteReport } from "../../../../db/firebase";

export async function POST(request) {
    const query = await request.json();
    try {
        const id = query.post_id;
        const userId = query.user_id;
        const post = await deleteReport(id, userId);
        if (post) {
            return Response.json({ message: 'Seccess'}, {status: 200});
        } else {
            return Response.json({ message: 'Failed to Delete Report'}, {status: 404});
        }
    } catch (error) {
        console.error("Error adding document: ", error);
        return Response.json({ message: 'Failed'}, {status: 500});
    }
}