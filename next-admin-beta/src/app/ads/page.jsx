"use client";
import NavBar from "@/components/NavBar";
import handleUploadFn from "../../../db/upload2s3";
import { useState } from 'react';
import axios from 'axios';

export default function AdsPage() {
  const [file, setFile] = useState(null);

  const handleFileChange = (event) => {
    const selectedFile = event.target.files[0];
    setFile(selectedFile);
  };

  const handleSubmit = async (event) => {
    event.preventDefault();

    const title = event.target.title.value;
    const description = event.target.description.value;
    const imageFile = event.target.image.files[0];
    const url = event.target.url.value;
    let s3Url;

    if (file) {
      console.log("E====================   ==================   ======================");
      console.log(file);
      console.log("E==================== .  ==================   ======================");

      // Add other form data if needed (e.g., title, description, url)
      const upload = await handleUploadFn(
        file.name,
        file,
        file.type,
      );
      if (upload.status === 200) {
        s3Url = upload.path;
        const data = {
          title: title,
          description: description,
          url: url,
          img_url: s3Url,
        };
      
        const config = {
          headers: {
            'Content-Type': 'application/json',
          },
        };
        const res = await axios.post('/api/create-ad', data, config);
        console.log({ res });
      } else {
        console.log("Error uploading image");
      }
    }
  };

  return (
    <div className="p-2">
      <NavBar />
      <div className="mt-3 pt-3 w-3/5 border-2 border-gray-500 rounded-lg p-4">
        <h1 className="text-2xl font-bold mb-4">Ads</h1>
        <form onSubmit={handleSubmit}>
          <div className="mb-4">
            <label htmlFor="title" className="block text-sm font-medium text-gray-600">
              Title
            </label>
            <input
              type="text"
              name="title"
              id="title"
              placeholder="Title..."
              className="mt-1 p-2 text-black border rounded-md w-full"
            />
          </div>
          <div className="mb-4">
            <label htmlFor="description" className="block text-sm font-medium text-gray-600">
              Description
            </label>
            <input
              type="text"
              name="description"
              id="description"
              placeholder="Description..."
              className="mt-1 p-2 text-black border rounded-md w-full"
            />
          </div>
          <div className="mb-4">
            <label htmlFor="image" className="block text-sm font-medium text-gray-600">
              Image size: 04:20
            </label>
            <input type="file" name="image" id="image" className="mt-1 p-2 border rounded-md" onChange={handleFileChange} />
          </div>
          <div className="mb-4">
            <label htmlFor="url" className="block text-sm font-medium text-gray-600">
              Url
            </label>
            <input
              type="text"
              name="url"
              id="url"
              placeholder="https://example.com"
              className="mt-1 p-2 text-black border rounded-md w-full"
            />
          </div>
          <div>
            <button
              type="submit"
              className="bg-blue-500 text-white px-4 py-2 rounded-md hover:bg-blue-600"
            >
              Submit
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
