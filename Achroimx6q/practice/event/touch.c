#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <linux/input.h>
#include <signal.h>

int main()
{
	int fd, ret,i;
	int x, y;
	int cnt = 0;
	pid_t pid;
	const char* evdev_path = "/dev/input/by-path/platform-imx-i2c.2-event";
	struct input_event iev[3];
	fd = open(evdev_path, O_RDONLY);
	if(fd < 0) {
		perror("error: could not open evdev");
		return -1;
	}

	pid = fork();
	if(pid == -1)
	{
		printf("can't fork, erro\n");
		exit(0);
	}
	else if(pid == 0){//0 = children pross
		while(1)
		{
			ret = read(fd, iev, sizeof(struct input_event)*3);
			if(ret < 0) {
				perror("error: could not read input event");
				break;
			}
 
			if(iev[0].type == 1 && iev[1].type == 3 && iev[2].type == 3)
			{
				printf("touch!!!!\n");
				printf("x = %d, y = %d \n",iev[1].value,iev[2].value);	
			}
			else if(iev[0].type == 0 && iev[1].type == 1 && iev[2].type == 0)
			{
				printf("hands off!!!\n");
			}
			else if(iev[0].type == 0 && iev[1].type == 3 && iev[2].type == 0 ||\
				iev[0].type == 3 && iev[1].type == 3 && iev[2].type == 0)
			{
				printf("touching...\n");
			}
		}
	}
	else{
		for(i = 0 ; i < 10 ; i ++)
		{
			printf("parents is alive\n");
			sleep(2);
		}
		kill(pid,SIGINT);
	}
	close(fd);

	return 0;

 

}
