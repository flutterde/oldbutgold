"use client";

import React, { useRef, useState, useEffect } from 'react';
import { FaPlay, FaPause, FaVolumeUp, FaVolumeMute } from 'react-icons/fa';

const VideoPlayer = ({ videoUrl }) => {
    const videoRef = useRef(null);
    const [isPlaying, setIsPlaying] = useState(false);
    const [isMuted, setIsMuted] = useState(false);
    const [volume, setVolume] = useState(1);
    const [progress, setProgress] = useState(0);
    const [duration, setDuration] = useState(0);
    const [currentTime, setCurrentTime] = useState(0);
  
    useEffect(() => {
      const updateProgress = () => {
        const currentTime = videoRef.current.currentTime;
        const duration = videoRef.current.duration;
        const progressPercentage = (currentTime / duration) * 100;
        setProgress(progressPercentage);
        setCurrentTime(currentTime);
      };
  
      const updateVolume = () => {
        setVolume(videoRef.current.volume);
        setIsMuted(videoRef.current.muted);
      };
  
      const setVideoDuration = () => {
        setDuration(videoRef.current.duration);
      };
  
      const videoElement = videoRef.current;
  
      videoElement.addEventListener('timeupdate', updateProgress);
      videoElement.addEventListener('volumechange', updateVolume);
      videoElement.addEventListener('loadedmetadata', setVideoDuration);
  
      return () => {
        videoElement.removeEventListener('timeupdate', updateProgress);
        videoElement.removeEventListener('volumechange', updateVolume);
        videoElement.removeEventListener('loadedmetadata', setVideoDuration);
      };
    }, []);
  
    const togglePlayPause = () => {
      if (videoRef.current.paused) {
        videoRef.current.play();
      } else {
        videoRef.current.pause();
      }
      setIsPlaying(!isPlaying);
    };
  
    const toggleMute = () => {
      videoRef.current.muted = !isMuted;
      setIsMuted(!isMuted);
    };
  
    const handleVolumeChange = (e) => {
      const newVolume = parseFloat(e.target.value);
      videoRef.current.volume = newVolume;
      setVolume(newVolume);
      setIsMuted(newVolume === 0);
    };
  
    const handleProgressChange = (e) => {
      const newProgress = parseFloat(e.target.value);
      const newTime = (newProgress / 100) * duration;
      videoRef.current.currentTime = newTime;
      setProgress(newProgress);
    };
  
    const formatTime = (seconds) => {
      const minutes = Math.floor(seconds / 60);
      const remainingSeconds = Math.floor(seconds % 60);
      return `${String(minutes).padStart(2, '0')}:${String(remainingSeconds).padStart(2, '0')}`;
    };
  
    return (
      <div className="max-w-screen-lg mx-auto my-8">
        <div className="relative" style={{ paddingBottom: '56.25%' }}>
          <video
            ref={videoRef}
            className="absolute top-0 left-0 w-full h-full rounded-lg shadow-md"
          >
            <source src={videoUrl} type="video/mp4" />
            Your browser does not support the video tag.
          </video>
        </div>
        <div className="flex items-center justify-center mt-4">
          <button
            className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded mr-4"
            onClick={togglePlayPause}
          >
            {isPlaying ? <FaPause /> : <FaPlay />}
          </button>
          <button
            className="bg-gray-500 hover:bg-gray-700 text-white font-bold py-2 px-4 rounded mr-4"
            onClick={toggleMute}
          >
            {isMuted ? <FaVolumeMute /> : <FaVolumeUp />}
          </button>
          <input
            type="range"
            min="0"
            max="1"
            step="0.01"
            value={volume}
            onChange={handleVolumeChange}
            className="mr-4"
          />
          <input
            type="range"
            min="0"
            max="100"
            step="0.1"
            value={progress}
            onChange={handleProgressChange}
            className="mr-4"
          />
          <div className="text-gray-600">
            {formatTime(currentTime)} / {formatTime(duration)}
          </div>
        </div>
        <div className="mt-2">
          <div className="bg-gray-300 h-2 w-full rounded">
            <div
              className="bg-blue-500 h-full rounded"
              style={{ width: `${progress}%` }}
            />
          </div>
        </div>
      </div>
    );
  };
  
  export default VideoPlayer;
  