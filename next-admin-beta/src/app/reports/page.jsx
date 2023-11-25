"use client"
import NavBar from "@/components/NavBar";
import axios from "axios";
import { useEffect, useState } from "react";
import { ClipLoader } from 'react-spinners';


export default function ReportsPage() {
  const [isLoadingData, setIsLoadingData] = useState(true);
  const [reports, setReports] = useState([]);



  const posts = [
    {
      id: "F3KJTQymAMpfOSGYw7erTNEeHV8Zvb",
      title: "Sample Report 1",
      user: "John Doe",
    },
    {
      id: "Ppht1OPsSqzfEi6vnzPgG0AyS36vo4",
      title: "Sample Report 2",
      user: "Jane Smith",
    },
  ];

  useEffect(() => {
    (async () => {

        console.log("==============>  <================");
        const data = {};
        const config = {
            headers: {
                'Content-Type': 'application/json',
            },
        };
        const response = await axios.get('/api/get-reports', data, config);
        if (response.status !== 200) {
            console.log(".......................error.......................");
            setIsLoadingData(false);
            return;
        } else {
            console.log(".......................success.......................");
            console.log(response.data.data);
            setReports(response.data.data);
            setIsLoadingData(false);
            return;
        }
    })();
}, []);

  return (
    <div className="p-2">
      <NavBar />
      <div className="mt-3 pt-3 w-3/5 border-2 border-gray-500 rounded-lg p-4">
        <h1 className="text-2xl font-bold mb-4">Reports</h1>
        <div>
          <table className="w-full border-collapse border border-gray-800">
            <thead>
              <tr>
                <th className="p-2 border border-gray-800">User id</th>
                <th className="p-2 border border-gray-800">Status</th>
                <th className="p-2 border border-gray-800">Action</th>
              </tr>
            </thead>
            <tbody>
              {isLoadingData ? <ClipLoader color="#fffff" size={60} /> : 
              reports.map((post) => (
                <tr key={post.id}>
                  <td className="p-2 border border-gray-800">{post.id}</td>
                  <td className="p-2 border border-gray-800">{post.status}</td>
                  <td className="p-2 border border-gray-800">
                    <a
                      href={`/post/${post.postId}?user=${post.id}`}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="text-blue-500"
                    >
                      Open in new tab
                    </a>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
