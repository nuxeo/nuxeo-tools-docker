Docker image to build FFmpeg without messing up the system.  

Build image: docker build -t nuxeo/ffmpeg-deb-pkg .  
Run build: docker run -v $(pwd)/packages:/packages:rw nuxeo/ffmpeg-deb-pkg  

