#!/usr/bin/perl
use List::Util 'shuffle', 'min', 'max';

sub gen_list {
	$hardcore_mode = 0;
	$Max = $NUM;
	$RndMax = 0;
	if ($hardcore_mode){
		$RndMax = $Max * 10;
	}
	# $index=-$NUM/2;
	$index=-1;
	for($i = 0; $i < $Max; $i++)
	{
		$tmp = 1 + int(rand() * $RndMax);
		$index += $tmp;
		if ($hardcore_mode && (rand() * 5) % 5 == 0) {
			push(@numbers, -$index);
		}
		else {
			push(@numbers, $index);
		}
	}
}

sub	find_minimum {
	$min = ~0>>1;
	$min_pos = 0;
	for (my $i = 0; $i < ((scalar @numbers)); $i++) {
		if ($numbers[$i] < $min){
			$min = $numbers[$i];
			$min_pos = $i;
		}
	}
}

sub	list_check_sorted {
	$disorder_factor = 0;
	my	$minimun_visited = 0;
	my	$not_sorted = 0;
	my	$i = min_pos;
	my	$tmp = 0;
	my	$max = 0;

	$min;
	$min_pos;
	find_minimum();

	while ($i >= 0 && $i < ((scalar @numbers))) {

		$tmp = $numbers[$i];

		if ($tmp > $max) {
			$max = $tmp;
		}
		elsif ($tmp < $max) {
			$disorder_factor++;
		}

		if ($tmp == $min) {
			$minimun_visited++;
		}

		$i++;

		if ($i >= (scalar @numbers)) {
			$i = 0;
		}
		if ($minimun_visited > 0) {
			return ($disorder_factor);
		}
	}
}

sub generate_worst_case {

	$disorder_factor = 0;

	gen_list();
	while (!$disorder_factor) {
		@numbers = shuffle(@numbers);
		$disorder_factor = list_check_sorted();
	}
	print("@numbers\n");
}



$NUM = @ARGV[0];

generate_worst_case();


# $cmd = "timeout 15 ./push_swap ".join(' ', @numbers)." | ./checker ".join(' ', @numbers);
# $res = `$cmd`;
# if ($res eq "KO\n")	{
# 	print "\n\033[1T\033[31;1mKO Checker\033[0m"." " x 50 ."\n";
# 	print "@numbers\n\n"; exit 1;
# }
# $cmd = "./push_swap ".join(' ', @numbers)." | wc -l";
# $res = `$cmd`;
# print("InstrCount ".$res);
