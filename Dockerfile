# Use an official Python runtime as a parent image
FROM python:3.12-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container at /app
COPY requirements.txt .

# Install any necessary dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the current directory contents into the container at /app
COPY . .

# Expose port 443 to the outside world
EXPOSE 443

# Define environment variables for the certificates
ENV NAMESPACES=""

# Start the FastAPI server with TLS support
CMD ["uvicorn", "awesome_mutator:app","--workers", "10", "--host", "0.0.0.0", "--port", "443", "--ssl-keyfile", "/etc/webhook/certs/webhook.key", "--ssl-certfile", "/etc/webhook/certs/webhook.crt"]