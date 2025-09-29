FROM nginx:stable

# Install openssl
RUN apt-get update && apt-get install -y openssl && rm -rf /var/lib/apt/lists/*

# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Create directory for certs
COPY ./ssl/certs.sh /usr/local/bin/certs.sh
RUN chmod +x /usr/local/bin/certs.sh

ENTRYPOINT ["/usr/local/bin/certs.sh"]

