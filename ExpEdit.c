import java.util.*;
import java.lang.Runtime;
import java.io.IOException;
/*
经验值加成算法
时间：2022年1月23日-08:08:24
*/
public class A
{
    static int getInput() {
        System.out.printf("输入：");
        Scanner sc = new Scanner(System.in);
        int number = sc.nextInt();
        return number;
    }

    public static void main(String[] args) throws InterruptedException, IOException
    {   
        Player p = new Player("颜程雨",300,150,30,60,30,40);
        p.playerInfo();
        while(true) {
            int exp = getInput();
            p.addExp(exp);
            p.updateRank();

            Runtime r = Runtime.getRuntime();
            r.exec("clear");
            
            p.playerInfo();
        }
    }
}

class Player 
{
    String name = "匿名";
    double VALUE = 2;
    double baseExp = 300;//基准值
    double lv = 1;//当前等级
    double lvMaxExp = 0;//当前等级最大经验
    double lvCurrExp = 0;//当前经验值

    double smz = 300;
    double hlz = 150;
    double ll = 30;
    double fy = 60;
    double mj = 30;
    double js = 40;

    public Player() {
        lvMaxExp = Math.pow(lv,VALUE) * baseExp;
    }

    public Player(String name,double smz,double hlz,double ll,double fy,double mj,double js) {
        lvMaxExp = Math.pow(lv,VALUE) * baseExp;
        this.name = name;
        this.smz = smz;
        this.hlz = hlz;
        this.ll = ll;
        this.fy = fy;
        this.mj = mj;
        this.js = js;
    }

    public void playerInfo() {
        System.out.printf("\n-------["+name+"]-------\n");
        System.out.printf("Lv.%.0f-",lv);//.0f表示保留0位小数
        System.out.printf("(%.0f/%.0f)",lvCurrExp,lvMaxExp);

        System.out.printf("\n[");
        if(lv >= 1 && lv <= 9)System.out.printf("魂士");
        if(lv >= 10 && lv <= 19)System.out.printf("魂师");
        if(lv >= 20&&lv <= 29)System.out.printf("大魂师");
        if(lv >= 30&&lv <= 39)System.out.printf("魂尊");
        if(lv >= 40&&lv <= 49)System.out.printf("魂宗");
        if(lv >= 50&&lv <= 59)System.out.printf("魂王");
        if(lv >= 60&&lv <= 69)System.out.printf("魂帝");
        if(lv >= 70&&lv <= 79)System.out.printf("魂圣");
        if(lv >= 80&&lv <= 89)System.out.printf("魂斗罗");
        if(lv >= 90&&lv <= 99)System.out.printf("封号斗罗");
        if(lv > 99)System.out.printf("神");
        System.out.printf("]\n");

        System.out.printf("生命值：%5.0f\n",smz);
        System.out.printf("魂力值：%5.0f\n",hlz);
        System.out.printf("力量：%5.0f\n",ll);
        System.out.printf("防御：%5.0f\n",fy);
        System.out.printf("敏捷：%5.0f\n",mj);
        System.out.printf("精神：%5.0f\n",js);
        //System.out.printf("魂环：黄、黄、紫、紫、黑、黑、黑、红、红、红、红、橙金\n");
        
        /*
        System.out.printf("技能：\n");
        System.out.printf("\t1-普通攻击(只靠力量进行攻击)\n");
        System.out.printf("\t2-三界审判之剑(AOE)\n");
        System.out.printf("\t3-海神黄昏(AOE)\n");
        System.out.printf("\t4-空间凝聚(领域)\n");
        System.out.printf("\t5-虚空之境(精神攻击，最高3层梦境，敌人全属削弱)\n");
        */
        System.out.printf("\n-------[End]-------\n\n");
    }

    public void updateRank() {
        /*
        等级提升属性加成比例
        生命值=1-10，2倍
        魂力值=1-11，3-10
        力量=13-1，2倍
        防御=13-1，1-5
        敏捷=14-1，7-3
        精神=14-1，2倍
        */
        if(lv%10 == 0) {
            //printf("Tip：等级上限突破\n");
            smz += smz * 1/10;
            hlz += hlz * 1/16;
            ll += ll * 1/14;
            fy += fy * 1/15;
            mj += mj * 1/17;
            js += js * 1/16;
        } else {
            //printf("Tip：Lv Up ++！\n");
            smz += smz * 1/22;
            hlz += hlz * 1/25;
            ll += ll * 1/21;
            fy += fy * 1/23;
            mj += mj * 1/20;
            js += js * 1/23;
        }
    }

    public void addExp(double exp) {
        if(lv >= 150) return;
        /*
        第一种情况：经验值没有超过当前等级最大经验值
        第二种情况：经验值超过当前最大经验值，需要加x等级
        */
        if((exp+lvCurrExp) <= lvMaxExp) {
            lvCurrExp += exp;
        } else {
            double duoExp = (exp+lvCurrExp) - lvMaxExp;
            do {
                lv++;
                updateRank();//全属性加成
                lvMaxExp = Math.pow(lv,VALUE) * baseExp;
                if(duoExp>lvMaxExp)
                    duoExp -= lvMaxExp;
            } while(duoExp > lvMaxExp);
            lvCurrExp = duoExp;
        }
    }
}
