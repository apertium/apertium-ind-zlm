#!/bin/sh
cat wordlist.id | sh create-monodix.sh id > ../../apertium-id-ms.id.dix
cat wordlist.ms | sh create-monodix.sh ms > ../../apertium-id-ms.ms.dix
