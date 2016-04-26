Docker image to build libsass.

Note that this is not useful on latest Ubuntu releases as the package is available in the repositories.


Build image: docker build -t nuxeo/libsass-deb-pkg .
Run build: docker run --rm -v $(pwd)/packages:/packages:rw nuxeo/libsass-deb-pkg

The resulting .deb package will be in the "packages" directory after the build.

