#!/bin/bash

# Run example ORT scan on https://github.com/jshttp/mime-types.git

# Download package
git clone https://github.com/jshttp/mime-types.git
cd mime-types
git checkout 2.1.18
cd ..

# Run the analyzer. Be aware that the ./analyzer-output directory must not exist.
ort --debug --stacktrace analyze \
    -i mime-types -o mime-types-ort/analyzer --allow-dynamic-versions

# Run the scanner
ort --debug --stacktrace scan \
    -i mime-types-ort/analyzer/analyzer-result.yml -o mime-types-ort/scanner \
    --scopes dependencies

# Run the evaluator
ort evaluate --rules-file ~/oss-review-toolkit/docs/examples/rules.kts \
    --license-configuration-file ~/oss-review-toolkit/docs/examples/licenses.yml \
    -i mime-types-ort/scanner/scan-result.yml -o mime-types-ort/evaluator

# Generate a report
ort report -f NoticeByPackage,StaticHtml,WebApp \
    -i mime-types-ort/evaluator/evaluation-result.yml -o mime-types-ort/reporter

echo "Please check mime-types-ort/reporter/scan-report.html"
