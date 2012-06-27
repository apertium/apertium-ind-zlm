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
	if [ "$i" = "n" ]; then
		TOTAL=`cat $INC | awk -F'\t' -v tag="<$i>" '$1 ~ tag' | awk -F'\t' '$1 !~ /<n><vblex>|<n><adj>/' | wc -l`; 
		AT=`cat $INC | awk -F'\t' -v tag="<$i>" '$1 ~ tag' | grep '@' | awk -F'\t' '$1 !~ /<n><vblex>|<n><adj>/' | wc -l`;
		HASH=`cat $INC | awk -F'\t' -v tag="<$i>" '$1 ~ tag' |  grep '#' | awk -F'\t' '$1 !~ /<n><vblex>|<n><adj>/' |  wc -l`;
	elif [ "$i" = "vblex" ]; then
		TOTAL=`cat $INC | awk -F'\t' -v tag="<$i>" '$1 ~ tag' | awk -F'\t' '$1 !~ /<vblex><n>/' | wc -l`; 
		AT=`cat $INC | awk -F'\t' -v tag="<$i>" '$1 ~ tag' | grep '@' | awk -F'\t' '$1 !~ /<vblex><n>/' | wc -l`;
		HASH=`cat $INC | awk -F'\t' -v tag="<$i>" '$1 ~ tag' |  grep '#' | awk -F'\t' '$1 !~ /<vblex><n>/' | wc -l`;
	elif [ "$i" = "adj" ]; then
		TOTAL=`cat $INC | awk -F'\t' -v tag="<$i>" '$1 ~ tag' | awk -F'\t' '$1 !~ /<adj><n>|<adj><vblex>/' | wc -l`; 
		AT=`cat $INC | awk -F'\t' -v tag="<$i>" '$1 ~ tag' | grep '@' | awk -F'\t' '$1 !~ /<adj><n>|<adj><vblex>/' | wc -l`;
		HASH=`cat $INC | awk -F'\t' -v tag="<$i>" '$1 ~ tag' |  grep '#' | awk -F'\t' '$1 !~ /<adj><n>|<adj><vblex>/' | wc -l`;
	elif [ "$i" = "adv" ]; then
		TOTAL=`cat $INC | awk -F'\t' -v tag="<$i>" '$1 ~ tag' | awk -F'\t' '$1 !~ /<adv><n>|<adv><vblex>/' | wc -l`; 
		AT=`cat $INC | awk -F'\t' -v tag="<$i>" '$1 ~ tag' | grep '@' | awk -F'\t' '$1 !~ /<adv><n>|<adv><vblex>/' | wc -l`;
		HASH=`cat $INC | awk -F'\t' -v tag="<$i>" '$1 ~ tag' |  grep '#' | awk -F'\t' '$1 !~ /<adv><n>|<adv><vblex>/' | wc -l`;
	elif [ "$i" = "det" ]; then
		TOTAL=`cat $INC | awk -F'\t' -v tag="<$i>" '$1 ~ tag' | awk -F'\t' '$1 !~ /<det><n>|<det><vblex>/' | wc -l`; 
		AT=`cat $INC | awk -F'\t' -v tag="<$i>" '$1 ~ tag' | grep '@' | awk -F'\t' '$1 !~ /<det><n>|<det><vblex>/' | wc -l`;
		HASH=`cat $INC | awk -F'\t' -v tag="<$i>" '$1 ~ tag' |  grep '#' | awk -F'\t' '$1 !~ /<det><n>|<det><vblex>/' | wc -l`;
	else
		TOTAL=`cat $INC | awk -F'\t' -v tag="<$i>" '$1 ~ tag' | wc -l`; 
		AT=`cat $INC | awk -F'\t' -v tag="<$i>" '$1 ~ tag' | grep '@' | wc -l`;
		HASH=`cat $INC | awk -F'\t' -v tag="<$i>" '$1 ~ tag' |  grep '#' | wc -l`;
	fi
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
