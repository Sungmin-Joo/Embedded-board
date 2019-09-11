#include<stdio.h>
#include<math.h>
#define pie 3.14159265358979323846 //파이 정의
main()
{
	double x = 1;
	double y = sqrt(3);
	double degree = 0;
	degree =atan2(y,x);
	printf("%f\n",degree*(180/pie));	

}
