using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Missile_HuoJianDan : MonoBehaviour
{
    [Header("发射")]
    public bool Run;

    [SerializeField, Header("加速度")]
    private float AcceleratedVeocity = 300f;

    [SerializeField, Header("最高速度")]
    private float MaximumVelocity = 500f;

    [SerializeField, Header("生命周期")]
    private float MaximumLifeTime = 16.0f;

    [SerializeField, Header("爆炸特效预制体")]
    private GameObject ExplosionPrefabs = null;

    [SerializeField, Header("导弹渲染体组件")]
    private Renderer MissileRenderer = null;

    [SerializeField, Header("尾焰及烟雾粒子特效")]
    private ParticleSystem[] MissileEffects = null;

    [SerializeField, Header("火箭弹杀伤范围")]
    private float SearchRadius = 100;

    [HideInInspector]
    public float CurrentVelocity = 0.0f;   // 当前速度

    private AudioSource audioSource = null;   // 音效组件
    public AudioClip Lacnch,End = null;
    private float lifeTime = 0.0f;            // 生命期

    private void Awake()
    {// 禁止所有粒子系统
        foreach (ParticleSystem ps in MissileEffects)
        {
            ps.Stop();
        }
        audioSource = gameObject.AddComponent<AudioSource>();
        audioSource.mute = true;
    }


    bool first = true;
    private void Update()
    {
        if (!Run)
            return;
        else
        {
            // 禁止所有粒子系统
            foreach (ParticleSystem ps in MissileEffects)
            {
                if (!ps.IsAlive())
                {
                    ps.Play();
                }
            }
        }

        if(Run && first)
        {
            audioSource.mute = false;
            first = false;
            audioSource.clip = Lacnch;
            audioSource.Play();
        }

        float deltaTime = Time.deltaTime;
        lifeTime += deltaTime;

        // 如果超出生命周期，或者到达了地面，则直接爆炸。
        if (lifeTime > MaximumLifeTime || transform.position.y <= -6)
        {
            Explode();
            return;
        }
        // 如果当前速度小于最高速度，则进行加速
        if (CurrentVelocity < MaximumVelocity)
            CurrentVelocity += deltaTime * AcceleratedVeocity;

        // 朝自己的前方位移
        transform.position += transform.forward * CurrentVelocity * deltaTime;
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.CompareTag("Wall"))
        {
            // 当发生碰撞，爆炸
            Explode();
        }
        else if (collision.gameObject.CompareTag("Enemy"))
        {
            Explode();
        }
    }

    // 爆炸
    private void Explode()
    {
        // 之所以爆炸时不直接删除物体，而是先禁用一系列组件，
        // 是因为导弹产生的烟雾等效果不应该立即消失

        // 禁止所有碰撞器
        foreach (Collider col in GetComponents<Collider>())
        {
            col.enabled = false;
        }
        // 禁止所有粒子系统
        foreach (ParticleSystem ps in MissileEffects)
        {
            ps.Stop();
        }
        audioSource.clip = End;
        audioSource.Play();

        // 停止渲染，停止本脚本，随机实例化爆炸特效，删除本物体
        if (MissileRenderer)
            MissileRenderer.enabled = false;

        //导弹爆炸有特效
        if (ExplosionPrefabs)
        {
            Destroy(Instantiate(ExplosionPrefabs, transform.position, Random.rotation), 2);
        }

        // 三秒后删除烟雾
        for (int i = 0; i < MissileEffects.Length; i++)
        {
            Destroy(MissileEffects[i].gameObject, 2.0f);
        }

        StartCoroutine(nameof(BaoZha));
    }

    IEnumerator BaoZha()
    {
        Collider[] colliders = Physics.OverlapSphere(transform.position, SearchRadius, 1 << LayerMask.NameToLayer("Enemy"));
        for (int i = 0; i < colliders.Length; i++)
        {
            GameObject t = Instantiate(ExplosionPrefabs, colliders[i].transform.position, Random.rotation);
            Destroy(t, 3f);
            Destroy(colliders[i].gameObject);
            yield return null;
        }
        Destroy(gameObject);
    }
}