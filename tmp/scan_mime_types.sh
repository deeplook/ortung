# Run example ORT scan on https://github.com/jshttp/mime-types.git

export PATH=~/oss-review-toolkit/cli/build/install/ort/bin/:$PATH

# Download package
git clone https://github.com/jshttp/mime-types.git
cd mime-types
git checkout 2.1.18

# Run the analyzer. Be aware that the ./analyzer-output directory must not exist.
ort --debug --stacktrace analyze -i . -o ./analyzer-output --allow-dynamic-versions # -f JSON

# Run the scanner
ort scan -i ./analyzer-output/analyzer-result.yml -o ./scanner-output --scopes dependencies

# Run the evaluator
ort evaluate --rules-file ../oss-review-toolkit/docs/examples/rules.kts -i ./scanner-output/scan-result.yml -o ./evaluator-output/mime-types

# Generate a report
ort report -f NoticeByPackage,StaticHtml,WebApp -i ./evaluator-output/evaluation-result.yml -o ./reporter-output
