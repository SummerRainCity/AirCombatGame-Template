using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityStandardAssets.CrossPlatformInput;

/// <summary>
/// 机炮
/// </summary>
public class Enemy_Muzzle : MonoBehaviour
{
    UnityStandardAssets.Vehicles.Aeroplane.AeroplaneAiControl ai = null;
    [Header("开火间隔时间")]
    public float fireRate = 1.0F;
    private float nextFire = 0.0F;
    [Header("开火特效")]
    public GameObject[] MissileEffects;
    [Header("最大射程范围")]
    public float MaximumRange = 3000f;
    [Header("攻击目标")]
    public Transform target;
    [Header("枪声")]
    public AudioClip clip_;
    private AudioSource audio_;

    private void Start()
    {
        ai = GetComponentInParent<UnityStandardAssets.Vehicles.Aeroplane.AeroplaneAiControl>();
        audio_ = gameObject.AddComponent<AudioSource>();
        audio_.clip = clip_;
        audio_.loop = true;
        audio_.volume = 0.1f;
        audio_.Stop();
    }

    private void FixedUpdate()
    {
        target = ai.GetTarget();
        if (target == null) return;
        float distance = Vector3.Distance(gameObject.transform.position, target.position);
        Vector3 dirt = target.position - gameObject.transform.position;
        Vector3 dirz = gameObject.transform.TransformPoint(0, 0, distance) - gameObject.transform.position;
        //你需要注意，Angle函数传入的是向量(具备指向性质)，不要只传入坐标点，否则得到的结果将是错误的！！
        float angle = Vector3.Angle(dirt, dirz);

        //print(angle);
        //Debug.DrawLine(gameObject.transform.position, gameObject.transform.TransformPoint(0, 0, distance), Color.blue);
        //Debug.DrawLine(gameObject.transform.position, target.position, Color.red);

        //开火条件：距玩家偏差角度小于25+在射程范围+间隔开火时间
        if (angle <= 25 && distance <= MaximumRange && Time.time > nextFire)
        {
            foreach (GameObject ps in MissileEffects)
            {
                if (!ps.activeSelf)
                {
                    ps.SetActive(true);
                }
            }
            StartCoroutine(nameof(PlayGun));
            nextFire = Time.time + fireRate;
            return;
        }
        if(angle > 25)
        {
            foreach (GameObject ps in MissileEffects)
            {
                if (ps.activeSelf)
                {
                    ps.SetActive(false);
                }
            }
            if (audio_.isPlaying)
            {
                audio_.Stop();
            }
        }
    }
    IEnumerator PlayGun()
    {
        audio_.Play();
        yield return new WaitForSeconds(0.2f);
    }
}
