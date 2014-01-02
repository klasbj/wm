import requests

URL = 'http://darkc.no-ip.org/puters'

def get_data():
    j = {}
    try:
        r = requests.get(URL)
        r.raise_for_status()
        j = r.json()
        return j['hosts']
    except (requests.exceptions.ConnectionError
            , requests.exceptions.HTTPError
            , ValueError):
        return None

TEXT_COL = {
        False : u'^low()',
        True  : u'^norm()'
        }

def print_data(d):
    ms = reduce(
        lambda x,y:
            x + [(y[0],y[1]['running'])] +
            ([(z['vm'],z['running']) for z in y[1]['vms'] ] if 'vms' in y[1] else []),
        d.iteritems(), [])
    return u'#'.join(map(lambda x: TEXT_COL[x[1]] + x[0], ms))

if __name__ == '__main__':
    d = get_data()
    print u'text servers ' + print_data(d)