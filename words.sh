#!/bin/bash
# HTCondor will transfer the file for us. Uncomment the following if you prefer to transfer form the script
# wget --no-check-certificate http://stash.osgconnect.net/+marco/words.tar.gz
tar xzf words.tar.gz
cat random_words | ./distribution 
