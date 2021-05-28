using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 导弹脚本-2021-来源Unity商店炮弹系统
/// 
/// 强力追踪弹
/// </summary>
public class Missile_Intercept : MonoBehaviour
{
    [Header("导弹飞行速度")]
    public float MissileSpeed = 300;

    [Header("激活导弹之前的初始速度")]
    public float InitialLaunchForce = 80;

    [Header("导弹电动机启动期间的导弹加速度")]
    public float Acceleration = 20;

    [Header("导弹生命周期")]
    public float MotorLifeTime = 3;

    [Header("导弹自动爆炸的时间")]
    public float MissileLifeTime = 30;

    [Header("导弹转向目标的速率")]
    public float TurnRate = 120;

    [Header("导弹射程，以指导目标")]
    public float MissileViewRange = 7500;

    [Header("导弹视角以度为单位，对目标的制导(180)")]
    [Range(0, 360)]
    public float MissileViewAngle;

    [Header("设置爆炸激活延迟")]
    public bool isExplosionActiveDelay;

    [Header("设定追踪延迟")]
    public bool isTrackingDelay;

    [Header("导弹尾焰特效预制件")]
    public GameObject MissileFlameTrail;

    [Header("导弹爆炸特效预制件")]
    public GameObject MissileExplosion;

    [Header("导弹发射音效")]
    public AudioSource LaunchSFX;

    private bool targetTracking = false; // 检查导弹是否可以跟踪目标
    private bool missileActive = false; // 检查导弹是否处于活动状态
    private float MissileLaunchTime; // 获取导弹发射时间
    private bool motorActive = false; // 检查电动机是否工作
    private float MotorActiveTime; // 获取导弹马达的活动时间
    private Quaternion guideRotation; // 储存旋转以引导导弹
    private Rigidbody rb = null;
    private bool isLaunch;

    [SerializeField, Header("锁定目标")]
    private Transform target;
    private Vector3 targetlastPosition; // 定位最后一帧中的最后一个位置
    private bool explosionActive = false; // 激活爆炸物

    private void Awake()
    {
        //rb = GetComponent<Rigidbody>();
        //if(rb != null)
        //{
        //    rb.useGravity = false;
        //    rb.isKinematic = false;
        //}
    }

    private void Start()
    {
        //if (!isLaunch && rb != null)
        //    rb.isKinematic = true;
    }

    private void FixedUpdate()
    {
        Run();
        if (target == null) return;
        GuideMissile();
    }

    private void OnCollisionEnter(Collision col)
    {
        if (col.gameObject.CompareTag("Enemy"))
        {
            if (!explosionActive) return;
            //消除击中的物体
            Destroy(col.gameObject);
            // Detach rocket flame 
            MissileFlameTrail.transform.parent = null;
            Destroy(MissileFlameTrail, 4f);
            // Destroy this missile
            DestroyMissile();
        }
    }

    // This Launch called from "InterceptMissileControlelr"
    public void Launch(Transform target)
    {
        if(rb == null)
        {
            rb = gameObject.AddComponent<Rigidbody>();
            rb.useGravity = false;
            rb.isKinematic = false;
        }

        this.target = target;
        isLaunch = true;
        MissileLaunchTime = Time.time;

        if (isExplosionActiveDelay)
            StartCoroutine(ExplosionDelay());
        else
            explosionActive = true;

        if (isTrackingDelay)
            StartCoroutine(TrackingDelay());
        else
            targetTracking = true;
        // missile activation delay
        StartCoroutine(ActiveDelay(1));
    }

    private void Run()
    {
        if (!isLaunch) return;

        if (!missileActive) return;

        // Check if missile motor is still active ?
        if (Since(MotorActiveTime) > MotorLifeTime)
            motorActive = false; // if motor exceed the "MotorActiveTime" duration : motor will be stopped
        else
            motorActive = true;  // if not : motor continuing running

        // if missile active move it
        if (!missileActive) return;

        // Keep missile accelerating when motor is still active
        if (motorActive)
            MissileSpeed += Acceleration * Time.deltaTime;

        rb.velocity = transform.forward * MissileSpeed;

        // Rotate missile towards target according to "guideRotation" value
        if (targetTracking)
            transform.rotation = Quaternion.RotateTowards(transform.rotation, guideRotation, TurnRate * Time.deltaTime);

        if (Since(MissileLaunchTime) > MissileLifeTime) // Destroy Missile if it more than live time
            DestroyMissile();

    }

    private void GuideMissile()
    {
        Vector3 relativePosition = target.position - transform.position; // Get current relaPosition towards target;
        float angleToTarget = Mathf.Abs(Vector3.Angle(transform.position.normalized, relativePosition.normalized));
        float distance = Vector3.Distance(target.position, transform.position);

        // target is out of missile's view angle or target distance out of missile's view range
        if (angleToTarget > MissileViewAngle || distance > MissileViewRange)
            targetTracking = false;

        if (!targetTracking) return;

        // Get target position in one second ahead 
        Vector3 targetSpeed = (target.position - targetlastPosition);
        targetSpeed /= Time.deltaTime; // Target distance in one second. Since "Time.deltaTime" = 1/FPS

        // ---------------------------------------------------------------------------------------------
        // Calculate the the lead target position based on target speed and projectileTravelTime to reach the target

        // Get time to hit based on distance
        float MissilespeedPrediction = MissileSpeed + Acceleration * Since(MissileLaunchTime);
        float MissileTravelTime = distance / MissilespeedPrediction;

        // Lead Position based on target position prediction within impact time
        Vector3 targetFuturePosition = target.position + targetSpeed * MissileTravelTime;
        Vector3 aimPosition = targetFuturePosition - transform.position;

        // During Rotation get target 90% in "MissileViewAngle" sinse positionToGo will likely out of "MissileViewAngle"
        relativePosition = Vector3.RotateTowards(relativePosition.normalized, aimPosition.normalized, MissileViewAngle * Mathf.Deg2Rad * 0.9f, 0f);
        guideRotation = Quaternion.LookRotation(relativePosition, transform.up);

        targetlastPosition = target.position;

    }

    IEnumerator ExplosionDelay()
    {
        yield return new WaitForSeconds(2);
        explosionActive = true;
    }

    IEnumerator TrackingDelay()
    {
        yield return new WaitForSeconds(2);
        targetTracking = true;
    }

    IEnumerator ActiveDelay(float time)
    {
        // Put initial speed to missile before activate 
        rb.velocity = transform.forward * InitialLaunchForce;
        yield return new WaitForSeconds(time);
        ActivateMissile();
    }

    // Activate missile
    private void ActivateMissile()
    {
        missileActive = true;
        motorActive = true;
        MotorActiveTime = Time.time;
        MissileFlameTrail.SetActive(true);
        LaunchSFX.Play();
    }

    // Get the "Since" time from the input/parameter value
    private float Since(float Since)
    {
        return Time.time - Since;
    }

    // Destroy Missile
    private void DestroyMissile()
    {
        GameObject missileExplosion = Instantiate(MissileExplosion, transform.position, transform.rotation);
        Destroy(missileExplosion, 2);//销毁爆炸预制件
        Destroy(gameObject);
    }

    public Transform GetTarget()
    {
        return target;
    }
}
