#!/bin/sh

./analyser.py $1 | grep -v \* > analyser-out.txt
cat manual.$1.txt analyser-out.txt | sort -u | ./sort-dic.py > entries.txt
./paradigms-gen.py < paradigms.txt > paradigms-gen.txt
cat header.txt paradigms-gen.txt middle.txt entries.txt footer.txt
