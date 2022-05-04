#!/bin/bash

if [ ! -f "trivy_0.2.1_Linux-64bit.tar.gz" ]; then
  curl -LO https://github.com/aquasecurity/trivy/releases/download/v0.2.1/trivy_0.2.1_Linux-64bit.tar.gz
fi
mkdir -p trivy_bin reports
ls -l *
tar -xvf trivy_0.2.1_Linux-64bit.tar.gz -C ./trivy_bin
chmod +x ./trivy_bin/trivy
rm trivy_0.2.1_Linux-64bit.tar.gz

for i in `cat image-list.txt`; do
  echo "Scanning $i"
  fname="${i##*/}"
  ./trivy_bin/trivy --format json --output ${fname}-report.jsonl -q $i
  cat ${fname}-report.jsonl | jq -c '.[]' > ${fname}-f.json
done
rm -rf trivy_bin *.jsonl
cat *-f.json > full-report.json
mv *.json reports
