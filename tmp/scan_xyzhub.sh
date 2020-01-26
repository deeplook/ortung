#!/bin/bash

# Run example ORT scan on https://github.com/heremaps/xyz-hub.git

# Download package
git clone https://github.com/heremaps/xyz-hub.git

# Run the analyzer. Be aware that the ./analyzer-output directory must not exist.
ort --debug --stacktrace analyze \
    -i xyz-hub -o xyz-hub-ort/analyzer --allow-dynamic-versions

# Run the scanner
ort --debug --stacktrace scan \
    -i xyz-hub-ort/analyzer/analyzer-result.yml -o xyz-hub-ort/scanner \
    --scopes dependencies

# Run the evaluator
ort evaluate --rules-file ~/oss-review-toolkit/docs/examples/rules.kts \
    --license-configuration-file ~/oss-review-toolkit/docs/examples/licenses.yml \
    -i xyz-hub-ort/scanner/scan-result.yml -o xyz-hub-ort/evaluator

# Generate a report
ort report -f NoticeByPackage,StaticHtml,WebApp \
    -i xyz-hub-ort/evaluator/evaluation-result.yml -o xyz-hub-ort/reporter

echo "Please check xyz-hub-ort/reporter/scan-report.html"
