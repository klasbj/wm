#!/usr/bin/env python

import sys
import os
from pulsectl import Pulse, PulseLoopStop

imgdir = './'

def sndimg(volume):
    if volume < 0.0:
        return 'snd-m.xpm'
    elif volume < .15:
        return 'snd-0.xpm'
    elif volume < .5:
        return 'snd-1.xpm'
    elif volume < .85:
        return 'snd-2.xpm'
    else:
        return 'snd-3.xpm'

def output(pulse):
    default_sink_name = pulse.server_info().default_sink_name
    default_sink = None
    for sink in pulse.sink_list():
        if sink.name == default_sink_name:
            default_sink = sink
            break
    else:
        return
    if default_sink.mute:
        volume = -1.0
    else:
        volume = pulse.volume_get_all_chans(default_sink)
    print('text volume ^i({},12)'.format(os.path.join(imgdir, sndimg(volume))))
    sys.stdout.flush()

if __name__ == '__main__':
    if len(sys.argv) > 1:
        imgdir = sys.argv[1]

    with Pulse('volumebar') as pulse:
        def cb(ev):
            raise PulseLoopStop

        pulse.event_mask_set('sink') # listen for sink changes
        pulse.event_callback_set(cb)


        while True:
            output(pulse)
            pulse.event_listen(60)
