#!/usr/bin/python
import sys

def get_par(l):
	a = l.find('<par n="')
	b = l.find('"', a+8)
	return l[a+8:b]

def get_lm(l):
	a = l.find('"')
	b = l.find('"', a+1)
	return l[a+1:b]

lines = sys.stdin.readlines()
par = {}

for l in lines:
	p = get_par(l)
	par[p]=1

for p in par.keys():
	lines.append('    <!-- lm=""<par n="'+p+'"/> -->\n')

for l in sorted(lines, key = lambda x : (get_par(x), get_lm(x))):
	sys.stdout.write(l.replace('lm=""',''))
