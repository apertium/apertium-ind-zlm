TMPDIR=/tmp

if [[ $1 = "id-ms" ]]; then

lt-expand ../.deps/id.dix | sort -u |  sed 's/:/%/g' | cut -f2 -d'%' |  sed 's/^/^/g' | sed 's/$/$ ^.<sent>$/g' | tee $TMPDIR/tmp_testvoc1.txt |
        apertium-pretransfer|
        apertium-transfer ../apertium-id-ms.id-ms.t1x  ../id-ms.t1x.bin  ../id-ms.autobil.bin | tee $TMPDIR/tmp_testvoc2.txt | 
        lt-proc -d ../id-ms.autogen.bin > $TMPDIR/tmp_testvoc3.txt
paste -d _ $TMPDIR/tmp_testvoc1.txt $TMPDIR/tmp_testvoc2.txt $TMPDIR/tmp_testvoc3.txt | sed 's/\^.<sent>\$//g' | sed 's/_/   --------->  /g'

elif [[ $1 = "ms-id" ]]; then

lt-expand ../ms.dix | sort -u | sed 's/:/%/g' | cut -f2 -d'%' |  sed 's/^/^/g' | sed 's/$/$ ^.<sent>$/g' | tee $TMPDIR/tmp_testvoc1.txt |
        apertium-pretransfer|
        apertium-transfer ../apertium-id-ms.ms-id.t1x  ../ms-id.t1x.bin  ../id-ms.autobil.bin | tee $TMPDIR/tmp_testvoc2.txt |
        lt-proc -d ../ms-id.autogen.bin > $TMPDIR/tmp_testvoc3.txt
paste -d _ $TMPDIR/tmp_testvoc1.txt $TMPDIR/tmp_testvoc2.txt $TMPDIR/tmp_testvoc3.txt | sed 's/\^.<sent>\$//g' | sed 's/_/   --------->  /g'

else
	echo "sh inconsistency.sh <direction>";
fi
