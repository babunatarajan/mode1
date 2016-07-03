#!/bin/bash

pip install -r packages/pip-requirements.txt

#django-evolution==0.6.7
pip install packages/django-evolution-release-0.6.7.zip

#django-mailer==0.2a1.dev3
pip install packages/django-mailer_0.2a1.dev3.orig.tar.gz

echo "untar packages/pyexiv2.tar.gz under /opt/clientname/lib/python2.7/site-packages/ directory"
tar -zxvf packages/pyexiv2.tar.gz /opt/clientname/lib/python2.7/site-packages/


