# Author: Mike Stemle, Jr.
#

use strict;use warnings;
use Data::Dumper;

{
	package MyUiLoop;

    use Data::Dumper;
	
	sub new {
		my ($pkg, %opts) = @_;
		
		my $self = {%opts};
		
		$self->{_kill_loop} = 0;
		$self->{_event_hooks} = {};
		
		return bless($self, $pkg);
	}
	
	# Callbacks for hooks have arguments:
	# - MyUiLoop Instance (the caller)
	# - $droid An instance of Android
	# - $event The event data
	# - $data The extra data that was registered with the hook
	
	sub set_hook {
		my ($self, $event_type, $id, $callback, $data) = @_;
		
		$self->{_event_hooks}->{$event_type}->{$id} = {
			callback => $callback,
			data     => $data,
		};
		
		return $self;
	}
	
	sub clear_hook {
		my ($self, $event_type, $id) = @_;
		
		delete $self->{_event_hooks}->{$event_type}->{$id};
		
		return $self;
	}
	
	sub _call_hook {
		my ($self, $droid, $event) = @_;
		
		my $event_type = $event->{result}->{name};
		my $id = $event->{result}->{data}->{id};
		
		if (!exists $self->{_event_hooks}->{$event_type} ||
		    !exists $self->{_event_hooks}->{$event_type}->{$id}) {
			main::double_print($droid, "No hook for '$event_type' and id '$id'");
			return;
		}
		my $hook = $self->{_event_hooks}->{$event_type}->{$id};
		
		if (!defined($hook) || !ref($hook)) {
			print "Bad hook!\n";
			return;
		}
		
		my $callback = $hook->{callback};
		my $data = $hook->{data};
		
		$callback->($self, $droid, $event, $data);
		
		return;
	}
	
	sub main_loop {
		my ($self, $droid) = @_;
		
		while ($self->{_kill_loop} == 0) {
			my $event = $droid->eventWait();
			
			print Dumper($event);
			$self->_call_hook($droid, $event);
		}
		
		# Yes, we keep going.
	}
	
	sub exit_main_loop {
		my ($self) = @_;
		
		$self->{_kill_loop} = 1;
		
		return $self;
	}
}

use Android;
use IO::File;

sub double_print {
	my ($droid, $msg) = @_;

    if (defined($droid) && ref($droid)) {
        $droid->log($msg);    	
    }	
	print "$msg\n";
}

our $single_read = 1024;
our $file_name = "/sdcard/sl4a/scripts/fullscreen.xml";

double_print(undef, "Starting");

my $uiIn = IO::File->new($file_name, O_RDONLY) || die("Failed to open file '$file_name' for reading: ".$!);

my $uiXml = "";

while ($uiIn->read(my $data, $single_read) != 0) {
	$uiXml .= $data;
}
double_print(undef, "I have UI XML: $uiXml");
$uiIn->close();

my $droid = Android->new();

double_print($droid, "I'm trying to show a UI layout");
$droid->fullShow($uiXml);
double_print($droid, "I think I succeeded in showing a UI layout");

my $businessEnd = MyUiLoop->new();

## Exit button
$businessEnd->set_hook(
    "click",
    "exit_button",
    sub {
        my ($caller, $droid, $event, $data) = @_;
        $caller->exit_main_loop();
        main::double_print($droid, "We got a request to exit!");
        
        return;    	
    },
    undef
);

## Battery Temp Button
$businessEnd->set_hook(
    "click",
    "talk",
    sub {
    	my ($caller, $droid, $event, $data) = @_;

        $droid->ttsSpeak("Something nice");    	
    	
    	return;
    }
);

## Starting the main loop! We don't stop this until something stops it for us!
$businessEnd->main_loop($droid);

$droid->fullDismiss();
double_print($droid, "I'm done here.");
