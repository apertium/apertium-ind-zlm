TMPDIR=/tmp

if [[ $1 = "ind-zlm" ]]; then

lt-expand ../../apertium-ind/apertium-ind.ind.dix | grep -v "REGEXP" | sort -u |  sed 's/:/%/g' | cut -f2 -d'%' |  sed 's/^/^/g' | sed 's/$/$ ^.<sent>$/g' | tee $TMPDIR/tmp_testvoc1.txt |
	apertium-pretransfer |
	apertium-transfer ../apertium-ind-zlm.ind-zlm.t1x  ../ind-zlm.t1x.bin  ../ind-zlm.autobil.bin | tee $TMPDIR/tmp_testvoc2.txt | 
	lt-proc -d ../ind-zlm.autogen.bin > $TMPDIR/tmp_testvoc3.txt

paste $TMPDIR/tmp_testvoc1.txt $TMPDIR/tmp_testvoc2.txt $TMPDIR/tmp_testvoc3.txt | sed 's/\^.<sent>\$//g'

elif [[ $1 = "zlm-ind" ]]; then

lt-expand ../../apertium-zlm/apertium-zlm.zlm.dix | grep -v "REGEXP" | sort -u | sed 's/:/%/g' | cut -f2 -d'%' |  sed 's/^/^/g' | sed 's/$/$ ^.<sent>$/g' | tee $TMPDIR/tmp_testvoc1.txt |
	apertium-pretransfer |
	apertium-transfer ../apertium-ind-zlm.zlm-ind.t1x  ../zlm-ind.t1x.bin  ../zlm-ind.autobil.bin | tee $TMPDIR/tmp_testvoc2.txt |
	lt-proc -d ../zlm-ind.autogen.bin > $TMPDIR/tmp_testvoc3.txt

paste $TMPDIR/tmp_testvoc1.txt $TMPDIR/tmp_testvoc2.txt $TMPDIR/tmp_testvoc3.txt | sed 's/\^.<sent>\$//g'

else
	echo "sh inconsistency.sh <direction>";
fi
