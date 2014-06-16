#include <string.h>
#include <strings.h>
#include <stdlib.h>

int ZipFile(char *fileName, int zipFlag) {
	char sCmd[256];
	
	if(zipFlag) {
		if(0 == strncasecmp(fileName+strlen(fileName)-3,".gz",3))
			return 0;
		strcpy(sCmd, "gzip ");
	} else {
		if(0 != strncasecmp(fileName+strlen(fileName)-3,".gz",3))
			return 0;
		strcpy(sCmd,"gunzip ");
	}
	strcat(sCmd,fileName);

	return system(sCmd);
}

int main(void) {
	char *fileName="hello.c";
	int zipFlag = 1;
	
	ZipFile(fileName,zipFlag);

	return 0;
}

