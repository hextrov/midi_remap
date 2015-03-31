#!/usr/bin/env perl
use strict;
use MIDI::ALSA(':CONSTS');
use Getopt::Long;

MIDI::ALSA::client('midi_remap', 1, 1, 0);

my $help = '';
my $toggle = '';

GetOptions ("help" => \$help,
            "toggle" => \$toggle)
        or help();

    if ($help == 1) { help(); }

my @ccs = (0) x 127;
my $ccv = 0;

while(1) {
    my @alsaevent = MIDI::ALSA::input();
    if ($alsaevent[0] == SND_SEQ_EVENT_PGMCHANGE()) {
        my $ch = $alsaevent[7][0];
        my $pc = $alsaevent[7][5];
       

        # toggle cc values, effects on/off etc
    
        if ($toggle == 1) {
            if ($ccs[$pc] == 0) {
                $ccs[$pc] = 127;
                $ccv = 127;
            } else {
                $ccs[$pc] = 0;
                $ccv = 0;
            };
        };

        my @msg = MIDI::ALSA::controllerevent($ch, $pc, $ccv);
        MIDI::ALSA::output(@msg);
    }
}

sub help
{
    print("-h --help            This help \n");
    print("-t --toggle          Toggle CC values \n");
    exit;
}
