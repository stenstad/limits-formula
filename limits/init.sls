#!py
# -*- coding: utf-8 -*-

# will be overwritten by the runner
__pillar__ = {}


def run():
    data = __pillar__.get('limits', {})

    files = {'salt.conf': []}
    for section in data.values():
        for p in section:
            file = p.get('file', 'salt.conf')
            if file not in files:
                files[file] = []

            files[file].append(p)

    result = {}
    # not using iteritems for py3 compatiblity.
    for file, data in files.items():
        result['limits_' + file] = {
            'file.managed': [
                {'name': '/etc/security/limits.d/' + file},
                {'source': 'salt://limits/templates/limits.conf.jinja'},
                {'template': 'jinja'},
                {'user': 'root'},
                {'group': 'root'},
                {'mode': '0600'},
                {'context': {
                    'data': data
                }}
            ]
        }

    return result
