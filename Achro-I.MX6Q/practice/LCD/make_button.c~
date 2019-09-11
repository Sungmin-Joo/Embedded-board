/* FILENAME : fbmranrect.c */
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/mman.h>
#include <unistd.h>
#include <linux/fb.h>
#define deep_puple 44026
#define puple 60957
void make_button(int position_x, int frame_fd, struct fb_var_screeninfo fvs, short color,int mod);

int main(int argc, char** argv) {
	int check, frame_fd;
	short* pfbdata;
	struct fb_var_screeninfo fvs;
	int position_x = 500;
	if((frame_fd = open("/dev/fb0",O_RDWR))<0) {
		perror("Frame Buffer Open Error!");
		exit(1);
	}
 
	if((check=ioctl(frame_fd,FBIOGET_VSCREENINFO,&fvs))<0) {
		perror("Get Information Error - VSCREENINFO!");
		exit(1);
	}
    make_button(0, frame_fd, fvs,puple,0);
    make_button(200, frame_fd, fvs,deep_puple,1);
    make_button(400, frame_fd, fvs,puple,2);
    make_button(600, frame_fd, fvs,deep_puple,3);
	close(frame_fd);
	return 0;
}

void make_button(int position_x, int frame_fd, struct fb_var_screeninfo fvs, short color,int mod)
{
	short* pfbdata;
	int repy, repx, offset, i =0, inc = 0 , j = 40;
	pfbdata = (short *) mmap(0, fvs.xres*fvs.yres*(sizeof(short)), PROT_READ| \
		PROT_WRITE, MAP_SHARED, frame_fd, 0); 
	
	if((unsigned)pfbdata == (unsigned)-1) {
		perror("Error Mapping!\n");
	}
	for(repy = 0 ; repy < 80 ; repy++)
	{
		offset = repy * fvs.xres;
		for(repx = 0 + position_x; repx < 150 + position_x; repx++)
		{
			if((repx >= 15+position_x || repy >= 15) && (repx < 135 + position_x || repy >= 15)&&\
				(repx >= 15+position_x || repy < 65) && (repx < 135 + position_x || repy < 65)) 
			{
				if(mod == 0)
				{	
					if((repx - position_x - 75)*(repx - position_x - 75) + (repy-40)*(repy-40) <= 529 &&\
						(repx - position_x - 75)*(repx - position_x - 75) + (repy-40)*(repy-40) >= 324)
						*(pfbdata+offset+repx) = 0;
					else
						*(pfbdata+offset+repx) = color;
				}
				else if(mod == 1)
				{	
					if((repx - position_x - 75 >= -20 && repx - position_x - 75 < 20) &&\
						(repy - 40 >= -20 && repy - 40 < 20)) 	
					{
						if((repy - 40 >= repx -75 - position_x -1) && (repy - 40 <= repx - 75 - position_x + 1))
							*(pfbdata+offset+repx) = 0;
						else if((repy - 40 <= -1 * (repx -75 - position_x) +1) && (repy - 40 >= -1*( repx - 75 - position_x) - 1))
							*(pfbdata+offset+repx) = 0;
						else
							*(pfbdata+offset+repx) = color;
					}
					else
						*(pfbdata+offset+repx) = color;
				}
				else if(mod == 2)
				{
					if((repy >= 20 && repy <= 60) && ((repx - position_x - 75 >= -1 * i) &&( repx - position_x - 75 <= i)))
					{
						*(pfbdata+offset+repx) = 0;
						inc = 1;
					}
					else
						*(pfbdata+offset+repx) = color;
				}
				else if(mod == 3)
				{
					if((repy >= 20 && repy <= 60) && ((repx - position_x - 75 >= -1 * j) &&( repx - position_x - 75 <= j)))
					{
						*(pfbdata+offset+repx) = 0;
						inc = 1;
					}
					else
						*(pfbdata+offset+repx) = color;
				}
			}
			else
			{
				if((repx - 15 - position_x)*(repx - 15 - position_x) + (repy-15)*(repy-15) <= 225)
					*(pfbdata+offset+repx) = color;
				else if((repx - 135 - position_x)*(repx - 135 - position_x) + (repy-15)*(repy-15) <= 225)
					*(pfbdata+offset+repx) = color;
				else if((repx - 15 - position_x)*(repx - 15 - position_x) + (repy-65)*(repy-65) <= 225)
					*(pfbdata+offset+repx) = color;
				else if((repx - 135 - position_x)*(repx - 135 - position_x) + (repy-65)*(repy-65) <= 225)
					*(pfbdata+offset+repx) = color;
				else
					*(pfbdata+offset+repx) = 0;	
			}
		}
		if(inc)
		{
			i++;
			j--;
			inc = 0;
			printf("%d\n",i);
		}
	}
	munmap(pfbdata,fvs.xres*fvs.yres*(sizeof(short))); // 맵핑된 메모리 해제
}
