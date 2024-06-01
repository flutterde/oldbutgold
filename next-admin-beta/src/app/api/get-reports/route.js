import { getReports } from "../../../../db/firebase";

export async function GET(request) {
    try {
        const reports = await getReports();
        if (reports) {
            return Response.json({ message: 'Seccess', data: reports}, {status: 200});
        } else {
            return Response.json({ message: 'Failed to Get Reports'}, {status: 404});
        }
    } catch (error) {
        console.error("Error adding document: ", error);
        return Response.json({ message: 'Failed'}, {status: 500});
    }
}