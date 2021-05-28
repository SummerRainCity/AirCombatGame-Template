using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 玩家飞机AI脚本
/// </summary>
public class Enemy_AI : MonoBehaviour
{
    //飞行控制器
    UnityStandardAssets.Vehicles.Aeroplane.AeroplaneAiControl ai = null;
    [Header("扫描范围")]
    public float range = 3000f;
    [Header("开火间隔时间")]
    public float fireRate = 0.8F;
    private float nextFire = 0.0F;
    [Header("开火特效")]
    public GameObject[] MissileEffects;
    [Header("当前锁定的敌人")]
    public Transform enemy_target = null;
    [Header("朝向区域点")]
    public Transform area_E;

    private void Start()
    {
        ai = GetComponent<UnityStandardAssets.Vehicles.Aeroplane.AeroplaneAiControl>();
        area_E = GameObject.Find("Enemy_Area").transform;
    }

    private void FixedUpdate()
    {
        Collider[] colliders = Physics.OverlapSphere(transform.position, range, 1 << LayerMask.NameToLayer("Player"));
        if (colliders.Length <= 0)
        {
            ai.SetTarget(area_E);
        }
        else
        {
            if (enemy_target == null)
            {
                enemy_target = colliders[Random.Range(0, colliders.Length - 1)].transform;
                ai.SetTarget(enemy_target);
            }
        }
    }
}
