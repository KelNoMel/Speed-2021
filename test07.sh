#!/bin/dash

# A test for the substitution command

# Print a seq 18-22
seq 18 22 | ./speed.pl 's/1/A/' > output.txt

if cat output.txt | grep -q '18'; then
    echo '18 Should not be in output'
    rm output.txt
    exit 1
fi

if cat output.txt | grep -q '19'; then
    echo '19 Should not be in output'
    rm output.txt
    exit 1
fi

if cat output.txt | grep -q '21'; then
    echo '21 Should not be in output'
    rm output.txt
    exit 1
fi

# Check for numbers that should be printed
if cat output.txt | grep -q 'A8'; then
    continue
else
    echo 'Missing output A8'
    rm output.txt
    exit 1
fi

if cat output.txt | grep -q 'A9'; then
    continue
else
    echo 'Missing output A9'
    rm output.txt
    exit 1
fi

if cat output.txt | grep -q '2A'; then
    continue
else
    echo 'Missing output 2A'
    rm output.txt
    exit 1
fi

if cat output.txt | grep -q '20'; then
    continue
else
    echo 'Missing number 20'
    rm output.txt
    exit 1
fi

if cat output.txt | grep -q '22'; then
    continue
else
    echo 'Missing number 22'
    rm output.txt
    exit 1
fi

echo 'Test passed'
rm output.txt