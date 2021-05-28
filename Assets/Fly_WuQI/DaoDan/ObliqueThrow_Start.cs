using UnityEngine;
using System.Collections.Generic;
using System.Collections;

/// <summary>
/// 来源：https://www.bbsmax.com/A/gAJG0vb45Z/
/// 
/// 【斜抛脚本】
/// </summary>
public class ObliqueThrow_Start : MonoBehaviour
{
    [Header("炸弹个数")]
    public uint currentCount = 1;
    //将实时获取飞机数据
    UnityStandardAssets.Vehicles.Aeroplane.AeroplaneController aeroplane = null;
    [Header("导弹追随相机")]
    private Camera camera_;
    [SerializeField, Header("按下指定键投弹")]
    private KeyCode key = KeyCode.Space;
    [SerializeField, Header("杀伤范围")]
    private float hurtRange = 100f;
    [SerializeField, Header("爆炸特效预制体")]
    private GameObject ExplosionPrefabs = null;
    [SerializeField, Header("投抛物体模型(炸弹模型)")]
    private GameObject model;
    [Header("丢弃下去的炸弹")]
    private GameObject zhadan = null;
    [SerializeField, Header("在什么高度爆炸")]
    private float hight = 1;
    [Header("投弹水平方向，这与飞机旋转Y轴一致")]//单位元，Sin-Cos计算方向
    private Vector2 direction = new Vector2(0, 0);

    private void Start()
    {
        UnityStandardAssets.Cameras.Follow mc = FindObjectOfType<UnityStandardAssets.Cameras.Follow>();
        if (mc)
        {
            camera_ = mc.GetComponent<Camera>();
        }
        aeroplane = GetComponentInParent<UnityStandardAssets.Vehicles.Aeroplane.AeroplaneController>();
    }

    private void Update()
    {
        if (currentCount <= 0) return;
        if (zhadan == null)
        {
            zhadan = Instantiate(model, transform, false);
            zhadan.transform.SetParent(transform);
        }
        if (Input.GetKeyDown(key))
        {
            zhadan.transform.SetParent(null);
            if (camera_)
                camera_.GetComponent<UnityStandardAssets.Cameras.Follow>().SetTarget(zhadan.transform);//镜头追踪
            zhadan.AddComponent<BoxCollider>();
            ObliqueThrow obliqueThrow = zhadan.AddComponent<ObliqueThrow>();
            obliqueThrow.isDebug = false;
            //飞机Y轴角度，将指定炸弹投弹水平方向
            direction.x = Mathf.Sin(aeroplane.transform.rotation.eulerAngles.y * Mathf.Deg2Rad);
            direction.y = Mathf.Cos(aeroplane.transform.rotation.eulerAngles.y * Mathf.Deg2Rad);
            //开始投弹
            obliqueThrow.StartMove(direction, aeroplane.speed, aeroplane.horizontalAngle, 1, (go) =>
            {
                //导弹爆炸特效
                if (ExplosionPrefabs)
                {
                    GameObject EPrefabs = Instantiate(ExplosionPrefabs, go.transform.position, Random.rotation);
                    Destroy(EPrefabs, 2);
                }
                Collider[] colliders = Physics.OverlapSphere(go.transform.position, hurtRange, 1 << LayerMask.NameToLayer("Enemy"));
                if (colliders.Length <= 0)
                {
                    Destroy(obliqueThrow.gameObject);
                    return;
                }
                StartCoroutine(CreateDD(colliders, obliqueThrow.gameObject));
            });
            zhadan = null;
            currentCount--;
        }
    }

    IEnumerator CreateDD(Collider[] colliders,GameObject DesObject)
    {
        for (int i = 0; i < colliders.Length; i++)
        {
            GameObject t = Instantiate(ExplosionPrefabs, colliders[i].transform.position, Random.rotation);
            Destroy(t, 2);
            Destroy(colliders[i].gameObject, 1);
            yield return null;
        }
        Destroy(DesObject, 1);
    }
}