#!/bin/bash
if [[ $# -ne 1 ]] && [[ -z $ARG ]]
then
	printf "Usage:\n$0 [number of elements]\n"
	exit 1
fi

if [[ $1 -lt 80 ]]
then
	VERBOSE='-v'
else
	VERBOSE=''
fi
# VERBOSE=''


if [[ -z $ARG ]]; then
	LIST=$(perl generate_worst_case.pl $1)
else
	LIST=$ARG
fi
echo "LIST = "${LIST[@]}
if [[ -z "${LIST[@]}" ]]
then
	echo LIST IS EMPTY
	exit 1;
fi

TIMEOUT=.6
printf "===== PUSH_SWAP =====\n"
# timeout $TIMEOUT
./prg_push_swap/push_swap $VERBOSE "${LIST[@]}"
# ./prg_push_swap/push_swap "${LIST[@]}"

printf "===== PUSH_SWAP + CHECKER =====\n"
printf "LIST = %s \n" "${LIST[@]}"
# ./prg_push_swap/push_swap "${LIST[@]}"
#timeout $TIMEOUT
./prg_push_swap/push_swap "${LIST[@]}" | ./prg_checker/checker "${LIST[@]}" || exit $?
printf "Count "
./prg_push_swap/push_swap "${LIST[@]}" | wc -l || exit $?


NUM_TEST=1000

# time perl push_swap_tester.pl $NUM $NUM_TEST
