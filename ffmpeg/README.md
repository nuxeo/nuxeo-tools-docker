Docker image to build FFmpeg without messing up the system.  

Change "build-all.sh false" to "build-all.sh true" in package-all.sh to enable mp4 support.

Build image: docker build -t nuxeo/ffmpeg-deb-pkg .  
Run build: docker run -v $(pwd)/packages:/packages:rw nuxeo/ffmpeg-deb-pkg  

