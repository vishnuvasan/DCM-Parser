use strict;
use warnings;

#Importing all Function from the DCM_Parser Directory.Import specific Functions if you wish
use DCM_Parser;

#Getting the DCM File Name as a Command Line Parameter and Passing it to DCM_File Function
DCM_File($ARGV[0]);

#Setting the Tag Values in the DCM to be Default which means German Tags
Default_Tags(0);

#Declaration of Hash to Get the Values of Parameter Details
my ($Details,%Parameters_Details);

#Function to return a Hash Containing all the Parameter Details
$Details=Parameters_Details_Print();

#DeReferencing the Obtained Hash Reference
%Parameters_Details=%$Details;

#Print All the Details contained in tha Hash
foreach my $Parameter (keys(%Parameters_Details))
{
	
		print "\n";
		print '+---------------------------------------',"\n";
		
		#Each Key of the Hash will be a Parameter
		print "		PARAMETER		: ",$Parameter,"\n";
		
		#Syntax to Get the Parameter Description
		print "		DESCRIPTION		: ",$Parameters_Details{$Parameter}{'DESCRIPTION'},"\n";
		
		#Syntax to Get the Function in which the Parameter is Used
		print "		FUNCTION		: ",$Parameters_Details{$Parameter}{'FUNCTION'},"\n";
		
		#Syntax to Get the Unit of the Parameter
		print "		UNIT			: ",$Parameters_Details{$Parameter}{'UNIT'},"\n";
		
		#Syntax to Get the Value of the Paramter
		print "		VALUE			: ",$Parameters_Details{$Parameter}{'VALUE'},"\n";
		
		print '											-------------------------------------------+';
		print "\n\n";
}

