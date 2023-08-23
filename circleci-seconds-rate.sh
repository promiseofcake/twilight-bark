#!/usr/bin/env bash

set -e

now="$(date +%s)"
metric_name="${1:?metric name is missing}"
value="${2:?metric value is missing}"

curl -X POST "https://api.datadoghq.com/api/v2/series" \
  -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  -H "DD-API-KEY: ${DD_API_KEY}" \
  -d '{
  "series": [
    {
      "metric": "'${metric_name}'",
      "type": 2,
      "unit": "second",
      "points": [
        {
          "timestamp": '${now}',
          "value": '${value}'
        }
      ],
      "resources": [
        {
          "type": "env",
          "name": "circleci"
        },
        {
          "type": "circleci-repo",
          "name": "'${CIRCLE_PROJECT_REPONAME}'"
        }
      ]
    }
  ]
}'
