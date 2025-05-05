# Use a multi-stage build to reduce image size
FROM python:3.13-alpine AS builder

# Install dependencies required to build Python packages
RUN apk add --no-cache --virtual .build-deps \
    gcc musl-dev libffi-dev openssl-dev cargo

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 
ENV PYTHONUNBUFFERED=1

# Set work directory
WORKDIR /project

# Install Python dependencies
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

# Production image
FROM python:3.13-alpine

# Install runtime dependencies only
RUN apk add --no-cache libffi openssl

ENV PATH="/root/.local/bin:$PATH" \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /project

# Copy installed Python packages from the builder stage
COPY --from=builder /root/.local /root/.local

# Copy project files
COPY . .

# Expose port
EXPOSE 8000

# Run the app with uvicorn
CMD ["uvicorn", "project.asgi:application", "--host", "0.0.0.0", "--port", "8000"]