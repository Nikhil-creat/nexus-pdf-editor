# Optional: containerized local hosting/preview.
# GitHub Pages needs none of this — it's here only if you want to run
# or demo the editor locally/on your own server via Docker instead.
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
# docker build -t nexus-pdf-editor .
# docker run -p 8080:80 nexus-pdf-editor   -> http://localhost:8080
