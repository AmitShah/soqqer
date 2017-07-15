using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Movement : MonoBehaviour {
	GameObject copyCamera;
	Vector3 moveTo;
	// Use this for initialization
	void Start () {
		copyCamera = GameObject.Find ("CopyCamera");
		moveTo = transform.position;
	}
	
	// Update is called once per frame
	void Update () {
		if (Input.GetMouseButton (0)) {
			moveTo = Camera.main.ScreenToWorldPoint(Input.mousePosition);

			moveTo.y = transform.position.y;

		}


		if (Input.GetKey(KeyCode.Space))
		{
			//TODO animate foot kick
			Debug.Log("foot animation");
		}

		transform.position = Vector3.Lerp(transform.position, moveTo, 0.15f); 



	}
}
