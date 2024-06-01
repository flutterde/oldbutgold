import { handlerUsr } from "../../../../db/firebase";


export async function GET(request) {
    const users = await handlerUsr();
    return Response.json({ data: users, message: 'Seccess'}, {status: 200});
}