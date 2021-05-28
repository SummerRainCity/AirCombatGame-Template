using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 导弹管理经理
/// </summary>
public class WQ : MonoBehaviour
{
    [Header("按下此键发射导弹")]
    public KeyCode mKeyCode_Q = KeyCode.Q;
    [Header("按下此键发射火箭弹")]
    public KeyCode mKeyCode_R = KeyCode.R;
    [Header("按下此键投弹")]
    public KeyCode mKeyCode_Space = KeyCode.Space;
    [Header("导弹追随相机")]
    private Camera camera_;
    [Header("敌人")]

    ////////////////////////////////////////////////////////
    //将实时获取飞机数据
    UnityStandardAssets.Vehicles.Aeroplane.AeroplaneController aeroplane = null;
    [Header("投弹水平方向，这与飞机旋转Y轴一致")]//单位元，Sin-Cos计算方向
    private Vector2 direction = new Vector2(0, 0);

    public Queue<GameObject> enemy;
    private Queue<Missile_HuoJianDan> q_HuoJIanDan = null;
    private Queue<Missile_Intercept> q_DaoDan = null;
    private Queue<Bomb> q_ZhaDan = null;

    private void Start()
    {
        UnityStandardAssets.Cameras.Follow mc = FindObjectOfType<UnityStandardAssets.Cameras.Follow>();
        if (mc)
        {
            camera_ = mc.GetComponent<Camera>();
        }
        //获取强力追踪弹
        Missile_Intercept[] a_array = FindObjectsOfType<Missile_Intercept>();
        if (a_array.Length > 0)
        {
            q_DaoDan = new Queue<Missile_Intercept>();
            for (int i = 0; i < a_array.Length; i++)
            {
                q_DaoDan.Enqueue(a_array[i]);
            }
        }
        //获取常规导弹
        Missile_HuoJianDan[] b_array = FindObjectsOfType<Missile_HuoJianDan>();
        if (b_array.Length > 0)
        {
            q_HuoJIanDan = new Queue<Missile_HuoJianDan>();
            for (int i = 0; i < b_array.Length; i++)
            {
                q_HuoJIanDan.Enqueue(b_array[i]);
            }
        }
        //获取炸弹
        Bomb[] q_array = FindObjectsOfType<Bomb>();
        if (q_array.Length > 0)
        {
            q_ZhaDan = new Queue<Bomb>();
            for (int i = 0; i < q_array.Length; i++)
            {
                q_ZhaDan.Enqueue(q_array[i]);
            }
        }
    }

    // Update is called once per frame
    private void Update()
    {
        if (Input.GetKeyDown(mKeyCode_R))
        {
            Launch_Rocket();
        }
        if (Input.GetKeyDown(mKeyCode_Q))
        {
            Launch_Missile();
        }
        if (Input.GetKeyDown(mKeyCode_Space))
        {
            Launch_Bomb();
        }
    }

    public void Launch_Bomb()
    {
        if (q_ZhaDan != null && q_ZhaDan.Count != 0)
        {
            Bomb bomb = q_ZhaDan.Dequeue();
            if (camera_)
                camera_.GetComponent<UnityStandardAssets.Cameras.Follow>().SetTarget(bomb.gameObject.transform);//镜头追踪
            bomb.transform.rotation = Quaternion.Euler(transform.eulerAngles);//调整追踪弹与飞机姿态平齐
            bomb.Launch();
        }
    }

    public void Launch_Missile()
    {
        if (q_DaoDan != null && q_DaoDan.Count != 0)
        {
            Transform enemy_ = GetEnemy();
            if (enemy_ == null) return;
            GameObject obj = q_DaoDan.Dequeue().gameObject;
            if (camera_)
                camera_.GetComponent<UnityStandardAssets.Cameras.Follow>().SetTarget(obj.transform);//镜头追踪
            obj.transform.SetParent(null);
            Missile_Intercept ml = obj.GetComponent<Missile_Intercept>();
            ml.transform.rotation = Quaternion.Euler(transform.eulerAngles);//调整追踪弹与飞机姿态平齐
            ml.Launch(enemy_);//发射
        }
    }

    public void Launch_Rocket()
    {
        Transform tf_ = null;
        if (q_HuoJIanDan != null && q_HuoJIanDan.Count != 0)
        {
            tf_ = q_HuoJIanDan.Dequeue().transform;
            Rigidbody rb = tf_.gameObject.AddComponent<Rigidbody>();
            rb.isKinematic = false;
            rb.useGravity = false;
            tf_.SetParent(null);
            if (camera_)
                camera_.GetComponent<UnityStandardAssets.Cameras.Follow>().SetTarget(tf_);//镜头追踪
            Missile_HuoJianDan mh = tf_.GetComponent<Missile_HuoJianDan>();
            mh.transform.rotation = Quaternion.Euler(transform.eulerAngles);//调整火箭弹与飞机姿态平齐
            mh.Run = true;//发射
        }
    }

    private Transform GetEnemy()
    {
        Collider[] colliders = Physics.OverlapSphere(transform.position, 6000, 1 << LayerMask.NameToLayer("Enemy"));
        if (colliders.Length <= 0) return null;
        //for (int i = 0; i < colliders.Length; i++)
        //{
        //    float len = Vector3.Distance(transform.position, colliders[i].gameObject.transform.position);
        //    print("导弹检测到：" + colliders[i].gameObject.name + "、距离：" + len);
        //}
        for (int i = 0; i < colliders.Length - 1; i++)
        {
            for (int k = 0; k < colliders.Length - i - 1; k++)
            {
                if (Vector3.Distance(transform.position, colliders[k].transform.position) > Vector3.Distance(transform.position, colliders[k + 1].transform.position))
                {
                    Collider temp = colliders[k];
                    colliders[k] = colliders[k + 1];
                    colliders[k + 1] = temp;
                }
            }
        }
        return colliders[0].transform;
    }
}
