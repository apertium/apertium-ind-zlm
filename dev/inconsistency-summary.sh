INC=$1
OUT=testvoc-summary.$2.txt
POS="adj adv cnjadv cnjcoo cnjsub det ij n np num pr prn vblex"

ECHOE="echo -e"
SED=sed

if test x$(uname -s) = xDarwin; then
        ECHOE="builtin echo"
        SED=gsed
fi


echo "" > $OUT;

date >> $OUT
$ECHOE  "===============================================" >> $OUT
$ECHOE  "POS	Total	Clean	With @	With #	Clean %" >> $OUT
for i in $POS; do
	TOTAL=`cat $INC | awk -F'\t' -v tag="<$i>" '$1 ~ tag' | wc -l`; 
	AT=`cat $INC | awk -F'\t' -v tag="<$i>" '$1 ~ tag' | grep '@' | wc -l`;
	HASH=`cat $INC | awk -F'\t' -v tag="<$i>" '$1 ~ tag' |  grep '#' | wc -l`;

	UNCLEAN=`calc $AT+$HASH`;
	CLEAN=`calc $TOTAL-$UNCLEAN`;
	PERCLEAN=`calc $UNCLEAN/$TOTAL*100 |sed 's/^\W*//g' | sed 's/~//g' | head -c 5`;
	echo $PERCLEAN | grep "Err" > /dev/null;
	if [ $? -eq 0 ]; then
		TOTPERCLEAN="100";
	else
		TOTPERCLEAN=`calc 100-$PERCLEAN | sed 's/^\W*//g' | sed 's/~//g' | head -c 5`;
	fi

	$ECHOE $TOTAL";"$i";"$CLEAN";"$AT";"$HASH";"$TOTPERCLEAN;
done | sort -gr | awk -F'\t' -F';' '{print $2"\t"$1"\t"$3"\t"$4"\t"$5"\t"$6}' >> $OUT

$ECHOE "===============================================" >> $OUT
cat $OUT;
