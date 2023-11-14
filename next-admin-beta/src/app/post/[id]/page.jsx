"use client";
import NavBar from "@/components/NavBar";
import VideoPlayer from "@/components/VideoPlayer";
import { RiDeleteBinLine } from "react-icons/ri";
import { AiTwotoneSafetyCertificate } from "react-icons/ai";
import { useState, useEffect } from "react";
import axios from "axios";
import { ClipLoader } from 'react-spinners';

export default function PostPage({ params }) {
    const [isLoadingData, setIsLoadingData] = useState(true);
    var [post, setPost] = useState({});
    const postId = params.id;
    useEffect(() => {
        (async () => {
            // Your async code here
            console.log("==============>  <================");
            const data = {
                post_id: postId,
            };
            const config = {
                headers: {
                    'Content-Type': 'application/json',
                },
            };
            const response = await axios.post('/api/get-post', data, config);
            if (response.status !== 200) {
                console.log(".......................error.......................");

                setIsLoadingData(false);
                return;
            } else {
                console.log(".......................success.......................");
                console.log(response.data.data);
                setPost(response.data.data);
                setIsLoadingData(false);
                return;
            }
        })();
    }, []);

    function handleTime(milliseconds) {
        const date = new Date(milliseconds);
        const formattedDate = date.toLocaleDateString() + ' ' + date.toLocaleTimeString();
        return (formattedDate);
    }

    async function deletePost() {
        console.log("delete post");
    }

    async function markAsSafe() {
        console.log("mark as safe");
    }
    return (
        <div className="p-2">
            <NavBar />
            <div className="mt-3 pt-3 border-2 border-gray-500 rounded-lg p-4">
                <h1 className="text-2xl font-bold mb-4">Post</h1>
                <div className="flex flex-row">
                    <div className="w-1/2">
                        {isLoadingData ? <ClipLoader color="#fffff" size={60} /> : <VideoPlayer videoUrl={`${process.env.NEXT_PUBLIC_CDN_ENDPOINT}/${post.videoUrl}`} />}
                    </div>
                    <div className="w-1/2 ml-4">
                        {isLoadingData ? <ClipLoader color="#fffff" size={60} /> :
                            <div>
                                <h2 className="text-gray-500 text-4xl">{post.user}</h2>
                                <p>{post.description}</p>
                                <p className="text-sm text-slate-300">create: {handleTime(post.created_at._seconds * 1000 + post.created_at._nanoseconds / 1000000)}</p>
                                <div className="flex flex-row mt-4">
                                    {post.tags.map((tag) => (
                                        <div key={tag} className="rounded-md p-2 mr-2">
                                            <p>#{tag}</p>
                                        </div>
                                    ))}
                                </div>
                                <p className="text-xs text-red-200 mt-4">Actions:</p>
                                <div className="flex space-x-6 mt-3">

                                    <div>
                                        <button
                                            className="flex text-red-500 hover:text-red-700 border-2 border-red-700 p-2 rounded-md  hover:bg-slate-300"
                                            onClick={deletePost}
                                        >
                                            Delete
                                            <RiDeleteBinLine className="ml-2" />
                                        </button>
                                    </div>
                                    <div >
                                        <button
                                            className="flex text-green-500 hover:text-green-700 border-2 border-green-700 p-2 rounded-md  hover:bg-slate-300"
                                            onClick={markAsSafe}
                                        >
                                            Mark as Safe
                                            <AiTwotoneSafetyCertificate className="ml-2" />
                                        </button>
                                    </div>
                                </div>
                            </div>
                        }
                    </div>
                </div>
            </div>
        </div>
    );
}

