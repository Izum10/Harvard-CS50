using UnityEngine;
using System.Collections;

public class DiamondSpawner : MonoBehaviour
{
    public GameObject[] prefabs;

    void Start()
    {

        StartCoroutine(SpawnDiamonds());
    }

    void Update()
    {

    }

    IEnumerator SpawnDiamonds()
    {
        while (true)
        {
            Instantiate(prefabs[Random.Range(0, prefabs.Length)], new Vector3(30, Random.Range(-5, 5), 10), Quaternion.identity);
            yield return new WaitForSeconds(Random.Range(1, 10)); // Identical to the coin spawner page however changed the time
        }


    }
}