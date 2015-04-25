#include "stdio.h"
#include "math.h"
  
int main() 
{
//    float inp;
//    while(1)
//    {
//        printf("Val ");
//        scanf("%f", &inp);
//        myservo = inp;
//        myservo2 = 1-inp;
//        printf("\r\nGoing to %f\r\n", inp);
//    }

    double PI = M_PI;

    double L1 = 14;
    double L2 = 30.5;
    double L3 = 2.5;
    double alpha = PI/4;
    double C = 30;
    double L4 = sqrt(L2*L2+L3*L3-2*L2*L3*cos(PI-alpha));
    double eta = acos((L3*L3+L4*L4-L2*L2)/(2*L3*L4));

    double range1degs = 160;
    double range2degs = 160;
    double offset1degs = 0;
    double offset2degs = 0;
    bool reverse1 = true;
    bool reverse2 = false;

    printf("L1 %f, L2 %f, L3 %f, L4 %f, eta %f, alpha %f\r\n", L1, L2, L3, L4, eta*180/PI, alpha*180/PI);

    for (int t = 0; t < 100; t++)
    {
        double r = 5;
        double x = r * cos(3*PI/2+PI*2*t/100.0) + C/2;
        double y = 30 + r * sin(3*PI/2+PI*2*t/100);

        double d3 = sqrt((C-x)*(C-x)+y*y);
        double theta2c = atan2(y, (C-x));
        double theta2d = acos((d3*d3+L1*L1-L4*L4) / (2*L1*d3));
        double theta2 = theta2c+theta2d;
        
        double x4 = C+L1*cos(PI-theta2);
        double y4 = L1*sin(PI-theta2);
        
        double delta = atan2(x4-x,y-y4);
        double x1 = x + L3*sin(delta - eta);
        double y1 = y - L3*cos(delta - eta);

        double d1 = sqrt(x1*x1+y1*y1);
        double theta1a = atan2(y1, x1);
        double theta1b = acos((d1*d1+L1*L1-L2*L2) / (2*L1*d1));
        
        double theta1 = theta1a+theta1b;
        
        // Servo 1 position
        double servo1degs = theta1 * 180 / PI + offset1degs;
        double servo1val = servo1degs / range1degs;
        if (reverse1)
            servo1val = 1 - servo1val;

        // Servo 2 position
        double servo2degs = theta2 * 180 / PI + offset2degs;
        double servo2val = servo2degs / range2degs;
        if (reverse2)
            servo2val = 1 - servo2val;

        // Cross check using different maths
        double theta1rev = theta1;
        double theta2rev = PI - theta2;
        double xh1 = L1 * cos(theta1rev);
        double yh1 = sin(theta1rev) * L1;
        double xh2 = C + L1 * cos(theta2rev);
        double yh2 = sin(theta2rev) * L1;
        double gamma = atan2((yh1-yh2), (xh1-xh2));
        double l = sqrt(pow(xh1-xh2,2)+pow(yh1-yh2,2));
        double h = sqrt(pow(L2,2)-pow(l/2,2));
        double xi = (xh1+xh2)/2 + (h * sin(gamma));
        double yi = (yh1+yh2)/2 + fabs(h * cos(gamma));

        double psichk = atan2((yi-yh2),(xh2-xi));
        double xu = xi - L3 * cos(psichk+alpha);
        double yu = yi + L3 * sin(psichk+alpha);

        printf("x %f, y %f, xu %f, yu %f, th1 %f, th2 %f\r\n", x, y, xu, yu, theta1, theta2);
        printf("th2c %f, th2d %f, theta2 %f, d3 %f, x4 %f, y4 %f, x1 %f, y1 %f, delta %f\r\n", 
                        theta2c*180/PI, theta2d*180/PI, theta2*180/PI, d3, x4, y4, x1, y1, delta*180/PI);
        printf("th1a %f, th1b %f, theta1 %f, d1 %f\r\n", 
                        theta1a*180/PI, theta1b*180/PI, theta1*180/PI, d1);
        printf("xh1 %f, yh1 %f, xh2 %f, yh2 %f, xi %f, yi %f, psichk %f, gamma %f, l %f, h %f\r\n", xh1, yh1, xh2, yh2, xi, yi, psichk*180/PI, gamma*180/PI, l, h);
        printf("s1degs %f, s1val %f, s2degs %f, s2val %f\r\n", servo1degs, servo1val, servo2degs, servo2val);
                
        if (servo1val < 0 || servo1val > 1.0)
            printf ("============ S1 OUT OF BOUNDS ==============\r\n");
        if (servo2val < 0 || servo2val > 1.0)
            printf ("============ S2 OUT OF BOUNDS ==============\r\n");
        if (fabs(x-xu)>0.01 || fabs(y-yu)>0.01)
            printf ("============ OUTPUT DISCRPENACY =============\r\n");
    }
}
