using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScrollCloud : MonoBehaviour {
	Material scrollMat;
	public Texture2D cloudTexture;
	public RenderTexture scrollCloudTexture;
	public Vector4 Offset;
	public Renderer rend;
	public float scrollSpeed = 1f;
	float offset = 0f;
	// Use this for initialization
	void Start () {
		//scrollCloudTexture = RenderTexture.GetTemporary (cloudTexture.width, cloudTexture.height);
		scrollMat = new Material (Shader.Find ("Unlit/scrollShader"));
		//scrollMat.SetVector ("_Offset", Offset);

	}

	// Update is called once per frame
	void FixedUpdate () {
		offset+= Time.deltaTime * scrollSpeed;

		scrollMat.mainTextureOffset = new Vector2(offset, 0f);
		//var restore = RenderTexture.active;
		//RenderTexture.active = scrollCloudTexture;

		//RenderTexture.active = restore;
		Graphics.Blit (cloudTexture, scrollCloudTexture, scrollMat);
	}
}
