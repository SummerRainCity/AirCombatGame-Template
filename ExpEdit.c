#include<stdio.h>
#include<stdlib.h>

//等级的次方，默认1(取值1-3即可，跨级最大经验加倍增加)
//lv^? * baseExp
#define VALUE 2

/*
日期：2021010208:24:17
经验值加成算法
*/

const int baseExp = 300;//基准值
int lv = 1;//当前等级
int lvMaxExp = 0;//当前等级最大经验
int lvCurrExp = 0;//当前经验值

void init()
{
    lvMaxExp = pow(lv,VALUE) * baseExp;
}

int getInput()
{
    int number = 0;
    printf("获得Exp：");
    scanf("%d",&number);
    return number;
}

void userInfo()
{
    printf("\n-------Player Info-------\n");
    printf("Lv.%d\n",lv);
    printf("Exp[%d/%d]\n",lvCurrExp,lvMaxExp);
    printf("-------End-------\n\n");
}

void addExp(int exp)
{
    /*
    第一种情况：经验值没有超过当前等级最大经验值
    第二种情况：经验值超过当前最大经验值，需要加x等级
    */
    if((exp+lvCurrExp) <= lvMaxExp) {
        lvCurrExp += exp;
    } else {
        int duoExp = (exp+lvCurrExp) - lvMaxExp;
        do {
            lv++;
            lvMaxExp = pow(lv,VALUE) * baseExp;
            if(duoExp>lvMaxExp)
                duoExp -= lvMaxExp;
        } while(duoExp > lvMaxExp);
        lvCurrExp = duoExp;
    }
}

int main(void)
{
    init();
    userInfo();

    //printf("-------EXP等级对应满级经验-------\n");

    for(int i = 1; i <= 100; i++)
    {
        //sleep(1);
        int a = pow(i,VALUE) * baseExp;
        printf("Lv.%d-MaxExp：%d\n",i,a);
    }

    while(1)
    {
        addExp(getInput());
        //system("clear");
        userInfo();
    }

    return 0;
}
