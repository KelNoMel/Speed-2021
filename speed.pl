#!/usr/bin/perl -w

### Initial Prep Start ###
# Identify args and create variables that will be important for
# the following commands

# Check for -n option argument and register command variable accordingly
$arg1 = $ARGV[0];
# -n option activated (1)
if ($arg1 eq '-n') {
    $command = $ARGV[1];
    $no_inp = 1;
# -n option unactivated (0)
} else {
    $command = $ARGV[0];
    $no_inp = 0;
}

# Allow commands to include whitespaces by removing them
$command =~ s/ //g;
# Allow commands to include comments by disregarding tail of #
my $comment = index ($command, '#');
if ($comment != -1) {
    $command = substr($command, 0, $comment);
}

### Initial Prep Finished, start commands ###

# Quit command
if ($command =~ /q$/) {

    # Get either a matching phrase or linenum to tell where to delete lines
    
    # Set default values for phrase and limit(linenum)
    my $phrase = '####';
    my $limit = -1;
    
    # Update phrase/limit values if specified in command
    # For phrase
    if ($command =~ /\/.*\//) {
        $phrase = substr($command, 1, -2);
    # For limit
    } elsif ($command =~ /^[1-9]/) {
        $limit = substr($command, 0, -1);
        # If $ address used, set special value to target last line
        if ($limit eq '$') {
            $limit = -2;
        }
    }

    # Execute command on input
    my $count = 1;
    while ( <STDIN> ) {
        # If match with any of the conditionals, print and skip to last (end loop)
        if (($count eq $limit) || (m/$phrase/)) {
            print "$_";
            last;
        # Otherwise continue printing
        } elsif ($no_inp == 0) {
            print "$_";
        }
        $count += 1;
    }


# Print command
} elsif ($command =~ /p$/) {

    # Get either a matching phrase or linenum to tell where to delete lines
    
    # Set default values for phrase and limit(linenum)
    my $phrase = '####';
    my $limit = -1;
    my $lowlim = -1;
    my $printall = -1;

    # Update phrase/limit values if specified in command
    # For limit
    if (($command =~ /^[1-9\$]/) || ($command =~ /^\/.*\/,/)) {
        $limit = substr($command, 0, -1);
        # If $ address used, set special value
        if ($limit eq '$') {
            $limit = -2;
        # Dealing with ranges
        } elsif ($limit =~ /,/) {
            ($lowlim, $limit) = split /,/, $limit;
            $printall = 0;
        }
    # For phrase
    } elsif ($command =~ /\/.*\//) {
        $phrase = substr($command, 1, -2);
    }

    # Execute command on input
    my $count = 1;
    my $backup = '####';
    while ( <STDIN> ) {
        
        # If working within range (subset 1)
        if ($lowlim ne -1) {
            
            # Check to see if crossing range boundaries
            # If not currently within range
            if ($printall == 0) {
                # Check within line to see if conditions put it into range
                # Matches a regex
                if ($lowlim =~ /^\/.*\/$/) {
                    my $match = substr($lowlim, 1, -1);
                    if (m/$match/) {
                        $printall = 1;
                    }
                # Or crossed into a specified linenum
                } elsif ($count == $lowlim) {
                    $printall = 1;
                }
                # If within range currently, execute command (print)
                if ($printall == 1) {
                    print "$_";
                }
            
            # If currently within range
            } elsif ($printall == 1) {
                # Can execute past linenum limit if matches regex
                my $prematch = substr($lowlim, 1, -1);
                if (m/$prematch/) {
                    print "$_";
                # Try to see if line is now out range, set printall to 0 if case
                # Matches a regex
                } elsif ($limit =~ /^\/.*\/$/) {
                    my $match = substr($limit, 1, -1);
                    if (m/$match/) {
                        $printall = 0;
                    }
                # Beyond linenum limit
                } elsif ($count > $limit) {
                    $printall = 0;
                # Previous checks didn't pass and still within range continue printing
                } else {
                    print "$_";
                }
            }
        
        # Command doesn't specify a range, execute as in subset 0
        
        # If fulfills either regex match or linenum condition, print
        } elsif (($count eq $limit) || (m/$phrase/)) {
            print "$_";
        # If no conditionals, print
        } elsif (($limit == -1) && ($phrase eq '####')) {
            print "$_";
        # $ address identified, save lines to backup
        } elsif ($limit == -2) {
            $backup = "$_";
        }
        # If -n not activated, print another line
        if ($no_inp == 0) {
            print "$_";
        }
        $count += 1;
    }
    # If backup has been used, at end of while loop print the most recent backup
    if ($backup ne '####') {
        print("$backup")
    }


# Delete command
} elsif ($command =~ /d$/) {
    # Get either a matching phrase or linenum to tell where to delete lines
    # Set default values for phrase and limit(linenum)
    my $phrase = '####';
    my $limit = -1;
    my $lowlim = -1;
    my $delall = -1;

    # Update phrase/limit values if specified in command
    # For limit
    if (($command =~ /^[1-9\$]/) || ($command =~ /^\/.*\/,/)) {
        $limit = substr($command, 0, -1);
        # If $ address used, set special value
        if ($limit eq '$') {
            $limit = -2;
        # Dealing with ranges
        } elsif ($limit =~ /,/) {
            ($lowlim, $limit) = split /,/, $limit;
            $delall = 0;
        }
    # For phrase
    } elsif ($command =~ /\/.*\//) {
        $phrase = substr($command, 1, -2);
    }

    # No conditionals, delete everying = don't print anything and just exit
    if (($phrase eq '####') && ($limit eq -1)) {
        exit(0);
    }

    # Execute command on input
    my $count = 1;
    my $backup = '####';

    while ( <STDIN> ) {
        
        # If working within range (subset 1)
        if ($lowlim ne -1) {
            
            # Check to see if crossing range boundaries
            # If not currently within range
            if ($delall == 0) {
                # Check within line to see if conditions put it into range
                # Matches a regex
                if ($lowlim =~ /^\/.*\/$/) {
                    my $match = substr($lowlim, 1, -1);
                    if (m/$match/) {
                        $delall = 1;
                    }
                # Or crossed into a specified linenum
                } elsif ($count == $lowlim) {
                    $delall = 1;
                }
                # If within range currently, execute command (delete)
                if ($delall == 0) {
                    print "$_";
                }
            
            # If currently within range
            } elsif ($delall == 1) {
                # Try to see if line is now out range, set printall to 0 if case
                # Matches a regex
                if ($limit =~ /^\/.*\/$/) {
                    my $match = substr($limit, 1, -1);
                    if (m/$match/) {
                        $delall = 0;
                    }
                # Beyond linenum limit
                } elsif ($count == $limit) {
                    $delall = 0;
                }
            }
        
        # Otherwise make sure -n is unactivated as well as no match (subset 0)
        # If doesn't match with regex match or linenum condition, print}
        } elsif ( ($no_inp == 0) && (! m/$phrase/) && ($count ne $limit) ) {
            
            # If working with $ address, save lines and print them later
            # This prevents us from printing the last line
            if ($limit == -2) {
                if ($backup ne '####') {
                    print($backup);
                }
                $backup = "$_"
            # If we are not working within a range, simply print
            }  else {
                print "$_";
            }
        }
        $count += 1;
    }


# Substitute command, Normal ver. Format ((/str/)*[0-9]*s/str1/str2/g*)
} elsif (($command =~ /[0-9]*s\//) || ($command =~ /\/.*\/s/)) {
    
    # Set default values for line/strtarget
    my $linetarg = -1;
    my $strtarg = '#####';
    my $lowlim = -1;
    my $suball = -1;
    my $numpos = index ($command, 's/');
    
    # If we're dealing with ranges (subset 1)
    if ($command =~ /^.*,.*s/) {
        my $strend = index ($command, 's/');
        my $ranges = substr($command, 0, $strend);
        ($lowlim, $linetarg) = split /,/, $ranges;
        $suball = 0;

    # Otherwise carry on normally (as subset 0)
    } else {
        # If string match in front of command is present
        if ($command =~ /^\/.*\/s/) {
            my $strend = index ($command, '/s');
            $strtarg = substr($command, 1, $strend - 1);
        }
        
        # If number representing line is present, extract
        if (($numpos != 0) && $strtarg eq '#####') {
            $linetarg = substr($command, 0, $numpos);
        }
    }

    # Check if the g option is active
    my $g_op = 0;
    if ($command =~ /g$/) {
        $g_op = 1;
    }

    # Get the two substrings used in the substitution
    # Default strings are ''
    my $str1 = '';
    my $str2 = '';
    my $combstr = '';
    if ($g_op == 1) {
        $combstr = substr($command, $numpos + 2, -2);
    } else {
        $combstr = substr($command, $numpos + 2, -1);
    }
    
    ($str1, $str2) = split /\//, $combstr;

    # We got all needed variables, continue to execute command
    
    # If there are conditionals (line matches $strtarg or $linetarg)
    if (($strtarg ne '#####') || ($linetarg ne -1)) {
        my $count = 1;
        while ( <STDIN> ) {
            my $line = $_;
            # If working within range (subset 1)
            if ($lowlim ne -1) {
                # Check to see if crossing range boundaries
                # If not within range
                if ($suball == 0) {
                    # Check for regex match
                    if ($lowlim =~ /^\/.*\/$/) {
                        my $match = substr($lowlim, 1, -1);
                        if (m/$match/) {
                            $suball = 1;
                        }
                    # Check for linenum match
                    } elsif ($count == $lowlim) {
                        $suball = 1;
                    }
                    # If now within range, execute substitution
                    if ($suball == 1) {
                        # If g option activated, sub all values
                        if ($g_op == 1) {
                            $line =~ s/$str1/$str2/g;
                            print($line);
                        # Otherwise only sub first occurence
                        } else {
                            $line =~ s/$str1/$str2/;
                            print($line);
                        }
                    
                    # Not within range, simply print line
                    } else {
                        if ($no_inp != 1) {
                            print($line);
                        }
                    }
                
                # If within range
                } elsif ($suball == 1) {
                    # Execute substitution
                    if ($g_op == 1) {
                        $line =~ s/$str1/$str2/g;
                        print($line);
                    } else {
                        $line =~ s/$str1/$str2/;
                        print($line);
                    }

                    # Check to see if moving out of range
                    if ($linetarg =~ /^\/.*\/$/) {
                        my $match = substr($linetarg, 1, -1);
                        if (m/$match/) {
                            $suball = 0;
                        }
                    } elsif ($count == $linetarg) {
                        $suball = 0;
                    }
                }
            
            # Continue as if subset 0
            # If matches regex or linenum, carry out substitution
            } elsif (($line =~ /$strtarg/) || ($count == $linetarg)) {
                if ($g_op == 1) {
                    $line =~ s/$str1/$str2/g;
                    print($line);
                } else {
                    $line =~ s/$str1/$str2/;
                    print($line);
                }
            # Otherwise print line
            } else {
                if ($no_inp != 1) {
                    print($line);
                }
            }
            $count += 1;
        }
    
    # Otherwise, perform substitution on all lines
    } else {
        while ( <STDIN> ) {
            my $line = $_;
            if ($g_op == 1) {
                $line =~ s/$str1/$str2/g;
                print($line);
            } else {
                $line =~ s/$str1/$str2/;
                print($line);
            }
            
        }
    }

}