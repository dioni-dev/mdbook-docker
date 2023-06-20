# Build stage
# Use the official Rust image as a base
FROM rust:1.57 as builder

# Define the mdbook version as an argument
ARG MDBOOK_VERSION=0.4.28

# Set the working directory to /build
WORKDIR /build

# Download the tar file of the specified version of mdbook from GitHub
# Extract the tar file
# Change to the newly extracted mdBook directory
# Compile mdbook using the 'cargo build --release' command
RUN curl -LO https://github.com/rust-lang/mdBook/archive/refs/tags/v${MDBOOK_VERSION}.tar.gz \
    && tar xzf v${MDBOOK_VERSION}.tar.gz \
    && cd mdBook-${MDBOOK_VERSION} \
    && cargo build --release

# Final stage
# Start a new stage based on the Alpine image
FROM alpine:3.17.3

# Install libgcc to ensure system library compatibility
RUN apk add --no-cache libgcc

# Copy the compiled mdbook binary from the builder stage to /usr/local/bin/ in the new image
COPY --from=builder /build/mdBook-${MDBOOK_VERSION}/target/release/mdbook /usr/local/bin/

# Set the working directory to /book
WORKDIR /book

# Set the command that will be run when a container is started from this image
# In this case, mdbook will serve the book on port 3000 and it will be accessible from any IP address
CMD ["mdbook", "serve", "--hostname", "0.0.0.0", "--port", "3000"]

# Inform Docker that the container will listen on port 3000
EXPOSE 3000
