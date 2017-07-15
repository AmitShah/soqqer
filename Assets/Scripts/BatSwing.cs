using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BatSwing : MonoBehaviour {

	bool isKicking;
	GameObject player;

	// Use this for initialization
	void Start () {
		isKicking = false;	
		player = GameObject.Find ("Cube");
	}
	
	// Update is called once per frame
	void Update () {
		if (Input.GetKeyDown (KeyCode.Space)) {
			transform.position = player.transform.position - new Vector3(-1f,0f,0f);

			isKicking = true;	
		}

		if (isKicking) {
			
			transform.RotateAround (player.transform.position, Vector3.up, -500f * Time.deltaTime);
			Debug.Log (Mathf.Sin (transform.rotation.eulerAngles.y));
			var scale  = Mathf.Clamp(Mathf.Sin(transform.rotation.eulerAngles.y),1,2);
			//Debug.Log (scale);
			transform.localScale = new Vector3 (scale, scale, scale);
		}

	}
}
