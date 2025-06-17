# Base Python Image
From python:3.9-slim

# Set workdir
WORKDIR /app

# Copy files
COPY requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

# Run the app
CMD ["python", "app.py"]
