#!/bin/bash
wget --no-check-certificate http://stash.osgconnect.net/+username/random_words
chmod 700 ./distribution
cat random_words | ./distribution 
