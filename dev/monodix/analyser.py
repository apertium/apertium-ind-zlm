#!/usr/bin/python
import sys, re

dic={} # dictionary from kateglo
added_words={} # words that are added manually
pars=[] # list of paradigms
excl_list=[] # list of words being excluded, usually they are uncommon or wrongly analyzed using kateglo

if len(sys.argv) < 2 or (sys.argv[1]!='id' and sys.argv[1]!='ms'):
	print 'analyzer.py <id/ms>';
	sys.exit(-1)
lang=sys.argv[1]

kat_fn="kateglo.txt"
par_fn="paradigms.txt"
added_fn="manual."+lang+".txt"
exc_fn="exceptions.txt"

# maps kateglo tag names
kat_pos=\
{ 'Adjektiva':'adj',\
'Adverbia':'adv',\
'Interjeksi':'ij',\
'Nomina':'n',\
'Numeralia':'num',\
'Preposisi':'pr',\
'Pronomina':'prn',\
'Verba':'vblex' }

# maps a combination of affixes to tags
tag_umum=\
{ 'pe':['pe'],\
'per':['per'],\
'pem':['peN'],\
'pen':['peN'],\
'peng':['peN'],\
'peny':['peN'],\
'pemer':['peN','per'],\
'pener':['peN','ter'],\
'pember':['peN','ber'],\
'penge':['peN'],\
'pembel':['peN','ber'],\
'ke':['ke'],\
'be':['be'],\
'ber':['ber'],\
'berke':['ber','ke'],\
'berpem':['ber','peN'],\
'berpen':['ber','peN'],\
'berpeng':['ber','peN'],\
'berpenge':['ber','peN'],\
'berpeny':['ber','peN'],\
'berse':['ber','se'],\
'berpe':['ber','pe'],\
'ter':['ter'],\
'se':['se'],\
'memper':['actv','per'],\
'diper':['pasv','per'],\
'keber':['ke','ber'],\
'keter':['ke','ter'],\
'kese':['ke','se'],\
'kepen':['ke','peN'],\
'kepe':['ke','pe'],\
'kepem':['ke','peN'],\
'kepeng':['ke','peN'],\
'kepenge':['ke','peN'],\
'kepeny':['ke','peN'],\
'me':['actv'],\
'mem':['actv'],\
'men':['actv'],\
'meng':['actv'],\
'meny':['actv'],\
'memer':['actv','per'],\
'mener':['actv','ter'],\
'memper':['actv','per'],\
'menge':['actv'],\
'di':['pasv'],\
'bel':['ber'],\
'pel':['per'],\
'terpel':['ter','per'],\
'member':['actv','ber'],\
'membel':['actv','ber'],\
'mempel':['actv','per'],\
'dipel':['pasv','per'],\
'diter':['pasv','ter'],\
'diber':['pasv','ber'],\
'i':['i'],'kan':['kan'],'an':['an'],\
'inya':['i','nya'],'kannya':['kan','nya'],'annya':['an','nya'],\
'nya':['nya'],\
'':[], 'unk':['unk']}

def is_excluded(w):
	# buah-buahan
	if w == w[:w.find('-')]+'-'+w[:w.find('-')]+'an':
		return True
	if w in excl_list:
		return True
	return False

def load_kat():
	for e in open(kat_fn):
		s, p, l = e.strip().split('\t')
		s = s.lower()
		if p in kat_pos:
			p = kat_pos[p]
		dic[s] = [str(p),str(l)]
	dic['tangan']=['n','tangan'] # hmm, manual correction (kateglo is sometimes wrong)

def load_added():
	for e in open(added_fn):
		if e.strip():
			if e.count('<i>'):
				a = e.find('<i>')+3 ; b = e.find('</i>')
				added_words[e[a:b].lower()]=e[:-1]
			else:
				a = e.find('<l>')+3 ; b = e.find('</l>')
				added_words[e[a:b].lower()]=e[:-1]

def load_pars():
	unused = ['subst','attr','actio','sg','pl','']
	for e in open(par_fn):
		if e.strip():
			tags, name = e.strip().split('\t')
			# e.g
			# adj.actio.actv.per-i -> ['adj','actv','per','i']
			tags = tags.replace('.san','.an')
			tags = tags.replace('-','.') # e.g. ke-an -> ke.an
			tags = tags.replace('si','i')
			tags = [tag for tag in tags.split('.') if tag not in unused]
			pars.append([tags, name])

def load_excl():
	global excl_list
	for e in open(exc_fn):
		if e.strip():
			excl_list += [e.strip()]
	excl_list += [chr(ord('a')+ch) for ch in range(26)]
	excl_list += [''+chr(ord('a')+ch).upper() for ch in range(26)]

def lemmatize(w):
	unk = 1
	if w in dic:
		unk=0
		lm = dic[w][1]
		if lm == '-1': # "w" is a lemma
			lm = w
	else: # predict the lemma 
		lm = ""
		tmp = w
		if w.count('-'): # 1. only take the first segment in reduplicated forms
			tmp = tmp[:tmp.find('-')]
		cand = ['nya','\\bter','\\bse','\\bdi','\\bper','kan\\b','i\\b']
		pasv = 0
		if tmp != re.sub(cand[3],'',tmp):
			pasv = 1
		for c in cand: # 2. try removing affixes that are not likely to appear in KBBI
			tmp = re.sub(c,'',tmp)
			if c == '\\bdi' and not pasv: # stop, further substitution will probably produce wrong lemma
				break
			if tmp in dic:
				lm = dic[tmp][1]
				if len(lm) <= 2: # lemma is too short
					unk=1
				else:
					unk=0
				break
		if lm == '-1':
			lm = tmp
	if unk:
		return None
	if w.count('-') > 1 or w.startswith('-') or w.endswith('-'): # invalid forms
		return None
	if w.count('-'):
		form = w[:w.find('-')]+'-'+w[:w.find('-')] # only handles word that contains full reduplication
		if w.count(form) != 1:
			return None
	return lm.lower()

def morph(w, lm):
	pos = dic[lm][0]
	if w == lm:
		return [pos]
	lm = lm.replace(' ','') # e.g. "beri tahu"
	suffs = ['i','kan','an',''] # TODO: lah, kah
	suff = "unk"
	for s in suffs: # let's predict the suffix
		if len(lm[1:]) and w.endswith(lm[1:]+s+'nya'):
			suff = s+'nya'
			break
		if len(lm[1:]) and w.endswith(lm[1:]+s):
			suff = s
			break
	frt = w
	red = []
	if w.count('-'):
		red = ['red']
		frt = w[:w.find('-')] # let's take only the first segment
	prefs = ['per','pe','pem','pen','peng','peny','pemer','penter','pener','pember','penge','pembel',\
	'ke','be','ber','ter','se','memper','diper','keber','keter','kese','kepen','kepe','kepen','kepem','kepeng','kepeny','kepenge',\
	'me','mem','men','meng','meny','menter','mener','memer','menge','member','di','bel','pel','membel','mempel','dipel',\
	'diter','diber','terpel','berke','berpem','berpen','berpeng','berpeny','berse','berpe','berpenge','']
	pref = "unk"
	for p in sorted(prefs, key=lambda x: -1 * len(x)):
		if frt.startswith(p+lm[1:]) or frt.startswith(p+lm):
			pref = p
	voc = ['a','e','i','o','u']
	if pref == 'pe' and (lm[0]=='r' or (lm[0] not in voc and lm[1:3]=='er')):
		pref = 'per'
	if pref == 'be' and (lm[0]=='r' or (lm[0] not in voc and lm[1:3]=='er')):
		pref = 'ber'
	return [pos] + tag_umum[pref] + tag_umum[suff] + red

def select_par(w, lm, tags):
	res = ""
	found = 0
	for p in pars:
		if tags[-3:] == ['ke','ber','an'] or tags[-3:] == ['peN','ber','an']: # e.g ke.ber-an is diff from ber.ke-an
			copy_tags = [] + tags
			tmp = copy_tags[-1]
			copy_tags[-1] = copy_tags[-2]
			copy_tags[-2] = tmp
			if copy_tags == p[0]:
				res = p[1]
				found = 1
				break
		elif sorted(tags) == sorted(p[0]):
			res = p[1]
			found = 1
			break
	if found:
		return format_par(w,lm,res)
	else:
		return None

def format_par(s, l, par):
	entry = '    <e lm="'+l+'">'
	if s==l:
		entry += '<i>'+s.replace(' ','<b/>')+'</i>'
	else:
		entry += '<p><l>'+s.replace(' ','<b/>')+'</l><r>'+l.replace(' ','<b/>')+'</r></p>'
	entry += '<par n="'+par+'"'
	entry += '/></e>'
	return entry

def startup():
	load_kat()
	load_added()
	load_pars()
	load_excl()

def analyze(w):
	w = w.strip().lower()
	if w in added_words:
		return added_words[w]
	elif is_excluded(w):
		return '*'+w
	else:
		lm = lemmatize(w)
		if lm == None:
			return '*'+w
		else:
			res = select_par(w, lm, morph(w, lm))
			if res == None:
				return '*'+w
			else:
				return res

startup()

while True:
	w = sys.stdin.readline().strip()
	if not w:
		break
	print analyze(w)
