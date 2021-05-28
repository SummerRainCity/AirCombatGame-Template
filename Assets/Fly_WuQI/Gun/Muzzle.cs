using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityStandardAssets.CrossPlatformInput;

/// <summary>
/// 机炮
/// </summary>
public class Muzzle : MonoBehaviour
{
    [Header("机炮爆炸特效")]
    public GameObject ExplosionPrefabs;
    [Header("机炮射击点")]
    public Transform[] cannonPoint;
    [Header("弹药")]
    public uint bullet = 300;
    [Header("开火间隔时间")]
    public float fireRate = 0.3F;
    private float nextFire = 0.0F;
    [Header("开火特效")]
    public GameObject[] MissileEffects;
    protected RaycastHit hit;
    [Header("枪声")]
    public AudioClip clip_;
    private AudioSource audio_;
    bool airBrakes = false;

    private void Start()
    {
        audio_ = gameObject.AddComponent<AudioSource>();
        audio_.volume = 0.3f;
        audio_.clip = clip_;
        audio_.volume = 0.5f;
        audio_.Stop();
    }

    private void Update()
    {
        if (bullet <= 0) return;
        //鼠标右键开枪
        airBrakes = CrossPlatformInputManager.GetButton("Fire2");
        if (airBrakes && Time.time > nextFire)
        {
            foreach (GameObject ps in MissileEffects)
            {
                if (!ps.activeSelf)
                {
                    ps.SetActive(true);
                }
                //FunPhysics(ps.transform);//射击敌人
                bullet--;
            }
            StartCoroutine(nameof(PlayGun));
            nextFire = Time.time + fireRate;
            return;
        }
        if (!airBrakes)
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

    /// <summary>
    /// 机炮
    /// </summary>
    /// <returns></returns>
    IEnumerator PlayGun()
    {
        audio_.Play();
        yield return new WaitForSeconds(0.2f);
        if(cannonPoint.Length > 0)
        {
            for(int i = 0; i < cannonPoint.Length; i++)
            {
                GunPhysics(cannonPoint[i]);
                yield return null;
            }
        }
    }

    private void GunPhysics(Transform dir)
    {
        Vector3 targetPos;
        if (Physics.Raycast(dir.position, dir.forward, out hit, 3000, 1 << LayerMask.NameToLayer("Enemy")))
        {
            targetPos = hit.point;//击中的位置
            Destroy(hit.transform.gameObject, 1);
        }
        else
        {
            targetPos = dir.transform.position + dir.transform.forward * 3000;
        }
        //返回资源对象-此时你才能在下面的代码中销毁此
        Destroy(Instantiate(ExplosionPrefabs, targetPos, Quaternion.identity), 2);
    }
}
