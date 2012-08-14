#!/usr/bin/python
import sys

atab="  "
#print atab+'<pardefs>'

for line in sys.stdin.readlines():
	if not line.strip():
		continue
	pars, name = line.strip().split('\t')
	print atab*2+'<pardef n="'+name+'">'
	for par in pars.split('+'):
		tags = par.split('.')
		complete = ""
		for tag in tags:
			complete += '<s n="'+tag+'"/>'
		print atab*2+'<e>'
		print atab*3+'<p>'
		print atab*4+'<l></l>'
		print atab*4+'<r>'+complete+'</r>'
		print atab*3+'</p>'
		print atab*2+'</e>'
	print atab*2+'</pardef>'

#print atab+'</pardefs>'
