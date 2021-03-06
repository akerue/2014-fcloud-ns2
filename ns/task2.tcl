set ns [new Simulator]

$ns color 1 red
$ns color 2 blue
$ns color 3 cyan
$ns color 4 green
$ns color 5 orange
$ns color 6 black
$ns color 7 yellow
$ns color 8 purple
$ns color 9 gold
$ns color 10 chocolate

set nums 1

#Trace setup
set fall [open task2.tr w]
$ns trace-all $fall

set fnam [open task2.nam w]
$ns namtrace-all $fnam

set ftcp [open task2.tcp w]

# Dumbbell topology 
#
# s0              r0
#   \            /
#    \          /
#     n0------n1
#    /          \
#   /            \
# s1              r1
#
set s0 [$ns node]
set s1 [$ns node]
set n0 [$ns node]
set n1 [$ns node]
set r0 [$ns node]
set r1 [$ns node]

$ns duplex-link $s0 $n0 10Mb 20ms DropTail
$ns duplex-link $s1 $n0 10Mb 30ms DropTail

$ns duplex-link $n0 $n1 0.5Mb 10ms DropTail
$ns duplex-link-op $n0 $n1 queuePos 0.5

$ns duplex-link $n1 $r0 10Mb 10ms DropTail
$ns duplex-link $n1 $r1 10Mb 5ms DropTail

$ns duplex-link-op $n0 $s0 orient up-left
$ns duplex-link-op $n0 $s1 orient down-left
$ns duplex-link-op $n0 $n1 orient right
$ns duplex-link-op $n1 $r0 orient up-right
$ns duplex-link-op $n1 $r1 orient down-right

$ns queue-limit $n0 $n1 50
$ns queue-limit $n1 $n0 50

Agent/TCP set window_ 200000
Agent/TCP set ssthresh_ 200000

# FTP sender 0: Transport and Application
set tcp0 [new Agent/TCP/Newreno]
$tcp0 set class_ 1
$ns attach-agent $s0 $tcp0

set sink0 [new Agent/TCPSink]
$ns attach-agent $r0 $sink0

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

$ns connect $tcp0 $sink0

$tcp0 trace cwnd_
$tcp0 trace ssthresh_
$tcp0 attach-trace $ftcp

# FTP sender 1: Transport and Application
set tcp1 [new Agent/TCP/Newreno]
$tcp1 set class_ 1
$ns attach-agent $s1 $tcp1

set sink1 [new Agent/TCPSink]
$ns attach-agent $r1 $sink1

set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1

$ns connect $tcp1 $sink1

$tcp1 trace cwnd_
$tcp1 trace ssthresh_
$tcp1 attach-trace $ftcp


#
# Scenario
#
proc finish {} {
	global ns fall fnam ftcp
	$ns flush-trace
	close $fall
	close $fnam
	close $ftcp
	exit 0
}

$ns at 1.0 "$ftp0 start; $ns trace-annotate \"Time:[$ns now] Start FTP\""
$ns at 1.0 "$ftp1 start; $ns trace-annotate \"Time:[$ns now] Start FTP\""
$ns at 200.0 "$ftp0 stop; $ns trace-annotate \"Time:[$ns now] Stop FTP\""
$ns at 200.0 "$ftp1 stop; $ns trace-annotate \"Time:[$ns now] Stop FTP\""
$ns at 200.0 "finish"
#
# start simulatuion
#
$ns run
