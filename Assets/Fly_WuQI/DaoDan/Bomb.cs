using UnityEngine;
using System.Collections.Generic;
using System.Collections;

public class Bomb : MonoBehaviour
{
    //将实时获取飞机数据
    UnityStandardAssets.Vehicles.Aeroplane.AeroplaneController ap = null;
    [SerializeField, Header("杀伤范围")]
    private float hurtRange = 600f;
    [SerializeField, Header("爆炸特效预制体")]
    private GameObject ExplosionPrefabs = null;
    [SerializeField, Header("在什么高度爆炸")]
    private float hight = 1;
    [Header("投弹水平方向，这与飞机旋转Y轴一致")]//单位元，Sin-Cos计算方向
    private Vector2 direction = new Vector2(0, 0);

    private void Start()
    {
        ap = GetComponentInParent<UnityStandardAssets.Vehicles.Aeroplane.AeroplaneController>();
    }

    public void Launch()
    {
        transform.SetParent(null);
        ObliqueThrow obliqueThrow = gameObject.AddComponent<ObliqueThrow>();
        obliqueThrow.isDebug = false;
        //飞机Y轴角度，将指定炸弹投弹水平方向
        direction.x = Mathf.Sin(ap.transform.rotation.eulerAngles.y * Mathf.Deg2Rad);
        direction.y = Mathf.Cos(ap.transform.rotation.eulerAngles.y * Mathf.Deg2Rad);
        //开始投弹
        obliqueThrow.StartMove(direction, ap.speed, ap.horizontalAngle, hight, (go) =>
        {
            //导弹爆炸特效
            if (ExplosionPrefabs)
            {
                GameObject EPrefabs = Instantiate(ExplosionPrefabs, go.transform.position, Random.rotation);
                Destroy(EPrefabs, 2);
            }
            Collider[] colliders = Physics.OverlapSphere(go.transform.position, hurtRange, LayerMask.GetMask("Enemy"));
            if (colliders.Length <= 0)
            {
                Destroy(obliqueThrow.gameObject);
                return;
            }
            StartCoroutine(CreateDD(colliders, obliqueThrow.gameObject));
        });
    }

    IEnumerator CreateDD(Collider[] colliders, GameObject DesObject)
    {
        for (int i = 0; i < colliders.Length; i++)
        {
            GameObject t = Instantiate(ExplosionPrefabs, colliders[i].transform.position, Random.rotation);
            Destroy(t, 2);
            if(colliders[i].transform != null)
                Destroy(colliders[i].transform.root.gameObject, 1);
            yield return null;
        }
        Destroy(DesObject);
        Destroy(gameObject);
    }
}