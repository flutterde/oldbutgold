import NavBar from "@/components/NavBar";
import VideoPlayer from "@/components/VideoPlayer";

export default function PostPage() {
    return (
        <div className="p-2">
            <NavBar />
            <div className="mt-3 pt-3 w-3/5 border-2 border-gray-500 rounded-lg p-4">
                <h1 className="text-2xl font-bold mb-4">Post</h1>
                <div>
                    <VideoPlayer videoUrl="https://pub-68120320998f4a388149a20790c5cff7.r2.dev/uploads/3CFNtuSMh6MDUDRltR9SVS6bTpU2/videos/2023/10/7/21/34-55/video.mp4" />
                </div>
            </div>
        </div>
    );
}
