#!/bin/bash

# Create compressed videos directory if it doesn't exist
mkdir -p compressed_videos

# Function to compress a video file
compress_video() {
    local input_file="$1"
    local output_file="compressed_videos/$(basename "$input_file")"
    
    echo "Compressing: $input_file"
    
    # Use different compression settings based on file size
    if [[ "$input_file" == *"website_teaser_video.mp4" ]]; then
        # For the largest video, use higher compression
        ffmpeg -i "$input_file" -c:v libx264 -crf 30 -c:a aac -b:a 128k -preset medium -y "$output_file"
    elif [[ "$input_file" == *"real_world"* ]] || [[ "$input_file" == *"plan_and_exec"* ]]; then
        # For large videos, use medium compression
        ffmpeg -i "$input_file" -c:v libx264 -crf 28 -c:a aac -b:a 128k -preset medium -y "$output_file"
    else
        # For smaller videos, use lighter compression
        ffmpeg -i "$input_file" -c:v libx264 -crf 26 -c:a aac -b:a 128k -preset medium -y "$output_file"
    fi
    
    # Get file sizes
    local original_size=$(du -h "$input_file" | cut -f1)
    local compressed_size=$(du -h "$output_file" | cut -f1)
    
    echo "  Original: $original_size -> Compressed: $compressed_size"
    echo ""
}

# Find all MP4 files and compress them
find assets -name "*.mp4" | while read -r file; do
    compress_video "$file"
done

echo "All videos compressed! Check the compressed_videos/ directory."
