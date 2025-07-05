import re
import sys

# Function to read log lines from file
def read_log_file(filename):
    try:
        with open(filename, 'r') as file:
            return [line.strip() for line in file.readlines() if line.strip()]
    except FileNotFoundError:
        print(f"Error: File '{filename}' not found.")
        return []
    except Exception as e:
        print(f"Error reading file '{filename}': {e}")
        return []

# Check if filename is provided as command line argument
if len(sys.argv) != 2:
    print("Usage: python ingress_logs_analysis.py <log_filename>")
    sys.exit(1)

log_filename = sys.argv[1]
print(f"Reading log file: {log_filename}")

# Read log data from file
log_lines = read_log_file(log_filename)

# Regex pattern
pattern = r'^(\S+) (\S+) (\S+) - - \[([^\]]+)\] "[A-Z]+ (\S+) HTTP/[0-9.]+" (\d{3}) (\d+) "([^"]+)" "([^"]+)" (\d+) (\d+\.\d+) \[[^\]]*\] \[\] (\S+) (\S+)'

# Function to parse a single log line
def parse_log_line(line):
    match = re.match(pattern, line)
    if match:
        return {
            "pod_name": match.group(1),
            "request_path": match.group(5),
            "http_code": match.group(6),
            "bytes_sent": int(match.group(7))
        }
    else:
        return None

# Function to process log lines and return stats
def process_log_entries(log_lines):
    pod_request_counts = {}
    http_response_counts = {}
    total_bytes_per_pod = {}
    unique_paths = set()

    for line in log_lines:
        parsed = parse_log_line(line)
        if not parsed:
            print("No match for line:\n", line)
            continue

        pod = parsed["pod_name"]
        path = parsed["request_path"]
        code = parsed["http_code"]
        bytes_sent = parsed["bytes_sent"]

        pod_request_counts[pod] = pod_request_counts.get(pod, 0) + 1
        http_response_counts[code] = http_response_counts.get(code, 0) + 1
        total_bytes_per_pod[pod] = total_bytes_per_pod.get(pod, 0) + bytes_sent
        unique_paths.add(path)

    return {
        "requests_per_pod": pod_request_counts,
        "response_codes": http_response_counts,
        "bytes_per_pod": total_bytes_per_pod,
        "unique_paths": unique_paths
    }

# Function to print the results
def print_summary(stats):
    print("------ Total requests per pod:")
    for pod, count in stats["requests_per_pod"].items():
        print(pod + ": " + str(count))

    print("\n------ Response code summary:")
    for code, count in stats["response_codes"].items():
        print(code + ": " + str(count))

    print("\n------ Total bytes sent per pod:")
    for pod, total in stats["bytes_per_pod"].items():
        print(pod + ": " + str(total) + " bytes")

    print("\n------ Unique request paths:")
    for path in stats["unique_paths"]:
        print(path)

# Run the program
if log_lines:
    print(f"Processing {len(log_lines)} log lines from '{log_filename}'...")
    stats = process_log_entries(log_lines)
    print_summary(stats)
else:
    print(f"No log lines to process. Please check if '{log_filename}' exists and contains valid log data.")
