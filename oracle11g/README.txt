Docker image with Oracle 11g.

Warning: data is NOT persisted when the container is stopped.

To build the image:
- Put the two files downloaded from Oracle in "install_files" (linux.x64_11gR2_database_1of2.zip and linux.x64_11gR2_database_2of2.zip)
- Run the build-image.sh script
This will create an image named nuxeo/oracle11g that exposes port 1521.

To run the image (adjust the parameters as fits your case):
docker run -d --privileged -p 0.0.0.0:1521:1521 -t -i nuxeo/oracle11g

