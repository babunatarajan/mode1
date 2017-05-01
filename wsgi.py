import os
import sys

_parent = lambda x: os.path.normpath(os.path.join(x, '..'))
_gparent = lambda x: os.path.normpath(os.path.join(x, '../..'))

DIRNAME = os.path.dirname(__file__)
PROJECT_ROOT = _parent(DIRNAME)

if not _parent(PROJECT_ROOT) in sys.path:
        sys.path.append(_parent(PROJECT_ROOT))
if not PROJECT_ROOT in sys.path:
        sys.path.append(PROJECT_ROOT)

path = '/opt/CLIENTNAME/E3/'
if path not in sys.path:
    sys.path.insert(0, '/opt/CLIENTNAME/E3')

os.environ['DJANGO_SETTINGS_MODULE'] = 'E3.production_settings'

import django.core.handlers.wsgi
application = django.core.handlers.wsgi.WSGIHandler()
