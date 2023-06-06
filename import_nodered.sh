#!/bin/bash

# Define the Node-RED API endpoint
NODE_RED_API="http://localhost:1880/flows"


wget 
# Define the path to the flow JSON file
FLOW_FILE="path/to/flow.json"

# Read the flow JSON file content
FLOW_CONTENT=$(cat "$FLOW_FILE")

# Make an HTTP POST request to import the flow
curl -X POST \
  -H "Content-Type: application/json" \
  -d "$FLOW_CONTENT" \
  "$NODE_RED_API"