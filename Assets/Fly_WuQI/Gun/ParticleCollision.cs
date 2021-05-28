using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 飞机被击中后坠毁脚本，挂在敌人和玩家身上
/// </summary>
public class ParticleCollision : MonoBehaviour
{
    [Header("被击中的爆炸特效")]
    public GameObject ExplosionPrefabs;
    private bool first = true;

    // 需要处理的碰撞信息，放在被撞的物体身上
    void OnParticleCollision(GameObject other)
    {
        if (first)
        {
            UnityStandardAssets.Vehicles.Aeroplane.AeroplaneController ac = GetComponent<UnityStandardAssets.Vehicles.Aeroplane.AeroplaneController>();
            if(ac)
                ac.SetImmobilized(first);
            first = false;
            StartCoroutine(nameof(TeXiao));
        }
    }

    IEnumerator TeXiao()
    {
        for(int k = 1; k<= 7; k++)
        {
            Destroy(Instantiate(ExplosionPrefabs, transform.position, Quaternion.identity), 2);
            yield return new WaitForSeconds(0.5f);
        }
        Destroy(gameObject);
    }
}
