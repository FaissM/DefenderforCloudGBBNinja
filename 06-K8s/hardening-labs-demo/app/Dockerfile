# Trivial build on top of nginx so the image is our own CI/CD artifact (required for
# Defender for Cloud code-to-runtime mapping), not a bare image pulled straight from
# Docker Hub.
FROM nginx:latest
COPY index.html /usr/share/nginx/html/index.html
