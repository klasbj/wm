import requests

URL = 'http://darkc.no-ip.org/puters'
#URL = 'http://darkc.dmz.se/puters'

def get_data():
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
        False : '^low()^ca(1, curl http://archway:5433/wake/{puter}){puter}^ca()',
        True  : '^norm()^ca(1, xterm -title {puter} -e ssh {puter}){puter}^ca()'
        }

def print_data(d):
    if d is None:
        return ''
    ms = []
    for k,v in d.items():
        ms.append((k,v['running']))
        if 'vms' in v and k not in ('twoducks',):
            for vm in v['vms']:
                ms.append((vm['vm'],vm['running']))
    return '#'.join(map(lambda x: TEXT_COL[x[1]].format(puter=x[0]), ms))

if __name__ == '__main__':
    d = get_data()
    print('text servers ' + print_data(d))
