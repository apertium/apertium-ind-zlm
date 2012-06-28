echo "==Indonesian->Malaysian===========================";
bash inconsistency.sh id-ms > /tmp/id-ms.testvoc; bash inconsistency-summary.sh /tmp/id-ms.testvoc id-ms
echo ""
echo "==Malaysian->Indonesian===========================";
bash inconsistency.sh ms-id > /tmp/ms-id.testvoc; bash inconsistency-summary.sh /tmp/ms-id.testvoc ms-id
