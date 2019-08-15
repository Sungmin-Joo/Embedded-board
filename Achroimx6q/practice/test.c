#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>

#define MAX_DIGIT 4
#define FND_DEVICE "/dev/fpga_fnd"

char* timeToString(struct tm *t);

int main(int argc, char **argv) {
	struct tm *t;
	time_t timer;
	
	//----------------------------
	int dev;
	unsigned char data[4];
	unsigned char retval;
	int i;
	int str_size;

	memset(data,0,sizeof(data));
	
	timer = time(NULL);    // 현재 시각을 초 단위로 얻기
	t = localtime(&timer); // 초 단위의 시간을 분리하여 구조체에 넣기
  	printf("%d\n",t->tm_min/10);
	if(argc != 2) {
		printf("please input the parameter! \n");
		return -1;
	}

	str_size = strlen(argv[1]);
	if(str_size > MAX_DIGIT)
	{
		printf("wrong num!\n");
		str_size = MAX_DIGIT;
	}

	for(i = 0;i <str_size; i++)
	{
		if((argv[1][i]<0x30)||(argv[1][i])>0x39) {
 			printf("Error! Invalid Value!\n");
 			return -1;
 		}	
 		data[i]=argv[1][i]-0x30;
	}

	dev = open(FND_DEVICE, O_RDWR);
 	if (dev<0) {
 		printf("Device open error : %s\n",FND_DEVICE);
 		exit(1);
 	}
 
	retval=write(dev,&data,4);
 	
	if(retval<0) {
 		printf("Write Error!\n");
 		return -1;
 	}

	memset(data,0,sizeof(data));
	sleep(1);
	
	retval=read(dev,&data,4);
	if(retval<0) {
		printf("Read Error!\n");
		return -1;
	}

	printf("Current FND Value : ");

	for(i=0;i<str_size;i++)
		printf("%d",data[i]);

	printf("\n");
	close(dev);
	//----------------------------
	timer = time(NULL);    // 현재 시각을 초 단위로 얻기
	t = localtime(&timer); // 초 단위의 시간을 분리하여 구조체에 넣기
	
	printf("%s\n", timeToString(t));
	printf("%d\n",t->tm_hour);
  	printf("%d\n",t->tm_min);
	return 0;
}


char* timeToString(struct tm *t) {
	static char s[20];

  	sprintf(s, "%04d-%02d-%02d %02d:%02d:%02d",
    	t->tm_year + 1900, t->tm_mon + 1, t->tm_mday,
		t->tm_hour, t->tm_min, t->tm_sec
    );

  	return s;
}	
//srand(time(NULL));
//a = rand();
