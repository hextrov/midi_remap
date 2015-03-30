#!/usr/bin/env perl
use strict;
use MIDI::ALSA(':CONSTS');
MIDI::ALSA::client('midi_remap', 1, 1, 0);

while(1) {
    my @alsaevent = MIDI::ALSA::input();
    if ($alsaevent[0] == SND_SEQ_EVENT_PGMCHANGE()) {
        my $ch = $alsaevent[7][0];
        my $pc = $alsaevent[7][5];
        my @msg = MIDI::ALSA::controllerevent($ch, $pc, 0);
        MIDI::ALSA::output(@msg);
    }
}