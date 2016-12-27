#!/usr/bin/perl

use strict;
use Getopt::Std;
use LWP::UserAgent;

my $plugin_name = 'check_http_content';
my $VERSION             = '2';

my $perfdata ='';
my $return_perf='';

# getopt module config
$Getopt::Std::STANDARD_HELP_VERSION = 1;

# nagios exit codes
# On cherche a voir si on a des erreurs
# on inverse donc le code retour afin que si on detecte un mot
# il nous renvoie une erreur
use constant EXIT_OK            => 0;
use constant EXIT_WARNING       => 1;
use constant EXIT_CRITICAL      => 2;
use constant EXIT_UNKNOWN       => 3;


# parse cmd opts
my %opts;
getopts('vU:t:m:', \%opts);
$opts{t} = 60 unless (defined $opts{t});
if (not (defined $opts{U} and defined $opts{m})) {
        print "ERROR: INVALID USAGE\n";
        HELP_MESSAGE();
        exit EXIT_CRITICAL;
}

my $status = EXIT_OK;
# set trx timeout
my $ua = LWP::UserAgent->new;
$ua->timeout($opts{t});

# retrieve url
my $response = $ua->get($opts{U});


if (not $response->is_success) {
        print "ERROR: CANNOT RETRIEVE URL: ", $response->status_line, "\n";
        $status = EXIT_UNKNOWN;
} else {
        my $content = $response->content;
        if ($content =~ m/$opts{m}/gsm) {
                $perfdata = EXIT_CRITICAL;
                print "CONTENT ERROR: Expression found |content=$perfdata \n";
                exit $perfdata;
        } else {
                my @output_lines = split(/\n/, $content);
                $perfdata = EXIT_OK;
#               print "CONTENT ERROR: Expression not found (last: $output_lines[$#output_lines])\nfull output was:\n$content |content=$perfdata \n";
               print "CONTENT OK: Expression not found\n |content=$perfdata \n";
                exit $perfdata;
        }
}
#if ($status eq EXIT_OK){
#       $perfdata .= $status;
#       print " Status :$status|Perf:$perfdata \n ";
#       exit $perfdata;
#}
#if ($status eq EXIT_CRITICAL){
#       $perfdata .= $status;
#       print " Status :$status|Perf:$perfdata \n ";
#       exit $perfdata;
#}

#&print_exit($perfdata);

sub HELP_MESSAGE
{
        print <<EOHELP
        Retrieve an http/s URL and looks in its output for a given text.
        Returns CRITICAL is not found, OK if found, UNKNOWN otherwise.

        --help      shows this message
        --version   shows version information

        -U          URL to retrieve (http or https)
        -m <text>   Text to match in the output of the URL
        -t          Timeout in seconds to wait for the URL to load. If the page fails to load,
                    $plugin_name will exit with UNKNOWN state (default 60)

EOHELP
;
}
