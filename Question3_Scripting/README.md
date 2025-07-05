# Nginx Ingress Log Analysis Script

The script processes nginx ingress log files and provides insights into:
- **Request distribution** per pod
- **HTTP response code patterns** 
- **Bandwidth usage** per pod
- **Unique request paths** accessed

## Script Architecture

### Core Functions

#### `read_log_file(filename)`
- **Purpose**: Safely reads log file and returns clean log lines
- **Input**: Path to log file
- **Output**: List of non-empty log lines
- **Error Handling**: Catches file not found

#### `parse_log_line(line)`
- **Purpose**: Extracts relevant data from a single log line using regex
- **Input**: Raw log line string
- **Output**: Dictionary with parsed fields (pod_name, request_path, http_code, bytes_sent)
- **Returns**: `None` if line doesn't match expected format

#### `process_log_entries(log_lines)`
- **Purpose**: Processes all log lines and aggregates statistics
- **Input**: List of log lines
- **Output**: Dictionary containing all summarized metrics
- **Metrics Generated**:
  - Request counts per pod
  - HTTP response code distribution
  - Total bytes sent per pod
  - Set of unique request paths

#### `print_summary(stats)`
- **Purpose**: Formats and displays the analysis results
- **Input**: Statistics dictionary from `process_log_entries()`
- **Output**: Formatted console output with all metrics

## Regex Pattern Breakdown

The script uses this regex pattern to parse nginx ingress logs:
```regex
^(\S+) (\S+) (\S+) - - \[([^\]]+)\] "[A-Z]+ (\S+) HTTP/[0-9.]+" (\d{3}) (\d+) "([^"]+)" "([^"]+)" (\d+) (\d+\.\d+) \[[^\]]*\] \[\] (\S+) (\S+)
```

**Captured Groups:**
- Group 1: **Pod name** 
- Group 5: **Request path** 
- Group 6: **HTTP status code** 
- Group 7: **Bytes sent**

## Usage

### Command Line
```bash
python ingress_logs_analysis.py <log_filename>
```

### Example
```bash
python ingress_logs_analysis.py fp-sre-challenge.log
```

## Error Handling

The script includes robust error handling:
- **File not found**: Clear error message with filename
- **File reading errors**: General exception handling for file I/O issues
- **Invalid arguments**: Usage instructions displayed and script exits
- **Parsing failures**: Lines that don't match expected format are silently skipped

## Dependencies

- **Python 3.x**
- **Standard library modules**:
  - `re` - Regular expressions for log parsing
  - `sys` - Command line argument handling

