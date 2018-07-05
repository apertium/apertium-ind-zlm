echo "==Indonesian->Malaysian===========================";
bash inconsistency.sh ind-zlm > /tmp/ind-zlm.testvoc; bash inconsistency-summary.sh /tmp/ind-zlm.testvoc ind-zlm
echo ""
echo "==Malaysian->Indonesian===========================";
bash inconsistency.sh zlm-ind > /tmp/zlm-ind.testvoc; bash inconsistency-summary.sh /tmp/zlm-ind.testvoc zlm-ind
