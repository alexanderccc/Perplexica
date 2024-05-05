commit_hash=$(git log -n 1 --format=%H | head -c 6)
echo $commit_hash

registry="harbor.cicd.home/perplexica"

# searxng
podman build -t $registry/searxng:$commit_hash -f searxng.dockerfile .
podman push $registry/searxng:$commit_hash

# perplexica-backend
podman build -t $registry/backend:$commit_hash --build-arg SEARXNG_API_URL=http://searxng:8080 -f backend.dockerfile .
podman push $registry/backend:$commit_hash

# frontend
podman build -t $registry/frontend:$commit_hash \
     -f app.dockerfile .
podman push $registry/frontend:$commit_hash