#!/usr/bin/python
import httplib, re, sys

num_of_pages = 3613

for i in range(num_of_pages):
	while True:
		try:
			conn = httplib.HTTPConnection("kateglo.bahtera.org")
			print >> sys.stderr, '##### ' + str(i+1) + ' #####'
			conn.request("GET", "/index.php?op=1&mod=dictionary&srch=all&p="+str(i+1))
			r = conn.getresponse()
			data = r.read()
			pattern = re.compile("<b><a href=\"\./\?mod=dictionary&action=view&phrase=(.*?)\">")
			conn.close()
			for word in pattern.findall(data):
				print >> sys.stderr, word
				conn = httplib.HTTPConnection("kateglo.bahtera.org")
				conn.request("GET", "/index.php?mod=dictionary&action=view&phrase="+word)
				r = conn.getresponse()
				data2 = r.read()
				conn.close()
				kelas = data2.find('<strong>Kelas:')
				if kelas != -1:
							kelas = data2.find('<a href', kelas)
							kelas = data2 [ data2.find('>', kelas)+1: data2.find('<', kelas+1) ]
				lm = data2.find('<strong>Kata dasar:')
				if lm != -1:
							lm = data2.find('<a href', lm)
							lm = data2 [ data2.find('>', lm)+1: data2.find('<', lm+1) ]
				print word+'\t'+str(kelas)+'\t'+str(lm)
			break
		except KeyboardInterrupt:
			sys.exit()
		except:
			pass
