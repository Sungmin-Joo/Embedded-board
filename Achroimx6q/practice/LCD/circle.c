/* FILENAME : fbmranrect.c */
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/mman.h>
#include <unistd.h>
#include <linux/fb.h>
#include <math.h>
#define pi 3.14159265358979323846
int list[46] = {0,349,698,1047,1396,1745,2094,2443,2792,3141,3490,3839,4188,4537,4886,5235,5585,5934,6283,6632,6981,7330,7679,8028,8377,8726,9075,9424,9773,10122,10471,10821,11170,11519,11868,12217,12566,12915,13264,13613,13962,14311,14660,15009,15358,15707};
int list_x[46] = {10000,9993,9975,9945,9902,9848,9781,9702,9612,9510,9396,9271,9135,9063,8910,8746,8571,8386,8191,7986,7771,7547,7313,7071,6819,6560,6293,6018,5735,5446,5150,4848,4694,4383,4226,3907,3583,3255,2923,2588,2249,2079,1736,1391,1045,697};

void swap(int *swapa, int *swapb);
short random_pixel(void);

int main(int argc, char** argv) {
	int check, frame_fd;
	short pixel;
	int offset, posx1, posy1, posx2, posy2;
	int repx, repy,count = 0 ;
	short* pfbdata;
	struct fb_var_screeninfo fvs;
	int x=0, y=0,i;
	int r[45];
	int slide = 0;
	for(i = 0; i < 45;i++)
	{
		r[i] = 500;
	}
	if((frame_fd = open("/dev/fb0",O_RDWR))<0) {
		perror("Frame Buffer Open Error!");
		exit(1);
	}
 
	if((check=ioctl(frame_fd,FBIOGET_VSCREENINFO,&fvs))<0) {
		perror("Get Information Error - VSCREENINFO!");
		exit(1);
	}
 
	pfbdata = (short *) mmap(0, fvs.xres*fvs.yres*(sizeof(pixel)), PROT_READ| \
		PROT_WRITE, MAP_SHARED, frame_fd, 0); 

	if((unsigned)pfbdata == (unsigned)-1) {
		perror("Error Mapping!\n");
	}
	r[14] = 310;
	r[15] = 300;
	r[16] = 290;
	r[17] = 300;
	r[18] = 310;
	r[23] = 140;
	r[24] = 150;
	r[25] = 160;
	r[26] = 170;
	r[27] = 180;
	//left circle
	for(i = 0; i < 45;i++)
	{
		//for(repy = 599; repy >= 0; repy--)
		for(repy = 599; repy >= 599-(r[i]*sin((count + 2)*(pi/180))); repy--)
		{
			offset = repy * fvs.xres;
			//for(repx = 512; repx < 1024; repx++)
			for(repx = 512; repx < 512 + ((r[i]*list_x[i])/10000); repx++)
			{
				x = repx - 512;
				y = 599 - repy;				
				if((x)*(x) + (y)*(y) <= r[i]*r[i])
				{	
					slide = atan2(y,x)*10000;
					if(slide <= list[i + 1] && slide >= list[i])
						*(pfbdata+offset+repx) = 992;
				}	
			}
		}
		//usleep(1);
		count+=2;
	}
	//left circle
	for(repy = 0; repy < 600; repy++)
	{
		offset = repy * fvs.xres;
		for(repx = 0; repx < 512; repx++)
		{
			x = repx - 511;
			y = repy - 599;
			
			if((x)*(x) + (y)*(y) <= r[i]*r[i])
				*(pfbdata+offset+repx) = 992;
			else
				*(pfbdata+offset+repx) = 0;
				
			usleep(1);
		}
	}
	munmap(pfbdata,fvs.xres*fvs.yres*(sizeof(pixel))); // 맵핑된 메모리 해제
	close(frame_fd);
	return 0;
}
short random_pixel(void) {
	return (int)(65536.0*rand()/(RAND_MAX+1.0));
}
void swap(int *swapa, int *swapb) {
	int temp;
	if(*swapa > *swapb) {
		temp = *swapb;
		*swapb = *swapa;
		*swapa = temp;
	}
}
