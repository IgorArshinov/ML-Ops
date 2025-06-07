# Use the official Python base image
FROM python:3.13-slim

# Expose the default port
EXPOSE 8989

# Set the working directory inside the container
WORKDIR /app

# Copy the application code and models to the working directory
COPY ./server/app.py .
COPY ./server/models/ ./models/

# Copy the requirements file to the working directory
COPY ./server/requirements.txt .

# Install the Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Run the FastAPI application using uvicorn server
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8989"]
