// Credit: AngryFoxGames
using UnityEngine;
using System.Collections;

public class CopyCamera : MonoBehaviour {
	
	// Use this for initialization
	void Start () {

	}

	// Update is called once per frame
	void Update () {
		
		gameObject.transform.position = Camera.main.transform.position;
		gameObject.transform.rotation = Camera.main.transform.rotation;
		transform.eulerAngles = new Vector3 (0,transform.eulerAngles.y,0);
	}
}