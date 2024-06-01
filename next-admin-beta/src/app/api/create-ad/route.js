import { createAd } from "../../../../db/firebase";


export async function POST(request) {
    const query = await request.json();
    const title = query.title;
    const description = query.description;
    const url = query.url;
    const image = query.img_url;
    console.log({title, description, url, image});
    try {
        const isCreated = await createAd(title, description, url, image);
        return Response.json({ message: 'Seccess'}, {status: 200});
    } catch (error) {
        console.error("Error adding document: ", error);
        return Response.json({ message: 'Failed'}, {status: 500});
    }
}
