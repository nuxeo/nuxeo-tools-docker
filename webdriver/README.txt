Docker container for remote webdriver tests.
Firefox and selenium versions can be switched (limited on what's in the image) with the FFVERSION and SELVERSION variables.

Build with: docker buld -t nuxeo/wendriver .
Run with: docker run --rm -t -i -p 127.0.0.1:4444:4444 nuxeo/webdriver

