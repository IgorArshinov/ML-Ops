# Use the official Python base image
FROM python:3.13-slim

#ARG AWS_ACCESS_KEY_ID
#ARG AWS_SECRET_ACCESS_KEY
#ARG AWS_DEFAULT_REGION
#
#ENV AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
#ENV AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
#ENV AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}

# Expose the default port
EXPOSE 8989

# Set the working directory inside the container
WORKDIR /app

# Copy the application code to the working directory
COPY ./server .

# Copy the requirements file to the working directory
COPY requirements.txt .

# Install the Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Run the FastAPI application using uvicorn server
CMD ["sh", "-c", "python models/init_model.py; uvicorn app:app --host 0.0.0.0 --port 8989"]
