#!/bin/bash

# Run example ORT scan on https://github.com/deeplook/ortung.git

# Download package
git clone https://github.com/deeplook/ortung.git

# Run the analyzer. Be aware that the ./analyzer-output directory must not exist.
# needs pip install virtualenv
ort --debug --stacktrace analyze \
    -i ortung -o ortung-ort/analyzer --allow-dynamic-versions

# Run the scanner
ort --debug --stacktrace scan \
    -i ortung-ort/analyzer/analyzer-result.yml -o ortung-ort/scanner \
    --scopes dependencies

# Run the evaluator
ort evaluate --rules-file ~/oss-review-toolkit/docs/examples/rules.kts \
    --license-configuration-file ~/oss-review-toolkit/docs/examples/licenses.yml \
    -i ortung-ort/scanner/scan-result.yml -o ortung-ort/evaluator

# Generate a report
ort report -f NoticeByPackage,StaticHtml,WebApp \
    -i ortung-ort/evaluator/evaluation-result.yml -o ortung-ort/reporter

echo "Please check ortung-ort/reporter/scan-report.html"
