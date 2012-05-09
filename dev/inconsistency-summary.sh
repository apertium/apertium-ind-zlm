INC=$1
OUT=testvoc-summary.$2.txt
POS="adj adv cm cnjcoo det guio ij n np num pr prn vblex vaux cnjsub"

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
	if [ "$i" = "det" ]; then
		TOTAL=`cat $INC | grep "<$i>" | grep -v -e '<n>' -e '<np>' | grep -v REGEX | wc -l`; 
		AT=`cat $INC | grep "<$i>" | grep '@' | grep -v -e '<n>' -e '<np>'  | grep -v REGEX | wc -l`;
		HASH=`cat $INC | grep "<$i>" |  sed 's/~#/#/g' |grep '>  *#' | grep -v -e '<n>' -e '<np>' | grep -v REGEX |  wc -l`;
	elif [ "$i" = "preadv" ]; then
		TOTAL=`cat $INC | grep "<$i>" | grep -v -e '<adj>' -e '<adv>' | grep -v REGEX | wc -l`; 
		AT=`cat $INC | grep "<$i>" | grep '@' | grep -v -e '<adj>' -e '<adv>'  | grep -v REGEX | wc -l`;
		HASH=`cat $INC | grep "<$i>" |  sed 's/~#/#/g' |grep '>  *#' | grep -v -e '<adj>' -e '<adv>' | grep -v REGEX |  wc -l`;
	elif [ "$i" = "adj" ]; then
		TOTAL=`cat $INC | grep "<$i>" | grep -v -e '<part>' -e '<qst>' -e '<cnj' -e '<v'  | grep -v REGEX | wc -l`; 
		AT=`cat $INC | grep "<$i>" | grep '@' | grep -v -e '<part>' -e '<qst>' -e '<cnj' -e '<v'  | grep -v REGEX | wc -l`;
		HASH=`cat $INC | grep "<$i>" |  sed 's/~#/#/g' |grep '>  *#' | grep -v -e '<part>' -e '<qst>' -e '<cnj' -e '<v' | grep -v REGEX |  wc -l`;
	elif [ "$i" = "adv" ]; then
		TOTAL=`cat $INC | grep "<$i>" | grep -v -e '<part>' -e '<qst>' -e '<cnj' -e '<v' -e '<adj>' | grep -v REGEX | wc -l`; 
		AT=`cat $INC | grep "<$i>" | grep '@' | grep -v -e '<part>' -e '<qst>' -e '<cnj' -e '<v' -e '<adj>'  | grep -v REGEX | wc -l`;
		HASH=`cat $INC | grep "<$i>" |  sed 's/~#/#/g' |grep '>  *#' | grep -v -e '<part>' -e '<qst>' -e '<cnj' -e '<v' -e '<adj>' | grep -v REGEX |  wc -l`;
	elif [ "$i" = "cnjcoo" ]; then
		TOTAL=`cat $INC | grep "<$i>" | grep -v -e '<v>' -e '<n>' -e '<adj>' | grep -v REGEX | wc -l`; 
		AT=`cat $INC | grep "<$i>" | grep '@' | grep -v -e '<v>' -e '<n>' -e '<adj>' | grep -v REGEX | wc -l`;
		HASH=`cat $INC | grep "<$i>" |  sed 's/~#/#/g' |grep '>  *#' | grep -v -e '<v>' -e '<n>' -e '<adj>' | grep -v REGEX |  wc -l`;
	elif [ "$i" = "np" ]; then
		TOTAL=`cat $INC | grep "<$i>" | grep -v -e '<part>' -e '<qst>' -e '<cnj' | grep -v REGEX | wc -l`; 
		AT=`cat $INC | grep "<$i>" | grep '@' | grep -v -e '<part>' -e '<qst>' -e '<cnj'  | grep -v REGEX | wc -l`;
		HASH=`cat $INC | grep "<$i>" |  sed 's/~#/#/g' |grep '>  *#' | grep -v -e '<part>' -e '<qst>' -e '<cnj' | grep -v REGEX |  wc -l`;
	elif [ "$i" = "n" ]; then
		TOTAL=`cat $INC | grep "<$i>" | grep -v -e '<part>' -e '<qst>' -e '<cnj' | grep -v REGEX | wc -l`; 
		AT=`cat $INC | grep "<$i>" | grep '@' | grep -v -e '<part>' -e '<qst>' -e '<cnj'  | grep -v REGEX | wc -l`;
		HASH=`cat $INC | grep "<$i>" |  sed 's/~#/#/g' |grep '>  *#' | grep -v -e '<part>' -e '<qst>' -e '<cnj' | grep -v REGEX |  wc -l`;
	elif [ "$i" = "v" ]; then
		TOTAL=`cat $INC | grep "<$i>" | grep -v -e '<part>' -e '<qst>' -e '<cnj' | grep -v REGEX | wc -l`; 
		AT=`cat $INC | grep "<$i>" | grep '@' | grep -v -e '<part>' -e '<qst>' -e '<cnj'  | grep -v REGEX | wc -l`;
		HASH=`cat $INC | grep "<$i>" |  sed 's/~#/#/g' |grep '>  *#' | grep -v -e '<part>' -e '<qst>' -e '<cnj' | grep -v REGEX |  wc -l`;
	else
		TOTAL=`cat $INC | grep "<$i>" | grep -v REGEX | wc -l`; 
		AT=`cat $INC | grep "<$i>" | grep '@'  | grep -v REGEX | wc -l`;
		HASH=`cat $INC | grep "<$i>" |  sed 's/~#/#/g' |grep '>  *#' | grep -v REGEX |  wc -l`;
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
done | sort -gr | awk -F';' '{print $2"\t"$1"\t"$3"\t"$4"\t"$5"\t"$6}' >> $OUT

$ECHOE "===============================================" >> $OUT
cat $OUT;
