import subprocess
import time
import sys
import argparse

# -------------------------------
# Argument parsing
# -------------------------------
parser = argparse.ArgumentParser(description="Docker Compose network health check")
parser.add_argument(
    "--network",
    required=True,
    help="Docker Compose network to attach curl containers to"
)
args = parser.parse_args()
network = args.network

# -------------------------------
# Configuration
# -------------------------------
services = ["carts", "orders", "user", "catalogue", "shipping", "payment", "queue-master"]
retries = 3
delay = 5

# -------------------------------
# Function to check a service
# -------------------------------
def check_service(service):
    url = f"http://{service}/health"
    try:
        result = subprocess.run(
            [
                "docker", "run", "--rm",
                "--network", network,
                "curlimages/curl",
                "-s", "-f", url
            ],
            capture_output=True,
            text=True,
            timeout=10
        )
        if result.returncode != 0:
            print(f"{service} error: {result.stderr.strip() or result.stdout.strip()}")
            return False
        print(f"{service} OK")
        return True
    except subprocess.TimeoutExpired:
        print(f"{service} error: request timed out")
        return False

# -------------------------------
# Main loop
# -------------------------------
for attempt in range(retries):
    all_ok = True
    for service in services:
        if not check_service(service):
            all_ok = False

    if all_ok:
        print("All services healthy!")
        sys.exit(0)
    else:
        print(f"Retrying in {delay}s...")
        time.sleep(delay)

sys.exit(1)
