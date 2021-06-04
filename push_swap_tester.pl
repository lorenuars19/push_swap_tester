#!/usr/bin/perl
use List::Util 'shuffle', 'min', 'max';

sub pass_or_fail {
	if (scalar(@_) != 2){print "ERROR", return 1;}

	$input = $NUM;
	my $result = @_[0];
	print "@_[1]";

	if ($input <= 3) {
		if ($result <= 3){
			print "\033[32;1mPASS\033[0m\n";
		}
		else {
			print "\033[31;1mFAIL\033[0m\n";
		}
	}
	elsif ($input <= 5) {
		if ($result <= 12){
			print "\033[32;1mPASS\033[0m\n";
		}
		else {
			print "\033[31;1mFAIL\033[0m\n";
		}
	}
	elsif ($input <= 100) {
		if ($result <= 700) {
			print "\033[32;1m5 points\033[0m\n";
		}
		elsif ($result <= 900) {
			print "\033[32;1m4 points\033[0m\n";
		}
		elsif ($result <= 1100) {
			print "\033[33;1m3 points\033[0m\n";
		}
		elsif ($result <= 1300) {
			print "\033[33;1m2 points\033[0m\n";
		}
		elsif ($result <= 1500) {
			print "\033[31;1m1 points\033[0m\n";
		}
		else {
			print "\033[31;1mFAIL\033[0m\n";
		}
	}
	elsif ($input <= 500) {
		if ($result <= 5500) {
			print "\033[32;1m5 points\033[0m\n";
		}
		elsif ($result <= 7000) {
			print "\033[32;1m4 points\033[0m\n";
		}
		elsif ($result <= 8500) {
			print "\033[33;1m3 points\033[0m\n";
		}
		elsif ($result <= 10000) {
			print "\033[33;1m2 points\033[0m\n";
		}
		elsif ($result <= 11500) {
			print "\033[31;1m1 points\033[0m\n";
		}
		else {
			print "\033[31;1mFAIL\033[0m\n";
		}
	}
}

sub print_stats {
	$n = scalar(@_);
	$sum = 0;
	if ($n == 0) {
		print "Number List Empty, \$n == 0\n"; exit (1);
	}
	foreach $item (@_) {
		$sum += $item;
	}
	$average = $sum / $n;
	print "\r\033[34;1m"." " x 300 ."\r";
	$/ = ' ';
	$min = min(@_); $min =~ s/\n//g;
	$max = max(@_); $max =~ s/\n//g;
	print "INPUT : ".$NUM."\nMin "."$min"."\nMax "."$max"."\nAverage : $average\033[0m\n";

	$input = $NUM;
	print "Pass or Fail ?\n";
	pass_or_fail($max, "Max : ");
	pass_or_fail($average, "Average : ");

}
sub gen_list {
	$Max = $NUM;
	# $RndMax = $Max * 10;
	$RndMax = 0;
	# $index=-$NUM/2;
	$index=-1;
	for($i = 0; $i < $Max; $i++)
	{
		$tmp = 1 + int(rand() * $RndMax);
		$index += $tmp;
		if (0 && (rand() * 5) % 5 == 0) {
			push(@numbers, -$index);
		}
		else {
			push(@numbers, $index);
		}
	}
}
sub	list_check_sorted {
	my $not_sorted = 0;
	for ($i = 0; $i < ((scalar @numbers) - 1); $i++) {
		if ($numbers[i] < $numbers[i + 1]) {
			$not_sorted = 1;
		}
	}
	return ($not_sorted)
}
sub generate_numbers {
	gen_list();
	while (list_check_sorted()) {
		@numbers = shuffle(@numbers);
	}
}
if ((scalar @ARGV) != 2)
{
	print "Usage :\nperl $0 [StackSize] [NumTests]\n";
	exit 0;
}

$NUM = @ARGV[0];
$NUM_TEST = @ARGV[1];
print "\033[s";

my @wait = (	".    ", "..   ", "...  ", ".... " , ".....", " ....", "  ...", "   ..", "    .",
				"     ", "    .", "   ..", "  ...", " ....", ".....", ".... ", "...  ", "..   ");
for ($test = 0; $test < $NUM_TEST; $test++)
{
	print "\033[u\033[\033[3".(2 + ($test / ($NUM_TEST / 10)) % 3).";1mGetting results \033[0m".($test + 1)."/".$NUM_TEST." \033[32;1m".@wait[(($test / ($NUM_TEST / 25)) % @wait)]."\033[0m ";
	@numbers = ( );
	generate_numbers();

	# print "@numbers"." " x 300 ."";

	$cmd = "timeout 15 ./push_swap ".join(' ', @numbers)." | ./checker ".join(' ', @numbers);
	$res = `$cmd`;
	if ($res eq "KO\n")	{
		print "\n\033[1T\033[31;1mKO Checker\033[0m"." " x 50 ."\n";
		print "@numbers\n\n"; exit 1;
	}
	$cmd = "./push_swap ".join(' ', @numbers)." | wc -l";
	$res = `$cmd`;
	push(@results, $res);
}
print_stats(@results);
