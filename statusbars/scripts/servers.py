import requests

URL = 'http://darkc.no-ip.org/puters'
#URL = 'http://darkc.dmz.se/puters'

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
        False : u'^low()^ca(1, curl http://archway:5433/wake/{puter}){puter}^ca()',
        True  : u'^norm()^ca(1, xterm -title {puter} -e ssh {puter}){puter}^ca()'
        }

def print_data(d):
    ms = reduce(
        lambda x,y:
            x + [(y[0],y[1]['running'])] +
            ([(z['vm'],z['running']) for z in y[1]['vms'] ] if 'vms' in y[1] and y[0] not in ('twoducks',) else []),
        d.iteritems(), [])
    return u'#'.join(map(lambda x: TEXT_COL[x[1]].format(puter=x[0]), ms))

if __name__ == '__main__':
    d = get_data()
    print u'text servers ' + print_data(d)
