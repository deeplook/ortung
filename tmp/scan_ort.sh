#!/bin/bash

# Run example ORT scan on https://github.com/heremaps/oss-review-toolkit.git

# Download package
git clone https://github.com/heremaps/oss-review-toolkit.git

# Run the analyzer. Be aware that the ./analyzer-output directory must not exist.
ort --debug --stacktrace analyze \
    -i ort -o ort-ort/analyzer --allow-dynamic-versions

# Run the scanner
ort --debug --stacktrace scan \
    -i ort-ort/analyzer/analyzer-result.yml -o ort-ort/scanner \
    --scopes dependencies

# Run the evaluator
ort evaluate --rules-file ~/oss-review-toolkit/docs/examples/rules.kts \
    --license-configuration-file ~/oss-review-toolkit/docs/examples/licenses.yml \
    -i ort-ort/scanner/scan-result.yml -o ort-ort/evaluator

# Generate a report
ort report -f NoticeByPackage,StaticHtml,WebApp \
    -i ort-ort/evaluator/evaluation-result.yml -o ort-ort/reporter

echo "Please check ort-ort/reporter/scan-report.html"
