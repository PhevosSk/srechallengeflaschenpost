# Nginx Ingress Log Analysis Script

A simple Python script that parses nginx ingress controller logs and extracts key metrics for analysis.

## What it does

This script solves the problem of extracting and summarizing the following data from nginx ingress logs:

1. **Total requests per pod**: Count the number of requests coming from each ingress pod
2. **Response code summary**: Count how many times each HTTP response code appears in the logs  
3. **Total bytes sent per pod**: Sum the total number of bytes sent for requests coming from each pod
4. **Unique request paths**: List all unique request paths that were logged

## How to use

Run the script with the log filename as an argument:
```bash
python ingress_logs_analysis.py <log_filename>
```

Examples:
```bash
# Analyze the fp-sre-challenge.log file
python ingress_logs_analysis.py fp-sre-challenge.log

# Analyze any other nginx log file
python ingress_logs_analysis.py my-nginx-logs.log
```

## Sample output
```
------ Total requests per pod:
ingress-nginx-controller-7b5855865f-7c8b4: X

------ Response code summary:
200: X
404: X

------ Total bytes sent per pod:
ingress-nginx-controller-7b5855865f-7c8b4: X bytes

------ Unique request paths:
/data/wasser/spritzig/3
/api/order/submit
/data/spirituosen/tabakwaren-spirituosen/3
```
