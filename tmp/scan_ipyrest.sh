#!/bin/bash

# Run example ORT scan on https://github.com/deeplook/ipyrest.git

# Download package
git clone https://github.com/deeplook/ipyrest.git

# Run the analyzer. Be aware that the ./analyzer-output directory must not exist.
# needs pip install virtualenv
ort --debug --stacktrace analyze \
    -i ipyrest -o ipyrest-ort/analyzer --allow-dynamic-versions

# Run the scanner
ort --debug --stacktrace scan \
    -i ipyrest-ort/analyzer/analyzer-result.yml -o ipyrest-ort/scanner \
    --scopes dependencies

# Run the evaluator
ort evaluate --rules-file ~/oss-review-toolkit/docs/examples/rules.kts \
    --license-configuration-file ~/oss-review-toolkit/docs/examples/licenses.yml \
    -i ipyrest-ort/scanner/scan-result.yml -o ipyrest-ort/evaluator

# Generate a report
ort report -f NoticeByPackage,StaticHtml,WebApp \
    -i ipyrest-ort/evaluator/evaluation-result.yml -o ipyrest-ort/reporter

echo "Please check ipyrest-ort/reporter/scan-report.html"
