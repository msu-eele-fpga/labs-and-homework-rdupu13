// getopt() use example 

#include <stdio.h>
#include <unistd.h>

char *file_path;
bool verbose = false;



/**
 * usage() - Prints usage information
 * 
 * 
 */
void usage(void)
{
	fprintf(stderr, "Usage:\n");
	fprintf(stderr, "    getopt_example [-hv] [f FILE]\n\n");
	fprintf(stderr, "    -h       show this usage text\n");
	fprintf(stderr, "    -v       be more verbose\n");
	fprintf(stderr, "    -f FILE  use FILE as input\n");
}



/**
 * main() - 
 * 
 * 
 * 
 */
int main (int argc, char **argv)
{	

	int opt_ret = getopt(argc, argv, "hvf:p::");
	
	if (opt_ret == 'h' | opt_ret == -1)
	{
		usage();
		return 1;
	}
	
	

	switch (opt_ret)
	{
		case 'h':
			usage();
			return 1;
			
		case 'v':
			printf("Verbose");		
			break;
			
		case 'p':
			printf("Pattern");
			break;
			
		case 'f':
			printf("File");
			break;
		
		case -1:
			usage();
			return 1;
		
		default:
			break;
	}

	
	return 0;
}
