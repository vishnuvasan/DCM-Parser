use strict;
use warnings;

#Importing all Function from the DCM_Parser Directory.Import specific Functions if you wish
use DCM_Parser;

#Getting the DCM File Name as a Command Line Distribution and Passing it to DCM_File Function
DCM_File($ARGV[0]);

#Setting the Tag Values in the DCM to be Default which means German Tags
Default_Tags(0);

#Declaration of Hash to Get the Values of Distribution Details
my ($Details,%Distributions_Details);

#Function to return a Hash Containing all the Distribution Details
$Details=Distributions_Details();

#DeReferencing the Obtained Hash Reference
%Distributions_Details=%$Details;

#Print All the Details contained in tha Hash

foreach my $Distribution (keys(%Distributions_Details))
{
	
		print "\n";
		print '+---------------------------------------',"\n";
		print "		DISTRIBUTION	: ",$Distribution,"\n";
		print "		SIZE			: ",$Distributions_Details{$Distribution}{'SIZE'},"\n";
		print "		DESCRIPTION		: ",$Distributions_Details{$Distribution}{'DESCRIPTION'},"\n";
		print "		FUNCTION		: ",$Distributions_Details{$Distribution}{'FUNCTION'},"\n";
		print "		X AXIS UNIT		: ",$Distributions_Details{$Distribution}{'X-AXIS-UNIT'},"\n";
		print "		X AXIS VALUE	: ",$Distributions_Details{$Distribution}{'X-AXIS-VALUE'},"\n";
		print '											-------------------------------------------+';
		print "\n\n";
}

