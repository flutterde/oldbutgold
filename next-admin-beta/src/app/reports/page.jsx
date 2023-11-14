import NavBar from "@/components/NavBar";

export default function ReportsPage() {
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
    // Add more sample posts as needed
  ];

  return (
    <div className="p-2">
      <NavBar />
      <div className="mt-3 pt-3 w-3/5 border-2 border-gray-500 rounded-lg p-4">
        <h1 className="text-2xl font-bold mb-4">Reports</h1>
        <div>
          <table className="w-full border-collapse border border-gray-800">
            <thead>
              <tr>
                <th className="p-2 border border-gray-800">Title</th>
                <th className="p-2 border border-gray-800">User</th>
                <th className="p-2 border border-gray-800">Action</th>
              </tr>
            </thead>
            <tbody>
              {posts.map((post) => (
                <tr key={post.id}>
                  <td className="p-2 border border-gray-800">{post.title}</td>
                  <td className="p-2 border border-gray-800">{post.user}</td>
                  <td className="p-2 border border-gray-800">
                    <a
                      href={`/post/${post.id}`}
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
