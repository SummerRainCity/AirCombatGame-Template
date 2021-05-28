using System;
using UnityEngine;

public class ObliqueThrow : MonoBehaviour
{
    private readonly float gravity = -9.8f;     //重力加速度
    private Vector2 horizontalDir;              //水平方向
    private float startSpeed;                   //初速度
    private float sinValue;                     //sin值
    private float cosValue;                     //cos值
    private Vector3 startPos;                   //开始位置
    private float endY;                         //结束高度(地面高度)
    private float timer;                        //运动消耗时间
    private Action<GameObject> finishCallBack;  //落地后的回调
    private bool canMove = false;               //能否运动
    private float rateOfDescent = 0.1f;         //下降速率，越大落得越快（默认0.5f）

    public bool isDebug = false;

    private void Update()
    {
        if (!canMove)
        {
            return;
        }

        //移动过程
        timer = timer + Time.deltaTime;

        float xOffset = startSpeed * timer * cosValue * horizontalDir.x;
        float zOffset = startSpeed * timer * cosValue * horizontalDir.y;
        float yOffset = startSpeed * timer * sinValue + rateOfDescent * gravity * timer * timer;

        Vector3 endPos = startPos + new Vector3(xOffset, yOffset, zOffset);
        if (endPos.y < endY)
        {
            endPos.y = endY;
            canMove = false;
        }
        transform.position = endPos;

        //移动结束
        if (!canMove)
        {
            finishCallBack(gameObject);
            Destroy(this);
        }

        if (isDebug)
        {
            GameObject go = GameObject.CreatePrimitive(PrimitiveType.Sphere);
            Destroy(go, 5);
            go.transform.position = transform.position;
            go.GetComponent<MeshRenderer>().material.color = Color.red;
            go.transform.localScale = new Vector3(0.5f, 0.5f, 0.5f);
        }
    }

    /// <summary>
    /// 开始斜抛物体：（1）、设定水平方向--（2）、初速度--（3）、角度
    /// </summary>
    /// <param name="horizontalDir">水平方向</param>
    /// <param name="startSpeed">起始初速度</param>
    /// <param name="angle">向上或向下的角度</param>
    /// <param name="endY">离地面多少米结束</param>
    /// <param name="finishCallBack">回调事件</param>
    public void StartMove(Vector2 horizontalDir, float startSpeed, float angle, float endY, Action<GameObject> finishCallBack)
    {
        this.horizontalDir = horizontalDir;
        this.startSpeed = startSpeed;
        sinValue = Mathf.Sin(Mathf.Deg2Rad * angle);
        cosValue = Mathf.Cos(Mathf.Deg2Rad * angle);
        startPos = transform.position;
        this.endY = endY;
        timer = 0;
        this.finishCallBack = finishCallBack;
        canMove = true;
    }
}