#!/usr/bin/python
import httplib, re, sys

tag = sys.argv[1]
num_of_pages = int(sys.argv[3])
tipe = sys.argv[2]


for i in range(num_of_pages):
	conn = httplib.HTTPConnection("kateglo.bahtera.org")
	print >> sys.stderr, '##### ' + str(i+1) + ' #####'
	conn.request("GET", "/index.php?op=1&phrase=&lex="+tag+"&type="+tipe+"&mod=dictionary&srch=Cari&p="+str(i+1))
	r = conn.getresponse()
	data = r.read()
	conn.close()
	pattern = re.compile("<b><a href=\"\./\?mod=dictionary&action=view&phrase=(.*?)\">")
	for word in pattern.findall(data):
		print >> sys.stderr, word
		print word
